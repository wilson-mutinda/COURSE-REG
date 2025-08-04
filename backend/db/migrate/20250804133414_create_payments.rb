class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :course_name
      t.decimal :cost
      t.string :user_phone
      t.string :status

      t.timestamps
    end
  end
end
