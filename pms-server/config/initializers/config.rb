# csv config
$csv_separator=';'

# file path
$template_file_path ='uploadfiles/template'
$upload_data_file_path = 'uploadfiles/data'
$tmp_file_path='uploadfiles/tmp'

[$template_file_path, $upload_data_file_path, $tmp_file_path].each do |path|
  FileUtils.mkdir_p(path) unless File.exists?(path)
  file_path=File.join(path,'.keep')
  FileUtils.touch(file_path) unless File.exists?(file_path)
end