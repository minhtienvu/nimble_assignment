json.err_msg @message
json.count @count
json.data do
  json.array! @statistics, partial: 'api/v1/external/statistics/statistics', as: :statistic
end
