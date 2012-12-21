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
  validates_inclusion_of :birthday,
            :in => Date.new(1900)..Time.now.years_ago(13).to_date,
            :message => 'Sorry, it looks like you are too young to start an account. You will need to have your parent or legal guardian start an account for you.'
  validates :terms_of_service, acceptance: true

  def birthday=(new_date)
    write_attribute(:birthday, Chronic::parse(new_date).strftime("%Y-%m-%d %H:%M:%S"))
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
