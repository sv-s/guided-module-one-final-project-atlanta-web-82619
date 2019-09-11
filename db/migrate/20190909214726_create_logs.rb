class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.integer :volunteer_id
      t.integer :organization_id
      t.string :clock_in, :default => '0:0'
      t.string :clock_out, :default => '0:0'
    end
  end
end