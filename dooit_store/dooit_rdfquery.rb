require 'active_rdf'
require 'active_record'
require 'uuid'

db_options = YAML::load(File.open('database.yml'))

pool = ConnectionPool.add_data_source :type => :redland,
    :name => 'db1', :location => :postgresql,
    :host => db_options["host"], :database => db_options["database"],
    :user => db_options["username"], :password => db_options["password"]

# pool.load 'dc.nt'
# pool.load 'ical.nt'

Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')
Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')

p ObjectManager.construct_classes

# Note that ActiveRDF doesn't support 'OPTIONAL' and so this
# query will only return Vtodos with all the attributes
query = Query.new.select(:vtodo, :summary, :status, :subject).
  where(:vtodo, RDF::type, ICAL.Vtodo).
  where(:vtodo, ICAL::summary, :summary).
  where(:vtodo, ICAL::status, :status).
  where(:vtodo, DC::subject, :subject)

p query.to_s
results = query.execute
p results

results.each do |result|
  p result
end

# kate: space-indent on; indent-width 2; replace-tabs on; mixed-indent off;
