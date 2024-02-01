local Cache = {}
local md5 = require("md5")

local compute_cache_key = function(path)
  local ct = 0
  local keys = {}
  local params = ngx.req.get_uri_args()
  for k,v in pairs(params) do
    keys[ct] = k
    ct = ct + 1
  end

  table.sort(keys)
  
  local str = ""
  
  for i = 0, #keys do      
    local k = keys[i]
    if k and type(params[k]) == 'string' then
      str = str .. k .. "=" .. params[k]
    end      
  end

  local sum = md5.sumhexa(str)
  local k = ngx.req.get_method() .. path .. "-----" .. sum
  --ngx.log(1, "CACHE_KEY: " .. k)
  return k
end

-- there's a reason i'm not using resty.redis that's another discussion all-together
function Cache:new(params)
  params = params or {}
  params.redis = require("redis")
  params.redis_host = params.redis_host or '127.0.0.1'
  params.redis_port = params.redis_port or 6379
  params.redis_client = params.redis.connect(params.redis_host, params.redis_port)
  setmetatable(params, self)
  self.__index = self
  return params
end



function Cache:get(path)
  local params = ngx.req.get_uri_args()
  local k = compute_cache_key(path)
  local v = self.redis_client:get(k)

  if v then
    ngx.header.content_type = "application/json"
    ngx.say(v)
    ngx.exit(200)
  end
end

function Cache:set(path, v)
  local k = compute_cache_key(path)
  self.redis_client:set(k, v)
end

return Cache
