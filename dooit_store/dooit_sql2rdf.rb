=begin
This script uses ActiveRecord to read all the vtodos in a local Postgres SQL
database and converts them to triples to save in a local Redland Postgres 
based triple store. It prints the data as it goes in a readable format.
=end

require 'active_rdf'
require 'active_record'
require 'uuid'

require 'vtodo'
require 'tag'
require 'tag_vtodo'

ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))

db_options = YAML::load(File.open('database.yml'))

pool = ConnectionPool.add_data_source :type => :redland,
    :name => 'db1', :location => :postgresql,
    :host => db_options["host"], :database => db_options["database"],
    :user => db_options["username"], :password => db_options["password"]

# pool.load 'dc.nt'
# pool.load 'ical.nt'

Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')
Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')

ObjectManager.construct_classes
base_url = "http://semsol.org/dooit/item/"

vtodos = Vtodo.find(:all)
$activerdflog.level = Logger::DEBUG
vtodos.each do |vtodo|
  uid = UUID.generate
  ical = ICAL::Vtodo.new("#{base_url}#{uid}#self")
  ical.save
  ical.summary = vtodo.summary if vtodo.summary 
  ical.status = (vtodo.status == 'done' ? 'done' : 'active') 
  ical.description = vtodo.description if vtodo.description
  ical.subject = vtodo.tags.map{|tag| tag.subject}
 

  puts "summary: #{vtodo.summary}"
  puts "    status: #{vtodo.status}"
  puts "    description: #{vtodo.description}"
  puts "    tags: %s" % vtodo.tags.map{|tag| tag.subject}.join(', ')
end


# kate: space-indent on; indent-width 2; replace-tabs on; mixed-indent off;
