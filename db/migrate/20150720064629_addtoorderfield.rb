class Addtoorderfield < ActiveRecord::Migration
  def self.up
    add_column :goods, :to_order, :boolean, :default => false
  end

  def self.down
    remove_column :goods, :to_order
  end
end
