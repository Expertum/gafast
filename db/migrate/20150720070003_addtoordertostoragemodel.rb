class Addtoordertostoragemodel < ActiveRecord::Migration
  def self.up
    add_column :storages, :to_order, :boolean, :default => false
  end

  def self.down
    remove_column :storages, :to_order
  end
end
