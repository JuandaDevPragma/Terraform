const  AWS = require('aws-sdk');

/**
 * Main method that executes sentences keeping in mind header environment
 * @param event the inbound event
 * @returns {Promise<unknown>} return the promise with executed sentence
 */
const deleteUser = async (event) => {
    const {id} = event.pathParameters;

    const db_action = {
        TableName: 'UsersTable',
        Key: {id}
    }

    return await deleteDbUser(db_action);
};

/**
 * Method to clear data to DynamoDB in delete operation
 * @param param the customer data param to remove
 * @returns {Promise<unknown>} the sentence result
 */
const deleteDbUser = async (param) => {
    const db = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});
    return new Promise((resolve, reject) => {
        db.delete(param, (err) => {
            console.log(JSON.stringify(err));
            err ? reject({
                    statusCode: 500,
                    body: JSON.stringify({
                        message: `User with id ${param.Key.id} could not be founded, ${err.message}`
                    })
                })
                : resolve(
                    {
                        statusCode: 204,
                        body: JSON.stringify({
                            message: `User with id ${param.Key.id} was deleted successfully`
                        })
                    }
                )
        })
    })
};

module.exports = {
    deleteUser
};