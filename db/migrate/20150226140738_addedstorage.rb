class Addedstorage < ActiveRecord::Migration
  def self.up
    create_table :storages do |t|
      t.string   :morion
      t.string   :codeg
      t.string   :name
      t.string   :madein
      t.string   :nds
      t.decimal  :cena, :precision => 12, :scale => 2, :default => 0.0
      t.date     :srok
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :price_id
      t.integer  :filial_id
    end
    add_index :storages, [:price_id]
    add_index :storages, [:filial_id]
  end

  def self.down
    drop_table :storages
  end
end
