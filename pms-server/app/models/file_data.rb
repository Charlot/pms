class FileData<BaseClass
  attr_accessor :type, :original_name, :size, :path, :path_name, :data, :extension, :uuid_name, :full_path

  # def default
  #   # {:uuid_name => SecureRandom.uuid}
  # end

  def save
    begin
      @extension=File.extname(@original_name).downcase
      if @path_name.nil?
        if @uuid_name
          @path_name=@uuid_name+@extension
        else
          @path_name= "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{@original_name}"
        end
      end
      @full_path=File.join(@path, @path_name)
      File.open(@full_path, 'wb') do |f|
        if @data.kind_of?(String)
          f.write(@data)
        else
          f.write(@data.read)
        end
        @type=FileData.get_type(@full_path)
      end
      return @path_name
    rescue => e
      puts e
      return false
    end
  end

  def self.get_size path
    bytes = File.size(path).to_f
    if bytes<10**3
      return "#{bytes} B"
    elsif bytes<10**6
      return "#{(bytes/10**3).round(2)} KB"
    else
      return "#{(bytes/10**6).round(2)} MB"
    end
  end

  def self.get_type path
    case File.extname(path).downcase
      when '.jpg', '.jpeg', '.gif', '.bmp', '.png'
        return 'image'
      when '.doc', '.docx'
        return 'doc'
      when '.xls', '.xlsx'
        return 'excel'
      when '.ppt', 'pptx'
        return 'ppt'
      when '.pdf'
        return 'pdf'
      when '.csv'
        return 'csv'
      when '.zip'
        return 'zip'
      else
        return 'default'
    end
  end

end
