module Destroyable
  extend ActiveSupport::Concern
  included do
    default_scope {where.not(state: KanbanState::DESTROYED)}
  end


  def destroy
	  self.update_attributes(state: KanbanState::DESTROYED)
  end
end
