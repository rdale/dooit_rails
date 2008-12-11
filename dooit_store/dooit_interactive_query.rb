require 'Qt4'
require 'rdf/redland'

SPARQL_QUERY = <<-EOS
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX ical: <http://www.w3.org/2002/12/cal/ical#>

SELECT ?s ?p ?o WHERE { 
     ?s ?p ?o .       
}
EOS

db_options = YAML::load(File.open('database.yml'))

store = Redland::TripleStore.new('postgresql', 'db1', 
  "host='#{db_options['host']}',database='#{db_options['database']}',user='#{db_options['username']}',password='#{db_options['password']}'" )

model = Redland::Model.new store

app = Qt::Application.new(ARGV)
form = Qt::Widget.new

query = Qt::TextEdit.new(form) do |f|
  f.plainText = SPARQL_QUERY
end

result = Qt::TextEdit.new(form)
button = Qt::PushButton.new("SPARQL Query")

layout = Qt::VBoxLayout.new(form) do |l|
  l.addWidget(query)
  l.addWidget(button)
  l.addWidget(result)
end

button.connect(SIGNAL(:clicked)) do 
  str = ""
  redland_query = Redland::Query.new(query.toPlainText, 'sparql')
  query_results = model.query_execute(redland_query)
  if query_results.nil?
    result.textColor = Qt::Color.new(Qt::red)
    result.plainText = "ERROR: INVALID QUERY"
  else
    number_bindings = query_results.binding_names.size
    while !query_results.finished?
      for i in 0...number_bindings
        str << "#{query_results.binding_names[i]} = "
        node = query_results.binding_value(i)
        if node.literal?
           str << Redland.librdf_node_get_literal_value(node.node) + "\n"
        elsif node.blank?
          str << node.to_s.sub(/\((.*)\)/) {|s| "_:#{$1}" } + "\n"
        else
          str << node.uri.to_s + "\n"
        end
      end  
      str << "\n"

      query_results.next
    end
    result.textColor = Qt::Color.new(Qt::black)
    result.plainText = str
  end
end

form.resize(800, 600)
form.show
app.exec