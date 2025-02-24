const { v6 } = require('uuid');
const AWS = require('aws-sdk');

const db = new AWS.DynamoDB.DocumentClient({ region : 'us-east-2' });
const sqs = new AWS.SQS();

/**
 * Main method that executes sentences keeping in mind header environmentlambda
 * @param event the inbound event
 * @returns {Promise<unknown>} return the promise with executed sentence
 */
const createUser = async ( event ) => {
    const { name , mail } = JSON.parse(event.body);

    const id = v6();

    const db_action = {
        TableName : 'UsersTable' ,
        Item : { id , name , mail }
    }

    return await persistUser(db_action);
};

/**
 * Method to persist data to DynamoDB in save operation
 * @param data the customer data
 * @returns {Promise<unknown>} the sentence result
 */
const persistUser = async ( data ) => {
    return new Promise(async ( resolve , reject ) => {
        try {
            await db.put(data).promise();

            const sqs_action = {
                QueueUrl : 'https://sqs.us-east-2.amazonaws.com/302263088688/UsersQueue' ,
                MessageBody : JSON.stringify(data.Item)
            };

            await sqs.sendMessage(sqs_action).promise();

            resolve({
                statusCode : 201 ,
                body : JSON.stringify({
                    message : `User with name ${ data.Item.name } created successfully`
                })
            })


        } catch ( error ) {
            console.log(JSON.stringify(error))
            reject({
                statusCode : 500 ,
                body : JSON.stringify({
                    message : `User with name ${ data.Item.name } could not be persisted, ${ error.message }`
                })
            })
        }
    })
};

module.exports = {
    createUser
};