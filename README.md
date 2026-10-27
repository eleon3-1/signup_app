# signup_app

A new Flutter project.

2. Why must the app keep form validation local even when it can ask an AI for a tip? Give one example of a bad decision if AI were allowed to approve signup

The app needs local validators so that it checks the required fields constantly. The email format that needs to include the @ , password length of more than 6 , etc . AI tips should only provide suggestions because they can be wrong or overlook a certain requirement that is required. For example AI could approve a 2 letter password even though the form requires 6 letters or charachters. 

4. Which local test case changed what you implemented? Describe what you observed.

The local error and retry test did not need any changes to the implementation. When i tapped retry after the simulated error the app displayed a tip. This shows that the feature can recover from an error correctly and successfully. 

