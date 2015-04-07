class CustomFieldsController < ApplicationController
  before_action :set_custom_field, only: [:show, :edit, :update, :destroy, :validate]

  # GET /custom_fields
  # GET /custom_fields.json
  def index
    @custom_fields = CustomField.all
  end

  # GET /custom_fields/1
  # GET /custom_fields/1.json
  def show
  end

  # GET /custom_fields/new
  def new
    @custom_field = CustomField.new
  end

  # GET /custom_fields/1/edit
  def edit
  end

  # POST /custom_fields
  # POST /custom_fields.json
  def create
    @custom_field = CustomField.new(custom_field_params)

    respond_to do |format|
      if @custom_field.save
        format.html { redirect_to @custom_field, notice: 'Custom field was successfully created.' }
        format.json { render :show, status: :created, location: @custom_field }
      else
        format.html { render :new }
        format.json { render json: @custom_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_fields/1
  # PATCH/PUT /custom_fields/1.json
  def update
    respond_to do |format|
      if @custom_field.update(custom_field_params)
        format.html { redirect_to @custom_field, notice: 'Custom field was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_field }
      else
        format.html { render :edit }
        format.json { render json: @custom_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_fields/1
  # DELETE /custom_fields/1.json
  def destroy
    @custom_field.destroy
    respond_to do |format|
      format.html { redirect_to custom_fields_url, notice: 'Custom field was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def validate
    msg=Message.new
    begin
      if @custom_field
        msg.content = @custom_field.validate_format_field(params[:args])
        msg.result = true
      else
        msg.content = 'no such custom field'
      end
    rescue => e
      msg.content = e.message
    end
    render json: msg
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_custom_field
    @custom_field = CustomField.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def custom_field_params
    params.require(:custom_field).permit(:type, :name, :field_format, :possible_values, :regexp, :min_length, :max_length, :is_required, :is_for_all, :is_filter, :position, :searchable, :default_value, :editable, :visible, :multiple, :format_store, :is_query_value, :validate_query, :value_query, :description)
  end
end
