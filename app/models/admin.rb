class Admin < ActiveRecord::Base
  # attr_accessible :title, :body
  devise :database_authenticatable, :timeoutable
end
