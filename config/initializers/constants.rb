module Constants
  # Use Rails.env.secret_key_base in development and test environments. Use ENV["SECRET_KEY_BASE"] in production
  SECRET_KEY = Rails.application.secret_key_base

  GOOGLE_SEARCH_URL = 'https://www.google.com/search'

  CUSTOMER_SEARCH_API = 'https://www.googleapis.com/customsearch'

  CSV_FORMAT = 'text/csv'

  READ_START_ROW = 1 # start from 1 because the first row is header

  MAXIMUM_DATA_SIZE = 100

  JSON_WEB_TOKEN = {
    authorization_error: 'Unauthorized',
    permission_denied: 'Permission denied!!'
  }

  GOOGLE_API_NOTICE = {
    file_required: 'File is required',
    file_type_is_not_csv: 'File is not csv',
    file_data_size_invalid: 'The number of rows should be between 1 to 100',
    import_success: 'Import search keywords successfully',
    file_is_processed: 'Your imported file will be processed and displayed in the list.'
  }
end
