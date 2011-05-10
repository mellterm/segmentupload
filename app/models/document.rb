# == Schema Information
# Schema version: 20110503060113
#
# Table name: documents
#
#  id             :integer         not null, primary key
#  document_name  :string(255)
#  provider_id    :integer
#  uploaded_by_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Document < ActiveRecord::Base
  include DocumentParser
  attr_accessible :document_name
  
  belongs_to :provider
  has_many :segments
  
end
