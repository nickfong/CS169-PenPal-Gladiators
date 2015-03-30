Feature: allow the user to navigate the site using the navigation bar
    As a registered gladiator
    So that I can access parts of the site more efficiently
    I want to use the navigation bar

Background: I am a registered gladiator who is navigating the site
    Given I am a user with email "foo@bar.com" and password "fizzbuzz"
    And I am signed in with "foo@bar.com"
    And I am on the home page

Scenario: can navigate to the profile page and back
    Given I am on the Home page
    When I follow "Profile"
    Then I should be on the profile page
    When I follow "Home"
    Then I should be on the home page

Scenario: can navigate to the home page and back
    Given I am on the profile page
    When I follow "Home"
    Then I should be on the home page
    When I follow "Profile"
    Then I should be on the profile page