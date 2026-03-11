PetBattlePokemonMusic = LibStub("AceAddon-3.0"):NewAddon("PetBattlePokemonMusic", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0" );


PokeTracks = {}

-- RSE wild   Start Effect,  Start Length, Music Track

PokeTracks[1] = {File ="Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Pokemon GS Wild.mp3", Name = "Gold & Silver Wild Pokemon Battle"}
PokeTracks[2] = {File ="Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Pokemon RSE Wild.ogg", Name = "Ruby, Saphire, & Emerald Wild Pokemon Battle"}
PokeTracks[3] = {File ="", Name = "Diamond & Pearl Wild Pokemon Battle"}
PokeTracks[4] = {File =" ", Name = "Fire Red & Life Green Wild Pokemon Battle"}
PokeTracks[5] = {File ="Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE Trainer.mp3", Name = "Ruby, Saphire, & Emerald Trainer Battle"}


local PokemonBattleMusicEffects = {}
--2.65
PokemonBattleMusicEffects[1] = {	Name = "Red, Blue, & Yellow Wild Pokemon Battle", 
											StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild Start.ogg",
											StartLength = 2.8,
											MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild.ogg"}
PokemonBattleMusicEffects[2] = {	Name = "Gold & Silver Wild Pokemon Battle", 
											StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild Start.ogg",
											StartLength = 2.65,
											MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild.ogg"}
PokemonBattleMusicEffects[3] = {	Name = "Ruby, Saphire, & Emerald Wild Pokemon Battle", 
											StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Start.ogg",
											StartLength = 2.685,
											MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild.ogg"}
PokemonBattleMusicEffects[4] = {	Name = "FireRed & LifeGreen Wild Pokemon Battle", 
											StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Start.ogg",
											StartLength = 2.485,
											MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild.ogg"}

local BattleStyleList = {}
			BattleStyleList[1] =	"Red, Blue, & Yellow Wild Pokemon Battle"
			BattleStyleList[2] =	"Gold & Silver Wild Pokemon Battle"
			BattleStyleList[3] =	"Ruby, Saphire, & Emerald Wild Pokemon Battle"
			BattleStyleList[4] =	"FireRed & LifeGreen Wild Pokemon Battle"
			--BattleStyleList[5] =	"Diamond & Pearl Wild Pokemon Battle"
			--BattleStyleList[6] =	"HeartGold & SoulSilver Wild Pokemon Battle"
			--BattleStyleList[7] =	"Black & White Wild Pokemon Battle"
			
local trackNames = {}
trackNames[1] = "Red, Blue, & Yellow Wild Pokemon Battle"
trackNames[2] = "Gold & Silver Wild Pokemon Battle"
trackNames[3] = "Ruby, Saphire, & Emerald Wild Pokemon Battle"
--trackNames[4] = "Diamond & Pearl Wild Pokemon Battle"
trackNames[5] = "Fire Red & Life Green Wild Pokemon Battle"
--trackNames[6] = "Ruby, Saphire, & Emerald Trainer Battle"


local HealingSounds = {}
--HealingSounds[1]= "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Healing.ogg"
HealingSounds[2]= "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\Poke GS Healing.ogg"
--HealingSounds[3]= "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\Poke RSE Healing.ogg"
local HealingSoundNames = {}

--HealingSoundNames[1] = "Red, Blue, & Yellow Pokecenter"
HealingSoundNames[2] = "Gold & Silver Pokecenter"
--HealingSoundNames[3] = "Ruby, Saphire, & Emerald Pokecenter"


local main = {
	name = "PetBattlePokemonMusic",
	type = "group",
	handler = PetBattlePokemonMusic,
	args = {
--		confgendesc = {
--			order = 1,
--			type = "description",
--			name = GetAddOnMetadata("PetBattlePokemonMusic", "Notes").."\n\n",
--			cmdHidden = true
--		},
--		confinfodesc = {
--			name = "",
--			type = "group", inline = true,
--			args = {
--				confversiondesc = {
--					order = 1,
--					type = "description",
--					name = "|cffffd700".."version "..": "
----					..G["GREEN_FONT_COLOR_CODE"]..tostring(GetAddOnMetadata("PetBattlePokemonMusic", "Version")).."\n",
--					cmdHidden = true
--				},
--				confauthordesc = {
--					order = 2,
--					type = "description",
--					name = "|cffffd700".."Author "..": "
--					..G["ORANGE_FONT_COLOR_CODE"]..GetAddOnMetadata("PetBattlePokemonMusic", "Author").."\n",
--					cmdHidden = true
--				}

--			}
--		}
	}
}

local WildBattleMusic = {
							name = "Wild",
							type = "group",
							handler = PetBattlePokemonMusic,
							args = {
										WildHeader = {
														type = "header",
														name = "Wild Pet Battle Music",
														order = 1
										},
										WildMusicOn =	{
														type	=		"toggle",
														name	=		"Enabled",
														desc	=		"Toogle whether music is played for wild pet battles or not",
														order	=		2,
														set		=		function (info, val) PetBattlePokemonMusic.db.profile.Wild.On = valu end,
														get		=		function () return PetBattlePokemonMusic.db.profile.Wild.On end
													},
										WildAlwaysOn =	{
														type	=		"toggle",
														name	=		"Always On",
														desc	=		"Toogles whether music will be played if music is disabled on the client",
														order	=		2,
														set		=		function (info, val) PetBattlePokemonMusic.db.profile.Wild.Always = val end,
														get		=		function () return PetBattlePokemonMusic.db.profile.Wild.Always end
													},
										WildTrack =		{
														type	=		"select",
														order	=		3,
														style	=		"dropdown",
														name	=		"Track",
														values	=		trackNames,
														width	=		"double",
														set		=		function(info, val) PetBattlePokemonMusic.db.profile.Wild.Track = val  end,
														get		=		function() return PetBattlePokemonMusic.db.profile.Wild.Track end
										},
								TrainerHeader = {
														type = "header",
														name = "Trainer Pet Battle Music",
														order = 4
										},
								TrainerMusicOn =	{
														type	=		"toggle",
														name	=		"Enabled",
														desc	=		"Toogle whether music is played for trainer pet battles or not",
														order	=		5,
														set		=		function (info, val) PetBattlePokemonMusic.db.profile.Trainer.On = valu end,
														get		=		function () return PetBattlePokemonMusic.db.profile.Trainer.On end
													},
										TrainerAlwaysOn =	{
														type	=		"toggle",
														name	=		"Always On",
														desc	=		"Toogles whether music will be played if music is disabled on the client",
														order	=		5,
														set		=		function (info, val) PetBattlePokemonMusic.db.profile.Trainer.Always = val end,
														get		=		function () return PetBattlePokemonMusic.db.profile.Trainer.Always end
													},
										TrainerTrack =		{
														type	=		"select",
														order	=		6,
														style	=		"dropdown",
														name	=		"Track",
														values	=		trackNames,
														set		=		function(info, val) PetBattlePokemonMusic.db.profile.Trainer.Track = val  end,
														get		=		function() return PetBattlePokemonMusic.db.profile.Trainer.Track end
													}
								
								
								
								
								
								
								
								
								--,
							--		CustomOn =	{
							--							type	=		"toggle",
							--							name	=		"Custom Track",
							--							desc	=		"Toogles whether the music will be used from a custom track",
								--						order	=		4,
								--						set		=		function (info, val) PetBattlePokemonMusic.db.profile.Wild.Custom = val end,
								--						get		=		function () return PetBattlePokemonMusic.db.profile.Wild.Custom end
									--				}--,
					--				CustomTracks =		{
					--									type	=		"select",
					--									order	=		4,
					--									style	=		"dropdown",
					--									name	=		"Custom Tracks",
					--									values	=		PetBattlePokemonMusic.db.profile.TrackNames,
					--									set		=		function(info, val) PetBattlePokemonMusic.db.profile.Wild.CustomTracks = val  end,
					--									get		=		function() return PetBattlePokemonMusic.db.profile.Wild.CustomTracks end
					--								},
									}
						}
local TrainerBattleMusic = {
							name = "Trainer",
							type = "group",
							handler = PetBattlePokemonMusic,
							args = {
										TrainerMusicOn =	{
														type	=		"toggle",
														name	=		"Enabled",
														desc	=		"Toogle whether music is played for trainer pet battles or not",
														order	=		2,
														set		=		function (info, val) PetBattlePokemonMusic.db.profile.Trainer.On = valu end,
														get		=		function () return PetBattlePokemonMusic.db.profile.Trainer.On end
													},
										TrainerAlwaysOn =	{
														type	=		"toggle",
														name	=		"Always On",
														desc	=		"Toogles whether music will be played if music is disabled on the client",
														order	=		2,
														set		=		function (info, val) PetBattlePokemonMusic.db.profile.Trainer.Always = val end,
														get		=		function () return PetBattlePokemonMusic.db.profile.Trainer.Always end
													},
										TrainerTrack =		{
														type	=		"select",
														order	=		3,
														style	=		"dropdown",
														name	=		"Track",
														values	=		trackNames,
														set		=		function(info, val) PetBattlePokemonMusic.db.profile.Trainer.Track = val  end,
														get		=		function() return PetBattlePokemonMusic.db.profile.Trainer.Track end
													}
									}
						}
local tempName = ""
local tempFile =""
local previewSelect = "none"
local removeSelect = "none"
local OtherSounds = {
							name = "Custom Tracks",
							type = "group",
							handler = PetBattlePokemonMusic,
							args = {
									HealingHeader = {
														type = "header",
														name = "Healing Pets",
														order = 1
									},
									HealingSoundOn =	{
														type	=		"toggle",
														name	=		"Enabled",
														desc	=		"Toogle whether pokemon center sound effect is played when healing your pets or not",
														order	=		2,
														set		=		function (info, val) PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Enabled = valu end,
														get		=		function () return PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Enabled end
													},
									HealingPets = {
															type = "select",
															name = "Healing Pet Sound",
															values = HealingSoundNames,
															get = function() return PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Value end,
															set = function(info, val) PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Value = val end,
															style = "dropdown",
															order = 2
														}
							
									}
}
local CustomTrackMenu = {
							name = "Custom Tracks",
							type = "group",
							handler = PetBattlePokemonMusic,
							args = {
										NewHeader = {
														type = "header",
														name = "Add Track",
														order = 1
													},
										NewTrackName = {
															type = "input",
															name = "New Track Name",
															get = function () return tempName end,
															set = function(info, val) tempName = val end,
															order = 2
														},
										NewTrackFile = {
															type = "input",
															name = "New Track File",
															get = function () return tempFile end,
															set = function(info, val)tempFile=val end,
															order = 2
														},
										NewTrackAdd = {
															type = "execute",
															name = "Add",
															func = function(...) if PetBattlePokemonMusic.db.profile.CustomTracks[tempName] == nil then 
																tinsert(PetBattlePokemonMusic.db.profile.TrackNames, tempName)
																PetBattlePokemonMusic.db.profile.CustomTracks[tempName] = tempFile end end,
															order = 2
														},
										PreviewHeader = {
															type = "header",
															name = "Preview Track",
															order = 3
										},
										PreviewSelect = {
															type = "select",
															name = "Custom Tracks",
															values = function () return PetBattlePokemonMusic.db.profile.TrackNames end,
															get = function() return previewSelect end,
															set = function(info, val) previewSelect = val end,
															style = "dropdown",
															order = 4
														},
										PreviewButton = {
															type = "execute",
															name = "Preview",
															func = function(...) if PetBattlePokemonMusic.db.profile.CustomTracks[tempName] == nil then PetBattlePokemonMusic.db.profile.CustomTracks[tempName] = tempFile end end,
															order = 4
										
														},


									}



						}

--Editbox for track name
--Editbox for track file location






local defaults = {
	profile={	
				Wild = {
							Track = 3,
							On = true,
							Always = true,
							Custom = false,
							CustomTrack = 1
						},
				Trainer = {
							Track = 2,
							On = true,
							Always = true,
							Custom = false,
							CustomTrack = 1
							},
		

				CustomTracks = {},
				TrackNames = {},
				SoundEffects ={HealingSound = {Value =3, Enabled = true}} --PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound
				
			}
				}
function PetBattlePokemonMusic:SetUpDefaults()
	defaults.profile.CustomTracks["None"] = "Empty"
	defaults.profile.TrackNames[1] = "None"
end
function PetBattlePokemonMusic:OnInitialize()
	PetBattlePokemonMusic:SetUpDefaults()
	self.db = LibStub("AceDB-3.0"):New("PBPM", defaults)

	local config = LibStub("AceConfig-3.0")
	local registry = LibStub("AceConfigRegistry-3.0")
	
	registry:RegisterOptionsTable("PetBattlePokemonMusic Main", main)
	registry:RegisterOptionsTable("Pet Battle Music", WildBattleMusic)
	registry:RegisterOptionsTable("Trainer Pet Battle", TrainerBattleMusic)
	registry:RegisterOptionsTable("Other Sounds", OtherSounds)
	registry:RegisterOptionsTable("Custom Tracks",CustomTrackMenu)

	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionFrames = {
			main	= dialog:AddToBlizOptions("PetBattlePokemonMusic Main", "PetBattlePokemonMusic"),
			Wild	= dialog:AddToBlizOptions("Pet Battle Music", "Pet Battle Music", "PetBattlePokemonMusic"),
		--	Trainer = dialog:AddToBlizOptions("Trainer Pet Battle", "Trainer Pet Battle", "PetBattlePokemonMusic"),
			OtherS =  dialog:AddToBlizOptions("Other Sounds", "Other Sounds", "PetBattlePokemonMusic")--,
		--Tracks = dialog:AddToBlizOptions("Custom Tracks", "Custom Tracks", "PetBattlePokemonMusic")
	}
	
	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	self:RegisterEvent("PET_BATTLE_FINAL_ROUND")
	self:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
end
function PetBattlePokemonMusic:AddTrack(info, val)

end
function PetBattlePokemonMusic:OnEnable()
    -- Called when the addon is enabled

    -- Print a message to the chat frame

end

function PetBattlePokemonMusic:OnDisable()
    -- Called when the addon is disabled
end
local OldMusicValue =  GetCVar("Sound_EnableMusic")
function PetBattlePokemonMusic:PET_BATTLE_OPENING_START(...)

--PokemonBattleMusicEffects[4] = {	Name = "Ruby, Saphire, & Emerald Wild Pokemon Battle", 
--											StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Start.ogg",
--											StartLength = 2.485,
--											MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild.ogg"}
	if C_PetBattles.IsWildBattle() then
	PlaySoundFile(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].StartSound, "Master")

	--PlaySoundFile("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Poke RSE Wild Start.ogg","Master")
		self:ScheduleTimer("PlayBattleTrack",PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].StartLength)
	else
		PlaySoundFile(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].StartSound, "Master")

	--PlaySoundFile("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Poke RSE Wild Start.ogg","Master")
		self:ScheduleTimer("PlayBattleTrack",PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].StartLength)
	end
end

function PetBattlePokemonMusic:PET_BATTLE_CLOSE(...)

	StopMusic();
	SetCVar("Sound_EnableMusic", OldMusicValue )
end
function PetBattlePokemonMusic:PET_BATTLE_QUEUE_PROPOSE_MATCH(...)

end
function PetBattlePokemonMusic:PET_BATTLE_FINAL_ROUND(...)
	PlayMusic("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Poke RBY Victory.mp3")
end
function PetBattlePokemonMusic:UNIT_SPELLCAST_SUCCEEDED(eveName, unitID, spell, rank, lineID, spellID)
	if spellID == 125801 then
		if PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Enabled == true then
			PlaySoundFile(HealingSounds[PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Value],"Master")
		--PlayMusic("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Healing.ogg")
		end
	end
end
function PetBattlePokemonMusic:SwitchTrack()

end

function PetBattlePokemonMusic:PlayBattleTrack()
	OldMusicValue = GetCVar("Sound_EnableMusic")
	if C_PetBattles.IsWildBattle() then
		if PetBattlePokemonMusic.db.profile.Wild.Always then
			SetCVar("Sound_EnableMusic", 1 )
		end
		if PetBattlePokemonMusic.db.profile.Wild.On then
			PlayMusic(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].MusicTrack)
		end
	else
		if PetBattlePokemonMusic.db.profile.Trainer.Always then
			SetCVar("Sound_EnableMusic", 1 )
		end
		if PetBattlePokemonMusic.db.profile.Trainer.On then
			PlayMusic(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].MusicTrack)
		end
	end
end