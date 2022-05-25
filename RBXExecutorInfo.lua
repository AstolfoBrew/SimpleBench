------------- ABOUT
-- SimpleBench ExecutorInfo
-- Used in RobloxLoader.lua to identify the executor. Also provides methods such as http requests.
-- Version: 1.1.2-DEV
-- Author: Yielding#3961
-- License: MIT
-- https://github.com/AstolfoBrew/SimpleBench
------------- CODE
local http_request = http_request or request or (http and http.request) or (syn and syn.request)
local exploit_type = 'Generic'
if getexecutorname then
  exploit_type = getexecutorname() -- Script-Ware is known to use this, however others might too - should return exec name
elseif identifyexecutor then
  exploit_type = identifyexecutor() -- Script-Ware is known to use this, however others might too - should return exec name
elseif KRNL_LOADED then
  exploit_type = 'KRNL'
elseif PROTOSMASHER_LOADED then
  exploit_type = 'ProtoSmasher'
elseif is_sirhurt_closure then
  exploit_type = 'Pedohurt'
elseif SENTINEL_LOADED then
  exploit_type = 'Sentinel'
elseif syn then
  exploit_type = 'Synapse-X'
elseif hookfunction_raw and hmjdfk then
  exploit_type = 'Fluxus Mac Free' -- dk if fluxus mac free still exists; don't think it does
  if not getconnections then
    getgenv().getconnections = function() return {} end
    getgenv().set_thread_context = function() return end
    getgenv().fluxus_loaded = true
  end
elseif FLUXUS_LOADED then
  exploit_type = 'Fluxus'
end
--
local rawinfo = {['name'] = exploit_type; ['http'] = http_request; ['hwid'] = nil; ['id'] = nil}
local info = rawinfo;
if setmetatable then
  local hwid;
  local id;
  local clientInfo;
  local hwidHeaders = {'Sw-Fingerprint'; 'Fingerprint'; 'Syn-Fingerprint'};
  local idHeaders = {
    'Sw-User-Identifier';
    'User-Identifier';
    'Syn-User-Identifier';
    (unpack or table.unpack and (unpack or table.unpack)(hwidHeaders));
  };
  local getClientInfo = function()
    if not clientInfo then clientInfo = rawinfo.http({Url = 'https://httpbin.org/get'}) end
    return clientInfo
  end
  info = setmetatable({}, {
    __index = function(t, k)
      k = string.lower(k)
      if rawinfo[k] then return rawinfo[k] end
      -------------- HWID
      if k == 'hwid' then
        if hwid then
          return hwid
        else
          if not string.find or not string.lower then
            error('{SimpleBench Exec Info} ~ Cannot search string without string.find and string.lower')
          end
          local Body = getClientInfo().Body;
          local ParsedBody = typeof(Body) == 'string' and game:GetService 'HttpService':JSONDecode(Body) or Body
          for h, v in pairs(ParsedBody.headers) do
            if (string.find(string.lower(h), '-fingerprint')) then
              hwid = v;
              return hwid;
            end
            for _, o in pairs(hwidHeaders) do
              if string.lower(h) == string.lower(o) then
                hwid = v
                return hwid
              end
            end
          end
          return hwid
        end
      end
      -------------- EXEC USER ID
      if k == 'id' then
        if id then return id end
        if not string.find or not string.lower then
          error('{SimpleBench Exec Info} ~ Cannot search string without string.find and string.lower')
        end
        local Body = getClientInfo().Body;
        local ParsedBody = typeof(Body) == 'string' and game:GetService 'HttpService':JSONDecode(Body) or Body
        local Headers = ParsedBody.Headers;
        for h, v in pairs(Headers) do
          if (string.find(string.lower(h), '-user-identifier')) then
            id = v;
            return v;
          end
          for _, o in pairs(idHeaders) do
            if string.lower(h) == string.lower(o) then
              id = v
              return v
            end
          end
        end
        return id
      end
    end;
  })
end
return info
