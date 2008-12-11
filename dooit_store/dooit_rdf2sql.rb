=begin
This script reads all the triples from the semsol endpoint on the web and converts
them to ActiveRecord instances which can be saved in a local Postgres SQL database
=end

require 'active_rdf'
require 'active_record'

require 'vtodo'
require 'tag'
require 'tag_vtodo'

ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))

# Delete all the existing SQL data
Vtodo.delete_all
Tag.delete_all

pool = ConnectionPool.add_data_source :type => :sparql, \
  :url => "http://semsol.org/dooit/sparql", \
  :results => :sparql_xml, :engine => :virtuoso

# ObjectManager.construct_classes.each {|k| puts k}

Namespace.register(:dc, 'http://purl.org/dc/elements/1.1/')
Namespace.register(:ical, 'http://www.w3.org/2002/12/cal/ical#')

# Just obtain all the triples in the database
query = Query.new.distinct(:s, :p, :o).where(:s, :p, :o)
p query.to_s
results = query.execute

vtodo = nil
pending_vtodos = {}
vtodos = {}

results.each do |result|
  puts "***NEW TRIPLE***"
  p result[0]
  p result[1]
  p result[2]

  if result[1] == RDF::type && 
    result[2].kind_of?(RDFS::Resource) && 
    result[2].uri == "http://www.w3.org/2002/12/cal/ical#Vtodo"
    pending_vtodos[result[0].uri] ||= Vtodo.new
    vtodos[result[0].uri] = pending_vtodos[result[0].uri]
  end

  # Note that an RDF::type of Vtodo should always be an RDFS::Resource, and
  # not a literal. However, some of them in the dooit store are actually 
  # literals, and so handle them here.
  if result[1] == RDF::type && 
    result[2] == "http://www.w3.org/2002/12/cal/ical#Vtodo"
    pending_vtodos[result[0].uri] ||= Vtodo.new
    vtodos[result[0].uri] = pending_vtodos[result[0].uri]
  end

  case result[1]
  when DC::subject
    tag = Tag.find_by_subject(result[2])
    if tag.nil?
      tag = Tag.new
      tag.subject = result[2]
      tag.save
    end
    pending_vtodos[result[0].uri] ||= Vtodo.new
    pending_vtodos[result[0].uri].tags << tag
  when DC::modified
    puts "found a modified #{result[2]}"
  when ICAL::summary
    pending_vtodos[result[0].uri] ||= Vtodo.new
    pending_vtodos[result[0].uri].summary = result[2]
  when ICAL::status
    pending_vtodos[result[0].uri] ||= Vtodo.new
    pending_vtodos[result[0].uri].status = result[2]
  when ICAL::description
    puts "found a description #{result[2]}"
  end
end
vtodos.each_pair do |key, todo|
  if todo.status == nil 
    todo.status = ''
  end
end

vtodos.each_pair do |key, todo|
  todo.save
end

v = Vtodo.find(:all)

v.each do |todo|
  puts "summary: #{todo.summary}"
  puts "    status: #{todo.status}"
  puts "    tags: %s" % todo.tags.map{|t| t.subject}.join(', ')
end

# kate: space-indent on; indent-width 2; replace-tabs on; mixed-indent off;
