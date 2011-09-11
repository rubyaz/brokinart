class ArtistRole < ActiveRecord::Base
  belongs_to :artist
  belongs_to :product

  def name_and_role
    "#{artist.name} (#{role})"
  end
end
