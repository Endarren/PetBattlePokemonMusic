PetBattlePokemonMusic = LibStub("AceAddon-3.0"):NewAddon("PetBattlePokemonMusic", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0" );


local unusableSoundNames = {}
--	TrainerAlwaysOn,TrainerMusicOn,TrainerTrack,TrainerCustomOn,WildCustom,TrainerCustom, WildCustomOn, 
--WildTrack,WildAlwaysOn ,WildHeader
unusableSoundNames["AddNewSoundHeader"] = true
unusableSoundNames["AddNewSoundName"] = true
unusableSoundNames["AddNewSoundFileName"] = true
unusableSoundNames["AddNewSoundLength"] = true
unusableSoundNames["AddNewSoundButton"] = true
unusableSoundNames["AddNewSoundError"] = true
unusableSoundNames["TrainerAlwaysOn"] = true
unusableSoundNames["TrainerMusicOn"] = true
unusableSoundNames["TrainerTrack"] = true
unusableSoundNames["TrainerCustomOn"] = true
unusableSoundNames["WildCustom"] = true
unusableSoundNames["TrainerCustom"] = true
unusableSoundNames["WildCustomOn"] = true
unusableSoundNames["WildTrack"] = true
unusableSoundNames["WildAlwaysOn"] = true
unusableSoundNames["WildHeader"] = true

local UndeleteableSounds = {}
UndeleteableSounds["Red, Blue, & Yellow Wild Pokemon Battle Start"] = true
UndeleteableSounds["Red, Blue, & Yellow Wild Pokemon Battle Victory"] = true
UndeleteableSounds["Red, Blue, & Yellow Wild Pokemon Battle"] = true

UndeleteableSounds["Gold & Silver Wild Pokemon Battle Start"] = true
UndeleteableSounds["Gold & Silver Wild Pokemon Battle"] = true
UndeleteableSounds["Gold & Silver Wild Pokemon Battle Victory"]=true

UndeleteableSounds["Ruby, Saphire, & Emerald Wild Pokemon Battle Start"] = true
UndeleteableSounds["Ruby, Saphire, & Emerald Wild Pokemon Battle"] = true
UndeleteableSounds["Ruby, Saphire, & Emerald Wild Pokemon Battle Victory"]=true

UndeleteableSounds["FireRed & LifeGreen Wild Pokemon Battle Start"] = true
UndeleteableSounds["FireRed & LifeGreen Wild Pokemon Battle"] = true
UndeleteableSounds["FireRed & LifeGreen Wild Pokemon Battle Victory"]=true	


					


local PokemonBattleMusicEffects = {}
--2.65
PokemonBattleMusicEffects[1] = {	Name = "Red, Blue, & Yellow Wild Pokemon Battle", 
									StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild Start.ogg",
									StartLength = 2.8,
									StartSoundKey = "Red, Blue, & Yellow Wild Pokemon Battle Start",
									MusicKey = "Red, Blue, & Yellow Wild Pokemon Battle",
									VictoryKey = "Red, Blue, & Yellow Wild Pokemon Battle Victory",
									MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild.ogg",
									VictorySound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Victory Wild.ogg"
}
PokemonBattleMusicEffects[2] = {	Name = "Gold & Silver Wild Pokemon Battle", 
									StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild Start.ogg",
									StartLength = 2.65,
									StartSoundKey = "Gold & Silver Wild Pokemon Battle Start",
									MusicKey = "Gold & Silver Wild Pokemon Battle",
									VictoryKey = "Gold & Silver Wild Pokemon Battle Victory",
									MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild.ogg",
									VictorySound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Victory Wild.ogg"
}
PokemonBattleMusicEffects[3] = {	Name = "Ruby, Saphire, & Emerald Wild Pokemon Battle", 
									StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Start.ogg",
									StartLength = 2.685,
									StartSoundKey = "Ruby, Saphire, & Emerald Wild Pokemon Battle Start",
									MusicKey = "Ruby, Saphire, & Emerald Wild Pokemon Battle",
									VictoryKey = "Ruby, Saphire, & Emerald Wild Pokemon Battle Victory",
									MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild.ogg",
									VictorySound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Victory Wild.ogg"
								}
PokemonBattleMusicEffects[4] = {	Name = "FireRed & LifeGreen Wild Pokemon Battle", 
									StartSound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Start.ogg",
									StartLength = 2.485,
									StartSoundKey = "FireRed & LifeGreen Wild Pokemon Battle Start",
									MusicKey = "FireRed & LifeGreen Wild Pokemon Battle",
									VictoryKey = "FireRed & LifeGreen Wild Pokemon Battle Victory",
									MusicTrack = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild.ogg",
									VictorySound = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Victory Wild.ogg"
								}

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
--WildBattleMusic.args.WildHeader.args.WildCustom.name= "Custom Track: ",
local WildBattleMusic = {
							name = "Wild",
							type = "group",
							handler = PetBattlePokemonMusic,
							childGroups = "tab",
							args = {
										WildHeader =	{
															type	 = "group",
															name	= "Wild Pet Battle Music",
															order	= 1,
															args = {
																		WildMusicOn =	{
																							type		=	"toggle",
																							name		=	"Enabled",
																							desc		=	"Toogle whether music is played for wild pet battles or not",
																							order		=	2,
																							set			=	function (info, val) PetBattlePokemonMusic.db.profile.Wild.On = valu end,
																							get			=	function () return PetBattlePokemonMusic.db.profile.Wild.On end
																						},
																		WildAlwaysOn =	{
																							type		=	"toggle",
																							name		=	"Always On",
																							desc		=	"Toogles whether music will be played if music is disabled on the client",
																							order		=	2,
																							set			=	function (info, val) PetBattlePokemonMusic.db.profile.Wild.Always = val end,
																							get			=	function () return PetBattlePokemonMusic.db.profile.Wild.Always end
																						},
																		WildTrack =		{
																							type		=	"select",
																							order		=	3,
																							style		=	"dropdown",
																							name		=	"Track",
																							values		=	trackNames,
																							width		=	"double",
																							set			=	function(info, val) PetBattlePokemonMusic.db.profile.Wild.Track = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.profile.Wild.Track end
																						},
																		WildCustomOn =	{
																							type		=	"toggle",
																							name		=	"Custom Track",
																							desc		=	"Toogles whether the music will be used from a custom track",
																							order		=	4,
																							set			=	function (info, val) PetBattlePokemonMusic.db.profile.Wild.Custom = val PetBattlePokemonMusic:ToggleCustomWild(val==false)end,
																							get			=	function () return PetBattlePokemonMusic.db.profile.Wild.Custom end
																						},
																		WildCustom =	{
																							order = 5,
																							type		= "description",
																							name		= "Custom Track: ",
																							cmdHidden	= true
																						}
																}
														},
										TrainerHeader =	{
														type	= "group",
														name	= "Trainer Pet Battle Music",
														order	= 4,
														args = {
																	TrainerMusicOn =	{
																							type		=	"toggle",
																							name		=	"Enabled",
																							desc		=	"Toogle whether music is played for trainer pet battles or not",
																							order		=	5,
																							set			=	function (info, val) PetBattlePokemonMusic.db.profile.Trainer.On = valu end,
																							get			=	function () return PetBattlePokemonMusic.db.profile.Trainer.On end
																						},
																	TrainerAlwaysOn =	{
																							type		=	"toggle",
																							name		=	"Always On",
																							desc		=	"Toogles whether music will be played if music is disabled on the client",
																							order		=	5,
																							set			=	function (info, val) PetBattlePokemonMusic.db.profile.Trainer.Always = val end,
																							get			=	function () return PetBattlePokemonMusic.db.profile.Trainer.Always end
																						},
																	TrainerTrack =		{
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	"Track",
																							values		=	trackNames,
																							width		=	"double",
																							set			=	function(info, val) PetBattlePokemonMusic.db.profile.Trainer.Track = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.profile.Trainer.Track end
																						},
																	TrainerCustomOn =	{
																							type		=	"toggle",
																							name		=	"Custom Track",
																							desc		=	"Toogles whether the music will be used from a custom track",
																							order		=	7,
																							set			=	function (info, val) PetBattlePokemonMusic.db.profile.Trainer.Custom = val PetBattlePokemonMusic:ToggleCustomTrainer(val ==false) end,
																							get			=	function () return PetBattlePokemonMusic.db.profile.Trainer.Custom end
																						},
															
																		TrainerCustom = {
																							order		=	8,
																							type		= "description",
																							name		= "Custom Track: ",
																							cmdHidden	=	true
																						}
														
																}
														}
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

local neoSoundNameTemp =""
local neoSoundFileTemp = ""
local neoSoundLengthTemp = 0

local SoundLibrary = {
						name = "Sound Library",
						type = "group",
						handler = PetBattlePokemonMusic,
						args = {
									AddNewSoundHeader = {
															type = "header",
															name = "Add New Sound",
															order = 1,
															desc = "Add a new sound to the addon"
														},
									AddNewSoundName =	{
															name = "Sound Name",
															type = "input",
															get = function()  return neoSoundNameTemp end,
															set = function (info, val)neoSoundNameTemp = val  end,
															order = 2
														},
								AddNewSoundFileName =	{
															name = "Sound File Name",
															type = "input",
															get = function()  return neoSoundFileTemp end,
															set = function (info, val) neoSoundFileTemp = val end,
															order = 2
														},
									AddNewSoundLength = {
															name = "Sound Length",
															type = "input",
															desc = "The length of the sound file in seconds",
															get = function()  return neoSoundLengthTemp end,
															set = function (info, val) neoSoundLengthTemp = tonumber(val) end,
															order = 2
														},
									AddNewSoundButton = {
															name = "Add Sound",
															type = "execute",
															func = function() if unusableSoundNames[neoSoundNameTemp] ~= nil  then
																		--SoundLibrary.args.AddNewSoundError
																			--Name is a key term.
																			print("INVALID  key term")
																			return false
																			end
																			if PetBattlePokemonMusic.db.profile.SoundLibrary[neoSoundNameTemp] ~= nil then
																				--Name already used
																				return false
																			end
																		PetBattlePokemonMusic.db.profile.SoundLibrary[neoSoundNameTemp] = {FileName = neoSoundFileTemp, Length = neoSoundLengthTemp}
																		PetBattlePokemonMusic:AddSoundToConfig(neoSoundNameTemp)
															 end,
															order = 3
														},
								AddNewSoundError =		{
															type = "description",
															name = "",
															hidden = true,
															order = 4
														}
								}
					}

local stopSoundThing = 0
local soundPlaying = false
local previewTimer = nil
function PetBattlePokemonMusic:StopEvent()
soundPlaying = false
end

function PetBattlePokemonMusic:AddSoundToConfig(soundkey)
	if SoundLibrary.args[soundkey] == nil then
		SoundLibrary.args[soundkey] = {
					type = "group",
					name = soundkey,
					args = {
								SoundFile = {
												type = "description",
												name = "File Name: "..self.db.profile.SoundLibrary[soundkey].FileName,
									order = 1
								},
						SoundLength = {
												type = "description",
												name = "Length: "..tostring(self.db.profile.SoundLibrary[soundkey].Length).." seconds",
								order = 2
											},
								PlayButton = {
												type = "execute",
												name = "Play",
												func = function ()
													if soundPlaying == false then
																previewTimer = self:ScheduleTimer("StopEvent", tonumber(self.db.profile.SoundLibrary[soundkey].Length))
																bla,stopSoundThing= PlaySoundFile(self.db.profile.SoundLibrary[soundkey].FileName,"Master")  
																soundPlaying = true
													end
												end, --TODO
												order = 3

								},
								DeleteButton = {
												type = "execute",
												name = "Delete",
												func = function ()
												self:CancelTimer(previewTimer,true)
																soundPlaying = false
													StopSound(stopSoundThing)
												self.db.profile.SoundLibrary[soundkey] = nil  SoundLibrary.args[soundkey] = nil end, --TODo
												order = 4,
												disabled = UndeleteableSounds[soundkey]

								},
								StopButton = {
												type = "execute",
												name = "Stop",
												func = function () 
																self:CancelTimer(previewTimer,true)
																soundPlaying = false
													StopSound(stopSoundThing)  end, --TODo
												order = 4,

		}



							}


		}
	else
	
	end
end
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

local neoTrackName = ""
local neoTrackStartKey = ""
local neoTrackMusic = ""
local neoTrackVictory = ""

local CreateCustomTrack =	{
								type = "group",
								name = "Create Custom Tracks",
								args =	{
											NewTrackName = {
																type = "input",
																get = function() return neoTrackName end,
																set = function(info, val) neoTrackName = val end,
																name = "New Track Name",
																order =1,
																width = "double"
											},
											StartDesc = {
																type = "description",
																name = "Start Sound: ",
																order = 2
											},
											MusicDesc = {
																type = "description",
																name = "Music Track: ",
																order = 3
											},
											VictoryDesc = {
																type = "description",
																name = "Victory Sound: ",
																order = 4
											},
											BadTrack = {
																type = "description",
																name = "",
																order = 5
											},
											StartSoundGroup = {
																name = "Start Sound",
																type = "group",
																order = 6,
																args = {}
											
											},
											MusicTrackGroup = {
																name = "Music Track",
																type = "group",
																order = 7,
																args = {}
											
											},
											VictorySoundGroup = {
																name = "Victory Sound",
																type = "group",
																order = 8,
																args = {}
											
											},
											SaveButton =	{
																type = "execute",
																name = "Save",
																func = function ()
																				PetBattlePokemonMusic:SaveNewTrack()
																--CreateCustomTrack.args.BadTrack.name = 

																end,
																order = 9
											
															}
								
										}




							}
function PetBattlePokemonMusic:SaveNewTrack()
if unusableSoundNames[neoTrackName] ~= nil then
		CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Cannot use that name"))
		--("|cffFF0000%s|r"):format(tostring("Cannot use that name"))
			  
		return false
	else
		if self.db.profile.CustomTracks[neoTrackName] ~= nil then
			CreateCustomTrack.args.BadTrack.name = "Track name already used"
			return false
		else
			--neoTrackStartKey
			if self.db.profile.SoundLibrary[neoTrackStartKey] == nil then
				CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Start sound not selected"))
			else
				if self.db.profile.SoundLibrary[neoTrackMusic] == nil then
					CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Music Track not selected"))
				else
					if self.db.profile.SoundLibrary[neoTrackVictory] == nil then
						CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Victory Sound not selected"))
					else
						CreateCustomTrack.args.BadTrack.name =""
						
							self.db.profile.CustomTracks[neoTrackName] ={StartSoundKey = neoTrackStartKey,
									MusicKey = neoTrackMusic,
									VictoryKey = neoTrackVictory}
									neoTrackVictory = ""
									neoTrackStartKey=""
									neoTrackMusic=""
									CreateCustomTrack.args.StartDesc.name = "Start Sound: "
									CreateCustomTrack.args.MusicDesc.name = "Music Track: "
									CreateCustomTrack.args.VictoryDesc.name = "Victory Sound: "
									PetBattlePokemonMusic:FillCustomWild()
									PetBattlePokemonMusic:AddCustomTrackToLibrary (neoTrackName)
					end
				end
			end
		end
	end
end
function PetBattlePokemonMusic:SetUpCustomCreator()
	CreateCustomTrack.args.StartSoundGroup.args = {}
	
	for key, val in pairs (self.db.profile.SoundLibrary) do
									CreateCustomTrack.args.StartSoundGroup.args[key] = {
																				type = "group",
																				name = key,
																				--name = ("|cffffd200%s|r"):format(tostring(key)),
																				--disabled = PetBattlePokemonMusic.db.profile.Wild.Custom,
																				args = 	{
																							SetStart = {
																											type = "execute",
																											name = "Set as start sound",
																											order = 1,
																											func = function ()
																																CreateCustomTrack.args.StartDesc.name = "Start Sound: "..key
																																neoTrackStartKey =(key) end
																										}

																						}
									
																			}
									CreateCustomTrack.args.MusicTrackGroup.args[key] = {
																				type = "group",
																				name = key,
																				--name = ("|cffffd200%s|r"):format(tostring(key)),
																				--disabled = PetBattlePokemonMusic.db.profile.Wild.Custom,
																				args = 	{
																							SetStart = {
																											type = "execute",
																											name = "Set as music",
																											order = 1,
																											func = function ()
																														CreateCustomTrack.args.MusicDesc.name = "Music Track: "..key
																											neoTrackMusic =(key) end
																										}

																						}
									
																			}
									CreateCustomTrack.args.VictorySoundGroup.args[key] = {
																				type = "group",
																				name = key,
																				--name = ("|cffffd200%s|r"):format(tostring(key)),
																				--disabled = PetBattlePokemonMusic.db.profile.Wild.Custom,
																				args = 	{
																							SetStart = {
																											type = "execute",
																											name = "Set as victory sound",
																											order = 1,
																											func = function ()
																											CreateCustomTrack.args.VictoryDesc.name = "Victory Sound: "..key
																											neoTrackVictory = key end
																										}

																						}
									
																			}
								end
end
-- neoTrackStartKey = ""
-- neoTrackMusic = ""
-- neoTrackVictory = ""

function PetBattlePokemonMusic:ToggleCustomWild(wer)
	for key, val in pairs (self.db.profile.CustomTracks) do
		WildBattleMusic.args.WildHeader.args[key].disabled = wer
	end
	
end
function PetBattlePokemonMusic:ToggleCustomTrainer(wer)
	for key, val in pairs (self.db.profile.CustomTracks) do
		WildBattleMusic.args.TrainerHeader.args[key].disabled = wer
	end
	
end
							--TrainerHeader
function PetBattlePokemonMusic:FillCustomWild()
	for key, val in pairs (self.db.profile.CustomTracks) do
		WildBattleMusic.args.WildHeader.args[key] = {
													type = "group",
													name = key,
													disabled = self.db.profile.Wild.Custom==false,
													args = 	{
																SetTrack = {
																				type = "execute",
																				name = "Select",
																				order = 1,
																				func = function () WildBattleMusic.args.WildHeader.args.WildCustom.name= "Custom Track: "..key  self.db.profile.Wild.CustomTrack = key	  end
																			}
																
															}
		
												}
	end
	
end
function PetBattlePokemonMusic:FillCustomTrainer()
	for key, val in pairs (self.db.profile.CustomTracks) do
		WildBattleMusic.args.TrainerHeader.args[key] = {
													type = "group",
													name = key,
													disabled = self.db.profile.Trainer.Custom==false,
													args = 	{
																SetTrack = {
																				type = "execute",
																				name = "Select",
																				order = 1,
																				func = function () WildBattleMusic.args.TrainerHeader.args.TrainerCustom.name= "Custom Track: "..key  self.db.profile.Trainer.CustomTrack = key	  end
																			}
																
															}
		
												}
	end
	
end
function PetBattlePokemonMusic:FillCustomMaker()
	for key, val in pairs (self.db.profile.SoundLibrary) do
		WildBattleMusic.args.WildHeader.args[key] = {
													type = "group",
													name = key,
													disabled = PetBattlePokemonMusic.db.profile.Wild.Custom,
													args = 	{
																SetStart = {
																				type = "execute",
																				name = "Set as start sound",
																				order = 1,
																				func = function () end
																			},
																SetMusic = {
																				type = "execute",
																				name = "Set as music track",
																				order = 2,
																				func = function () end
																			},
																SetVictory = {
																				type = "execute",
																				name = "Set as victory sound",
																				order = 3,
																				func = function () end
																			},
															}
		
												}
	end
	
end

local CustomTrackLibrary =	{
								name = "Custom Tracks",
								type = "group",
								args =		{
												S
								
											}


}
--{StartSoundKey = neoTrackStartKey,
--									MusicKey = neoTrackMusic,
--									VictoryKey = neoTrackVictory}
function PetBattlePokemonMusic:AddCustomTrackToLibrary (key)

	if self.db.profile.CustomTracks[key] ~= nil then
		CustomTrackLibrary.args[key] =	{
											type = "group",
											childGroups = "tab",
											name = key,
											args =	{
												StartDesc = {--CustomTrackLibrary.args[key].args.StartDesc
																type = "description",
																name = "Start Sound: "..self.db.profile.CustomTracks[key].StartSoundKey,
																order = 2
											},
											MusicDesc = { --CustomTrackLibrary.args[key].args.MusicDesc
																type = "description",
																name = "Music Track: "..self.db.profile.CustomTracks[key].MusicKey,
																order = 3
											},
											VictoryDesc = {--CustomTrackLibrary.args[key].args.VictoryDesc
																type = "description",
																name = "Victory Sound: "..self.db.profile.CustomTracks[key].VictoryKey,
																order = 4
											},

												DeleteBut = {
																				type = "execute",
																				name = "Delete",
																				order = 6,
																				func = function () self.db.profile.CustomTracks[key]= nil  CustomTrackLibrary.args[key] = nil WildBattleMusic.args.TrainerHeader.args[key] = nil WildBattleMusic.args.WildHeader.args[key] = nil end
																			},	
														StartEffect	=	{
																			type ="group",
																			name = "Start Sound",
																			order = 7,
																			args = {}
														},
												MusicTrack	=	{
																			type ="group",
																			name = "Music Track",
																			order = 8,
																			args = {}
												},
												VictorySound	=	{
																			type ="group",
																			name = "Victory Sound",
																			order = 9,
																			args = {}
																		},
													}

		}


		for k, v in pairs (self.db.profile.SoundLibrary) do
			if k ~= nil then
		CustomTrackLibrary.args[key].args.StartEffect.args[k] = {
													type = "group",
													name = k,

													args = 	{
																SetStart = {
																				type = "execute",
																				name = "Set as Start sound",
																				order = 3,
																				func = function () CustomTrackLibrary.args[key].args.StartDesc.name = "Start Sound: "..k    self.db.profile.CustomTracks[key].StartSoundKey   = k end
																			}
																
															}
		
		}
				CustomTrackLibrary.args[key].args.MusicTrack.args[k] = {
													type = "group",
													name = k,

													args = 	{
																SetMusic = {
																				type = "execute",
																				name = "Set as Music Track",
																				order = 3,
																				func = function () CustomTrackLibrary.args[key].args.MusicDesc.name = "Music Track: "..k    self.db.profile.CustomTracks[key].MusicKey    = k  end
																			}
																
															}
		
				}
				CustomTrackLibrary.args[key].args.VictorySound.args[k] = {
													type = "group",
													name = k,

													args = 	{
																SetVictory = {
																				type = "execute",
																				name = "Set as Victory Sound",
																				order = 3,
																				func = function () CustomTrackLibrary.args[key].args.VictoryDesc.name =  "Victory Sound: "..k    self.db.profile.CustomTracks[key].VictoryKey   = k end
																			}
																
															}
		
												}
												end
		end
	end

end
function PetBattlePokemonMusic:FillCustomLib()
	for key,val in pairs (self.db.profile.CustomTracks) do
		PetBattlePokemonMusic:AddCustomTrackToLibrary (key)
	end
end
				--self.db.profile.Wild.CustomTrack			
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
		
				SoundLibrary = {},	-- {FileName, Length}
				CustomTracks = {},
				TrackNames = {},
				SoundEffects ={HealingSound = {Value =3, Enabled = true}} --PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound
				
			}
				}
defaults.profile.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle Start"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild Start.ogg",
																							Length = 2.8}
