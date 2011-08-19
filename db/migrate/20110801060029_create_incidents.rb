class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string   :case_id
      t.date     :occurred_on
      t.string   :occurred_on_str
      t.string   :lat
      t.string   :lng
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
  end
end
