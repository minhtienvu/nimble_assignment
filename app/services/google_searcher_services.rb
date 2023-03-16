module GoogleSearcherServices
  def search_words_from_file(file)
    @file = file
    validate_file!
    @current_user = (@current_user ||= current_user) ## @current_user is for api, while current_user is for web

    ActiveRecord::Base.transaction do
      args = {
        file: @file,
        data: @data,
        current_user: @current_user
      }
      GoogleSearchWordsJob.perform_async(JSON.parse(args.to_json))
    end
  end

  private

  def validate_file!
    return raise StandardError, Constants::GOOGLE_API_NOTICE[:file_required] if @file.blank?

    return raise StandardError, Constants::GOOGLE_API_NOTICE[:file_type_is_not_csv] if @file.content_type != Constants::CSV_FORMAT

    @data = Roo::Spreadsheet.open(@file.tempfile)
    maximum_data_size = Constants::MAXIMUM_DATA_SIZE + Constants::READ_START_ROW

    if (@data.last_row <= Constants::READ_START_ROW) || (@data.last_row > maximum_data_size)
      raise StandardError, Constants::GOOGLE_API_NOTICE[:file_data_size_invalid]
    end
  end
end
