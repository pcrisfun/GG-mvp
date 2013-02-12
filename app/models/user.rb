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
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :birthday, :terms_of_service, :remember_me
  
  validates :first_name,  presence: true, length: { maximum: 20 }
  validates :last_name,  presence: true, length: { maximum: 20 }
  validates_uniqueness_of :email, :case_sensitive => false, :message => 'email is already in use'
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => '
  must be a valid email address.' 
  validates_confirmation_of :password
  validates :terms_of_service, acceptance: true
  validates :birthday, :date => {:before => Proc.new {Time.now - 13.years }}

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :email_regexp =>  /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  after_create :add_user_to_mailchimp unless Rails.env.test?
  before_destroy :remove_user_from_mailchimp unless Rails.env.test?

  def name
    return "#{first_name} #{last_name}"
  end

  def birthday=(new_date)
    write_attribute(:birthday, Chronic::parse(new_date).strftime("%Y-%m-%d %H:%M:%S"))
  end

  # MailChimp list_subscribe options: http://apidocs.mailchimp.com/api/rtfm/listsubscribe.func.php
  def add_user_to_mailchimp
    mailchimp = Hominid::API.new(ENV["MAILCHIMP_API_KEY"])
    list_id = mailchimp.find_list_id_by_name "UsersTest"
    info = {"FNAME" => self.first_name, "LNAME" => self.last_name }
    result = mailchimp.list_subscribe(list_id, self.email, info, 'html', true, true, false, true)
    Rails.logger.info("MAILCHIMP SUBSCRIBE: result #{result.inspect} for #{self.email}")
  end

  # MailChimp list_subscribe options: http://apidocs.mailchimp.com/api/rtfm/listunsubscribe.func.php
  def remove_user_from_mailchimp
    mailchimp = Hominid::API.new(ENV["MAILCHIMP_API_KEY"])
    list_id = mailchimp.find_list_id_by_name "UsersTest"
    result = mailchimp.list_unsubscribe(list_id, self.email, 'html', true, true, true)
    Rails.logger.info("MAILCHIMP UNSUBSCRIBE: result #{result.inspect} for #{self.email}")
  end

  private
end
