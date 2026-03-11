-- ================================================================================================================================================================================================================================================ --
--													PetBattlePokemonMusic
-- ================================================================================================================================================================================================================================================ --
--	Addon Name:	Pet Battle Pokemon Mod.
--	Written by: Endar_Ren.
--	
-- ================================================================================================================================================================================================================================================ --
--	Version 1 Beta.		8/26/2012
-- ================================================================================================================================================================================================================================================ --

--
--
-- ================================================================================================================================================================================================================================================ --
--	Version 1-1 Beta.	8/29/2012
-- ================================================================================================================================================================================================================================================ --
--	* Updated for 5.0.4.
--	*
--	*
-- ================================================================================================================================================================================================================================================ --
--	Version 1-2 Beta.  9/3/2012
-- ================================================================================================================================================================================================================================================ --
--	* Added SoundLibrary to self.db.profile.
--	* Added SoundLibrary to interface configuration.
--	* Reworked PetBattlePokemonMusic to use keys in the SoundLibrary.
--	* Added functions to add new sounds.
--	**	Created table unusableSoundNames, that lists strings that cannot be used as sound names.
--	**	Created a table UndeleteableSounds, that lists the keys of sounds in the SoundLibrary that cannot be deleted.
--	* Functions for adding custom tracks added.
--	* Modified PokemonBattleMusicEffects by adding StartSoundKey, MusicKey, and VictoryKey.
--	* Removed PokeTrack table.
-- ================================================================================================================================================================================================================================================ --
--	Version 1-3 Release. 
-- ================================================================================================================================================================================================================================================ --
--	* Cleaned up the code.
--	* Documentation.
--	* Renamed WildBattleMusic as BattleMusic.
--	* Remove TrainerBattleMusic table.
--	* Removed StartSound, StartLength, MusicTrack, and VictorySound elements from all tracks in PokemonBattleMusicEffects.
--	* Removed BattleStyleList table.
--	* Removed function SetUpDefaults().
--	* Removed function AddTrack(info, val).
--	* Removed function FillCustomMaker().
--	* Removed fields tempName and tempFile.
--	* Code added to make it so that custom tracks that have a nil value are not show in the lists for wild and trainer.
--	* Add code to make an invalid custom tracks not set for wild or trainer.
--	* Fixed Victory effect for custom tracks.
--	* Found out what the structure of Battle Pet Ability hyperlinks is.
--	* TODO:  Make code so that a custom track with a nil value is red in the Custom Track Library and can be edited.
--	* TODO:	 Add code so that if a sound key returns a nil value when about to play it, it is aborted.  (nil value error)
--	* 
-- ================================================================================================================================================================================================================================================ --

