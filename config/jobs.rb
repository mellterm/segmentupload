require File.expand_path("../environment", __FILE__)  

job "document.upload" do |args|  
  document = Document.find(args['id'])
  document.import_from_file(args['path']['path'])
end  
