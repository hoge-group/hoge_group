class CreateSeminars < ActiveRecord::Migration
  def change
    create_table :seminars do |t|
      t.string :summary

      t.timestamps
    end
  end
end
