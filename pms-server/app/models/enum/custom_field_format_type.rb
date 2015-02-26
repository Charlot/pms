class CustomFieldFormatType<BaseType
  PART='part'
  FLOAT='float'
  INT='int'
  STRING='string'

  def self.method_missing(method_name, *args, &block)
    mn=method_name.to_s.sub(/\?/, '')
    if /\w+\?/.match(method_name.to_s)
      begin
        self.const_get(mn.upcase)==args[0].to_s
      rescue
        super
      end
    else
      super
    end
  end
end