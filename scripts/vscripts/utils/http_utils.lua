if HttpUtils == nil then HttpUtils = class({}) end



function HttpUtils:SendHTTPPost(url,game_data,success_cb, fail_cb)
	--document https://partner.steamgames.com/doc/api/isteamhttp
    print(url)
    
    self:_HTTPPostRequest("POST", url, JSON:encode(game_data), function(statusCode, body)
        local errno, rsp = HttpUtils:_parseRsp(statusCode, body);
        if errno == 0 then
            if success_cb ~= nil then
                success_cb(rsp)
            end
        else
            if fail_cb ~= nil then
                fail_cb(errno, rsp.errmsg)
            end
        end
    end)
    
end




function HttpUtils:SendHttpGet(url, params, success_cb, fail_cb)
    
    

    local req = CreateHTTPRequestScriptVM('GET', url)
    if params ~= nil then
        for k,v in pairs(params) do
            req:SetHTTPRequestGetOrPostParameter(tostring(k), tostring(v));
            -- url = url .. "&" .. tostring(k) .. "=" .. tostring(v)
        end
    end
	req:SetHTTPRequestAbsoluteTimeoutMS(20000)
    req:Send(function(res)
        local errno, rsp = HttpUtils:_parseRsp(res.StatusCode, res.Body);
        if errno == 0 then
            if success_cb ~= nil then
                success_cb(rsp)
            end
        else
            if fail_cb ~= nil then
                fail_cb(errno)
            end
        end
    end)
end

function HttpUtils:_HTTPPostRequest(method, url, reqBody, cbFunc, fTimeout)
	local req = CreateHTTPRequestScriptVM(method, url)
    
    
    
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
    req:SetHTTPRequestRawPostBody("application/json;charset=UTF-8", reqBody)
    req:SetHTTPRequestAbsoluteTimeoutMS(fTimeout or 5000)
    req:Send(function(res)
        cbFunc(res.StatusCode, res.Body)
        if res.StatusCode == 0 or res.StatusCode >= 400 then
          CustomGameEventManager:Send_ServerToAllClients( "show_server_message", {msg=res.Body, code=res.StatusCode} )
        end
    end)
end

function HttpUtils:_HTTPGetRequest(url, queryString, cbFunc, fTimeout)
	local req = CreateHTTPRequestScriptVM("GET", url)
    
    if queryString ~= nil then
        url = url .. "?";
        for k,v in pairs(queryString) do
            --SetHTTPRequestGetOrPostParameter(tostring(k), tostring(v));
            url = url .. tostring(k) .. "=" .. tostring(v) .. "&" ;
        end
    end
    print('get url ' .. url)
    -- req:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
    
    req:SetHTTPRequestAbsoluteTimeoutMS(fTimeout or 5000)
    req:Send(function(res)
        cbFunc(res.StatusCode, res.Body)
        if res.StatusCode == 0 or res.StatusCode >= 400 then
          CustomGameEventManager:Send_ServerToAllClients( "show_server_message", {msg=res.Body, code=res.StatusCode} )
        end
    end)
end

function HttpUtils:_parseRsp(statusCode, body)
    if not body then
        return -1, {}
    end
    local obj = JSON:decode(body)
    if obj.errno ~= 0 then
        return obj.errno, obj
    end
    
    return 0, obj
end

function HttpUtils:SendHTTPPostSync(url, data, timeout)
	local co = coroutine.running()
	self:_HTTPPostRequest("POST", url, JSON:encode(data), function ( statusCode, retBody )
        local errno, rspTable = HttpUtils:_parseRsp(statusCode, retBody);
		coroutine.resume(co, errno, rspTable)
	end, timeout)
	return coroutine.yield()
end

function HttpUtils:SendHTTPGetSync(url, queryString, timeout)
	local co = coroutine.running()
	self:_HTTPGetRequest(url, queryString, function ( statusCode, retBody )
        local errno, rspTable = HttpUtils:_parseRsp(statusCode, retBody);
		coroutine.resume(co, errno, rspTable)
	end, timeout)
	return coroutine.yield()
end