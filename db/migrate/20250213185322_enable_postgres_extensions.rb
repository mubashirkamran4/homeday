class EnablePostgresExtensions < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'cube'
    enable_extension 'earthdistance'
  end
end
