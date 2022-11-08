const AWS = require('aws-sdk');
const cloudwatchLogs = new AWS.CloudWatchLogs();

const config = {
    defaultRetentionDays: 7                // allowed values are [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653]
};

async function setRetentionOfCloudwatchLogGroup(logGroupName, duration) {
    let params = {
        logGroupName: logGroupName,
        retentionInDays: duration
    };
    return cloudwatchLogs.putRetentionPolicy(params).promise();
}

async function getLogGroups() {
    let params = {};
    let logGroups = [];

    do {


        let response = await cloudwatchLogs.describeLogGroups(params).promise();

        for (const logGroup of response.logGroups) {
            logGroups.push(logGroup);
        }

        params.nextToken = response.nextToken || undefined;

    } while (params.nextToken !== undefined);
    return logGroups;
}


exports.handler = async (event, context) => {

    try {
        let logGroups = await getLogGroups();

        for (const logGroup of logGroups) {
            if (logGroup.retentionInDays === undefined) {
                
                

                await setRetentionOfCloudwatchLogGroup(logGroup.logGroupName, config.defaultRetentionDays);
                console.log(logGroup.logGroupName + "have been applied");
            }
        }
    }
    catch (err) {
        console.log('>>>>>>ERROR>>>>>>>\n' + err);
    }
};