PetBattlePokemonMusic = LibStub("AceAddon-3.0"):NewAddon("PetBattlePokemonMusic", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0" );

local BPApattern = "|cff4e96f7|HbattlePetAbil:(%d*):%d*:%d*:%d*|h%[.*%]|h|r"
local iconpattern = "INTERFACE\\ICON\\.*%.BLP:%d*"



local BPAPatternDealtYour = "(.*) dealt %d* damage to your (.*)%."
local BPAPatternDealtEnemy = "(.*) dealt %d* damage to enemy (.*)%."


local BPAPatternDealtYourCrit = "(.*) dealt %d* damage to your (.*) %(Critical%)%."
local BPAPatternDealtEnemyCrit = "(.*) dealt %d* damage to enemy (.*) %(Critical%)%."

local BPAPatternDealtYourStrong = "(.*) dealt %d* damage to your INTERFACE\\.*\\.*.%BLP:14.* %(Strong%)%."
local BPAPatternDealtEnemyStrong = "(.*) dealt %d* damage to enemy INTERFACE\\.*\\.*.%BLP:14.* %(Strong%)%."

local BPAPatternDealtYourWeak = "(.*) dealt %d* damage to your (.*) %(Weak%)%."
local BPAPatternDealtEnemyWeak = "(.*) dealt %d* damage to enemy (.*) %(Weak%)%."

local BPAPatternYourDodged = "(.*) was dodged by your (.*)%."
local BPAPatternEnemyDodged = "(.*) was dodged by enemy (.*)%."

local BPAPatternYourFade = "(.*) fades from your (.*)%."
local BPAPatternEnemyFade = "(.*) fades from enemy (.*)%."

local BPAPatternYourApp = "(.*) applied (.*) to your (.*)%."
local BPAPatternEnemyApp = "(.*) applied (.*) to enemy (.*)%."

local BPAPatternYourMiss = "(.*) missed your (.*)%."
local BPAPatternEnemyMiss = "(.*) missed enemy (.*)%."

local BPAPatternHealYour = "(.*) healed %d* damage from your (.*)%."
local BPAPatternHealEnemy = "(.*) healed %d* damage from enemy (.*)%."
local weatherIn = "(.*) changed the weather to (.*)%."
local weatherOut ="(.*) is no longer the weather%."

local BPLevelUpPattern = "(.*) has reached level %d*!"

local block = " was blocked from striking "

local SoundListUI = {}
local SoundListUIKeys = {}


--- This is a table of strings that are used for UI elements and cannot be used for sound names.
local unusableSoundNames = {}
	unusableSoundNames["AddNewSoundHeader"]		= true
	unusableSoundNames["AddNewSoundName"]		= true
	unusableSoundNames["AddNewSoundFileName"]	= true
	unusableSoundNames["AddNewSoundLength"]		= true
	unusableSoundNames["AddNewSoundButton"]		= true
	unusableSoundNames["AddNewSoundError"]		= true
	unusableSoundNames["TrainerAlwaysOn"]		= true
	unusableSoundNames["TrainerMusicOn"]		= true
	unusableSoundNames["TrainerTrack"]			= true
	unusableSoundNames["TrainerCustomOn"]		= true
	unusableSoundNames["WildCustom"]			= true
	unusableSoundNames["TrainerCustom"]			= true
	unusableSoundNames["WildCustomOn"]			= true
	unusableSoundNames["WildTrack"]				= true
	unusableSoundNames["WildAlwaysOn"]			= true
	unusableSoundNames["WildHeader"]			= true
	unusableSoundNames["EnabledS"]				= true
	unusableSoundNames["SelectedFile"]			= true
---This is a list of sound keys that come with the addon and cannot be removed.
local UndeleteableSounds = {}
	--Red, Blue, Yellow Sounds
	UndeleteableSounds["Red, Blue, & Yellow Wild Pokemon Battle Start"]			= true
	UndeleteableSounds["Red, Blue, & Yellow Wild Pokemon Battle Victory"]		= true
	UndeleteableSounds["Red, Blue, & Yellow Wild Pokemon Battle"]				= true

	UndeleteableSounds["Gold & Silver Wild Pokemon Battle Start"]				= true
	UndeleteableSounds["Gold & Silver Wild Pokemon Battle"]						= true
	UndeleteableSounds["Gold & Silver Wild Pokemon Battle Victory"]				= true

	UndeleteableSounds["Ruby, Saphire, & Emerald Wild Pokemon Battle Start"]	= true
	UndeleteableSounds["Ruby, Saphire, & Emerald Wild Pokemon Battle"]			= true
	UndeleteableSounds["Ruby, Saphire, & Emerald Wild Pokemon Battle Victory"]	= true

	UndeleteableSounds["FireRed & LifeGreen Wild Pokemon Battle Start"]			= true
	UndeleteableSounds["FireRed & LifeGreen Wild Pokemon Battle"]				= true
	UndeleteableSounds["FireRed & LifeGreen Wild Pokemon Battle Victory"]		= true	


					

--- A table for the pre-made tracks
local PokemonBattleMusicEffects = {}
	PokemonBattleMusicEffects[1] =	{	Name = "Red, Blue, & Yellow Wild Pokemon Battle", 
										StartSoundKey = "Red, Blue, & Yellow Wild Pokemon Battle Start",
										MusicKey = "Red, Blue, & Yellow Wild Pokemon Battle",
										VictoryKey = "Red, Blue, & Yellow Wild Pokemon Battle Victory"
									}
	PokemonBattleMusicEffects[2] =	{	Name = "Gold & Silver Wild Pokemon Battle", 
										StartSoundKey = "Gold & Silver Wild Pokemon Battle Start",
										MusicKey = "Gold & Silver Wild Pokemon Battle",
										VictoryKey = "Gold & Silver Wild Pokemon Battle Victory"										
									}
	PokemonBattleMusicEffects[3] =	{	Name = "Ruby, Saphire, & Emerald Wild Pokemon Battle", 
										StartSoundKey = "Ruby, Saphire, & Emerald Wild Pokemon Battle Start",
										MusicKey = "Ruby, Saphire, & Emerald Wild Pokemon Battle",
										VictoryKey = "Ruby, Saphire, & Emerald Wild Pokemon Battle Victory"
									}
	PokemonBattleMusicEffects[4] =	{	Name = "FireRed & LifeGreen Wild Pokemon Battle", 
										StartSoundKey = "FireRed & LifeGreen Wild Pokemon Battle Start",
										MusicKey = "FireRed & LifeGreen Wild Pokemon Battle",
										VictoryKey = "FireRed & LifeGreen Wild Pokemon Battle Victory"
									}

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
	name = "Pet Battle Pokemon Mod",
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
-- ================================================================================================================================================================================================================================================ --
--											BattleMusic
-- ================================================================================================================================================================================================================================================ --
local BattleMusic = {
							name = "Wild",
							type = "group",
							handler = PetBattlePokemonMusic,
							childGroups = "tab",
							args = {
									------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
																							order		= 5,
																							type		= "description",
																							name		= "Custom Track: ",
																							cmdHidden	= true
																						}
																}
												},
									--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

-- ================================================================================================================================================================================================================================================ --
--			Local Fields
-- ================================================================================================================================================================================================================================================ --

local previewSelect = "none"
local removeSelect = "none"

local neoSoundNameTemp =""
local neoSoundFileTemp = ""
local neoSoundLengthTemp = 0

local stopSoundThing = 0
local soundPlaying = false
local previewTimer = nil

local neoTrackName = ""
local neoTrackStartKey = ""
local neoTrackMusic = ""
local neoTrackVictory = ""
local battleTimer = nil
local currentSound = nil

local OldMusicValue =  GetCVar("Sound_EnableMusic")
-- ================================================================================================================================================================================================================================================ --
--
-- ================================================================================================================================================================================================================================================ --
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
-- ================================================================================================================================================================================================================================================ --

function PetBattlePokemonMusic:StopEvent()
	soundPlaying = false
end

