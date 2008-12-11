=begin
Each Vtodo needs to have an ICAL::status of either 'active' or 'done',
and this script adds any missing 'active' predicates. This makes it
easier to perform queries on either all 'active' or all 'done' Vtodos.
=end

require 'active_rdf'

db_options = YAML::load(File.open('database.yml'))

local_store = ConnectionPool.add_data_source :type => :redland,
    :name => 'db1', :location => :postgresql,
    :host => db_options["host"], :database => db_options["database"],
    :user => db_options["username"], :password => db_options["password"]

Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')
Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')

p ObjectManager.construct_classes
vtodos = ICAL::Vtodo.find(:all)
p vtodos
for vtodo in vtodos
  p vtodo.status
  if vtodo.status.nil? 
    local_store.add(vtodo, ICAL::status, 'active')
  end
  p vtodo.status
end

