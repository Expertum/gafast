class Addeddelivertocheckmodel < ActiveRecord::Migration
  def self.up
    add_column :checks, :deliver, :boolean, :default => false

    remove_column :storages, :deliver
  end

  def self.down
    remove_column :checks, :deliver

    add_column :storages, :deliver, :boolean, :default => false
  end
end
