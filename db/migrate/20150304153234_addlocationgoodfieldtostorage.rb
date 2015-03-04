class Addlocationgoodfieldtostorage < ActiveRecord::Migration
  def self.up
    add_column :storages, :location_good, :string
  end

  def self.down
    remove_column :storages, :location_good
  end
end
