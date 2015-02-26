class Addasociationgoodsandprice < ActiveRecord::Migration
  def self.up
    add_column :goods, :price_id, :integer

    add_index :goods, [:price_id]
  end

  def self.down
    remove_column :goods, :price_id

    remove_index :goods, :name => :index_goods_on_price_id rescue ActiveRecord::StatementInvalid
  end
end
