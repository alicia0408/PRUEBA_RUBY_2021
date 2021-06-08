#metodo request

require 'uri'
require 'net/http'
require 'json'


class RequestNasa
    def initialize (url, api_key)
        @url = url
        @api_key = api_key
        @uri = URI("#{@url}&api_key=#{@api_key}")
    end
  
    def request
        http = Net::HTTP.new(@uri.host, @uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(@uri)
        response = http.request(request)
        hash = JSON.parse(response.read_body)
        buid_web_page(hash)
    end
    
    
    def buid_web_page(hash)
        photos = hash['photos'].map{|x| x['img_src']}
        html_inicio = "<html>\n<head>\n</head>\n<body>\n<ul>\n"
        html_final = "</ul>\n</body>\n</html>"
        html = ""
        photos.each do |photo|
        html += "\t<img src=\"#{photo}\">\n"
    end
  
    File.write('output.html', html_inicio + html + html_final)

end


def photos_count(hash)
    new_hash = []
    hash['photos'].each{|h| 
    new_hash << {name: h['camera']['name'], quantity: h['rover']['total_photos']}}
    puts new_hash

end

end

api_key = 'VSnoHgMTyzQwJYogprHCVn9mVDIl979CJSMvo3OO' 
url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10'
obj = RequestNasa.new(url, api_key)
hash = obj.request



