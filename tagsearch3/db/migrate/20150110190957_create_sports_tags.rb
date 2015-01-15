class CreateSportsTags < ActiveRecord::Migration
  def change
    create_table :sports_tags do |t|

      t.timestamps
    end
  end
end
