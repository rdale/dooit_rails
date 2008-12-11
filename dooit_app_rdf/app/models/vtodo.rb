class ICAL::Vtodo
  VTODO_BASE_URL = "http://localhost:3000/vtodos/"

  def initialize(uri = VTODO_BASE_URL)
    super
    add_predicate('tags', DC::subject)
  end
 
  def tag_list
    tags.join(', ')
  end

  def update_attributes(attributes)
    self.summary = attributes[:summary] unless attributes[:summary].empty?
    if !attributes[:tag_list].empty?
      list = attributes[:tag_list].split(",").each {|t| t.strip!}
      self.tags = list
    end
    self.description = attributes[:description] unless attributes[:description].empty?
    return true
  end

  def self.find(*args)
    results = super(*args)
    results.map {|v| ICAL::Vtodo.new(v)}
  end

  def uuid
    uri =~ Regexp.new("#{VTODO_BASE_URL}(.+)") ? $1 : 0
  end

  def to_param
    uuid
  end

  def self.find_by_id(uuid)
    return ICAL::Vtodo.new("#{VTODO_BASE_URL}#{uuid}")
  end

  def destroy
    db = ConnectionPool.write_adapter
    Query.new.distinct(:p,:o).where(self, :p, :o).execute do |p, o|
      db.delete(self, p, o)
    end
  end

  def self.to_xml(*opts)
    base = Namespace.expand(Namespace.prefix(self),'').chop

    xml = "<?xml version=\"1.0\"?>\n"
    xml += "<rdf:RDF xmlns=\"#{base}\#\"\n"
    Namespace.abbreviations.each { |p| uri = Namespace.expand(p,''); xml += "  xmlns:#{p.to_s}=\"#{uri}\"\n" if uri != base + '#' }
    xml += "  xml:base=\"#{base}\">\n"

    find(:all).each do |vtodo|
      xml += "<rdf:Description rdf:about=\"\##{vtodo.localname}\">\n"
      vtodo.direct_predicates.each do |p|
        objects = Query.new.distinct(:o).where(vtodo, p, :o).execute
        objects.each do |obj|
          prefix, localname = Namespace.prefix(p), Namespace.localname(p)
          pred_xml = if prefix
                       "%s:%s" % [prefix, localname]
                     else
                       p.uri
                     end

          case obj
          when RDFS::Resource
            xml += "  <#{pred_xml} rdf:resource=\"#{obj.uri}\"/>\n"
          when LocalizedString
            xml += "  <#{pred_xml} xml:lang=\"#{obj.lang}\">#{obj}</#{pred_xml}>\n"
          else
            xml += "  <#{pred_xml} rdf:datatype=\"#{obj.xsd_type.uri}\">#{obj}</#{pred_xml}>\n"
          end
        end
      end
      xml += "</rdf:Description>\n"
    end

    xml += "</rdf:RDF>"
  end

end