---
-- This function adds a sound to the SoundLibrary display.
--@param soundkey the string key used to identify the sound in the SoundLibrary.
function PetBattlePokemonMusic:AddSoundToConfig(soundkey)
PetBattlePokemonMusic:FillSoundListUI()
	if SoundLibrary.args[soundkey] == nil then
		SoundLibrary.args[soundkey] = {
					type = "group",
					name = soundkey,
					args = {
								SoundFile =		{
													type	= "description",
													name	= "File Name: "..self.db.profile.SoundLibrary[soundkey].FileName,
													order	= 1
												},
								SoundLength =	{
													type	= "description",
													name	= "Length: "..tostring(self.db.profile.SoundLibrary[soundkey].Length).." seconds",
													order	= 2
												},
								PlayButton =	{
													type = "execute",
													name = "Play",
													func = function ()
																if soundPlaying == false then
																			previewTimer = self:ScheduleTimer("StopEvent", tonumber(self.db.profile.SoundLibrary[soundkey].Length))
																			bla,stopSoundThing= PlaySoundFile(self.db.profile.SoundLibrary[soundkey].FileName,"Master")  
																			soundPlaying = true
																end
															end, 
													order = 3
												},
								DeleteButton =	{
													type		= "execute",
													name		= "Delete",
													func		=	function () 
																		self:CancelTimer(previewTimer,true)
																		soundPlaying = false
																		StopSound(stopSoundThing)
																		PetBattlePokemonMusic:RemoveSoundFromAllAbilityOptions(soundkey)
																		self.db.profile.SoundLibrary[soundkey] = nil  
																		SoundLibrary.args[soundkey] = nil 
																		for key, value in pairs(self.db.CustomTracks) do
																			if value.StartSoundKey == soundkey then
																				self.db.CustomTracks[key].StartSoundKey = nil
																				BattleMusic.args.WildHeader.args[key] = nil
																				BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.profile.Wild.CustomTrack == key then
																					self.db.profile.Wild.CustomTrack = nil
																				end
																				if self.db.profile.Trainer.CustomTrack == key then
																					self.db.profile.Trainer.CustomTrack = nil
																				end
																			end		
																			if value.MusicKey == soundkey then
																				self.db.CustomTracks[key].MusicKey = nil
																				BattleMusic.args.WildHeader.args[key] = nil
																				BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.profile.Wild.CustomTrack == key then
																					self.db.profile.Wild.CustomTrack = nil
																				end
																				if self.db.profile.Trainer.CustomTrack == key then
																					self.db.profile.Trainer.CustomTrack = nil
																				end
																			end	
																			if value.VictoryKey == soundkey then
																				self.db.CustomTracks[key].VictoryKey = nil
																				BattleMusic.args.WildHeader.args[key] = nil
																				BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.profile.Wild.CustomTrack == key then
																					self.db.profile.Wild.CustomTrack = nil
																				end
																				if self.db.profile.Trainer.CustomTrack == key then
																					self.db.profile.Trainer.CustomTrack = nil
																				end
																			end	
																			
																		end
																	end, 
													order		= 4,
													disabled	= UndeleteableSounds[soundkey]
												},
								StopButton =	{
													type = "execute",
													name = "Stop",
													func = function () 
																	self:CancelTimer(previewTimer,true)
																	soundPlaying = false
																	StopSound(stopSoundThing)  
															end, 
													order = 4,
												}
							}
		}
	else
	
	end
end
-- ================================================================================================================================================================================================================================================ --
--		Other Sounds Table
-- ================================================================================================================================================================================================================================================ --
--  This table will be used for other sounds for pet battles that might be added in in future releases of the addon.																																--
--  Currently, it only has the stablemaster healing your pets.																																														--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local OtherSounds = {
							name	= "Custom Tracks",
							type	= "group",
							handler = PetBattlePokemonMusic,
							args = {
									HealingHeader =		{
															type	= "header",
															name	= "Healing Pets",
															order	= 1
														},
									HealingSoundOn =	{
															type	=		"toggle",
															name	=		"Enabled",
															desc	=		"Toogle whether pokemon center sound effect is played when healing your pets or not",
															order	=		2,
															set		=		function (info, val) PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Enabled = valu end,
															get		=		function () return PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Enabled end
														},
									HealingPets =		{
															type	= "select",
															name	= "Healing Pet Sound",
															values	= HealingSoundNames,
															get		= function() return PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Value end,
															set		= function(info, val) PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Value = val end,
															style	= "dropdown",
															order	= 2
														}
									}
}


-- ================================================================================================================================================================================================================================================ --
--
-- ================================================================================================================================================================================================================================================ --
--This is the configuration table for the controls for making a custom track.
--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local CreateCustomTrack =	{
								type = "group",
								name = "Create Custom Tracks",
								args =	{
												NewTrackName = {
																	type	= "input",
																	get		= function() return neoTrackName end,
																	set		= function(info, val) neoTrackName = val end,
																	name	= "New Track Name",
																	order	= 1,
																	width	= "double"
																},
												StartDesc =		{
																	type	= "description",
																	name	= "Start Sound: ",
																	order	= 2
																},
												MusicDesc =		{
																	type	= "description",
																	name	= "Music Track: ",
																	order	= 3
																},
												VictoryDesc =	{
																	type	= "description",
																	name	= "Victory Sound: ",
																	order	= 4
																},
												BadTrack =		{
																	type	= "description",
																	name	= "",
																	order	= 5
																},
											StartSoundGroup =	{
																	name	= "Start Sound",
																	type	= "group",
																	order	= 6,
																	args	= {}
																},
											MusicTrackGroup =	{
																	name	= "Music Track",
																	type	= "group",
																	order	= 7,
																	args	= {}
																},
											VictorySoundGroup = {
																	name	= "Victory Sound",
																	type	= "group",
																	order	= 8,
																	args	= {}
																},
											SaveButton =		{
																	type = "execute",
																	name = "Save",
																	func = function ()
																					PetBattlePokemonMusic:SaveNewTrack()
																			end,
																	order = 9
																}
										}
							}
