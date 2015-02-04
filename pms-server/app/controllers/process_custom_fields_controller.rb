class ProcessCustomFieldsController < ApplicationController
  before_action :set_process_custom_field, only: [:show, :edit, :update, :destroy]

  # GET /process_custom_fields
  # GET /process_custom_fields.json
  def index
    @process_custom_fields = ProcessCustomField.all
  end

  # GET /process_custom_fields/1
  # GET /process_custom_fields/1.json
  def show
  end

  # GET /process_custom_fields/new
  def new
    @process_custom_field = ProcessCustomField.new
  end

  # GET /process_custom_fields/1/edit
  def edit
  end

  # POST /process_custom_fields
  # POST /process_custom_fields.json
  def create
    @process_custom_field = ProcessCustomField.new(process_custom_field_params)

    respond_to do |format|
      if @process_custom_field.save
        format.html { redirect_to @process_custom_field, notice: 'Process custom field was successfully created.' }
        format.json { render :show, status: :created, location: @process_custom_field }
      else
        format.html { render :new }
        format.json { render json: @process_custom_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /process_custom_fields/1
  # PATCH/PUT /process_custom_fields/1.json
  def update
    respond_to do |format|
      if @process_custom_field.update(process_custom_field_params)
        format.html { redirect_to @process_custom_field, notice: 'Process custom field was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_custom_field }
      else
        format.html { render :edit }
        format.json { render json: @process_custom_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_custom_fields/1
  # DELETE /process_custom_fields/1.json
  def destroy
    @process_custom_field.destroy
    respond_to do |format|
      format.html { redirect_to process_custom_fields_url, notice: 'Process custom field was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_custom_field
      @process_custom_field = ProcessCustomField.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_custom_field_params
      params.require(:process_custom_field).permit(:type, :name, :field_format, :possible_values, :regexp, :min_length, :max_length, :is_required, :is_for_all, :is_filter, :position, :searchable, :default_value, :editable, :visible, :multiple, :format_store, :is_query_value, :validate_query, :value_query, :description)
    end
end
