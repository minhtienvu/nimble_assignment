
### System dependencies
Suppose you clone this project and run it on your locally. Ensure your laptop/computer is familiar with these versions to avoid any problems when running my project.
- Ruby 3.1.3
- Rails 7.0.4
- PostgreSQL

### NOTE
- Because I use the Programmable Search Engine of Google with `a free account with 100 search queries per day`. If you search more than 100 words, it will raise an error `Quota exceeded for quota metric 'Queries' and limit 'Queries per day'`

### Features
- UI features: https://nimble.herokuapp.com/
    1. Log in/Log out
    2. Upload CSV file to search keywords on Google
    3. Store searched keywords and display these on views.
- API features: Refer to API Documentation below. You can also import [my POSTMAN collection](https://github.com/minhtienvu/nimble_assignment/blob/feature/update_read_me_file/nimble_technical_test.postman_collection.json) to test on your POSTMAN.
    1. Login using your registered account.
    2. Get a list of search keywords that belong to this account.
    3. Upload CSV file to search keywords on Google page.

---
#### API Documentation
* Login: Using your registered account to log in
    * Description: Get a new token from your email and password.
    * URL: `/api/v1/login`
    * Method: POST
    * Params
    
        | Parameter | Type   | Required | Description           |
        |-----------|--------|----------|-----------------------|
        | email     | string | Yes      | Your account email    |
        | password  | string | Yes      | Your account password |
    
* Get the search result information for each keyword
    * Description: Get the list of search keywords for this account.
    * URL: `/api/v1/statistics`
    * Method: GET
    * Authorization: Bearer Token
    * Params
        | Parameter | Type    | Required | Description    |
        |-----------|---------|----------|----------------|
        | limit     | integer | No       | Limit records  |
        | offset    | integer | No       | Offset records |
    
* Upload a keyword file
    * Description: Upload CSV file to search keywords on the Google page
    * URL: `/api/v1/statistics/upload`
    * Method: POST
    * Authorization: Bearer Token
    * Params
        | Parameter | Type | Required | Description |
        |-----------|------|----------|-------------|
        | file      | file | Yes      | CSV file    |

## How to test my application
I attached my Postman collection to this project. You can [download it at this link](https://github.com/minhtienvu/nimble_assignment/blob/feature/update_read_me_file/nimble_technical_test.postman_collection.json) and import it to your Postman application to test it easily
- `Local` folder: If you run this project locally, use this folder to test API locally.
- `Heroku` folder: Test API on Heroku.

#### For API features
   - You need to follow these steps as a new user:
       1. If you already have an account, skip this step. If you haven't had an account, create a new account on [this website](https://nimble.herokuapp.com/users/sign_up)
       2. Login with your created account to get a new token in API `/api/v1/login`.
       3. In the Postman application, Choose `Authorization -> Type -> Bearer Token`. Insert your token step 2 in the `Token` input. Be sure to use the valid token to call API.
           *  If you have a `Permission denied!!` error which means your token is expired, please use API `/api/v1/login` again to get a new token(I only set 10 minutes in my project to quickly check expired token).
       4. Call your API.
