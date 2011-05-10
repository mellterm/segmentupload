# == Schema Information
# Schema version: 20110505134836
#
# Table name: segments
#
#  id                 :integer         not null, primary key
#  source_content     :string(255)
#  target_content     :string(255)
#  source_language_id :integer
#  target_language_id :integer
#  document_id        :integer
#  creationdate       :datetime
#  creationid         :string(255)
#  changedate         :datetime
#  changeid           :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Segment < ActiveRecord::Base

  belongs_to :document

end
