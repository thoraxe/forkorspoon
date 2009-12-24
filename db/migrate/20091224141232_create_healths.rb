class CreateHealths < ActiveRecord::Migration
  def self.up
    create_table :healths do |t|
      t.integer :user_id # the user we belong to
      t.decimal :weight, :precision => 4, :scale => 1 # the user's weight
      t.decimal :fat_percent, :precision => 3, :scale => 1 # the user's fat percentage
      t.integer :bmr # the user's BMR
      t.timestamps
    end
  end

  def self.down
    drop_table :healths
  end
end
