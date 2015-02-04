module ProcessTemplatesHelper
  def process_type_options
    ProcessType.to_select.map { |t| [t.display, t.value] }
  end

  def build_process_template
    puts '----------------------------------------'

    puts params
    puts '----------------------------------------'
    ProcessTemplate.transaction do
      @process_template=ProcessTemplate.new(params[:process_template])
      unless params[:process_custom_field].blank?
        if to_enum_value(params[:type])==ProcessType::AUTO
          puts '================='
          params[:process_custom_field].keys.each do |key|
            ProcessTemplateAuto.build_custom_field(key)
          end
          puts '================='

        end
      end
      respond_to do |format|
        if @process_template.save
          format.html { redirect_to @process_template, notice: 'Process template was successfully created.' }
          format.json { render :show, status: :created, location: @process_template }
        else
          format.html { render :new }
          format.json { render json: @process_template.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end