-- ================================================================================================================================================================================================================================================ --
---This function will save a new track, if the start sound, music track, and victory sound are set.
--
function PetBattlePokemonMusic:SaveNewTrack()
	if unusableSoundNames[neoTrackName] ~= nil then
		CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Cannot use that name"))
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
---
--
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
																								type	= "execute",
																								name	= "Set as start sound",
																								order	= 1,
																								func	=	function ()
																												CreateCustomTrack.args.StartDesc.name = "Start Sound: "..key
																												neoTrackStartKey =(key) 
																											end
																							}
																			}
																}
			CreateCustomTrack.args.MusicTrackGroup.args[key] =	{
																	type = "group",
																	name = key,
																	--name = ("|cffffd200%s|r"):format(tostring(key)),
																	--disabled = PetBattlePokemonMusic.db.profile.Wild.Custom,
																	args = 	{
																				SetStart = {
																								type	= "execute",
																								name	= "Set as music",
																								order	= 1,
																								func	=	function ()
																												CreateCustomTrack.args.MusicDesc.name = "Music Track: "..key
																												neoTrackMusic =(key) 
																											end
																							}

																			}
									
																}
		CreateCustomTrack.args.VictorySoundGroup.args[key] =	{
																	type = "group",
																	name = key,
																	--name = ("|cffffd200%s|r"):format(tostring(key)),
																	--disabled = PetBattlePokemonMusic.db.profile.Wild.Custom,
																	args = 	{
																				SetStart = {
																								type	= "execute",
																								name	= "Set as victory sound",
																								order	= 1,
																								func	=	function ()
																												CreateCustomTrack.args.VictoryDesc.name = "Victory Sound: "..key
																												neoTrackVictory = key 
																											end
																							}
																			}
												}
								end
end

---
--
--@param wer
function PetBattlePokemonMusic:ToggleCustomWild(wer)
	for key, val in pairs (self.db.profile.CustomTracks) do
		if BattleMusic.args.WildHeader.args[key]~= nil then
			BattleMusic.args.WildHeader.args[key].disabled = wer
		end
	end
end
---
--
--@param wer
function PetBattlePokemonMusic:ToggleCustomTrainer(wer)
	for key, val in pairs (self.db.profile.CustomTracks) do
		if BattleMusic.args.TrainerHeader.args[key] ~= nil then
			BattleMusic.args.TrainerHeader.args[key].disabled = wer
		end
	end
end
--- This function fills up the Custom list for the wild tab with the custom tracks.
--
function PetBattlePokemonMusic:FillCustomWild()
	for key, val in pairs (self.db.profile.CustomTracks) do
	if self.db.profile.CustomTracks[key].StartSoundKey~= nil or self.db.profile.CustomTracks[key].MusicKey~= nil or self.db.profile.CustomTracks[key].VictoryKey~=nil then
		BattleMusic.args.WildHeader.args[key] = {
														type		= "group",
														name		= key,
														disabled	= self.db.profile.Wild.Custom==false,
														args	= {
																	SetTrack = {
																					type	= "execute",
																					name	= "Select",
																					order	= 1,
																					func	=	function () 
																									BattleMusic.args.WildHeader.args.WildCustom.name= "Custom Track: "..key  
																									self.db.profile.Wild.CustomTrack = key	  
																								end
																				}
																
																	}
													}
end
	end
	
end
--- This function fills up the Custom list for the trainer tab with the custom tracks.
--
function PetBattlePokemonMusic:FillCustomTrainer()
	for key, val in pairs (self.db.profile.CustomTracks) do
	if self.db.profile.CustomTracks[key].StartSoundKey~= nil or self.db.profile.CustomTracks[key].MusicKey~= nil or self.db.profile.CustomTracks[key].VictoryKey~=nil then
		BattleMusic.args.TrainerHeader.args[key] = {
													type = "group",
													name = key,
													disabled = self.db.profile.Trainer.Custom==false,
													args = 	{
																SetTrack = {
																				type = "execute",
																				name = "Select",
																				order = 1,
																				func = function () BattleMusic.args.TrainerHeader.args.TrainerCustom.name= "Custom Track: "..key  self.db.profile.Trainer.CustomTrack = key	  end
																			}
																
															}
		
												}
	end
	end
end

