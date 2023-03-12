module Constants
  # Use Rails.env.secret_key_base in development and test environments. Use ENV["SECRET_KEY_BASE"] in production
  SECRET_KEY = Rails.application.secret_key_base

  TOKEN_EXPIRATION_DATE = 10.minutes.from_now

  GOOGLE_SEARCH_URL = 'https://www.google.com/search'

  CUSTOMER_SEARCH_API = 'https://www.googleapis.com/customsearch'

  START_READ_FROM = 1 # start read csv file from row 1

  JSON_WEB_TOKEN = {
    authorization_error: 'Unauthorized',
    permission_denied: 'Permission denied!!'
  }

  GOOGLE_API_NOTICE = {
    file_required: 'File is required',
    fail_to_call_api: 'Faill to call Google API',
    file_data_size_invalid: 'The number of rows should be between 1 to 100',
    import_success: 'Import search keywords successfully'
  }
end
