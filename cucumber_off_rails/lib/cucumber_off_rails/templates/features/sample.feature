Feature: Testing feature system

  Scenario: Homepage test
    Given I am on the home page
    Then I should see "Privacy"
    And I should see "Business Solutions"
    And I should see "About Google"

  Scenario: Feeling luck test
    Given I am on the home page
    When I press "I'm Feeling Lucky"
    Then I should be on path "/search"

