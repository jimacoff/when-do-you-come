class Position < ActiveRecord::Base
  attr_accessible :total_km, :remaining_km,
                  :a_poi_lat,
                  :a_poi_lng,
                  :b_poi_lat,
                  :b_poi_lng,
                  :actual_poi_lat,
                  :actual_poi_lng,
                  :a_timestamp,
                  :remaining_time

end
