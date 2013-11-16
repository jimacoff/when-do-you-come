class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :total_km
      t.integer :remaining_km
      t.timestamp :a_timestamp
      t.integer :remaining_time
      t.decimal :a_poi_lat
      t.decimal :a_poi_lng
      t.decimal :b_poi_lat
      t.decimal :b_poi_lng
      t.decimal :actual_poi_lat
      t.decimal :actual_poi_lng

      t.timestamps
    end
  end
end