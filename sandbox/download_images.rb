require 'cocos'

(0..9999).each do |id|
   ## read (local) metadata
   data = read_json( "./tmp/#{id}.json" )
   image_url = data['image']

   res = wget( image_url )

   if res.status.ok?
      content_type   = res.content_type
      content_length = res.content_length

      puts "  content_type: #{content_type}, content_length: #{content_length}"

      format = if content_type =~ %r{image/jpeg}i
                 'jpg'
               elsif content_type =~ %r{image/png}i
                 'png'
               elsif content_type =~ %r{image/gif}i
                 'gif'
               else
                 puts "!! ERROR:"
                 puts " unknown image format content type: >#{content_type}<"
                 exit 1
               end

      ## save image - using b(inary) mode
      write_blob( "./tmp/#{id}.#{format}", res.blob )
   else
      puts "!! ERROR - failed to download image; sorry - #{res.status.code} #{res.status.message}"
      exit 1
   end
end
