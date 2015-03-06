class Addnacenkytogoods < ActiveRecord::Migration
  def self.up
    add_column :goods, :nacenka, :decimal, :precision => 12, :scale => 2, :default => 35
  end

  def self.down
    remove_column :goods, :nacenka
  end
end
