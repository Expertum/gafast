class Addedposteridfortomodel < ActiveRecord::Migration
  def self.up
    add_column :goods, :poster_id, :integer

    add_column :storages, :poster_id, :integer

    add_index :goods, [:poster_id]

    add_index :storages, [:poster_id]
  end

  def self.down
    remove_column :goods, :poster_id

    remove_column :storages, :poster_id

    remove_index :goods, :name => :index_goods_on_poster_id rescue ActiveRecord::StatementInvalid

    remove_index :storages, :name => :index_storages_on_poster_id rescue ActiveRecord::StatementInvalid
  end
end