defaults.profile.SoundLibrary["Gold & Silver Wild Pokemon Battle Start"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild Start.ogg",
																							Length = 2.65}
defaults.profile.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle Start"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Start.ogg",
																							Length = 2.685}
defaults.profile.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle Start"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Start.ogg",
																							Length = 2.485}
defaults.profile.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle Victory"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Victory Wild.ogg",
																							Length = 34.8}
defaults.profile.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild.ogg",
																							Length = 78.5}
defaults.profile.SoundLibrary["Gold & Silver Wild Pokemon Battle"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild.ogg",
																							Length = 78}																					
defaults.profile.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild.ogg",
																							Length = 78.5}																						
defaults.profile.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild.ogg",
																							Length = 82.5}																							
defaults.profile.SoundLibrary["Gold & Silver Wild Pokemon Battle Victory"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Victory Wild.ogg",
																							Length = 34.5}
defaults.profile.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle Victory"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Victory.ogg",
																							Length = 21}
defaults.profile.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle Victory"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Victory.ogg",
																							Length = 30.2}														
function PetBattlePokemonMusic:SetUpDefaults()

end
function PetBattlePokemonMusic:SetUpSL()
	for key,val in pairs (PetBattlePokemonMusic.db.profile.SoundLibrary) do
		PetBattlePokemonMusic:AddSoundToConfig(key)
	end
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
	registry:RegisterOptionsTable("Sound Library",SoundLibrary)
	registry:RegisterOptionsTable("Create Custom Track",CreateCustomTrack)
	registry:RegisterOptionsTable("Custom Tracks",CustomTrackLibrary)
	

	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionFrames = {
			main	= dialog:AddToBlizOptions("PetBattlePokemonMusic Main", "Pet Battle Pokemon Mod"),
			Wild	= dialog:AddToBlizOptions("Pet Battle Music", "Pet Battle Music", "Pet Battle Pokemon Mod"),
			OtherS =  dialog:AddToBlizOptions("Other Sounds", "Other Sounds", "Pet Battle Pokemon Mod"),
			Library = dialog:AddToBlizOptions("Sound Library", "Sound Library", "Pet Battle Pokemon Mod"),
			CreateCust = dialog:AddToBlizOptions("Create Custom Track", "Create Custom Track", "Pet Battle Pokemon Mod"),
			Custs = dialog:AddToBlizOptions("Custom Tracks", "Custom Tracks", "Pet Battle Pokemon Mod"),
		--,
		--Tracks = dialog:AddToBlizOptions("Custom Tracks", "Custom Tracks", "PetBattlePokemonMusic")
	}
	
	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	self:RegisterEvent("PET_BATTLE_OVER")
	self:RegisterEvent("PET_BATTLE_FINAL_ROUND")
	self:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
	self:RegisterEvent("PET_BATTLE_PET_ROUND_RESULTS")
	self:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
	self:RegisterEvent("CHAT_MSG_PET_BATTLE_INFO")
	PetBattlePokemonMusic:SetUpSL()
	PetBattlePokemonMusic:FillCustomWild()
	PetBattlePokemonMusic:FillCustomTrainer()
	PetBattlePokemonMusic:SetUpCustomCreator()
	PetBattlePokemonMusic:FillCustomLib()
