import requests
import json


def lambda_handler(event, context):
    responseStatus = 'SUCCESS'
    responseData = {}

    if event['RequestType'] == 'Delete':
        sendResponse(event, context, responseStatus, responseData)

    timeInfo = getTimeZoneInfo(event['ResourceProperties']['TimeZone'])

    responseData = {'timeInfo': getFormattedString(
        timeInfo), 'unixTime': getUnixTime(timeInfo)}

    sendResponse(event, context, responseStatus, responseData)


