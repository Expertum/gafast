class Addprnameforstorage < ActiveRecord::Migration
  def self.up
    add_column :storages, :pr_name, :string
  end

  def self.down
    remove_column :storages, :pr_name
  end
end
