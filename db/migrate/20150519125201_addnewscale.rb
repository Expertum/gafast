class Addnewscale < ActiveRecord::Migration
  def self.up
    change_column :storages, :good_minus, :decimal, :limit => nil, :precision => 12, :scale => 3, :default => 0.0
  end

  def self.down
    change_column :storages, :good_minus, :decimal, :precision => 12, :scale => 2, :default => 0.0
  end
end