---This table is used to hold the data for the UI objects in the Custom Track Library.
-- It is empty now because the items have to be added in for each entry in the custom track list.
local CustomTrackLibrary =	{
								name = "Custom Tracks",
								type = "group",
								args =		{
												
								
											}


}
---Add a custom track to the custom track library display.
--
--@param key The string key used to identify a custom track.
function PetBattlePokemonMusic:AddCustomTrackToLibrary (key)

	if self.db.profile.CustomTracks[key] ~= nil and self.db.profile.CustomTracks[key].StartSoundKey~= nil and self.db.profile.CustomTracks[key].MusicKey~= nil and self.db.profile.CustomTracks[key].VictoryKey~=nil then
		CustomTrackLibrary.args[key] =	{
											type		= "group",
											childGroups = "tab",
											name		= key,
											args		=	{
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
																VictoryDesc =	{--CustomTrackLibrary.args[key].args.VictoryDesc
																					type = "description",
																					name = "Victory Sound: "..self.db.profile.CustomTracks[key].VictoryKey,
																					order = 4
																				},

																DeleteBut =		{
																					type	= "execute",
																					name	= "Delete",
																					order	= 6,
																					func	=	function () 
																									self.db.profile.CustomTracks[key]= nil  
																									CustomTrackLibrary.args[key] = nil 
																									BattleMusic.args.TrainerHeader.args[key] = nil 
																									BattleMusic.args.WildHeader.args[key] = nil 
																									if self.db.profile.Wild.CustomTrack == key then
																										--TODO set custom track to another, if there is one.
																									end
																									if self.db.profile.Trainer.CustomTrack == key then
																										--TODO set custom track to another, if there is one.
																									end
																								end
																				},	
															StartEffect	=		{
																					type	= "group",
																					name	= "Start Sound",
																					order	= 7,
																					args	= {}
																				},
															MusicTrack	=		{
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
					CustomTrackLibrary.args[key].args.StartEffect.args[k] =	{
																				type = "group",
																				name = k,
																				args = 	{
																							SetStart = {
																											type = "execute",
																											name = "Set as Start sound",
																											order = 3,
																											func =	function () 
																														CustomTrackLibrary.args[key].args.StartDesc.name = "Start Sound: "..k    
																														self.db.profile.CustomTracks[key].StartSoundKey   = k 
																													end
																										}
																						}
		
																			}
					CustomTrackLibrary.args[key].args.MusicTrack.args[k] =	{
																				type = "group",
																				name = k,
																				args = 	{
																							SetMusic = {
																											type = "execute",
																											name = "Set as Music Track",
																											order = 3,
																											func =	function () 
																														CustomTrackLibrary.args[key].args.MusicDesc.name = "Music Track: "..k    
																														self.db.profile.CustomTracks[key].MusicKey    = k  
																													end
																										}
																						}
		
																			}
				CustomTrackLibrary.args[key].args.VictorySound.args[k] =	{
																				type = "group",
																				name = k,
																				args = 	{
																							SetVictory =	{
																												type = "execute",
																												name = "Set as Victory Sound",
																												order = 3,
																												func =	function () 
																															CustomTrackLibrary.args[key].args.VictoryDesc.name =  "Victory Sound: "..k    
																															self.db.profile.CustomTracks[key].VictoryKey   = k 
																														end
																											}
																						}
																			}
			end
		end
	end
end
---
--
function PetBattlePokemonMusic:FillCustomLib()
	for key,val in pairs (self.db.profile.CustomTracks) do
		PetBattlePokemonMusic:AddCustomTrackToLibrary (key)
	end
end
local idtemp = ""
local BattlePetAbilitySoundSettings =	{
											type = "group",
											name = "Battle Pet Sounds",
											args = {
														BPAbilitySounds ={
																			type = "toggle",
																			name = "Enabled",
																			get = function () return PetBattlePokemonMusic.db.profile.BPAbilitySoundsOn end,
																			set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySoundsOn = val end,
																			order = 1
														},
														descbox =		{
																			type = "description",
																			name = "Spell: ",
																			order = 4,
																			image = "INTERFACE\ICONS\INV_Misc_QuestionMark.png"
																		},
														BPAInputBox =	{
																			type = "input",
																			name = "New Battle Pet Ability ID",
																			set = function(info, val) idtemp = val 
																			--print(C_PetBattles.GetAbilityInfoByID(tonumber(val)))
																			if tonumber(val)== nil then
																				return false
																			end

																				if C_PetBattles.GetAbilityInfoByID(tonumber(val)) ~= nil then

																					demo,a1,a2,a3,a4,a5,a6 = C_PetBattles.GetAbilityInfoByID(tonumber(val))
																					if a1 ~= nil then
																					
																						PetBattlePokemonMusic:UpdateDesco(a1,a2)
																					end
																				 
																				else
																					idtemp=""
																						PetBattlePokemonMusic:UpdateDescoINVALID()
																					end
																				end,
																			get = function() return idtemp end,
																			order = 2
																	
																		},
														AddAbility = 	{
																			type = "execute",
																			name = "Add",
																			order = 3,
																			func = function() PetBattlePokemonMusic:AddAbility(idtemp) PetBattlePokemonMusic:AddAbilityUI(idtemp) idtemp = ""  end
														
														
																		}
													}
										}

function PetBattlePokemonMusic:AddAbility(id)
	if tonumber(id) == nil then
		return false
	end
	if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)] == nil then
		PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)] = {	Damage = {File = "", On = true},
																			Healing ={File = "", On = true},
																			Applied ={File = "", On = true},
																			Dodged = {File = "", On = true},
																			Missed = {File = "", On = true},
																			Faded = {File = "", On = true},
																			Blocked ={File = "", On = true}
																			}
		
	else
		return false
	end
	end
	function PetBattlePokemonMusic:AddAbilityUI(id)
	demo,a1,a2,a3,a4,a5,a6 = C_PetBattles.GetAbilityInfoByID(tonumber(id))
	if demo ~= nil then

		BattlePetAbilitySoundSettings.args[tostring(id)] = 	{
																type = "group",
																name = a1,
																--icon = a2,
																args = 	{
																			
																			damIn =	{
																						type = "select",
																						name = "Damage sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Damage.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Damage.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 1
																					},
																		damon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Damage.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Damage.On = val end,
																						order =2
																		
																					},
																		healIn =	{
																						type = "select",
																						name = "Healing sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Healing.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Healing.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 3
																					},
																		healon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Healing.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Healing.On = val end,
																						order =4
																		
																					},
																		applIn =	{
																						type = "select",
																						name = "Applied sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Applied.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Applied.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 5
																					},
																		appon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Applied.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Applied.On = val end,
																						order =6
																		
																					},
																		missIn =	{
																						type = "select",
																						name = "Missed sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Missed.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Missed.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 7
																					},
																		misson 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Missed.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Missed.On = val end,
																						order =8
																		
																					},
																		dodgeIn =	{
																						type = "select",
																						name = "Dodged sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Dodged.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Dodged.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 9
																					},
																			dodgeon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Dodged.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Dodged.On = val end,
																						order =10
																		
																					},
																		blockIn =	{
																						type = "select",
																						name = "Block sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Blocked.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Blocked.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 11
																					},
																		blockon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Blocked.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Blocked.On = val end,
																						order =12
																		
																					},
																		fadeIn =	{
																						type = "select",
																						name = "Fade sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Faded.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Faded.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 13
																					},
																		fadeon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Faded.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)].Faded.On = val end,
																						order =14
																		
																					},
																		removeit = {
																						type = "execute",
																						name = "Remove",
																						order = 15,
																						func = function() 
																											PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(id)] = nil
																									BattlePetAbilitySoundSettings.args[tostring(id)] = nil
																									end
																		
																					}
																		}
															}
															
	end
