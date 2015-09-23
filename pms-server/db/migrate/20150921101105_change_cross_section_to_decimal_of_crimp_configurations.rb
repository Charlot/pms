class ChangeCrossSectionToDecimalOfCrimpConfigurations < ActiveRecord::Migration
  def change
    change_column :crimp_configurations, :cross_section, :decimal, :precision => 15, :scale => 10

  end
end
