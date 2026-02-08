local Utils = {}

function Utils.contains<T>(source: { T }, target: T): boolean
	for _, value in pairs(source) do
		if value == target then
			return true
		end
	end
	return false
end

function Utils.sub<T>(source: { T }, startIndex: number, endIndex: number?): { T }
	local result: { T } = {}

	local ed = endIndex or #source

	if ed > #source then
		error("endIndex is out of range (" .. ed .. " > " .. #source .. ")")
	elseif ed < startIndex then
		return result
	elseif startIndex < 1 then
		error("startIndex is out of range (" .. startIndex .. " < 1)")
	end

	for i = startIndex, ed do
		table.insert(result, source[i])
	end

	return result
end

return Utils
