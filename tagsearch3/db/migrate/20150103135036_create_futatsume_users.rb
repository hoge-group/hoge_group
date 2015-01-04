class CreateFutatsumeUsers < ActiveRecord::Migration
  def change
    create_table :futatsume_users do |t|

      t.timestamps
    end
  end
end
