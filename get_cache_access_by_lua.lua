local full_p = ngx.var.request_uri
local path = string.match(full_p, "(.*)?")

if not path then
  path = full_p
end

cache:get(path)