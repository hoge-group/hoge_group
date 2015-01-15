class CreateAnimeTags < ActiveRecord::Migration
  def change
    create_table :anime_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
