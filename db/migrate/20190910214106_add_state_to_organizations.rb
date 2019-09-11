class AddStateToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations,:state,:string
    add_column :organizations,:city,:string
    remove_column :organizations,:location
    ## Added 2 columns and removed as well
  end
end
