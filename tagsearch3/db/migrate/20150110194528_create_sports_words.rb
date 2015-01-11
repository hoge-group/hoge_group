class CreateSportsWords < ActiveRecord::Migration
  def change
    create_table :sports_words do |t|

      t.timestamps
    end
  end
end
