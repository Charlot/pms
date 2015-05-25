class MasterBomItem < ActiveRecord::Base
  belongs_to :department
  belongs_to :product, class_name: 'Part'
  belongs_to :bom_item, class_name: 'Part'


  def self.search(params)
    q=joins(:department)
          .joins(:product)
          .joins('inner join parts as bom_items on bom_items.id=master_bom_items.bom_item_id')
          .select('master_bom_items.*,parts.nr as product_nr,bom_items.nr as bom_item_nr,departments.name as department_name,departments.code as department_code')
          .order(:product_id)
    unless params[:product_nr].blank?
      q=q.where(parts: {nr: params[:product_nr]})
    end

    unless params[:bom_item_nr].blank?
      q=q.where(bom_items: {nr: params[:bom_item_nr]})
    end

    unless params[:department_id].blank?
      q=q.where(department_id: params[:department_id])
    end
    q
  end
end