end
function PetBattlePokemonMusic:FILLSOUNDLIST ()
	str =""
	for key, val in pairs(PetBattlePokemonMusic.db.profile.SoundLibrary) do
		str = str..key.."\n"
	end

	--BattlePetAbilitySoundSettings.args.Desc.name = str
end
function PetBattlePokemonMusic:UpdateDesco(key, img)
	BattlePetAbilitySoundSettings.args.descbox.name = "Spell: "..tostring(key)

	BattlePetAbilitySoundSettings.args.descbox.image = img
end		
function PetBattlePokemonMusic:UpdateDescoINVALID()

	BattlePetAbilitySoundSettings.args.descbox.name = "INVALID ID"
	BattlePetAbilitySoundSettings.args.descbox.image = nil
end							
function PetBattlePokemonMusic:AddAbilitySoundSetting(key)
	

end
function PetBattlePokemonMusic:RemoveSoundFromAllAbilityOptions(soundkey)


end
--BattlePetAbilitySoundSettings[key].args.damaging.args.SelectedFile.name = "Sound File: ".. soundkey
function PetBattlePokemonMusic:AddSoundToAllAbilityOptions(soundkey)
	
end
function PetBattlePokemonMusic:SetUpAbilities()
	for key, val in pairs (PetBattlePokemonMusic.db.profile.BPAbilitySounds) do
		PetBattlePokemonMusic:AddAbilityUI(key)
	end


end

				--self.db.profile.Wild.CustomTrack		
-- ================================================================================================================================================================================================================================================ --
--					Database Defaults
-- ================================================================================================================================================================================================================================================ --
-- Wild is a table that holds data for battles with wild pets.
-- Trainer is a table that holds data for battles with other trainers or tamers (either a player or an NPC)
-- SoundLibrary holds all of the sound file addresses and their durations.
-- SoundEffects is a table that indexs sound files by the spell ID that plays them.
local defaults = {
					profile={	
									Wild = {
												Track		= 3,
												On			= true,
												Always		= true,
												Custom		= false,
												CustomTrack = 1
											},
								Trainer =	{
												Track		= 2,
												On			= true,
												Always		= true,
												Custom		= false,
												CustomTrack = 1
											},
		
								SoundLibrary	= {},	-- {FileName, Length}
								CustomTracks	= {},
								TrackNames		= {},
								BPAbilitySoundsOn = true,
								BPAbilitySounds = {},
								SoundEffects	=	{
														HealingSound = {Value =3, Enabled = true}
													} --PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound
				
			}
}

--Built in sound files.

defaults.profile.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle Start"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild Start.ogg",
																					Length = 2.8}
defaults.profile.SoundLibrary["Gold & Silver Wild Pokemon Battle Start"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild Start.ogg",
																				Length = 2.65}
defaults.profile.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle Start"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Start.ogg",
																						Length = 2.685}
defaults.profile.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle Start"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Start.ogg",
																					Length = 2.485}
defaults.profile.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle Victory"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Victory Wild.ogg",
																					Length = 34.8}
defaults.profile.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle"] = {FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild.ogg",
																							Length = 78.5}
defaults.profile.SoundLibrary["Gold & Silver Wild Pokemon Battle"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild.ogg",
																		Length = 78}																					
defaults.profile.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild.ogg",
																					Length = 78.5}																						
defaults.profile.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild.ogg",
																				Length = 82.5}																							
defaults.profile.SoundLibrary["Gold & Silver Wild Pokemon Battle Victory"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Victory Wild.ogg",
																				Length = 34.5}
defaults.profile.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle Victory"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Victory.ogg",
																							Length = 21}
defaults.profile.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle Victory"] = {	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Victory.ogg",
																						Length = 30.2}														


	--PetBattlePokemonMusic.db.profile.BPAbilitySounds[key]																		
function PetBattlePokemonMusic:SetUpSL()
	for key,val in pairs (PetBattlePokemonMusic.db.profile.SoundLibrary) do
		PetBattlePokemonMusic:AddSoundToConfig(key)
	end
end
function PetBattlePokemonMusic:FillSoundListUI()
	SoundListUI = {}
	SoundListUIKeys = {}
	for k, v in pairs (PetBattlePokemonMusic.db.profile.SoundLibrary) do
		tinsert(SoundListUI,k)
		SoundListUIKeys[k] = #SoundListUI
	end
	for k, v in pairs (PetBattlePokemonMusic.db.profile.BPAbilitySounds) do
		if BattlePetAbilitySoundSettings.args[tostring(k)] ~= nil then
		BattlePetAbilitySoundSettings.args[tostring(k)].args.damIn.values = SoundListUI
		BattlePetAbilitySoundSettings.args[tostring(k)].args.healIn.values = SoundListUI
		BattlePetAbilitySoundSettings.args[tostring(k)].args.applIn.values = SoundListUI
		BattlePetAbilitySoundSettings.args[tostring(k)].args.missIn.values = SoundListUI
		BattlePetAbilitySoundSettings.args[tostring(k)].args.dodgeIn.values = SoundListUI
		BattlePetAbilitySoundSettings.args[tostring(k)].args.blockIn.values = SoundListUI
		BattlePetAbilitySoundSettings.args[tostring(k)].args.fadeIn.values = SoundListUI
		end
	end
	
	