end
local battleTimer = nil
local currentSound = nil
function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_INFO(...)
	demo = {...}
	--print("P Battle info " .. #demo)
	--for i=1,#demo do
	--	print(i..".".." "..tostring(demo[i]))
		
	--end
end
function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_COMBAT_LOG(...)
		demo = {...}
	--print("PB Combat log " .. #demo)
	--for i=1,#demo do
	--	print(i..".".." "..tostring(demo[i]))
--	end
	--2 is the text that is shown
	--12 appears to increases with each one.
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
		if PetBattlePokemonMusic.db.profile.Wild.Custom then
			if PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Wild.CustomTrack] ~= nil then
				
				bla, currentSound =PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Wild.CustomTrack].StartSoundKey].FileName, "Master")

	--PlaySoundFile("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Poke RSE Wild Start.ogg","Master")
			battleTimer=	self:ScheduleTimer("PlayBattleTrack",PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Wild.CustomTrack].StartSoundKey].Length)
			end
	else
			bla, currentSound =PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].StartSoundKey].FileName, "Master")

	--PlaySoundFile("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Poke RSE Wild Start.ogg","Master")
			battleTimer =self:ScheduleTimer("PlayBattleTrack",PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].StartSoundKey].Length)
		end
		
	else
		bla, currentSound =PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].StartSoundKey].FileName, "Master")

	--PlaySoundFile("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\Poke RSE Wild Start.ogg","Master")
	battleTimer=	self:ScheduleTimer("PlayBattleTrack",PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].StartSoundKey].Length)
	end
