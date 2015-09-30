module Destroyable
  extend ActiveSupport::Concern
  included do
    default_scope {where.not(state: CrudState::DESTROYED)}
  end


  def destroy
	  self.update_attributes(state: CrudState::DESTROYED)
    run_callbacks :destroy
    freeze
  end

end
