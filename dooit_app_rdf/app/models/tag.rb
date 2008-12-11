class Tag < ActiveRecord::Base
  has_many :tag_vtodos
  has_many :vtodos, :through => :tag_vtodos
   validates_presence_of :subject
  def active_total
    count = 0
    vtodos.each do |vtodo|
       if vtodo.status == ''
        count += 1
      #logger.info("vtodoq = %s " % vtodo.status)
      end
    end
    count
  end
  def show_bigger_than_zero(tag_count, tag)
    if tag_count > 0
     string = tag.subject.to_s + ' (' + tag_count.to_s + ')'
    end
  end
  
end
