class Addlogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :params, :text
    add_column :logs, :ht_key, :string
    add_column :logs, :message, :string
    add_column :logs, :logable_id, :integer
    add_column :logs, :logable_type, :string
    add_column :logs, :user_id, :integer

    add_index :logs, [:logable_type, :logable_id]
    add_index :logs, [:user_id]
  end

  def self.down
    remove_column :logs, :params
    remove_column :logs, :ht_key
    remove_column :logs, :message
    remove_column :logs, :logable_id
    remove_column :logs, :logable_type
    remove_column :logs, :user_id

    remove_index :logs, :name => :index_logs_on_logable_type_and_logable_id rescue ActiveRecord::StatementInvalid
    remove_index :logs, :name => :index_logs_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
