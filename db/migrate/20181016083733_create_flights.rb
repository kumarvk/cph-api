class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.string :type
      t.datetime :date
      t.datetime :exact_time
      t.datetime :expected_time
      t.text :destination
      t.string :flight_no
      t.string :airline
      t.string :status

      t.timestamps
    end
  end
end
