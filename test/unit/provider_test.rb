require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Provider.new.valid?
  end
end
