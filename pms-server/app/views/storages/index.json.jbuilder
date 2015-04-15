json.array!(@storages) do |storage|
  json.extract! storage, :id, :nr, :warehouse_id
  json.url storage_url(storage, format: :json)
end
