# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base

  has_many :apprenticeships
  has_many :workshops
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :birthday, :terms_of_service
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :first_name, 	presence: true, length: { maximum: 50 }
  validates :last_name,  presence: true, length: { maximum: 50 }  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  					uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  validates :terms_of_service, acceptance: true
  validates :birthday, :date => {:before => Proc.new { Time.now - 13.year }}

  def name
    return "#{first_name} #{last_name}"
  end

  def birthday=(new_date)
    write_attribute(:birthday, Chronic::parse(new_date).strftime("%Y-%m-%d %H:%M:%S"))
  end

  def deliver_welcome
    return false unless valid?
    Pony.mail({
      :to => "#{name}<#{email}>", 
      :from => "GirlsGuild<hello@girlsguild.com>",
      :reply_to => "hello@girlsguild.com",
      :subject => "Welcome to GirlsGuild!",
      :body => "Welcome #{name}! Thanks for joining GirlsGuild and being part of our beta tests. Your login is: #{email}",
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_update
    return false unless valid?
    Pony.mail({
      :to => "#{name}<#{email}>",
      :from => "GirlsGuild<hello@girlsguild.com>",
      :reply_to =>  "hello@girlsguild.com",
      :subject => "Boom. You've updated your account",
      :body => "Thanks #{name}. You've updated your account information. If you did not update your account, please let us know by replying to this email. :-)",
    })
    return true
  end 

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
