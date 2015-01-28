module FileHandler
  class Base<BaseClass
    def self.full_tmp_path(file_name)
      File.join($tmp_file_path, Time.now.strftime('%Y%m%d%H%M%S%L')+'-'+file_name)
    end
  end
end