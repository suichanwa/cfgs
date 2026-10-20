-- Remove rounded corners across all Yazi UI dialogs, popups, and inputs
local orig_border = getmetatable(ui.Border).__call
getmetatable(ui.Border).__call = function(self, ...)
	local b = orig_border(self, ...)
	return b:type(ui.Border.PLAIN)
end
ui.Border.ROUNDED = ui.Border.PLAIN
