module ProcessTemplatesHelper
  def process_type_options
    ProcessType.to_select.map { |t| [t.display, t.value] }
  end

  # build process template
  def build_process_template(params)
    ProcessTemplate.transaction do
      @process_template=ProcessTemplate.new(params[:process_template])
      respond_to do |format|
        if @process_template.save
          unless params[:custom_field].blank?
            if to_enum_value(params[:type])==ProcessType::AUTO
              ProcessTemplateAuto.build_custom_fields(params[:custom_field].keys, @process_template).each do |cf|
                cf.save
              end
            end
          end
          format.html { redirect_to @process_template, notice: 'Process template was successfully created.' }
          format.json { render :show, status: :created, location: @process_template }
        else
          format.html { render :new }
          format.json { render json: @process_template.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # render process template html
  def render_template_html(process_template)

  end
end
