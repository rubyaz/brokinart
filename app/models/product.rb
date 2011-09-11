class Product < ActiveRecord::Base
  has_and_belongs_to_many :materials
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
end
