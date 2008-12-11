class Vtodo < ActiveRecord::Base
	has_many :tag_vtodos, :dependent => true, :dependent => :destroy
	has_many :tags, :through => :tag_vtodos 
	validates_presence_of :summary
	validates_presence_of :tags
	def tag_list=(str) #edit.html.erb
		current_list = tags
				
		tag_names = str.split(",").each {|t| t.strip!}
		tags.each do |tag|
			if !tag_names.include?(tag.subject)
				self.tags.destroy(tag)
			end
		end
		tag_names.each do |name|
			tag = Tag.find_by_subject(name)
			if tag.nil?
				tag = Tag.new(:subject => name)
				self.tags << tag
			end
		end	
	end
	def tag_list
		tags.map{|t| t.subject}.join(', ')	
	end
end
