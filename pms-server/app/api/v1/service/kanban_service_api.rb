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
    end
  end
  end
end