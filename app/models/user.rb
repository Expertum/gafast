class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name          :string, :required, :unique
    email_address :email_address, :login => true
    phone_number  :string
    administrator :boolean, :default => false
    role          enum_string(:provizor, :farmaceft,:prov_manager,:courier), :required
    receive_messages :boolean, :default => true
    position      :string, :required

    last_active_at   :datetime
    timestamps
  end
  
  attr_accessor :password, :password_confirmation, :current_password
  attr_accessible :phone_number, :receive_messages, :role, :filial, :position,
                  :name, :email_address, :password, :password_confirmation, :current_password

  validates :filial, :presence => true

  # Проверки на роль пользователя
  def provizor?          ;role == :provizor;    end
  def farmaceft?          ;role == :farmaceft;    end
  def prov_manager?       ;role == :prov_manager;      end
  def courier?            ;role == :courier; end


  # - Assossiations ---------------------------------
  has_many :prices, :foreign_key => "poster_id"
  has_many :adjuster_prices, :class_name => "Price", :foreign_key => "adjuster_id"
  has_many :prices_read_assignments, :dependent => :destroy, :class_name => "PricesRead"
  has_many :read_prices, :through => :prices_read_assignments, :dependent => :destroy, :source => :price, :class_name => "Price"


  has_many :comments, :foreign_key => "poster_id"
  has_many :recipient_comments, :class_name => "Comment", :foreign_key => "recipient_id"
  has_many :logs

  has_many :news, :foreign_key => "poster_id"
  has_many :news_reads, :dependent => :destroy
  has_many :read_news, :through => :news_reads

  belongs_to :filial

  # This gives admin rights and an :active state to the first sign-up.
  # Just remove it if you don't want that
  before_create do |user|
    if !Rails.env.test? && user.class.count == 0
      user.administrator = true
      user.state = "active"
    end
  end

  def new_password_required_with_invite_only?
    new_password_required_without_invite_only? || self.class.count==0
  end
  alias_method_chain :new_password_required?, :invite_only

  # --- Signup lifecycle --- #

  lifecycle do

    state :invited, :default => true
    state :active

    create :invite,
           :available_to => "acting_user if acting_user.administrator?",
           :params => [:name, :email_address, :phone_number, :role, :position, :filial],
           :new_key => true,
           :become => :invited do
       UserMailer.invite(self, lifecycle.key).deliver
    end

    transition :accept_invitation, { :invited => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

    transition :request_password_reset, { :active => :active }, :new_key => true do
      logger.info("SENDING MAIL FROM LIFECYCLE")
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

  end

  def signed_up?
    state=="active"
  end

  # --- Permissions --- #

  def create_permitted?
    # Only the initial admin user can be created
    self.class.count == 0
  end

  def update_permitted?
    return true if acting_user.administrator?
    return true if (acting_user == self && only_changed?(:phone_number, :receive_messages,
        :email_address, :crypted_password, :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    return true if acting_user.administrator?
  end

  def view_permitted?(field)
    return true   if self.state == "invited"
    # нужно только для того регистрации первого пользователя
    return true   if self.class.count == 0
    return true   if acting_user.administrator?
    # Разрешаем если это сам пользователь
    return true   if acting_user.class == User && self.id == acting_user.id
    # Совсем не обязательно всем видеть поле receive_messages
    return false  if field == :receive_messages
    # Все остальное можно
    true
  end
end
