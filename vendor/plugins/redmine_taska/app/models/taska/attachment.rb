require 'ftools'
require 'RMagick'

module Taska
  module Attachment
    def self.included(base)
      base.class_eval do
        belongs_to :project
        
        alias_method_chain :before_save, :taska
      end
    end
    
    def before_save_with_taska
      before_save_without_taska
      
      if container.is_a?(Project)
        self.project = container
      else
        self.project = container.project if container.respond_to?(:project)
      end
    end
    
    def after_save
      thumbnail(diskfile, thumb, 200) if image? && !File.file?(thumb)
    end
    
    def thumbnail(source, target, width, height = nil)
      return nil unless File.file?(source)
      height ||= width

      img = Magick::Image.read(source).first
      
      if img.columns > width && img.rows > height 
        rows, cols = img.rows, img.columns
        
        source_aspect = cols.to_f / rows
        target_aspect = width.to_f / height
        thumbnail_wider = target_aspect > source_aspect

        factor = thumbnail_wider ? width.to_f / cols : height.to_f / rows
        img.thumbnail!(factor)
        img.crop!(Magick::CenterGravity, width, height)
      else
        img.resize_to_fit(width, height)
        foo = Magick::Image.new(width, height) {
         self.background_color = 'white'
        }
        
        img = foo.composite(img, Magick::CenterGravity, Magick::OverCompositeOp)
      end

      FileUtils.mkdir_p(File.dirname(target))
      img.write(target) { self.quality = 75 }
    end
    
    def thumb_uri
      "thumbs/#{id}.jpg"
    end
    
    def thumb
      "#{RAILS_ROOT}/public/images/" + thumb_uri
    end
     
    def activity_action
      'uploaded'
    end
  end
end