class Artist < ActiveRecord::Base
  has_many :products, :through => :artist_roles
end
