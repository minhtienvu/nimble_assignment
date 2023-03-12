
### System dependencies
If you clone this project and run it on your local. Ensure your laptop/computer is familiar with these versions to avoid any problems when running my project.
- Ruby 3.1.3
- Rails 7.0.4
- PostgreSQL

### Features
- UI features: https://nimble.herokuapp.com/
    1. Log in/Log out
    2. Upload CSV file to search keywords on Google
    3. Store searched keywords and display on views.
- API features: Refer my collection to test in your POSTMAN Application

---
#### API External
* Login
    * Description: Get a new token from your email and password.
    * URL: `/api/v1/login`
    * Method: POST
    * Params
    | Parameter | Type | Required  | Description |
    | `email` | `string` | o | Your account email |
    | `password` | `string` | o | Your account password  |
* Get the search result information for each keyword
    * Description: Get list key words
    * URL: `/api/v1/statistics`
    * Authorization: Bearer Token
    * Method: GET
    * Params
    | Parameter | Type | Required  | Description |
    | `limit` | `integer` | x | Limit records |
    | `offset` | `integer` | x | Offset records |
* Upload a keyword file
    * Description: Upload CSV file to search keywords on Google page
    * URL: `/api/v1/statistics/upload`
    * Authorization: Bearer Token
    * Method: POST
    * Params
    | Parameter | Type | Required  | Description |
    | `file` | `file` | true | CSV file |

## How to test my application
I attached my Postman collection on this project. You can [download at this link](https://github.com/minhtienvu/url_shortener/blob/master/Oivan_url_shortened.postman_collection.json) and import it to your Postman application to test it easily :
- `Local` folder: If you clone this project and test it on your local
- `Heroku` folder: If you want to use my project on the Heroku server

#### For API features(particularly `/api/v1/statistics` and `/api/v1/statistics/upload`)
   - You need to follow these steps as a new user:
       1. If you already have an account, skip this step. If you haven't had an account, create a new account on [this link](https://nimble.herokuapp.com/users/sign_up)
       2. Login with your created account to get a new token in API `/api/v1/login`.
       3. In the Postman application, Choose `Authorization -> Type -> Bearer Token`. Insert your token step 2 in `Token` input. Be sure use the valid token to call API.
           *  If you have `Permission denied!!` error which means your token is expired, please use API `/api/v1/login` again to get a new token(I only set 10 minutes for the token in my project).
