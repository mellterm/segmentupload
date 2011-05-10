# == Schema Information
# Schema version: 20110503060113
#
# Table name: providers
#
#  id            :integer         not null, primary key
#  provider_name :string(255)
#  description   :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Provider < ActiveRecord::Base
  attr_accessible :provider_name, :description
  
  belongs_to :user
  has_many :documents
end
