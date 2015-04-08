class ResourceGroupPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :resource_group
  belongs_to :resource_group_tool, foreign_key: :resource_group_id
end
