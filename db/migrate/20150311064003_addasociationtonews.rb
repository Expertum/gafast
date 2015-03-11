class Addasociationtonews < ActiveRecord::Migration
  def self.up
    add_column :news, :content, :text
    add_column :news, :poster_id, :integer
    add_column :news, :filial_id, :integer

    add_index :news, [:poster_id]
    add_index :news, [:filial_id]
  end

  def self.down
    remove_column :news, :content
    remove_column :news, :poster_id
    remove_column :news, :filial_id

    remove_index :news, :name => :index_news_on_poster_id rescue ActiveRecord::StatementInvalid
    remove_index :news, :name => :index_news_on_filial_id rescue ActiveRecord::StatementInvalid
  end
end
