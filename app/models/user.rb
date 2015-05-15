class User < ActiveRecord::Base
  
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  validates :first_name, :last_name, :presence => true, on: :create, :if => '!from_omniauth?'
  validates :password, presence: true, length: { minimum: 8 }, on: :create, :if => '!from_omniauth?'
  validates :password_confirmation, presence: true, on: :create, :if => '!from_omniauth?'

  validates :first_name, :last_name, :presence => true, on: :update, :if => '!is_updating_password?'
  validates :password, presence: true, length: { minimum: 8 }, on: :update, :if => 'is_updating_password?'
  validates :password_confirmation, presence: true, on: :update, :if => 'is_updating_password?'
  
  attr_accessor :update_password_section, :create_from_omniauth
  
  def from_omniauth?
    if @create_from_omniauth && @create_from_omniauth == true
      return true 
    else
      return false
    end
  end

  def is_updating_password?
    return @update_password_section
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and customer if they exist
    identity = CustomerIdentity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing customer
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    customer = signed_in_resource ? signed_in_resource : identity.customer

    # Create the customer if needed
    if customer.nil?
      # Get the existing customer by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # customer to verify it on the next step via CustomersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      customer = Customer.where(:email => email).first if email

      # Create the customer if it's a new registration
      if customer.nil?
        customer = Customer.new(
          first_name: auth.extra.raw_info.first_name,
          last_name: auth.extra.raw_info.last_name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        
        #customer.skip_confirmation!
        customer.create_from_omniauth = true
        customer.sn_first_time = true
        customer.save!
        #customer.create_organization
      end
    end

    # Associate the identity with the customer if needed
    if identity.customer != customer
      identity.customer = customer
      identity.save!
    end
    customer
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def full_name
    self.first_name + " " + self.last_name
  end
  
  def update_with_password(params={}) 
    self.update_password_section = true

    if params[:password].blank? 
      @update_password_section = false

      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    else
      params[:sn_first_time] = false
    end 

    super(params)
  end
  
  def update_without_password(params={}) 
    self.update_password_section = true

    if params[:password].blank? 
      @update_password_section = false

      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    else
      params[:sn_first_time] = false
    end 

    super(params)
  end

end
