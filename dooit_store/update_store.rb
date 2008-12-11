require 'active_rdf'

db_options = YAML::load(File.open('database.yml'))

pool = ConnectionPool.add_data_source :type => :redland, # :new => true,
    :name => 'db1', :location => :postgresql,
    :host => db_options["host"], :database => db_options["database"],
    :user => db_options["username"], :password => db_options["password"]

Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')
Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')

klasses = ObjectManager.construct_classes
p klasses
