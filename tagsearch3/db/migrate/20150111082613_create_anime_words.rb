class CreateAnimeWords < ActiveRecord::Migration
  def change
    create_table :anime_words do |t|
      t.string :name

      t.timestamps
    end
  end
end
