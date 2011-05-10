require 'nokogiri'
module DocumentParser

  def parse(filepath)
    document = Nokogiri.XML(File.open(filepath))
    document.css("tu").each do |tu|
      build_segment(tu)
    end
  end

  def build_segment(element)
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

      tu.children.css("tuv").each do |tuv|
        lang = tuv.attributes["lang"].value if tuv.attributes["lang"]
        content = tuv.at("seg").content
        if lang == "EN-US"
          segment[:target_language_id] = lang
          segment[:target_content] = content
        elsif lang == "DE-DE"
          segment[:source_language_id] = lang
          segment[:source_content] = content
        end
      end
      self.segments.build(segment)
      #puts segment
  end

end


