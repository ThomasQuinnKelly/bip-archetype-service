Feature: Service Health check endpoint.

  @health
  Scenario Outline: Service Health check endpoint.
    Given the claimant is not a "<Veteran>"
    And invoke token API by passing header from "<tokenrequestfile>" and sets the authorization in the header
    When client request health info "<ServiceURL>"
    Then the service returns status code = 200
    And verify health service status is UP and details of Service REST Provider Up and Running

    @DEV
    Examples: 
      | Veteran     | tokenrequestfile  | ServiceURL             |
      | dev-janedoe | dev/token.request | /api/v1/origin/health |

    @VA
    Examples: 
      | Veteran    | tokenrequestfile | ServiceURL             |
      | va-janedoe | va/token.request | /api/v1/origin/health |
