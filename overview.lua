local overview = {}

overview.iterations = 0;
overview.zoomfactor = 0;
overview.button_a = 0;
overview.button_b = 0;
overview.pause = {value = false}
overview.reset = false;
overview.colorPicker = {value = '#ff0000'}
overview.speed = 1;
overview.debug = {value = false}
overview.cx = 0;
overview.cx_text = {value = "0.0"}
overview.cy = 0;
overview.cy_text = {value = "0.0"}
overview.osc_cx = 0;
overview.osc_cy = 0;
overview.animate_c = false;
overview.swap_button = false;

function overview:drawUI (ui)
	if ui:windowBegin('Render Options', 550, 50, 200, 335, 'border', 'movable', 'title', 'minimizable') then
		ui:layoutRow('dynamic', 315, 1)
		if ui:groupBegin('Group 2', 'border') then

			ui:layoutRow('dynamic', 30, 2)
			
			ui:checkbox('Pause', self.pause)
			if(ui:button('Reset')) then
				self.reset = true
			else
				self.reset = false
			end
			ui:label('Zoom')
			self.zoomfactor = ui:slider(1, self.zoomfactor, 10, 0.0001)
			
			ui:layoutRow('dynamic', 30, 1)
			ui:label('Zoom Level:' .. string.sub(tostring((self.zoomfactor) * 100), 1,5) .. "%")

			ui:label('Color picker:')
			ui:button(nil, self.colorPicker.value)
			ui:layoutRow('dynamic', 90, 1)
			ui:colorPicker(self.colorPicker)

			ui:layoutRow('dynamic', 30, 1)
			ui:checkbox('Debug', self.debug)
			
			ui:groupEnd()
		end
	end
	ui:windowEnd()
	if ui:windowBegin('Fractal Options', 490, 350, 310, 210, 'border', 'movable', 'title', 'minimizable') then
		ui:layoutRow('dynamic', 30, 2);
		ui:label('Iterations: ' .. self.iterations)
		self.iterations = ui:slider(20, self.iterations, 200, 5)
		ui:layoutRow('dynamic', 30, 2);
		ui:label("Osc Speed: " .. string.sub(tostring(self.speed * 100.01), 1,5) .. "%")
		self.speed = ui:slider(0.3, self.speed, 5, 0.1)
		ui:layoutRow('dynamic', 30, 4);
		ui:label('Cx')
		local state, edited = ui:edit('simple', self.cx_text);
		if edited then
			local n = tonumber(self.cx_text.value)
			if n ~= nil then
				self.cx = n;
			end
		end
		ui:label('Cy')
		state, edited = ui:edit('simple', self.cy_text);
		if edited then
			local n = tonumber(self.cy_text.value)
			if n ~= nil then
				self.cy = n;
			end
		end
		ui:layoutRow('dynamic', 30, 4);
		ui:label('Osc Cx')
		self.osc_cx = ui:slider(-1, self.osc_cx, 1, 0.02)
		ui:label('Osc Cy')
		self.osc_cy = ui:slider(-1, self.osc_cy, 1, 0.02)
		ui:layoutRow('dynamic', 30, 1);
		self.swap_button = ui:button("Swap Julia/Mbrot");
	end
	ui:windowEnd();
end

return overview