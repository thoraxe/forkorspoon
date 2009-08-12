class CreateFoods < ActiveRecord::Migration
  def self.up
    create_table :foods do |t|
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :foods
  end
end
