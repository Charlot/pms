module ApplicationHelper

  def batch_destroy
    begin
      model.transaction do
        params[:items].each do |id|
          if item=model.find_by_id(id)
            item.destroy
          end
        end
      end
      render json: {result: true}
    rescue => e
      render json: {result: false, content: e.message}
    end
  end

  # def search
  #   model = params[:controller].classify.constantize
  #   condition = {}
  #   params[:q].each { |k, v|
  #     condition[k] = v
  #   }
  #
  #   results = model.where(condition)
  #   instance_variable_set("@#{params[:controller].pluralize}", results)
  #
  #   respond_to do |format|
  #     format.json { render json: {result: true, content: results} }
  #     format.html { render partial: "search_result" }
  #   end
  # end

  def search
    @condition=params[@model]
    query=model.all#.unscoped
    @condition.each do |k, v|
      if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
        puts @condition.has_key?(k+'_fuzzy')
        if @condition.has_key?(k+'_fuzzy')
          query=query.where("#{k} like ?", "%#{v}%")
        else
          query=query.where(Hash[k, v])
        end
        instance_variable_set("@#{k}", v)
      end

      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        values=v.values.sort
        values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date? & values[0].include?('-')
        values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date? & values[1].include?('-')
        query=query.where(Hash[k, (values[0]..values[1])])
        v.each do |kk, vv|
          instance_variable_set("@#{k}_#{kk}", vv)
        end
      end
    end

    if params.has_key? "download"
      send_data(query.to_xlsx(query),
                :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                :filename => @model.pluralize+".xlsx")
      #render :json => query.to_xlsx(query)
    else
      instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]).all)
      render :index
    end
  end

  def export
    msg = "FileHandler::Excel::#{params[:model]}Handler".constantize.export(params[:q])
    if msg.result
      send_file msg.content
    else
      render json: msg
    end
  end

  def scope_search
    model = params[:model].classify.constantize
    @q = params[:q]
    resultes = model.search_for(@q).paginate(:page => params[:page])
    instance_variable_set("@#{params[:controller]}", resultes)
    render :index
  end


  def form_search
    @condition=params[@model]
    query=model.unscoped
    @condition.each do |k, v|
      if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
        puts @condition.has_key?(k+'_fuzzy')
        if @condition.has_key?(k+'_fuzzy')
          query=query.where("#{k} like ?", "%#{v}%")
        else
          query=query.where(Hash[k, v])
        end
        instance_variable_set("@#{k}", v)
      end

      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        values=v.values.sort
        values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date? & values[0].include?('-')
        values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date? & values[1].include?('-')
        query=query.where(Hash[k, (values[0]..values[1])])
        v.each do |kk, vv|
          instance_variable_set("@#{k}_#{kk}", vv)
        end
      end
    end
    instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]).all)
    if params.has_key? 'download'
      send_data(query.to_xlsx(query),
                :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                :filename => @model.pluralize+".xlsx")
    else
      render :index
    end
  end
end
