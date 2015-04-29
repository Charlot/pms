class ProcessEntitiesController < ApplicationController
  before_action :set_process_entity, only: [:show, :edit, :update, :destroy,
                                   :simple]

  # GET /process_entities
  # GET /process_entities.json
  def index
    @process_entities = ProcessEntity.paginate(:page => params[:page])
  end

  # GET /process_enti
  # ties/1
  # GET /process_entities/1.json
  def show
  end

  # GET /process_entities/new
  def new
    @process_entity = ProcessEntity.new
    authorize(@process_entity)
  end

  # GET /process_entities/1/edit
  def edit
  end

  # GET /process_entities/1/simple
  def simple
    render partial: 'simple',locals:{process_entity:@process_entity}
  end

  #GET

  def export_auto
    authorize(ProcessEntity)
    msg = Message.new
    begin
      msg = FileHandler::Excel::ProcessEntityAutoHandler.export(params[:q])
    rescue => e
      msg.content = e.message
    end
    if msg.result
      send_file msg.content
    else
      render json: msg
    end
  end

  def export_semi
    authorize(ProcessEntity)
    msg = Message.new
    begin
      msg = FileHandler::Excel::ProcessEntitySemiAutoHandler.export(params[:q])
    rescue => e
      msg.content = e.message
    end
    if msg.result
      send_file msg.content
    else
      render json: msg
    end
  end

  # GET POST
  def import_auto
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file,original_name:file.original_filename,path:$upload_data_file_path,path_name:"#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save
        #file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase,file_path: fd.full_path,file_name: file.original_filename)
        msg = FileHandler::Excel::ProcessEntityAutoHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  #GET POST
  def import_semi_auto
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file,original_name:file.original_filename,path:$upload_data_file_path,path_name:"#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save

        #file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase,file_path: fd.full_path,file_name: file.original_filename)
        #msg = FileHandler::Csv::ProcessEntitySemiAutoHandler.import(file)
        msg = FileHandler::Excel::ProcessEntitySemiAutoHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  # GET
  def export_unused
    msg = FileHandler::Csv::ProcessEntityHandler.export_unused(request.user_agent.downcase)
    #render json: msg
    if msg.result
      send_file msg.content
    else
      render json: msg
    end
  end

  # POST /process_entities
  # POST /process_entities.json
  def create
    params.permit!
    ProcessEntity.transaction do
      puts '*****'
      puts params[:process_entity]
      puts params[:custom_field]
      # puts permit_params[:process_entity].except(:custom_field)
      puts '*****'
      @process_entity = ProcessEntity.new(params[:process_entity])
      @process_template=ProcessTemplate.find_by_id(params[:process_entity][:process_template_id])
      @process_entity.process_template=@process_template

      respond_to do |format|
        if @process_entity.save
          unless params[:custom_field].blank?
            if ProcessType.auto?(@process_template.type)
              params[:custom_field].each do |k, v|
                puts "#{k}:#{v}"

                if cf=CustomField.find_by_id(k)
                  cv=CustomValue.new(custom_field_id: k, is_for_out_stock: cf.is_for_out_stock, value: cf.get_field_format_value(v))
                  @process_entity.custom_values<<cv
                end
              end

              # puts '-----------------------------------------------'
              # puts  @process_entity.custom_values.to_json
              # puts '-----------------------------------------------'
              # build process part
              @process_entity.custom_values.each do |cv|
                cf=cv.custom_field
                # puts '*************************'
                # puts cf.to_json
                # puts '*************************'
                if CustomFieldFormatType.part?(cf.field_format) #&& cf.is_for_out_stock
                  puts "*************#{cf.name}"
                  @process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: @process_entity.process_part_quantity_by_cf(cf.name.to_sym))
                end
              end
            elsif ProcessType.semi_auto?(@process_template.type)
              params[:custom_field].each do |k, v|
                puts "#{k}:#{v}"

                if cf=CustomField.find_by_id(k)
                  cv=CustomValue.new(custom_field_id: k, is_for_out_stock: params[:is_for_out_stock].has_key?(k), value: cf.get_field_format_value(v))
                  @process_entity.custom_values<<cv
                end
              end

              @process_entity.custom_values.each do |cv|
                cf=cv.custom_field
                if CustomFieldFormatType.part?(cf.field_format) #&& cf.is_for_out_stock
                  puts "*************#{ params[:out_stock_qty][cf.id.to_s.to_sym]}"
                  @process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: params[:out_stock_qty][cf.id.to_s.to_sym])
                end
              end
            end
            # raise
          end

          format.html { redirect_to @process_entity, notice: 'Process entity was successfully created.' }
          format.json { render :show, status: :created, location: @process_entity }
        else
          format.html { render :new }
          format.json { render json: @process_entity.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /process_entities/1
  # PATCH/PUT /process_entities/1.json
  def update
    respond_to do |format|
      if @process_entity.update(process_entity_params)
        format.html { redirect_to @process_entity, notice: 'Process entity was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_entity }
      else
        format.html { render :edit }
        format.json { render json: @process_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_entities/1
  # DELETE /process_entities/1.json
  def destroy
    @process_entity.destroy
    respond_to do |format|
      format.html { redirect_to process_entities_url, notice: 'Process entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_process_entity
    @process_entity = ProcessEntity.find(params[:id])
    authorize(@process_entity)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def process_entity_params
    params.require(:process_entity).permit(:nr, :name, :description, :stand_time, :process_template_id,:remark, :workstation_type_id, :cost_center_id)
  end
end
