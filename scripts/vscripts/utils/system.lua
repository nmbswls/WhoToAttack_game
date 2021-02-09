function Co( func )
	coroutine.wrap(func)()
end


function Sleep( fTime, szUnique )
    print('try sleep')
	local co = coroutine.running()
	szUnique = szUnique or DoUniqueString("sleep")
	PlayerResource:SetContextThink(szUnique, function ( )
        print('sleep wake')
		coroutine.resume(co)
	end, fTime )
	coroutine.yield()
end