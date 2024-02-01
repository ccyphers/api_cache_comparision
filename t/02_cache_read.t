use Test::Nginx::Socket 'no_plan';
no_shuffle();
run_tests();

__DATA__
=== TEST 1: Cache is stored in redis
Ensure that data is set in redis

--- server_config
listen       9999;
server_name  localhost;

--- http_config
lua_package_path "./?.lua;;";


--- config

location /verify_redis_data {
  content_by_lua_block {
    local key = 'GET/cacheable-----3f5e55130be741b9809aebfa2477c908'
    local redis = require("redis")
    local redis_host = '127.0.0.1'
    local redis_port = 6379
    local redis_client = redis.connect(redis_host, redis_port)
    local v = redis_client:get(key)

    if v then
      ngx.say(v)
      ngx.exit(200)
    else
      ngx.say('')
      ngx.exit(404)
    end
  }
}

--- request
GET /verify_redis_data
--- response_body
STUB_SERVICE
