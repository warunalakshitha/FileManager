import ballerina/test;
import ballerina/http;
import ballerina/io;
import ballerina/log;

string[] logs = [];

http:Client clientEndpoint = check new ("http://0.0.0.0:8080");
@test:Mock {
    moduleName: "ballerina/log",
    functionName: "printInfo"
}
test:MockFunction mock_printInfo = new ();

public function mockPrintInfo(string msg, *log:KeyValues keyValues, error? err = ()) {
    logs.push(msg);
    io:println(msg);
}

@test:Config {}
function testFileCreateService() {
    // Test file add service
    test:when(mock_printInfo).call("mockPrintInfo");
    var response = checkpanic clientEndpoint->post("/files?fileName=myfile", "");
    test:assertEquals(response.getTextPayload(), "File is created successfully");
}

@test:Config {dependsOn: [testFileCreateService]}
function testFileModifyService() {
    // Test file modify service
    test:when(mock_printInfo).call("mockPrintInfo");
    var response = checkpanic clientEndpoint->put("/files?fileName=myfile", "File content");
    test:assertEquals(response.getTextPayload(), "File is modified successfully");
}

@test:Config {dependsOn: [testFileModifyService]}
function testFileDeleteService() {
    // Test file delete 
    test:when(mock_printInfo).call("mockPrintInfo");
    var response = checkpanic clientEndpoint->delete("/files?fileName=myfile");
    test:assertEquals(response.getTextPayload(), "File is deleted successfully");
}

@test:Config {dependsOn: [testFileDeleteService]}
function testFileDirectoryListener() {
    // Test directory lisnter logs 
    test:assertEquals(logs[0], "File Created");
    test:assertEquals(logs[1], "File Modified");
    test:assertEquals(logs[2], "File Modified");
    test:assertEquals(logs[3], "File Deleted");
}
