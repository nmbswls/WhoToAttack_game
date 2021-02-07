function Co( func )
	coroutine.wrap(func)()
end


function Sleep( fTime, szUnique )
	local co = coroutine.running()
	szUnique = szUnique or DoUniqueString("sleep")
	GameMode:SetContextThink(szUnique, function ( )
		coroutine.resume(co)
	end, fTime )
	coroutine.yield()
end