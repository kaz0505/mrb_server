# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader'
require "securerandom"

MRBC = '../mruby/bin/mrbc'

get '/' do
  @message =  `#{MRBC} --version`
  erb :index
end

get '/version' do
  `#{MRBC} --version`
end

get '/editor' do
  erb :editor
end


# 一定時間が経過した一時ファイルを削除する
def delete_expired_tmpfile
  Dir.glob('/tmp/*.rb').each do |file|
    if File.mtime(file) < Time.new - 90 then
      File.delete(file)
    end
  end
  Dir.glob('/tmp/*.mrb').each do |file|
    if File.mtime(file) < Time.new - 60 then
      File.delete(file)
    end
  end
end



post '/compile' do

  delete_expired_tmpfile

  src = params[:s]
  key = params[:key]

  if key!="swest" then
    return "Error"
  end

  filename = "/tmp/" + SecureRandom.uuid
  File.open("#{filename}.rb", "w") do |file|
    file.write(src)
  end

  `#{MRBC} -E -o#{filename}.mrb #{filename}.rb`

  File.delete("#{filename}.rb")
  send_file("#{filename}.mrb", filename: 'download.mrb')

end

