use Test::Nginx::Socket 'no_plan';
no_shuffle();
run_tests();

__DATA__
=== TEST 1: Cache is set
Ensure that request is cached for header x-cache-set

--- server_config
listen       9999;
server_name  localhost;

--- http_config
lua_package_path "./?.lua;;";
init_worker_by_lua_block {
    local Cache = require('cache')
    cache = Cache:new() 
}
access_by_lua_file ../../get_cache_access_by_lua.lua;


--- config

location = /stub_service {

  content_by_lua_block {
    ngx.header['X-Cache-Set'] = 1
    ngx.say("STUB_SERVICE")
  }
}

location = /cacheable {
  body_filter_by_lua_file ../../set_cache_body_filter.lua;
  proxy_pass 'http://localhost:1984/stub_service';   
}
--- request
GET /cacheable?a=1&b=2
--- response_body
STUB_SERVICE


