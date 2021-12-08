--Adds commas to your score, apparently
function scorecap(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(,-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function GetChartType(player)
	if GAMESTATE:GetCurrentSteps(player) then
		local stepType = GAMESTATE:GetCurrentSteps(player):GetStepsType()
		local stepDescription = GAMESTATE:GetCurrentSteps(player):GetDescription()
		
		-- This is HORRIBLE I wish an engine function could provide simple names instead
		if stepType ~= nil then
			if IsGame("pump") then
				if stepType == "StepsType_Pump_Single" then
					if string.find(stepDescription, "SP") then
						return "Single P."
					else
						return "Single"
					end
				elseif stepType == "StepsType_Pump_Halfdouble" then
					return "Half-Double"
				elseif stepType == "StepsType_Pump_Double" then
					--Check for StepF2 Double Performance tag
					if string.find(stepDescription, "DP") then
						return "Double P."
					else
						return "Double"
					end
				elseif stepType == "StepsType_Pump_Couple" then
					return "Couple"
				elseif stepType == "StepsType_Pump_Routine" then
					return "Routine"
				else
					return stepType
				end
			elseif IsGame ("dance") then
				if stepType == "StepsType_Dance_Single" then
					return "Single"
				elseif stepType == "StepsType_Dance_Solo" then
					return "Solo"
				elseif stepType == "StepsType_Dance_Threepanel" then
					return "Three Panel"
				elseif stepType == "StepsType_Dance_Double" then
					return "Double"
				elseif stepType == "StepsType_Dance_Couple" then
					return "Couple"
				elseif stepType == "StepsType_Dance_Routine" then
					return "Routine"
				else
					return stepType
				end
			else
				return stepType
			end
		end
	end
end

-- borrowed from RIO
function getRandomWall()
	local sImagesPath = THEME:GetPathG("","Wallpapers");
	local sRandomWalls = FILEMAN:GetDirListing(sImagesPath.."/",false,true)
	 math.randomseed(Hour()*3600+Second())
	return sRandomWalls[math.random(#sRandomWalls)]
end
