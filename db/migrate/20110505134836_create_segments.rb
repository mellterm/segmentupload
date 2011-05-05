class CreateSegments < ActiveRecord::Migration
  def self.up
    create_table :segments do |t|
      t.string :source_content
      t.string :target_content
      t.integer :source_language_id
      t.integer :target_language_id
      t.integer :document_id
      t.datetime :creationdate
      t.string :creationid
      t.datetime :changedate
      t.string :changeid

      t.timestamps
    end
  end

  def self.down
    drop_table :segments
  end
end
