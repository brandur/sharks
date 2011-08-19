class Incident < ActiveRecord::Base
  validates_presence_of :case_id
  validates_uniqueness_of :case_id
end