end
function PetBattlePokemonMusic:PET_BATTLE_OVER(...)

end
function PetBattlePokemonMusic:PET_BATTLE_CLOSE(...)
--PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track]
	StopMusic();
	SetCVar("Sound_EnableMusic", OldMusicValue )
	self:CancelTimer(battleTimer,true)
	if currentSound ~= nil then
		StopSound(currentSound)
		currentSound=nil
	end
end
function PetBattlePokemonMusic:PET_BATTLE_PET_ROUND_RESULTS(a1,a2,a3,a4,a5,a6,a7,a8,a9)
	
end
function PetBattlePokemonMusic:PET_BATTLE_QUEUE_PROPOSE_MATCH(...)

end
function PetBattlePokemonMusic:PET_BATTLE_FINAL_ROUND(a1,a2)
		StopMusic();
	SetCVar("Sound_EnableMusic", OldMusicValue )
	self:CancelTimer(battleTimer,true)
	if currentSound ~= nil then
		StopSound(currentSound)
		currentSound=nil
	end
	if a2 == 1 then
	
		if C_PetBattles.IsWildBattle() then
			PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].VictoryKey].FileName, "Master")
		else
			PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].VictoryKey].FileName, "Master")
		end
	end
	
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
			if PetBattlePokemonMusic.db.profile.Wild.Custom == false then
				PlayMusic(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].MusicKey].FileName)
			else
				PlayMusic(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Wild.CustomTrack].MusicKey].FileName)
			end
		end
	else
		if PetBattlePokemonMusic.db.profile.Trainer.Always then
			SetCVar("Sound_EnableMusic", 1 )
		end
		if PetBattlePokemonMusic.db.profile.Trainer.On then
			--PlayMusic(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].MusicTrack)
			
			if PetBattlePokemonMusic.db.profile.Trainer.Custom == false then
				PlayMusic(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].MusicKey].FileName)
			else
				PlayMusic(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Trainer.CustomTrack].MusicKey].FileName)
			end
		end
	end
end