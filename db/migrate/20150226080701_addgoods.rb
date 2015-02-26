class Addgoods < ActiveRecord::Migration
  def self.up
    create_table :goods do |t|
      t.string   :name
      t.decimal  :price, :precision => 12, :scale => 2, :default => 0.0
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :goods
  end
end
