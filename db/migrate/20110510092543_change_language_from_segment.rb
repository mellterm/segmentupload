class ChangeLanguageFromSegment < ActiveRecord::Migration
  def self.up
    change_column :segments, :source_language_id, :string
    change_column :segments, :target_language_id, :string
  end

  def self.down
    change_column :segments, :source_language_id, :integer
    change_column :segments, :target_language_id, :integer
  end
end
