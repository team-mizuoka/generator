require "tempfile"
require "securerandom"
require "sinatra"
require "sinatra/json"
require "sinatra/cors"
require "rmagick"
require "./uploader.rb"

# CORS
set :allow_origin, "https://mizuoka-generator.web.app"
set :allow_methods, "GET,POST"
set :allow_headers, "content-type"
set :expose_headers, "location,link"

$uploader = CloudStorageUploader.new

post "/generate" do
  text = prepare_text(params["text"])
  img = generate(text)
  file_url = upload_image(img)

  status 500
  if file_url != ""
    status 200
  end

  json :location => file_url
end

def prepare_text(text)
  return text
           .slice(0, 50)
           .each_char
           .each_slice(10)
           .map { |s| s.join }
           .join("\n")
end

def generate(text)
  img = Magick::ImageList.new("assets/mizuoka.jpg")

  quote = Magick::Draw.new

  width = 0
  height = 0
  pos_x = 205
  pos_y = 145

  quote.annotate(img, width, height, pos_x, pos_y, text) do
    self.font = "assets/mplus-1p-medium.otf"
    self.pointsize = 60
    self.gravity = Magick::NorthWestGravity
    self.fill = "black"
  end

  return img
end

def upload_image(img)
  file_url = ""

  Tempfile.create do |f|
    img.write(f)

    uuid = SecureRandom.uuid
    output_file_name = "#{uuid}.jpg"

    uploaded_file = $uploader.upload(f, output_file_name)

    file_url = uploaded_file.public_url
  end

  return file_url
end
