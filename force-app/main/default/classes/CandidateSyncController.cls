public with sharing class CandidateSyncController {
    @AuraEnabled
    public static void syncCandidate(Id candidateId) {
      Candidate__c cand = [SELECT Name, Email__c FROM Candidate__c WHERE Id = :candidateId LIMIT 1];
  
      HttpRequest req = new HttpRequest();
      req.setEndpoint('callout:Environment/services/apexrest/candidates');
      req.setMethod('POST');
      req.setHeader('Content-Type', 'application/json');
      req.setBody(JSON.serialize(cand));
  
      Http http = new Http();
      HttpResponse res = http.send(req);
  
      if (res.getStatusCode() != 200) {
        throw new AuraHandledException('Sync failed: ' + res.getBody());
      }
  
      insert new Sync_Log__c(
        Candidate__c = candidateId,
        Status__c = 'Success',
        Response__c = res.getBody()
      );
    }
  }
  