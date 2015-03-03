class Addcountfieldtostoragengoods < ActiveRecord::Migration
  def self.up
    add_column :goods, :count, :string

    add_column :storages, :count, :string
  end

  def self.down
    remove_column :goods, :count

    remove_column :storages, :count
  end
end
