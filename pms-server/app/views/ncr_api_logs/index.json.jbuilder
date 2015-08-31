json.array!(@ncr_api_logs) do |ncr_api_log|
  json.extract! ncr_api_log, :id, :machine_nr, :order_item_nr, :log_type, :order_item_state, :order_item_qty, :params_detail, :return_detail
  json.url ncr_api_log_url(ncr_api_log, format: :json)
end
