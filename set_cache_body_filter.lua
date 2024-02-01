local headers = ngx.resp.get_headers()

if not headers['x-cache-set'] then
  return
end

local full_p = ngx.var.request_uri
local path = string.match(full_p, "(.*)?")

if not path then
    path = full_p
end 

local chunk = ngx.arg[1]
local eof = ngx.arg[2]

ngx.ctx.buffered = (ngx.ctx.buffered or "") .. chunk
if eof then
  cache:set(path, ngx.ctx.buffered)
end