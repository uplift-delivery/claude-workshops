Feature: Health check
  The service reports that it is alive over HTTP.
  Reference: system/api-contract.md "GET /health"

  Scenario: Service reports it is alive
    Given the service is running locally or on your cloud
    When a separate HTTP client sends GET /health
    Then the response status is 200
    And the response body is {"status": "ok"}
