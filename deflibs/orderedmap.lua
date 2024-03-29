local OrderedMap = {}
OrderedMap.__index = OrderedMap

function OrderedMap.new()
	local this = {}
	setmetatable( this, OrderedMap )

	this.keyValues = {}
	this.orderedKeys = {}

	return this
end

function OrderedMap:put( key, value )
	if self.keyValues[ key ] == nil then 
		self.orderedKeys[ #self.orderedKeys + 1 ] = key
	end
	self.keyValues[ key ] = value
end	

function OrderedMap:get( key )
	if tonumber( key ) ~= nil then 
		return self.keyValues[ self.orderedKeys[ key ] ]
	else 
		return self.keyValues[ key ]
	end
end

function OrderedMap:has( key )
	return self.keyValues[ key ] ~= nil
end

function OrderedMap:size()
	return #self.orderedKeys
end

function OrderedMap:keys()
	return self.orderedKeys
end

function OrderedMap:contains( value )
	local res = false
	local k
	for _, key in ipairs( self:keys() ) do
		if self:get( key ) == value then
			res = true
			k = key
			break
		end
	end
	return res, k
end

function OrderedMap:foreach( fn )
	if fn == nil then return end
	local result = nil
	for _, key in ipairs( self:keys() ) do
		result = fn( key, self:get( key ) )
		-- Beware, arbitray definition to interrupt prematurely:
		-- If a result is returned from any iteration,
		-- break off iteration and return the value to the caller
		if result ~= nil then return result end
	end
end


return OrderedMap

