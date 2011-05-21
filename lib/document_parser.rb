require 'nokogiri'
require 'zip/zip'
module DocumentParser
  extend ActiveSupport::Memoizable

  FORMAT_TAGS= ["ut","bpt","ph","ept"]

  def import_from_file(path)
    path = File.extname(path) == ".zip" ? extract(path) : path
    parse(path)
  end

  def parse(filepath)
    reader = Nokogiri::XML::Reader(File.open("/home/minhajuddin/tmx1.xml"))
    reader.each do |node|
      next if node.name != "tu" || node.empty_element? || node.inner_xml.empty?
      save_segment(node)
    end
  end

  protected
  def extract(path)
    archive_path = ""
    Zip::ZipInputStream::open(path) do |io|
      file = io.get_next_entry
      file = io.get_next_entry if file.name_is_directory?
      archive_path = Rails.root.join("archives", "#{Time.now.strftime( "%Y%m%d%H%M%S" )}-#{file.name}")
      File.open(archive_path, "wb") do |f|
        f.write io.read
      end
    end
    archive_path
  end

  def save_segment(node)
    tu = Nokogiri.XML("<tu>#{node.inner_xml}</tu>")

    prop_json = tu.children.css("prop").map { |x| {:type => x.attributes["type"].value, :value => x.content}}.to_json

    source_tuv, target_tuv = tu.children.css("tuv").map do |tuv|
      {
        :lang => find_lang(tuv.attributes["lang"].value).id,
        :content => tuv.at("seg").children.reject {|x| FORMAT_TAGS.include?(x.name) || (x.text? && x.text.match(/<\/?cf.*>/))}.map{|t| t.text}.join
      }
    end

    segment_attrs = {
      :creationdate => node.attributes["creationdate"],
      :creationid => node.attributes["creationid"],
      :changeid => node.attributes["changeid"],
      :changedate => node.attributes["changedate"],
      :prop => prop_json,
      :source_language_id => source_tuv[:lang],
      :source_content => source_tuv[:content],
      :target_language_id => target_tuv[:lang],
      :target_content => target_tuv[:content]
    }

    self.segments.build(segment_attrs).save
  end

  def find_lang(code)
    Language.find_or_create_by_code(code)
  end

  memoize :find_lang

end
