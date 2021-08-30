local Set = {}
Set.__index = Set


function Set.new( list )
	if list == nil then list = {} end
	
	local set = {}
	setmetatable( set, Set )

	for _, l in ipairs( list ) do set[ l ] = true end

	return set
end


function Set:union( other )
	local res = Set.new( self )
	for k in pairs( other ) do res[ k ] = true end
	
	return res
end


function Set:intersection( other )
	local res = Set.new()
	for k in pairs( self ) do res[ k ] = other[ k ] end
	
	return res
end


function Set:equals( other )
	local ok = true
	for k in pairs( self ) do 
		if self[ k ] ~= other[ k ] then 
			ok = false
			break
		end
	end
	for k in pairs( other ) do 
		if other[ k ] ~= self[ k ] then 
			ok = false
			break
		end
	end
	
	return ok
end


function Set:tostring()
	local s = "{"
	local sep = ""
	for e in pairs( self ) do
		s = s .. sep .. e
		sep = ", "
	end
	
	return s .. "}"
end


return Set

