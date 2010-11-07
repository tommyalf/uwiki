require 'sinatra'
require 'tilt' # we need rdiscount too
require 'erb'

get "/" do
  redirect "/pages/home"
end

get '/pages/*' do
  page = params[:splat][0]
  puts page

  page_path = "#{FileUtils.pwd}/pages/#{page}.md"
  if File.exists? page_path
    if params.keys.include? "edit"
      action = :edit
      content = File.read page_path
    else
      action = :show
      content = Tilt.new(page_path).render
    end
  else
    action = :edit
    content = ""
  end
  locals = {
    page: page,
    page_path: page_path,
    content: content
  }
  erb action, :locals => locals
end

get '/themes/*' do
  page = params[:splat][0]
  page_path = "#{FileUtils.pwd}/themes/#{page}"
  if File.exists? page_path
      action = :show
      f = IO.read page_path
      content = f
  end
  content  
end



post '/pages/*' do
  page = params[:splat][0]
  page_path = "#{FileUtils.pwd}/pages/#{page}.md"
  dirname = File.dirname page_path
  FileUtils.mkdir_p dirname unless File.exists? dirname
  content = params[:content]
  File.open(page_path, "w") do |file|
    file.write content
  end
  redirect "/pages/#{page}"
end
