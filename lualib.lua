local lua = {}

-- GLOBAL --------------------------------------
function printf( txt, ... )
	pprint( string.format( txt, ... ) )
end

function sprintf( txt, ... )
	return string.format( txt, ... )
end

function string.split( self, delim )
	local t = {} 
	local wordStart = 1
	local delimStart, delimEnd 
	while true  do
		delimStart, delimEnd = self:find( delim, wordStart )
		if delimStart == nil then 
			if wordStart <= #self then 
				table.insert( t, self:sub( wordStart ))
				break
			end 
		end
		table.insert( t, self:sub( wordStart, delimStart - 1 ) )
		wordStart = delimEnd + 1
	end 
	pprint(t)
	return t
end


string.startsWith = function( s, start )
	return s:sub( 1, #start ) == start
end


string.endsWith = function( s, ending )
	return ending == "" or s:sub(-#ending) == ending
end


string.indexOf = function( s, txt, startAtPos )
	if startAtPos == nil then startAtPos = 0 end

	-- returns two values: start and end position!
	local start, stop = string.find( s, txt, startAtPos, true )
	if start then 
		return start 
	else
		return -1
	end
end


string.lastIndexOf = function( haystack, needle )
	if needle == "." then needle = "%." end
	local i = haystack:match(".*"..needle.."()")
	if i == nil then return nil else return i - 1 end
end


string.between = function( s, strStart, strEnd, isExcluded )
	local pos01 = s:indexOf( strStart )
	if pos01 == nil then return nil end

	local pos02 = s:indexOf( strEnd, pos01 )
	if pos02 == nil then return nil end

	local res = s:sub( pos01, pos02 )
	if isExcluded then 
		if res:len() < 2 then return "" end
		return res:sub( 2, res:len() - 1 )
	else
		return res 
	end
end


string.cntSubstr = function( s1, s2 )
	if s2 == nil then return 0 end
	if s2 == "." then s2 = "%." end

	return select( 2, s1:gsub( s2, "" ) )
end


StringBuilder = {}
function StringBuilder.new( txt )
	local sb = {}
	sb.strings = {}

	function sb:append( txt )
		table.insert( sb.strings, txt )
		return sb
	end

	function sb:remove( index )
		if index == nil then 
			table.remove( sb.strings )
		else
			table.remove( sb.strings, index )
		end
	end

	function sb:toString()
		table.insert( sb.strings, "" )
		return table.concat( sb.strings )
	end

	-- initial value?
	if txt ~= nil then 
		sb:append( txt )
	end

	return sb
end



-- NAMESPACED --------------------------------------
function lua.approximates( value, compare, range )
	return ( value >= compare - range ) and ( value <= compare + range )
end


function lua.randomize()
	math.randomseed( socket.gettime() )
	math.random(); math.random(); math.random()
end

function lua.length( t )
	if t == nil then return 0 end
	
	local count = 0
	for _ in pairs( t ) do count = count + 1 end
	return count
end


function lua.round( num )
	return math.floor( num + .5 )
end


function lua.contains( tab, value )
	for key, item in pairs( tab ) do
		if item == value then
			return true
		end
	end

	return false
end



function lua.haveSameItems( tab1, tab2 )
	if( tab1 == nil ) and ( tab2 == nil ) then return true end
	if( tab1 == nil ) or ( tab2 == nil ) then return false end

	if table.getn( tab1 ) ~= table.getn( tab2 ) then 
		-- print( "Not the same amount of items in tables..." )
		return false 
	end

	local result = true
	for i, item in ipairs( tab1 ) do
		if not lua.contains(  tab2, item ) then
			result = false
			-- break
		end
	end

	return result
end


function lua.concat( t1, t2 )
	for _, v in ipairs( t2 ) do 
		table.insert( t1, v )
	end

	return t1
end


function lua.keys( tab )
	local ks = {}
	local n = 0
	for key, value in pairs( tab ) do
		n = n + 1
		ks[ n ] = key
	end

	return ks
end


function lua.deepcopy( obj )
	if type( obj ) ~= 'table' then return obj end
	local res = {}
	for k, v in pairs( obj ) do res[ lua.deepcopy( k ) ] = lua.deepcopy( v ) end

	return res
end


return lua