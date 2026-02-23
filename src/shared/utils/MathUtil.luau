local MathUtil = {}

local Unit = { "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }

-- Formats a number into a more readable string with units (e.g., 1500 -> "1.5K")
function MathUtil:formatNumber(num: number): string
	if num < 1000 then
		return tostring(num)
	end

	local index = 0
	local displayNum = num

	while displayNum >= 1000 and index < #Unit do
		displayNum /= 1000
		index += 1
	end

	local result = string.format("%.2f", displayNum)
	result = result:gsub("%.?0+$", "")
	return result .. Unit[index]
end

return MathUtil
