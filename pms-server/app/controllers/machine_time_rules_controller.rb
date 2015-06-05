class MachineTimeRulesController < ApplicationController
  before_action :set_machine_time_rule, only: [:show, :edit, :update, :destroy]

  # GET /machine_time_rules
  # GET /machine_time_rules.json
  def index
    @machine_time_rules = MachineTimeRule.all
  end

  # GET /machine_time_rules/1
  # GET /machine_time_rules/1.json
  def show
  end

  # GET /machine_time_rules/new
  def new
    @machine_time_rule = MachineTimeRule.new
    # authorize(@machine_time_rule)
  end

  # GET /machine_time_rules/1/edit
  def edit
  end

  # GET/POST
  def import
    # authorize(MachineTimeRule)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::MachineTimeRuleHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  # POST /machine_time_rules
  # POST /machine_time_rules.json
  def create
    @machine_time_rule = MachineTimeRule.new(machine_time_rule_params)
    # authorize(@machine_time_rule)
    respond_to do |format|
      if @machine_time_rule.save
        format.html { redirect_to @machine_time_rule, notice: 'Machine time rule was successfully created.' }
        format.json { render :show, status: :created, location: @machine_time_rule }
      else
        format.html { render :new }
        format.json { render json: @machine_time_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machine_time_rules/1
  # PATCH/PUT /machine_time_rules/1.json
  def update
    respond_to do |format|
      if @machine_time_rule.update(machine_time_rule_params)
        format.html { redirect_to @machine_time_rule, notice: 'Machine time rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @machine_time_rule }
      else
        format.html { render :edit }
        format.json { render json: @machine_time_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_time_rules/1
  # DELETE /machine_time_rules/1.json
  def destroy
    @machine_time_rule.destroy
    respond_to do |format|
      format.html { redirect_to machine_time_rules_url, notice: 'Machine time rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine_time_rule
      @machine_time_rule = MachineTimeRule.find(params[:id])
      # authorize(@machine_time_rule)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_time_rule_params
      params.require(:machine_time_rule).permit(:oee_code_id, :machine_type_id, :length, :time)
    end
end
