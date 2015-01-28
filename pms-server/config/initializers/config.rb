# csv config
$csv_separator=';'

# file path
$template_file_path ='uploadfiles/template'
$upload_data_file_path = 'uploadfiles/data'

[$template_file_path, $upload_data_file_path].each do |path|
  FileUtils.mkdir_p(path) unless File.exists?(path)
end