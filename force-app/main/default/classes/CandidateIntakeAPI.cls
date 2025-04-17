@RestResource(urlMapping='/candidate-intake/v1')
global with sharing class CandidateIntakeAPI {

  global class CandidateRequest {
    public String name;
    public String email;
    public String source;
    public String applicationDate;
    public String status;
  }

  @HttpPost
  global static void createCandidate() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    
    CandidateRequest input;
    try {
      input = (CandidateRequest)JSON.deserialize(req.requestBody.toString(), CandidateRequest.class);
    } catch (Exception e) {
      res.statusCode = 400;
      res.responseBody = Blob.valueOf('Invalid JSON payload');
      return;
    }

    if (String.isBlank(input.name) || String.isBlank(input.email)) {
      res.statusCode = 422;
      res.responseBody = Blob.valueOf('Name and Email are required.');
      return;
    }

    Candidate__c candidate = new Candidate__c(
      Name = input.name,
      Email__c = input.email,
      Source__c = input.source,
      Application_Date__c = Date.valueOf(input.applicationDate),
      Status__c = input.status
    );

    try {
      insert candidate;
      res.statusCode = 201;
      res.responseBody = Blob.valueOf('Candidate created successfully.');
    } catch (Exception e) {
      res.statusCode = 500;
      res.responseBody = Blob.valueOf('Server error: ' + e.getMessage());
    }
  }
}
