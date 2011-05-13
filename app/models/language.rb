class Language < ActiveRecord::Base
  has_many :source_language_segments
end

# == Schema Information
#
# Table name: languages
#
#  id        :integer         not null, primary key
#  code      :string(255)
#  long_name :string(255)
#

