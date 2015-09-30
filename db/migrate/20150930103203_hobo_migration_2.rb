class HoboMigration2 < ActiveRecord::Migration
  def self.up
    add_column :comments, :news_id, :integer

    add_index :comments, [:news_id]
  end

  def self.down
    remove_column :comments, :news_id

    remove_index :comments, :name => :index_comments_on_news_id rescue ActiveRecord::StatementInvalid
  end
end
