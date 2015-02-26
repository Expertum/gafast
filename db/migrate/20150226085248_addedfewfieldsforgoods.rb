class Addedfewfieldsforgoods < ActiveRecord::Migration
  def self.up
    add_column :goods, :morion, :string
    add_column :goods, :codeg, :string
    add_column :goods, :madein, :string
    add_column :goods, :nds, :string
    add_column :goods, :cena, :decimal, :precision => 12, :scale => 2, :default => 0.0
    add_column :goods, :srok, :date
    remove_column :goods, :price
  end

  def self.down
    remove_column :goods, :morion
    remove_column :goods, :codeg
    remove_column :goods, :madein
    remove_column :goods, :nds
    remove_column :goods, :cena
    remove_column :goods, :srok
    add_column :goods, :price, :decimal, :precision => 12, :scale => 2, :default => 0.0
  end
end
