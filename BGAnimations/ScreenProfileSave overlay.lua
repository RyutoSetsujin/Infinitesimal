local WallpaperDir = getRandomWall()
local UseLogo = true

local t = Def.ActorFrame {

	Def.Quad {
		InitCommand=function(self)
			self:valign(1)
			:halign(0)
			:faderight(1)
			:zoomx(384):zoomy(48)
			:xy(0, SCREEN_BOTTOM)
			:diffuse(0,0,0,0.75)
		end,
		OffCommand=function(self)
			self:linear(0.15)
			:diffusealpha(0)
		end
	},

	Def.BitmapText {
		Font="Montserrat normal 40px",
		Text=ScreenString("Saving Profiles"),
		InitCommand=function(self)
			self:Center()
			:zoom(0.75)
			:diffuse(1,1,1,1)
			:shadowlength(1)
			:valign(1)
			:halign(0)
			:xy(15, SCREEN_BOTTOM-15)
		end,
		OffCommand=function(self)
			self:linear(0.15)
			:diffusealpha(0)
		end
	},

	Def.Sprite {
		Texture=THEME:GetPathG("", "logo"),
		InitCommand=function(self)
			self:visible(string.find(string.lower(WallpaperDir), "withlogo") == nil)
			:halign(1)
			:valign(1)
			:zoom(0.25)
			:xy(SCREEN_RIGHT-15, SCREEN_BOTTOM-10)
			:shadowlength(2)
			:shadowcolor(0,0,0,0.5)
		end
	}
}

t[#t+1] = Def.Actor {
	BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToSave() then self:sleep(1) end
		self:queuecommand("Load")
	end,
	LoadCommand=function() SCREENMAN:GetTopScreen():Continue() end
}

return t
