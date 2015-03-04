class Changedfieldtodecimal < ActiveRecord::Migration
  def self.up
    change_column :goods, :count, :decimal, :limit => nil, :precision => 12, :scale => 2, :default => 0.0

    change_column :storages, :count, :decimal, :limit => nil, :precision => 12, :scale => 2, :default => 0.0
  end

  def self.down
    change_column :goods, :count, :string

    change_column :storages, :count, :string
  end
end
