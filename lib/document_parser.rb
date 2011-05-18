require 'nokogiri'
module DocumentParser
  extend ActiveSupport::Memoizable

  FORMAT_TAGS= ["ut","bpt","ph","ept"]

  def parse(filepath)
    document = Nokogiri.XML(File.open(filepath))
    document.css("tu").each do |tu|
      build_segment(tu)
    end
  end

  def build_segment(tu)
    segment = {}      
    segment[:creationdate] = tu.attributes["creationdate"].value if tu.attributes["creationdate"]
    segment[:creationid] = tu.attributes["creationid"].value if tu.attributes["creationid"]
    segment[:changeid] = tu.attributes["changeid"].value if tu.attributes["changeid"] 
    segment[:changedate] = tu.attributes["changedate"].value if tu.attributes["changedate"] 

    prop =  []
    tu.children.css("prop").each do |p|
      prop << {:type => p.attributes["type"].value, :value => p.content}
    end

    segment[:prop] = prop.to_json

    source_tuv = tu.children.css("tuv").first
    source_lang= find_lang(source_tuv.attributes["lang"].value)
    source_content = get_content(source_tuv.at("seg"))
    segment[:source_language_id] = source_lang.id
    segment[:source_content] = source_content

    target_tuv = tu.children.css("tuv")[1]
    target_lang= find_lang(target_tuv.attributes["lang"].value)
    target_content = get_content(target_tuv.at("seg"))
    segment[:target_language_id] = target_lang.id
    segment[:target_content] = target_content

    self.segments.build(segment)
  end


  def get_content(seg)
    skip_tags(seg.children).map{|t| t.text}.join#(' ')
  end

  def skip_tags(tag)
    tag.reject do |x|
      FORMAT_TAGS.include?(x.name) || (x.text? && x.text.match(/<\/?cf.*>/))
    end
  end

  def find_lang(code)
    Language.find_or_create_by_code(code)
  end

  memoize :find_lang

end


