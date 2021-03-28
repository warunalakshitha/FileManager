import ballerina/http;
import ballerina/file;
import FileManager.config;
import ballerina/io;

public string directoryPath = config:directoryPath;
const string FILE_NAME_PARAM = "fileName";

service / on new http:Listener(8080) {
    resource function post files(http:Caller caller, http:Request req) returns string {
        string filePath = getFilePath(req);
        checkpanic file:create(filePath);
        return "File is created successfully";
    }

    resource function delete files(http:Caller caller, http:Request req) returns string {
        string filePath = getFilePath(req);
        checkpanic file:remove(filePath);
        return "File is deleted successfully";
    }

    resource function put files(http:Caller caller, http:Request req) returns string {
        string filePath = getFilePath(req);
        string textPayload = checkpanic req.getTextPayload();
        checkpanic io:fileWriteString(filePath, textPayload);
        return "File is modified successfully";
    }
}

function getFilePath(http:Request req) returns string {
    map<string[]> queryParams = req.getQueryParams();
    string[] fileName = queryParams.get("fileName");
    return checkpanic file:joinPath(directoryPath, fileName[0]);
}
