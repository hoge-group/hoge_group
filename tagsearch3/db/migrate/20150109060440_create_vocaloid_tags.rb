class CreateVocaloidTags < ActiveRecord::Migration
  def change
    create_table :vocaloid_tags do |t|
      t.string :tag

      t.timestamps
    end
  end
end
