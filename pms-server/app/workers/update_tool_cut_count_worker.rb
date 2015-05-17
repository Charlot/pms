class UpdateToolCutCountWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :tool)

  def perform(id)
    if (label=ProductionOrderItemLabel.find_by_id(id)) && (item=label.production_order_item)
      if tool1=Tool.find_by_nr(item.tool1)
        tool1.update_attributes(mnt: tool1.mnt+label.qty, tol: tool1.tol+label.qty)
      end

      if tool2=Tool.find_by_nr(item.tool2)
        tool2.update_attributes(mnt: tool2.mnt+label.qty, tol: tool2.tol+label.qty)
      end
    end
  end
end