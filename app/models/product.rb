class Product < ActiveRecord::Base
  has_and_belongs_to_many :materials
  has_many :artist_roles
  has_many :artists, :through => :artist_roles

  def material_list
    materials.collect{|m| m.name}.join(', ')
  end

  def material_list=(material_string)
    material_names = material_string.split(',')
    # we are creating a separate list and appending to that since we want to completely replace the materials list rather than just append to it
    material_list = Array.new
    material_names.each do |m|
      # calling downcase here to normalize the names and prevent duplicates like steel, Steel, STEEL
      m_name = m.strip.downcase
      next if m_name.empty?
      material_list.push(Material.find_or_create_by_name(m_name))
    end
    # need explicitly call on self here or ruby will think we are creating a new local variable
    self.materials = material_list
  end

  def artist_list
    artist_roles.collect{|a| a.name_and_role}.join(', ')
  end

  def artist_list=(artist_string)
    artist_names = artist_string.split(',')
    # we are creating a separate list and appending to that since we want to completely replace the artists list rather than just append to it
    role_list = Array.new
    artist_names.each do |a|
      # calling downcase here to normalize the names and prevent duplicates like steel, Steel, STEEL
      a_string = a.strip.downcase
      next if a_string.empty?
      # couldn't decide whether to allow spaces in the role name, they are allowed for now
      role_match = a_string.match /^([\w ]+?)\s*(?:\(\s*([\w ]+?)\s*\))?$/
      next if role_match.nil?
      a_name = role_match[1].strip
      # 'creator' is the default role for now
      role = role_match[2] || 'creator'
      puts "DEBUG: Creating ArtistRole: #{a_name} (#{role})"
      role_list.push(ArtistRole.new(:artist_id => Artist.find_or_create_by_name(a_name).id, :product_id => self.id, :role => role))
    end
    # we are doing this here so we can bail without modification if there are errors
    self.artists.clear
    role_list.each{|r| r.save}
  end
end
