class Addnacenkacurrentfillial < ActiveRecord::Migration
  def self.up
    add_column :filials, :nacenka, :decimal, :precision => 12, :scale => 2, :default => 30
  end

  def self.down
    remove_column :filials, :nacenka
  end
end
