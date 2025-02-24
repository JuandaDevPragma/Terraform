const  AWS = require('aws-sdk');

/**
 * Main method that executes sentences keeping in mind header environment
 * @param event the inbound event
 * @returns {Promise<unknown>} return the promise with executed sentence
 */
const getUser = async (event) => {
    const {id} = event.pathParameters;

    const db_action = {
        TableName: 'UsersTable',
        Key: {id}
    }

    return await getDBUser(db_action);
};

/**
 * Method to inquiry data to DynamoDB in get by id operation
 * @param data the customer data sentence with filter
 * @returns {Promise<unknown>} the sentence result
 */
const getDBUser = async (data) => {
    const db = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});
    return new Promise((resolve, reject) => {
        db.get(data, (err, response) => {
            console.log(JSON.stringify(err))
            err ? reject({
                    statusCode: 500,
                    body: JSON.stringify({
                        message: `User with name ${data.Item.name} could not be founded, ${err.message}`
                    })
                })
                : resolve(
                    {
                        statusCode: 200,
                        body: JSON.stringify(response.Item)
                    }
                )
        })
    })
};

module.exports = {
    getUser
};