module ApplicationHelper
  def search
    model = params[:controller].classify.constantize
    condition = {}
    params[:q].each { |k,v|
      condition[k] = v
    }

    results = model.where(condition)
    instance_variable_set("@#{params[:controller].pluralize}",results)

    respond_to do |format|
      format.json {render json: {result:true,content:results}}
      format.html {render partial: "search_result"}
    end
  end
end
