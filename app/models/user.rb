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

  has_many :events
  has_many :apprenticeships
  has_many :workshops
  has_many :signups
  has_many :app_signups
  has_many :work_signups
  has_many :preregs

  has_one :gallery, :dependent => :destroy
  has_many :photos, :through => :gallery
  after_create :create_gallery
  has_attached_file :avatar, :styles => { :large => "214x214#", :medium => "50x50#", :small => "25x25#" }

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :birthday, :terms_of_service, :remember_me, :avatar, :use_gravatar, :phone, :maker_id, :twitter, :facebook, :bio, :website, :webshop

  validates :first_name,  presence: true, length: { maximum: 20 }
  validates :last_name,  presence: true, length: { maximum: 20 }
  validates_uniqueness_of :email, :case_sensitive => false, :message => 'email is already in use'
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'must be a valid email address.'
  validates_confirmation_of :password

  validates :terms_of_service, acceptance: true
  validates :birthday, :date => {:before => Proc.new { Time.now - 13.years }}

  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :email_regexp =>  /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  # after_create :add_user_to_mailchimp unless Rails.env.test?
  # before_destroy :remove_user_from_mailchimp unless Rails.env.test?

  def name
    return "#{first_name} #{last_name}"
  end

  def birthday=(new_date)
      write_attribute(:birthday, Chronic::parse(new_date))
  end

  def age
    now = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  def over_18
    age >= 18
  end

  def update_avatar=(new_avatar)
    write_attribute(:avatar, new_avatar)
  end

  def preregistered?(event)
    preregs.exists?(:event_id => event.id)
  end

  private

    def create_gallery
      self.gallery = Gallery.new
    end

end
