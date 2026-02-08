local Utils = {}

function Utils.contains<T>(table: { T }, target: T): boolean
	for _, value in pairs(table) do
		if value == target then
			return true
		end
	end
	return false
end

return Utils
