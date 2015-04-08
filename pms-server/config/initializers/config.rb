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

config=YAML.load(File.open("#{Rails.root}/config/config.yml"))
# api default auth user and password
auth=config['api']['auth']
$API_AUTH_USER={user: auth['user'], passwd: auth['password']}

lanka = config['printer']['lanka']
$ROUTE_PART_COUNT= lanka['route_part_count']

kanban_scan = config['kanban']['scan']
$SCAN_BY_KANBAN = kanban_scan['scan_by_kanban']