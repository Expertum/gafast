class Addednewfildtocheckmodel < ActiveRecord::Migration
  def self.up
    create_table :checks do |t|
      t.string   :check_text
      t.string   :deliver_text
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :poster_id
      t.integer  :filial_id
    end
    add_index :checks, [:poster_id]
    add_index :checks, [:filial_id]
  end

  def self.down
    drop_table :checks
  end
end
