class Addcheckanddelivertostorage < ActiveRecord::Migration
  def self.up
    add_column :storages, :date_check, :date
    add_column :storages, :date_deliver, :date
    add_column :storages, :check, :boolean, :default => false
    add_column :storages, :deliver, :boolean, :default => false
    add_column :storages, :check_text, :string
    add_column :storages, :deliver_text, :string
  end

  def self.down
    remove_column :storages, :date_check
    remove_column :storages, :date_deliver
    remove_column :storages, :check
    remove_column :storages, :deliver
    remove_column :storages, :check_text
    remove_column :storages, :deliver_text
  end
end
