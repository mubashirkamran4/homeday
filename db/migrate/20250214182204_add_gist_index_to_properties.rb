class AddGistIndexToProperties < ActiveRecord::Migration[7.2]
  def change
    add_index :properties, "ll_to_earth(lat, lng)", using: :gist, name: "index_properties_on_lat_lng_gist"
  end
end
