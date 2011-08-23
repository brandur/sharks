class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string   :case_id
      t.date     :occurred_on
      t.string   :occurred_on_str
      t.float    :lat, { :length => 10, :decimals => 6 }
      t.float    :lng, { :length => 10, :decimals => 6 }
      t.string   :full_address
      t.string   :country
      t.string   :area
      t.string   :location
      t.string   :activity
      t.string   :name
      t.string   :sex
      t.integer  :age
      t.string   :injury
      t.boolean  :is_fatal
      t.boolean  :is_provoked
      t.string   :time_of_day
      t.string   :species
      t.string   :source

      t.timestamps
    end
    add_index :incidents, :occurred_on
    add_index :incidents, [:lat, :lng]
  end
end
