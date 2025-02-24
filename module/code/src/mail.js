const  AWS = require('aws-sdk');
const sns = new AWS.SNS();

/**
 * Main method that executes sentences keeping in mind header environment
 * @param event the inbound event
 * @returns {Promise<unknown>} return the promise with executed sentence
 */
const sendMail = async (event) => {
    return new Promise(async (resolve, reject) => {
        try{

            const message = event.Records[0];
            const body = JSON.parse(message.body);

            console.log("The inbound event: ", body);

            const msg = {
                Subject: `User ${body.id} was created`,
                Message: `User ${body.mail} was created successfully`
            }

            const msgParam = {
                TopicArn: 'arn:aws:sns:us-east-2:302263088688:UserSavedTopic',
                Message: JSON.stringify(msg)
            }

            await sns.publish(msgParam).promise();
            resolve();
        }catch (error){
            console.log(JSON.stringify(error))
            reject(error);
        }
    })
}

module.exports = {
    sendMail
}