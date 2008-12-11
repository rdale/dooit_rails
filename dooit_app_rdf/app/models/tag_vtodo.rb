class TagVtodo < ActiveRecord::Base
  belongs_to :vtodo 
  belongs_to :tag
   def before_destroy
    #logger.info("Count9 = %d " % self.tag.vtodos.length)
    if self.tag.vtodos.length == 1
      self.tag.destroy
    end
  end
end
