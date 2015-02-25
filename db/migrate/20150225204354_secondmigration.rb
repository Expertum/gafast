class Secondmigration < ActiveRecord::Migration
  def self.up
    add_column :comments, :recipient_id, :integer
    add_column :comments, :poster_id, :integer
    add_column :comments, :price_id, :integer

    add_column :prices_reads, :price_id, :integer
    add_column :prices_reads, :user_id, :integer

    add_column :uploads, :uploadable_id, :integer
    add_column :uploads, :uploadable_type, :string
    add_column :uploads, :poster_id, :integer

    add_index :comments, [:recipient_id]
    add_index :comments, [:poster_id]
    add_index :comments, [:price_id]

    add_index :prices_reads, [:price_id]
    add_index :prices_reads, [:user_id]

    add_index :uploads, [:uploadable_type, :uploadable_id]
    add_index :uploads, [:poster_id]
  end

  def self.down
    remove_column :comments, :recipient_id
    remove_column :comments, :poster_id
    remove_column :comments, :price_id

    remove_column :prices_reads, :price_id
    remove_column :prices_reads, :user_id

    remove_column :uploads, :uploadable_id
    remove_column :uploads, :uploadable_type
    remove_column :uploads, :poster_id

    remove_index :comments, :name => :index_comments_on_recipient_id rescue ActiveRecord::StatementInvalid
    remove_index :comments, :name => :index_comments_on_poster_id rescue ActiveRecord::StatementInvalid
    remove_index :comments, :name => :index_comments_on_price_id rescue ActiveRecord::StatementInvalid

    remove_index :prices_reads, :name => :index_prices_reads_on_price_id rescue ActiveRecord::StatementInvalid
    remove_index :prices_reads, :name => :index_prices_reads_on_user_id rescue ActiveRecord::StatementInvalid

    remove_index :uploads, :name => :index_uploads_on_uploadable_type_and_uploadable_id rescue ActiveRecord::StatementInvalid
    remove_index :uploads, :name => :index_uploads_on_poster_id rescue ActiveRecord::StatementInvalid
  end
end
