class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :volunteer_id
      t.integer :organization_id
      t.string :review
      t.integer :rating, :default => 0
    end
  end
end
