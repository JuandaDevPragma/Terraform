const  AWS = require('aws-sdk');

/**
 * Main method that executes sentences keeping in mind header environment
 * @param event the inbound event
 * @returns {Promise<unknown>} return the promise with executed sentence
 */
const getUsers = async (event) => {
    const db_action = {
        TableName: 'UsersTable'
    }

    return await getDBUsers(db_action);
};

/**
 * Method to inquiry data to DynamoDB in list return operation
 * @param data the filter sentence data
 * @returns {Promise<unknown>} the sentence result
 */
const getDBUsers = async (data) => {
    const db = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});
    return new Promise((resolve, reject) => {
        db.scan(data, (err, response) => {
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
                        body: JSON.stringify(response.Items)
                    }
                )
        })
    })
};

module.exports = {
    getUsers
};