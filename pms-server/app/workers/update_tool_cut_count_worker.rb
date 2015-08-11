class UpdateToolCutCountWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :tool, retry: false)

  def perform(id)
    if (label=ProductionOrderItemLabel.find_by_id(id)) && (item=label.production_order_item)
      if tool1=Tool.find_by_nr(item.tool1)
        puts "#{tool1.nr}-------------------".red
        tool1.update_attributes(mnt: tool1.mnt+label.qty, tol: tool1.tol+label.qty)
        Mold::RestService.new.update_cut_count(tool1.nr,tool1.mnt,tool1.tol)
      end

      if tool2=Tool.find_by_nr(item.tool2)
        puts "#{tool2.nr}-------------------".yellow
        tool2.update_attributes(mnt: tool2.mnt+label.qty, tol: tool2.tol+label.qty)
        Mold::RestService.new.update_cut_count(tool2.nr,tool2.mnt,tool2.tol)
      end
    end
  end
end