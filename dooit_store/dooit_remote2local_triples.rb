=begin
This script makes a query on the semsol endpoint to retrieve all the triples
in the store on the web. Then it adds each triple to a local Redland Postgres 
based store
=end

require 'active_rdf'

semsol_endpoint = ConnectionPool.add_data_source :type => :sparql, \
  :url => "http://semsol.org/dooit/sparql", \
  :results => :sparql_xml, :engine => :virtuoso

Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')
Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')

ObjectManager.construct_classes

# Just obtain all the triples in the semsol endpoint
query = Query.new.distinct(:v).where(:v, RDF::type, ICAL::Vtodo)
results = query.execute

db_options = YAML::load(File.open('database.yml'))

local_store = ConnectionPool.add_data_source :type => :redland,
    :name => 'db1', :location => :postgresql,
    :host => db_options["host"], :database => db_options["database"],
    :user => db_options["username"], :password => db_options["password"]

$activerdflog.level = Logger::DEBUG

results.each do |result|
  v = ICAL::Vtodo.new(result)
  v.save
end

# kate: space-indent on; indent-width 2; replace-tabs on; mixed-indent off;