end
function PetBattlePokemonMusic:OnInitialize()
	

	self.db = LibStub("AceDB-3.0"):New("PBPM", defaults)

	
	
	PetBattlePokemonMusic:FillSoundListUI()

	local config = LibStub("AceConfig-3.0")
	local registry = LibStub("AceConfigRegistry-3.0")

	PetBattlePokemonMusic:FILLSOUNDLIST ()
	PetBattlePokemonMusic:SetUpAbilities()

	registry:RegisterOptionsTable("PetBattlePokemonMusic Main", main)
	registry:RegisterOptionsTable("Pet Battle Music", BattleMusic)
	registry:RegisterOptionsTable("Other Sounds", OtherSounds)
	registry:RegisterOptionsTable("Sound Library",SoundLibrary)
	registry:RegisterOptionsTable("Create Custom Track",CreateCustomTrack)
	registry:RegisterOptionsTable("Custom Tracks",CustomTrackLibrary)
	registry:RegisterOptionsTable("Battle Pet Sounds",BattlePetAbilitySoundSettings)
	

	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionFrames = {
							main		= dialog:AddToBlizOptions("PetBattlePokemonMusic Main", "Pet Battle Pokemon Mod"),
							Wild		= dialog:AddToBlizOptions("Pet Battle Music", "Pet Battle Music", "Pet Battle Pokemon Mod"),
							OtherS		=  dialog:AddToBlizOptions("Other Sounds", "Other Sounds", "Pet Battle Pokemon Mod"),
							Library		= dialog:AddToBlizOptions("Sound Library", "Sound Library", "Pet Battle Pokemon Mod"),
							CreateCust	= dialog:AddToBlizOptions("Create Custom Track", "Create Custom Track", "Pet Battle Pokemon Mod"),
							Custs		= dialog:AddToBlizOptions("Custom Tracks", "Custom Tracks", "Pet Battle Pokemon Mod"),
							BPS			= dialog:AddToBlizOptions("Battle Pet Sounds", "Battle Pet Sounds", "Pet Battle Pokemon Mod")
		--,
		--Tracks = dialog:AddToBlizOptions("Custom Tracks", "Custom Tracks", "PetBattlePokemonMusic")
						}
	-- Register Events.
	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	self:RegisterEvent("PET_BATTLE_OVER")
	self:RegisterEvent("PET_BATTLE_FINAL_ROUND")
	self:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
	self:RegisterEvent("PET_BATTLE_PET_ROUND_RESULTS")
	self:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
	self:RegisterEvent("CHAT_MSG_PET_BATTLE_INFO")

	--  Set up Functions.
	PetBattlePokemonMusic:SetUpSL()
	PetBattlePokemonMusic:FillCustomWild()
	PetBattlePokemonMusic:FillCustomTrainer()
	PetBattlePokemonMusic:SetUpCustomCreator()
	PetBattlePokemonMusic:FillCustomLib()
end
---
--
--@param event The name of the event.
--@param
function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_INFO(event, ...)
	demo = {...}

	for i=1,#demo do
		--print((i+1)..".".." "..tostring(demo[i]))
		
	end
