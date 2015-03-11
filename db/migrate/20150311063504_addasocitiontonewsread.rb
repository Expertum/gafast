class Addasocitiontonewsread < ActiveRecord::Migration
  def self.up
    add_column :news_reads, :news_id, :integer
    add_column :news_reads, :user_id, :integer

    add_index :news_reads, [:news_id]
    add_index :news_reads, [:user_id]
  end

  def self.down
    remove_column :news_reads, :news_id
    remove_column :news_reads, :user_id

    remove_index :news_reads, :name => :index_news_reads_on_news_id rescue ActiveRecord::StatementInvalid
    remove_index :news_reads, :name => :index_news_reads_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
