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
                fail_cb(errno)
            end
        end
    end)
    
end




function HttpUtils:SendHttpGet(url, params, success_cb, fail_cb)
    
    if params ~= nil then
        for k,v in pairs(params) do
            url = url .. "&" .. tostring(k) .. "=" .. tostring(v)
        end
    end

    local req = CreateHTTPRequestScriptVM('GET', url)
	req:SetHTTPRequestAbsoluteTimeoutMS(20000)
    req:Send(function(statusCode, body)
        if statusCode ~= 200 or not body then
            if fail_cb ~= nil then
            	fail_cb(obj)
            end
            return
        end

        local obj = JSON:decode(body)
        if callback ~= nil then
        	callback(obj)
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

function HttpUtils:_parseRsp(statusCode, body)
    
    if statusCode ~= 200 or not body then
        return -1, nil
    end
    
    local obj = JSON:decode(body)
    if obj.errno ~= 0 then
        return obj.errno, nil
    end
    
    return 0, obj
    
end

function HttpUtils:SendHTTPPostSync(url, data, timeout)
	local co = coroutine.running()
	self:_HTTPPostRequest("POST", url, JSON:encode(data), function ( statusCode, retBody )
        local errno, rspTable = HttpUtils:_parseRsp(statusCode, body);
		coroutine.resume(co, errno, rspTable)
	end, timeout)
	return coroutine.yield()
end