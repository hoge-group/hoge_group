class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :tag
      t.string :tag1
      t.string :tag2
      t.string :tag3
      t.string :tag4
      t.string :tag5
      t.string :tag6
      t.string :tag7
      t.string :tag8
      t.string :tag9

      t.timestamps
    end
  end
end
