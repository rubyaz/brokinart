class CreateArtistRoles < ActiveRecord::Migration
  def self.up
    create_table :artist_roles do |t|
      t.references :artist
      t.references :product
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :artist_roles
  end
end
