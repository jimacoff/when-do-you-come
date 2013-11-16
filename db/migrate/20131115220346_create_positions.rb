class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :total_km
      t.integer :remaining_km
      t.timestamp :a_timestamp
      t.integer :remaining_time
      t.decimal :a_poi_lat, :precision => 10, :scale => 7
      t.decimal :a_poi_lng, :precision => 10, :scale => 7
      t.decimal :b_poi_lat, :precision => 10, :scale => 7
      t.decimal :b_poi_lng, :precision => 10, :scale => 7
      t.decimal :actual_poi_lat, :precision => 8, :scale => 7
      t.decimal :actual_poi_lng, :precision => 8, :scale => 7

      t.timestamps
    end
  end
end