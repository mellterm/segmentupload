require 'nokogiri'
module DocumentParser

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

    tuv = tu.children.css("tuv").first
    lang= Language.find_by_code(tuv.attributes["lang"].value)
    content = get_content(tuv.at("seg"))
    segment[:source_language_id] = lang.id
    segment[:source_content] = content

    tuv = tu.children.css("tuv")[1]
    lang= Language.find_by_code(tuv.attributes["lang"].value)
    content = get_content tuv.at("seg")
    segment[:target_language_id] = lang.id
    segment[:target_content] = content

    self.segments.build(segment)
  end


  def get_content(seg)
   text_tags = skip_tags(seg.children)
   str = ""
   text_tags.each{|t| str = str + t.text}
   str
  end

  def skip_tags(tag)
    discard_tags= ["ut","bpt","ph","ept"]
    tag.reject do |x|
      discard_tags.include?(x.name) || (x.text? && x.text.match(/<\/?cf.*>/))
    end
  end

end


