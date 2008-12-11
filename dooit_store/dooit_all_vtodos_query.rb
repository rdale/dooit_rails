require 'active_rdf'

db_options = YAML::load(File.open('database.yml'))

pool = ConnectionPool.add_data_source :type => :redland, :new => true,
    :name => 'db1', :location => :postgresql,
    :host => db_options["host"], :database => db_options["database"],
    :user => db_options["username"], :password => db_options["password"]

Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')
Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')

p ObjectManager.construct_classes
@vtodos = ICAL::Vtodo.find(:all)
# $activerdflog.level = Logger::DEBUG


@vtodos.each do |vtodo|
  puts "summary: #{vtodo.summary}"
  puts "    uri: #{vtodo.uri}"
  #puts "    status: #{vtodo.status}"
  tags = vtodo.subject
  if tags
    tags = [tags] unless tags.kind_of?(Array)
    puts "    tags: #{tags.join(', ')}"
  end
  #puts "    description: #{vtodo.description}"
  
 #vtodo.subject = ['new1', 'new2', 'new3']
 #vtodo.status = 'done'
#vtodo.save
end

# kate: space-indent on; indent-width 2; replace-tabs on; mixed-indent off;
