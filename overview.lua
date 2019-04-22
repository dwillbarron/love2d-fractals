local overview = {}

overview.iterations = 0;
overview.zoomfactor = 0;
overview.button_a = 0;
overview.button_b = 0;
overview.pause = {value = false}
overview.reset = false;
overview.colorPicker = {value = '#ff0000'}
overview.speed = 0.01;
overview.debug = {value = false}

function overview:drawUI (ui)
	if ui:windowBegin('MandelBrot', 550, 50, 200, 500, 'border', 'movable', 'title') then
		ui:layoutRow('dynamic', 450, 1)
		if ui:groupBegin('Group 2', 'border') then

			ui:layoutRow('dynamic', 30, 2)
			
			ui:checkbox('Pause', self.pause)
			if(ui:button('Reset')) then
				self.reset = true
			else
				self.reset = false
			end

			ui:label('Iterations')
			self.iterations = ui:slider(20, self.iterations, 200, 5)
			ui:label('Zoom Factor')
			self.zoomfactor = ui:slider(1, self.zoomfactor, 10, 0.0001)
			ui:label('Speed')
			self.speed = ui:slider(0.005, self.speed, 0.05, 0.001)

			ui:layoutRow('dynamic', 30, 1)
			ui:label('Iterations: ' .. self.iterations)
			ui:layoutRow('dynamic', 30, 1)
			ui:label('Zoom Factor:' .. string.sub(tostring((self.zoomfactor - 1) / 9 * 100), 1,5) .. "%")
			ui:layoutRow('dynamic', 30, 1)
			ui:label("Speed: " .. string.sub(tostring(self.speed * 10001), 1,5) .. "%")

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
end

return overview