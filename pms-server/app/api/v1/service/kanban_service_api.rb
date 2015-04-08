module V1
  module Service
  class KanbanServiceAPI<BaseAPI
    namespace :kanbans do
      guard_all!

      get :print_code do
        kanban = Kanban.find_by_nr(params[:nr])
        if kanban.present?
          code = ""
          case kanban.ktype
          when KanbanType::WHITE
            code = "P002"
          when KanbanType::BLUE
            code = "P001"
          else
            code = ""
          end
          code
        else
          ""
        end
      end

      get do
        kanbans = Kanban.where(ktype:params[:type]).paginate(:page=> params[:page])
        data = []
        kanbans.each_with_index{|k,index|
          data << {No:index+kanbans.offset+1,Id:k.id,Nr:k.nr,Type:k.ktype}
        }
        data
      end

      get :types do
        KanbanType.to_select
      end
    end
  end
  end
end