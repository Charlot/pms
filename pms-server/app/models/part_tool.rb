class PartTool < ActiveRecord::Base
  belongs_to :part
  belongs_to :tool

  validates_uniqueness_of :part_id, scope: :tool_id,message:'已存在此零件和模具组合'
  # validates :part_tools, uniqueness: {scope: [:part_id, :tool_id]}
end
