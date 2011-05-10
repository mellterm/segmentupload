class AddPropToSegment < ActiveRecord::Migration
  def self.up
    add_column :segments, :prop, :string
  end

  def self.down
    remove_column :segments, :prop
  end
end
