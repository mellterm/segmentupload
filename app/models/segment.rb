# == Schema Information
# Schema version: 20110510102831
#
# Table name: segments
#
#  id                 :integer         not null, primary key
#  source_content     :string(255)
#  target_content     :string(255)
#  source_language_id :string(255)
#  target_language_id :string(255)
#  document_id        :integer
#  creationdate       :datetime
#  creationid         :string(255)
#  changedate         :datetime
#  changeid           :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  prop               :string(255)
#

class Segment < ActiveRecord::Base
  belongs_to :document
  belongs_to :source_language, :class_name => "Language"
  belongs_to :target_language, :class_name => "Language"
end
