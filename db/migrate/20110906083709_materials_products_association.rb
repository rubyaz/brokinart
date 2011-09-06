class MaterialsProductsAssociation < ActiveRecord::Migration
  def self.up
    create_table :materials_products, :force => true, :id => false do |t|
      t.references :material, :product
    end
  end

  def self.down
    drop_table :materials_products
  end
end
