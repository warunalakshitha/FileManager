import FileManager.config;
import FileManager.file_service as _;
import ballerina/file;
import ballerina/log;

string directoryPath = config:directoryPath;
error? createDirResults = file:createDir(directoryPath);
listener file:Listener directoryListerner = new ({path: directoryPath});

service on directoryListerner {

    remote function onCreate(file:FileEvent m) {
        log:printInfo("File Created", name = m.name);
    }

    remote function onDelete(file:FileEvent m) {
        log:printInfo("File Deleted", name = m.name);
    }

    remote function onModify(file:FileEvent m) {
        log:printInfo("File Modified", name = m.name);
    }
}
