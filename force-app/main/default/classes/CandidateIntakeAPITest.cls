@IsTest
private class CandidateIntakeAPITest {
  @IsTest
  static void testCreateCandidate_success() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestUri = '/services/apexrest/candidate-intake/v1';
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(JSON.serialize(new Map<String, Object>{
      'name' => 'Jane Doe',
      'email' => 'jane.doe@example.com',
      'source' => 'Referral',
      'applicationDate' => String.valueOf(Date.today()),
      'status' => 'Applied'
    }));
    
    RestContext.request = req;
    RestContext.response = res;

    Test.startTest();
    CandidateIntakeAPI.createCandidate();
    Test.stopTest();

    System.assertEquals(201, RestContext.response.statusCode);
  }
}
