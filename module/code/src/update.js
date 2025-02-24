const {v6} = require('uuid');
const  AWS = require('aws-sdk');

/**
 * Main method that executes sentences keeping in mind header environment
 * @param event the inbound event
 * @returns {Promise<unknown>} return the promise with executed sentence
 */
const updateUser = async (event) => {

    const {name, mail} = JSON.parse(event.body);

    const {id} = event.pathParameters;

    const db_action = {
        action: {
            TableName: 'UsersTable',
            Key: {id:id},
            UpdateExpression: "set #nameUser = :name, mail = :mail",
            ExpressionAttributeNames: {
                "#nameUser":"name"
            },
            ExpressionAttributeValues: {
                ":name": name,
                ":mail": mail
            },
            ReturnValues: "ALL_NEW"
        },
        name
    }

    return await persistUser(db_action);
};

/**
 * Method to persist data to DynamoDB in update operation
 * @param data the customer data
 * @returns {Promise<unknown>} the sentence result
 */
const persistUser = async (data) => {
    const db = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

    return new Promise( (resolve, reject) => {
        db.update(data.action, (err, result) => {
            console.log(JSON.stringify(err))
            err ? reject({
                    statusCode: 500,
                    body: JSON.stringify({
                        message: `User with id ${data.action.Key.id} could not be updated`
                    })
                })
                : resolve( {
                    statusCode: 200,
                    body: JSON.stringify({
                        message: `User ${result.Attributes.name} updated successfully`
                    })
                })
        })
    })
};

module.exports = {
    updateUser
};