class Removesomefields < ActiveRecord::Migration
  def self.up
    remove_column :storages, :date_check
    remove_column :storages, :date_deliver
    remove_column :storages, :check_text
    remove_column :storages, :deliver_text
  end

  def self.down
    add_column :storages, :date_check, :date
    add_column :storages, :date_deliver, :date
    add_column :storages, :check_text, :string
    add_column :storages, :deliver_text, :string
  end
end
