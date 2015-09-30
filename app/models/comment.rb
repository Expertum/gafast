#encoding: utf-8
class Comment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  after_create do |comment|
    puts '-----------------------------------------'
    puts 'ми в автер сейве'
    @n_id = comment.news.id.to_i
    @p_id = comment.poster_id.to_i
    NewsRead.all.each{|x| if x.news_id.to_i == @n_id && x.user_id != @p_id then x.delete;puts 'delete************************'; end}
  end

  fields do
    content :string
    timestamps
  end
  attr_accessible :content

  belongs_to :recipient, :class_name => "User"

  belongs_to :poster, :class_name => "User", :creator => true
  belongs_to :price, :touch => true
  belongs_to :news, :touch => true

  def recent?
    created_at ? created_at > Time.now - 2.days : false
  end

  # --- Permissions --- #

  def create_permitted?
    return true if acting_user.administrator?
    acting_user.signed_up?
  end

  def update_permitted?
    return true if acting_user.administrator?
    return true if acting_user.farmaceft? && recent?
    poster_is?(acting_user) && recent?
  end

  def destroy_permitted?
    return true if acting_user.administrator?
    return true if acting_user.farmaceft? && recent?
    poster_is?(acting_user) && recent?
  end

  def view_permitted?(field)
    return true if acting_user.administrator?
    true
  end

end
