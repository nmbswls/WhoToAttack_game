if HttpUtils == nil then HttpUtils = class({}) end



function HttpUtils:SendHTTPPost(url,game_data,success_cb, fail_cb)
	--document https://partner.steamgames.com/doc/api/isteamhttp
    print(url)
    local req = CreateHTTPRequestScriptVM("POST", url)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
    -- ScoreSystemUpdateCount = ScoreSystemUpdateCount + 1
    --req:SetHTTPRequestGetOrPostParameter("data", JSON:encode(game_data))
    for k,v in pairs(game_data) do
        req:SetHTTPRequestGetOrPostParameter(tostring(k), JSON:encode(v))
    end
    req:Send(function(res)
        if res.StatusCode ~= 200 or not res.Body then
            if fail_cb ~= nil then
                fail_cb();
            end
            return
        end
        local obj = JSON:decode(res.Body)
        if success_cb ~= nil then
            success_cb(obj)
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
    req:Send(function(res)
        if res.StatusCode ~= 200 or not res.Body then
            if fail_callback ~= nil then
            	fail_callback(obj)
            end
            return
        end

        local obj = JSON:decode(res.Body)
        if callback ~= nil then
        	callback(obj)
        end
    end)
end