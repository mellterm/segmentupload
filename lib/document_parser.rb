require 'nokogiri'
module DocumentParser

  def parse
    document = Nokogiri.XML(File.open(File.join(Rails.root,"tmp", "#{id}.xml")))
    document.css("tu").each do |tu|
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
      puts segment
    end

  end

end