end
function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_COMBAT_LOG(...)
		demo = {...}
	--print("PB Combat log " .. #demo)
	str = ""
	--Basic Damage Dealing  INTERFACE\\.*\\.*.%BLP:14|
	--print(strfind((demo[2]),"INTERFACE\\.*\\.*.%BLP:14|"))
	w,ty = strfind((demo[2]),"HbattlePetAbil:(%d*):%d*:%d*:%d*|h%[.*%]|h|r")
	if ty ~= nil then
	--print("FGG")
	--print(strsub((demo[2]),ty+1))
	--print(strsub((demo[2]),1,ty))
	rwr , qwe= strfind((strsub((demo[2]),1,ty)),"INTERFACE\\.*\\.*.%BLP:14.*")
	--print(strsub((strsub((demo[2]),1,ty)),qwe+1))
	end
	if strfind(tostring(demo[2]),BPAPatternDealtYour) ~= nil then
		--print("Damage dealt to yours")
		e1, e2, goal = strfind(demo[2],BPAPatternDealtYour)
		sd, rqw, qrr = strfind(goal,BPApattern)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	if strfind(demo[2],BPAPatternDealtEnemy) ~= nil then
		--print("Damage dealt to enemy")
		e1, e2, goal = strfind(demo[2],BPAPatternDealtEnemy)
		e1, e2, goal = strfind(demo[2],BPAPatternDealtEnemy)
		sd, rqw, qrr = strfind(goal,BPApattern)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	--MISSED
	if strfind(demo[2],BPAPatternYourMiss  ) ~= nil then

		e1, e2, goal,g2 = strfind(demo[2],BPAPatternYourMiss )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternYourMiss )
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)
		--print (goal)
		--print (qrr)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Missed.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Missed.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	if strfind(demo[2],BPAPatternEnemyMiss  ) ~= nil then

		e1, e2, goal,g2 = strfind(demo[2],BPAPatternEnemyMiss )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternEnemyMiss )
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)
		--print (goal)
		--print (qrr)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Missed.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Missed.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end	
	--BPAPatternHealYour
	--HEALED
	if strfind(tostring(demo[2]),BPAPatternHealYour) ~= nil then
		--print("heal")
		e1, e2, goal = strfind(demo[2],BPAPatternHealYour)
		sd, rqw, qrr = strfind(goal,BPApattern)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	if strfind(demo[2],BPAPatternHealEnemy) ~= nil then
		--print("heal")
		e1, e2, goal = strfind(demo[2],BPAPatternHealEnemy)
		e1, e2, goal = strfind(demo[2],BPAPatternHealEnemy)
		sd, rqw, qrr = strfind(goal,BPApattern)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	--Dodge
	if strfind(tostring(demo[2]),BPAPatternYourDodged) ~= nil then
	
		e1, e2, goal = strfind(demo[2],BPAPatternYourDodged)
		sd, rqw, qrr = strfind(goal,BPApattern)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	if strfind(demo[2],BPAPatternEnemyDodged) ~= nil then
	
		e1, e2, goal = strfind(demo[2],BPAPatternEnemyDodged)
		e1, e2, goal = strfind(demo[2],BPAPatternEnemyDodged)
		sd, rqw, qrr = strfind(goal,BPApattern)
		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	--- APPLIED
	if strfind(demo[2],BPAPatternYourApp ) ~= nil then

		e1, e2, goal,g2 = strfind(demo[2],BPAPatternYourApp)
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternYourApp)
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)

		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Applied.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Applied.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	if strfind(demo[2],BPAPatternEnemyApp  ) ~= nil then

		e1, e2, goal,g2 = strfind(demo[2],BPAPatternEnemyApp )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternEnemyApp )
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)

		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Applied.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Applied.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	--FADE
	if strfind(demo[2],BPAPatternEnemyFade ) ~= nil then

		e1, e2, goal,g2 = strfind(demo[2],BPAPatternEnemyFade)
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternEnemyFade)
		sd, rqw, qrr, a2, a3 = strfind(goal,BPApattern)

		--print(qrr)
		
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Faded.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Faded.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	--fade
	if strfind(demo[2],BPAPatternYourFade  ) ~= nil then
		--print("FADE")
		e1, e2, goal,g2 = strfind(demo[2],BPAPatternYourFade )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternYourFade )
		sd, rqw, qrr, a2, a3 = strfind(goal,BPApattern)

	
			--print(PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File)
			if PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Faded.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Faded.File].FileName,"Master")
			--PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName
				end
			end
		
	end
	iorww = strfind(demo[2],"HbattlePetAbil:")
	if iorww ~= nil then
		str = strsub(demo[2],iorww)
		--print(strsub(str,16))
		werer = strfind(strsub(str,16),":")

		if werer ~= nil then
		--	print(strsub(strsub(str,16),1,werer-1))
		end
	end
	--"|cff4e96f7|HbattlePetAbil:abilityID:maxHealth:power:speed|h[text]|h|r"
	
	
	--ICON battlePetAbil " dealt " # " damage to enemy " ICON2 EnemyName
	
end

function PetBattlePokemonMusic:OnEnable()
    -- Called when the addon is enabled

    -- Print a message to the chat frame

end

function PetBattlePokemonMusic:OnDisable()
    -- Called when the addon is disabled
end
---This function handles the event when a pet battle starts.
--@param event Event Name
function PetBattlePokemonMusic:PET_BATTLE_OPENING_START(event,...)

	demo = {...}
	--print("PET_BATTLE_OPENING_START " .. #demo)
	for i=1,#demo do
		--print(i+1..".".." "..tostring(demo[i]))
		
	end
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
--@param event The event name.
function PetBattlePokemonMusic:PET_BATTLE_OVER(event,...)
	demo = {...}
	--print("PET_BATTLE_OVER " .. #demo)
	for i=1,#demo do
	--	print(i+1..".".." "..tostring(demo[i]))
		
	end
end
---
--
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
---This handles an event that is thrown at the end of a pet battle.
--@param event Event name.
--@param outcomenumber This value is a number that appears to change depending on the winner.  1 seems to mean that you won.  2 seems to mean the other won.  
--More values may be possible.
function PetBattlePokemonMusic:PET_BATTLE_FINAL_ROUND(event,outcomenumber)
	StopMusic();
	SetCVar("Sound_EnableMusic", OldMusicValue )
	self:CancelTimer(battleTimer,true)
	if currentSound ~= nil then
		StopSound(currentSound)
		currentSound=nil
	end
	if outcomenumber == 1 then
	
		if C_PetBattles.IsWildBattle() then
			if PetBattlePokemonMusic.db.profile.Wild.Custom then
				if PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Wild.CustomTrack] ~= nil then
					if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Wild.CustomTrack].VictoryKey] ~= nil then
						PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Wild.CustomTrack].VictoryKey].FileName, "Master")					
					end
				end
			else
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Wild.Track].VictoryKey].FileName, "Master")
			end
		else
			if PetBattlePokemonMusic.db.profile.Trainer.Custom then
				if PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Trainer.CustomTrack] ~= nil then
					if PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Trainer.CustomTrack].VictoryKey] ~= nil then
						PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PetBattlePokemonMusic.db.profile.CustomTracks[PetBattlePokemonMusic.db.profile.Trainer.CustomTrack].VictoryKey].FileName, "Master")					
					end
				end
			else
				PlaySoundFile(PetBattlePokemonMusic.db.profile.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.profile.Trainer.Track].VictoryKey].FileName, "Master")
			end
		end
	end
	
end
function PetBattlePokemonMusic:UNIT_SPELLCAST_SUCCEEDED(eveName, unitID, spell, rank, lineID, spellID)
	
	if spellID == 125801 then
		--if PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Enabled == true then
			--PlaySoundFile(HealingSounds[PetBattlePokemonMusic.db.profile.SoundEffects.HealingSound.Value],"Master")
		--PlayMusic("Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Healing.ogg")
		--end
		print("Pokecenter disabled for now")
	end
end




-- Music Functions

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