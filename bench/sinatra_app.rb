
require 'redis'
require 'sinatra/base'

class App < Sinatra::Base
  @@redis = Redis.new  
  get '/cacheable' do
    @@redis.get('GET/cacheable-----d41d8cd98f00b204e9800998ecf8427e')
  end    
end


