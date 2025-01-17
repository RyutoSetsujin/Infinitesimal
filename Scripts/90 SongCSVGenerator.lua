--Written for RIO, this script will scrape all your sscs and create a csv with useful data.
--Good for checking what difficulties you have and stuff.

function hasLargeJacket(song)
	local songdir  = song:GetSongDir()
	local path = split("/",songdir)
	path = "/SongJacketsLarge/"..path[#path-1];
	--SCREENMAN:SystemMessage(path)
	if FILEMAN:DoesFileExist(path..".png") then
		return true;
	elseif FILEMAN:DoesFileExist(path..".jpg") then
		return true;
	elseif FILEMAN:DoesFileExist(path..".jpeg") then
		return true;
	elseif FILEMAN:DoesFileExist(songdir.."largejk.png") then
		return true;
	end;
	return false;
end;

function returnMeterIfSteps(steps)
	if steps then
		return steps:GetMeter()
	else
		return nil
	end;
end;

--Only return empty string instead of nil... Because of course.
--Short for noNilString.
function nns(obj)
	if obj then return obj else return "" end;
end;

function parseData()
	local groupsToScan = SONGMAN:GetSongGroupNames()
	for j,group in ipairs(groupsToScan) do
		--local group = "05-K-Pop"
		local exportName = THEME:GetCurrentThemeDirectory().."Scripts/export/"..group..".csv"
		local channelName = string.gsub(group,"^%d%d? ?%- ?", "")
		local lines = {}
		for i,song in ipairs(SONGMAN:GetSongsInGroup(group)) do
			if song:GetDisplayFullTitle() ~= "info" then
				local songInformation = {Name,Artist,Channel,Genre,Count,SPN,SPE,SPM,SPH,SPX,DPM,DPH,DPX,RTN,BGA_HD,BGA_SD,Banner,LargeJacket,msg}
				songInformation["Channel"]=channelName;
				songInformation["Name"] = song:GetDisplayFullTitle()
				songInformation["Artist"] = song:GetDisplayArtist()
				songInformation["Genre"] = song:GetGenre()
				songInformation["Banner"] = boolToString((song:HasBanner() or song:HasJacket()))
				songInformation["LargeJacket"] = boolToString(hasLargeJacket(song))
				--Single Difficulties
				songInformation["SPN"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Single','Difficulty_Beginner'))
				songInformation["SPE"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Single','Difficulty_Easy'))
				songInformation["SPM"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Single','Difficulty_Medium'))
				songInformation["SPH"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Single','Difficulty_Hard'))
				songInformation["SPX"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Single','Difficulty_Challenge'))
				--Double difficulties
				songInformation["DPM"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Double','Difficulty_Medium'))
				songInformation["DPH"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Double','Difficulty_Hard'))
				songInformation["DPX"] = returnMeterIfSteps(song:GetOneSteps('StepsType_Pump_Double','Difficulty_Challenge'))
				--Routine
				local routineCharts = song:GetStepsByStepsType('StepsType_Pump_Routine')
				if routineCharts then
					songInformation["RTN"] = returnMeterIfSteps(routineCharts[1])
				end;
				--Build csv line now
				local line = nns(songInformation["Name"])..";"..nns(songInformation["Artist"])..";"..nns(songInformation["Channel"])..";"..nns(songInformation["Genre"])..";"..nns(songInformation["Count"])..";;";
				line = line..nns(songInformation["SPN"])..";"..nns(songInformation["SPE"])..";"..nns(songInformation["SPM"])..";"..nns(songInformation["SPH"])..";"..nns(songInformation["SPX"])..";;";
				line = line..nns(songInformation["DPM"])..";"..nns(songInformation["DPH"])..";"..nns(songInformation["DPX"])..";;"..nns(songInformation["RTN"])..";;;;;"..songInformation["Banner"]..";"..songInformation["LargeJacket"]..";"
				table.insert(lines,line)
			end;
		end;
		local file = RageFileUtil.CreateRageFile();
		file:Open(exportName, 2) --access type: 2(write)
		file:PutLine("NAME;ARTIST;CHANNEL;GENRE;COUNT;PM;SPN;SPE;SPM;SPH;SPX;NONE;DPM;DPH;DPX;NONE;RTN;NONE;BGA_HD;BGA_SD;PREVIEW;BANNER;LARGEJACKET;MSG.TXT")
		for i,line in ipairs(lines) do
			file:PutLine(line)
		end;
		file:Close()
		file:destroy()
		SCREENMAN:SystemMessage(exportName)
	end;
end;
