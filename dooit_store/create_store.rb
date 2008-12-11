=begin
This script creates the Redland based Postgres store, and adds the
ontologies used by the ICAL Vtodo class
=end

require 'active_rdf'

db_options = YAML::load(File.open('database.yml'))

pool = ConnectionPool.add_data_source :type => :redland, :new => true,
    :name => 'db1', :location => :postgresql,
    :host => db_options["host"], :database => db_options["database"],
    :user => db_options["username"], :password => db_options["password"]

pool.load('dc.nt')
pool.load('rdfs.nt')
pool.load('owl.nt')
pool.load('ical.nt')

Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')
Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')
Namespace.register(:owl, 'http://www.w3.org/2002/07/owl#')

# $activerdflog.level = Logger::DEBUG

# The OWL ontology for ICAL::Vtodos is too complex for ActiveRDF to handle
# correctly, so add some triples to simplify it a bit.
pool.add(ICAL::status, RDFS::domain, RDFS::Resource.new(ICAL::Vtodo.uri))
pool.add(ICAL::summary, RDFS::domain, RDFS::Resource.new(ICAL::Vtodo.uri))
pool.add(ICAL::description, RDFS::domain, RDFS::Resource.new(ICAL::Vtodo.uri))
pool.add(DC::subject, RDFS::domain, RDFS::Resource.new(ICAL::Vtodo.uri))
