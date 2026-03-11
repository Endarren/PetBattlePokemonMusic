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
--	* Added SoundLibrary to self.db.global.
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
--	Version 1-4
-- ================================================================================================================================================================================================================================================ --
--	* Added Trainer Tracks.
--	** Added trainer sound names to UndeleteableSounds.
--	** Added premade trainer tracks to PokemonBattleMusicEffects.
--	** Added premade trainer track names to trackNames.
--	** Added trainer sound files to default database.
--	* Add volume control.
--	* TODO Add option to not use start.

-- ================================================================================================================================================================================================================================================ --
--	Version 2.0
-- ================================================================================================================================================================================================================================================ --
--	* TODO  Template adding functions.
--	* TODO  Playlist

PetBattlePokemonMusic = LibStub("AceAddon-3.0"):NewAddon("PetBattlePokemonMusic", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0" );

local BPApattern = "|cff4e96f7|HbattlePetAbil:(%d*):%d*:%d*:%d*|h%[.*%]|h|r"
local iconpattern = "INTERFACE\\ICON\\.*%.BLP:%d*"


local damagePattern = ""
local missPattern = ""
local dodgePattern =""
local healedPattern = ""
local auraAppliedPattern = ""
local auraFadesPattern = ""
local weatherChangePattern = ""
local weatherFadePattern = ""

--This function is supposed to take the client strings for the pet battle combat log,
--and make patterns that can be used to get information use they are used in the log.
function PetBattlePokemonMusic:makePattern(str)
	str2 =string.gsub(str, "%%s", "(.*)")
	str2 =string.gsub(str2, "%%d", "%(%%d%*%)")
	str2 =string.gsub(str2, "%)%.", "%)%%.")
	
	return str2
end


function PetBattlePokemonMusic:createLocalizedPatterns()
	damagePattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_DAMAGE)
	missPattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_MISS)
	dodgePattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_DODGE)
	healedPattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_HEALING)
	auraAppliedPattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_PAD_AURA_APPLIED)
	auraFadesPattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_PAD_AURA_FADES)
	weatherChangePattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_WEATHER_AURA_APPLIED)
	weatherFadePattern = PetBattlePokemonMusic:makePattern(PET_BATTLE_COMBAT_LOG_WEATHER_AURA_FADES)
end


--Damaged
local BPAPatternDealtYour = "(.*) dealt %d* damage to your (.*)%."
local BPAPatternDealtEnemy = "(.*) dealt %d* damage to enemy (.*)%."
--Damaged Critical
local BPAPatternDealtYourCrit = "(.*) dealt %d* damage to your (.*) %(Critical%)%."
local BPAPatternDealtEnemyCrit = "(.*) dealt %d* damage to enemy (.*) %(Critical%)%."
--Damaged Strong
local BPAPatternDealtYourStrong = "(.*) dealt %d* damage to your INTERFACE\\.*\\.*.%BLP:14.* %(Strong%)%."
local BPAPatternDealtEnemyStrong = "(.*) dealt %d* damage to enemy INTERFACE\\.*\\.*.%BLP:14.* %(Strong%)%."
--Damaged Weak
local BPAPatternDealtYourWeak = "(.*) dealt %d* damage to your (.*) %(Weak%)%."
local BPAPatternDealtEnemyWeak = "(.*) dealt %d* damage to enemy (.*) %(Weak%)%."
--Dodged
local BPAPatternYourDodged = "(.*) was dodged by your (.*)%."
local BPAPatternEnemyDodged = "(.*) was dodged by enemy (.*)%."
--Faded
local BPAPatternYourFade = "(.*) fades from your (.*)%."
local BPAPatternEnemyFade = "(.*) fades from enemy (.*)%."
--Applied
local BPAPatternYourApp = "(.*) applied (.*) to your (.*)%."
local BPAPatternEnemyApp = "(.*) applied (.*) to enemy (.*)%."
--Miss
local BPAPatternYourMiss = "(.*) missed your (.*)%."
local BPAPatternEnemyMiss = "(.*) missed enemy (.*)%."
--Heals
local BPAPatternHealYour = "(.*) healed %d* damage from your (.*)%."
local BPAPatternHealEnemy = "(.*) healed %d* damage from enemy (.*)%."
--Weather Change:  Not complete
local weatherIn = "(.*) changed the weather to (.*)%."
local weatherOut ="(.*) is no longer the weather%."

local BPLevelUpPattern = "(.*) has reached level %d*!"

local block = " was blocked from striking "

local SoundListUI = {}
local SoundListUIKeys = {}
local testersd = 0;
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

	UndeleteableSounds["FireRed & LifeGreen Trainer Battle Start"]			= true
	UndeleteableSounds["FireRed & LifeGreen Trainer Battle"]				= true
	UndeleteableSounds["FireRed & LifeGreen Trainer Battle Victory"]		= true	
				
	UndeleteableSounds["Red, Blue, & Yellow Trainer Start"]					= true
	UndeleteableSounds["Red, Blue, & Yellow Trainer Battle"]				= true
	UndeleteableSounds["Red, Blue, & Yellow Trainer Victory"]		= true	
																			
	UndeleteableSounds["Gold & Silver Trainer Battle Start"]			= true
	UndeleteableSounds["Gold & Silver Trainer Battle"]				= true
	UndeleteableSounds["Gold & Silver Trainer Battle Victory"]		= true	
	
	UndeleteableSounds["Ruby, Saphire, & Emerald Trainer Start"]			= true
	UndeleteableSounds["Ruby, Saphire, & Emerald Trainer Battle"]				= true
	UndeleteableSounds["Ruby, Saphire, & Emerald Trainer Victory"]		= true	
	

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
	-- TRAINER
	PokemonBattleMusicEffects[5] =	{	Name = "Red, Blue, & Yellow Trainer Battle", 
										StartSoundKey = "Red, Blue, & Yellow Trainer Start",
										MusicKey = "Red, Blue, & Yellow Trainer Battle",
										VictoryKey = "Red, Blue, & Yellow Trainer Victory"
									}
	PokemonBattleMusicEffects[6] =	{	Name = "Gold & Silver Trainer Battle", 
										StartSoundKey = "Gold & Silver Trainer Battle Start",
										MusicKey = "Gold & Silver Trainer Battle",
										VictoryKey = "Gold & Silver Trainer Battle Victory"
									}
	PokemonBattleMusicEffects[7] =	{	Name = "Ruby, Saphire, & Emerald Trainer Battle", 
										StartSoundKey = "Ruby, Saphire, & Emerald Trainer Start",
										MusicKey = "Ruby, Saphire, & Emerald Trainer Battle",
										VictoryKey = "Ruby, Saphire, & Emerald Trainer Victory"
									}
	
	PokemonBattleMusicEffects[8] =	{	Name = "FireRed & LifeGreen Trainer Battle", 
										StartSoundKey = "FireRed & LifeGreen Trainer Battle Start",
										MusicKey = "FireRed & LifeGreen Trainer Battle",
										VictoryKey = "FireRed & LifeGreen Trainer Battle Victory"
	}
	
local trackNames = {}
	trackNames[1] = "Red, Blue, & Yellow Wild Pokemon Battle"
	trackNames[2] = "Gold & Silver Wild Pokemon Battle"
	trackNames[3] = "Ruby, Saphire, & Emerald Wild Pokemon Battle"
	trackNames[4] = "FireRed & LifeGreen Wild Pokemon Battle"
	trackNames[5] = "Red, Blue, & Yellow Trainer Battle"
	trackNames[6] = "Gold & Silver Trainer Battle"
	trackNames[7] = "Ruby, Saphire, & Emerald Trainer Battle"
	trackNames[8] = "FireRed & LifeGreen Trainer Battle"

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
--StartSoundOn
		StartSoundOp = {
							type		= "toggle",
							name		= "Start Sound",
							desc		=	"Toogle whether start sound is used at beginning of battle or not.",
							order		=	1,
							set			=	function (info, val) PetBattlePokemonMusic.db.global.StartSoundOn = val end,
							get			= function () return PetBattlePokemonMusic.db.global.StartSoundOn end
						},
		VictorySoundOp = {
							type		= "toggle",
							name		= "Victory Sound",
							desc		=	"Toogle whether the victory sound is played or not.",
							order		=	1,
							set			=	function (info, val) PetBattlePokemonMusic.db.global.VictorySoundOn = val end,
							get			= function () return PetBattlePokemonMusic.db.global.VictorySoundOn end
		},
		resetbut = {
			type = "execute",
			name = "Reset Addon",
			func = function () PetBattlePokemonMusic:Reset() end
		},
TrainerCustom = {
																							order		=	8,
																							type		= "description",
																							name		= testersd.." ",
																							cmdHidden	=	true
																						}
	}
}
-- ================================================================================================================================================================================================================================================ --
--											BattleMusic
-- ================================================================================================================================================================================================================================================ --
local BattleMusic = {
							name = "Battle Music",
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
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.Wild.On = valu end,
																							get			=	function () return PetBattlePokemonMusic.db.global.Wild.On end
																						},
																		WildAlwaysOn =	{
																							type		=	"toggle",
																							name		=	"Always On",
																							desc		=	"Toogles whether music will be played if music is disabled on the client",
																							order		=	2,
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.Wild.Always = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.Wild.Always end
																		},
																		WildMusicVolume =	{
																							type = "range",
																							name = "Music Volume",
																							min  = 0,
																							max  = 1,
																							step = 0.1,
																							get = function() return  PetBattlePokemonMusic.db.global.Wild.Volume.Music; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.Wild.Volume.Music = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsWildBattle() then
																									SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music )
																								end
																								end,
																							order = 4
																		},
																WildMasterVolume =	{
																							type = "range",
																							name = "Sound Effect Volume",
																							min  = 0,
																							max  = 1,
																							step = 0.1,
																							get = function() return  PetBattlePokemonMusic.db.global.Wild.Volume.Master; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.Wild.Volume.Master = val;
																								--TODO update current volume if in battle.
																								SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master )
																								if C_PetBattles.IsWildBattle() then
																											
				
																								end
																							end,
																							order = 4
																},

																		WildTrack =		{
																							type		=	"select",
																							order		=	5,
																							style		=	"dropdown",
																							name		=	"Track",
																							values		=	trackNames,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.Wild.Track = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.global.Wild.Track end
																						},
																		WildCustomOn =	{
																							type		=	"toggle",
																							name		=	"Custom Track",
																							desc		=	"Toogles whether the music will be used from a custom track",
																							order		=	6,
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.Wild.Custom = val PetBattlePokemonMusic:ToggleCustomWild(val==false)end,
																							get			=	function () return PetBattlePokemonMusic.db.global.Wild.Custom end
																						},
																		WildCustom =	{
																							order		= 7,
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
																							order		=	3,
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.Trainer.On = valu end,
																							get			=	function () return PetBattlePokemonMusic.db.global.Trainer.On end
																						},
																	TrainerAlwaysOn =	{
																							type		=	"toggle",
																							name		=	"Always On",
																							desc		=	"Toogles whether music will be played if music is disabled on the client",
																							order		=	3,
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.Trainer.Always = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.Trainer.Always end
																	},
															TrainerMusicVolume =	{
																							type = "range",
																							name = "Music Volume",
																							min  = 0,
																							max  = 1,
																							step = 0.1,
																							get = function() return  PetBattlePokemonMusic.db.global.Trainer.Volume.Music; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.Trainer.Volume.Music = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music )
																								end
																								end,
																							order = 5
																		},
																TrainerMasterVolume =	{
																							type = "range",
																							name = "Sound Effect Volume",
																							min  = 0,
																							max  = 1,
																							step = 0.1,
																							get = function() return  PetBattlePokemonMusic.db.global.Trainer.Volume.Master; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.Trainer.Volume.Master = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
																								end
																								end,
																							order = 5
																},
																	TrainerTrack =		{
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	"Track",
																							values		=	trackNames,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.Trainer.Track = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.global.Trainer.Track end
																						},
																	TrainerCustomOn =	{
																							type		=	"toggle",
																							name		=	"Custom Track",
																							desc		=	"Toogles whether the music will be used from a custom track",
																							order		=	7,
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.Trainer.Custom = val PetBattlePokemonMusic:ToggleCustomTrainer(val ==false) end,
																							get			=	function () return PetBattlePokemonMusic.db.global.Trainer.Custom end
																						},
															
																		TrainerCustom = {
																							order		=	8,
																							type		= "description",
																							name		= "Custom Track: ",
																							cmdHidden	=	true
																						}
														
																}
										}
								--TODO PvP options here
									}
}

-- ================================================================================================================================================================================================================================================ --
--			Local Fields
-- ================================================================================================================================================================================================================================================ --
local battleTimer = nil

local removeSelect = "none"

local stopSoundThing = 0
local soundPlaying = false

local previewSelect = "none"
local previewTimer = nil
local idtemp = ""
local neoSoundFileTemp = ""
local neoSoundLengthTemp = 0
local neoSoundNameTemp =""

local neoTrackMusic = ""
local neoTrackName = ""
local neoTrackStartKey = ""

local neoTrackVictory = ""

local currentSound = nil

local OldMusicVolume;
local OldMasterVolume;
local InBattle = false;

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
																			if PetBattlePokemonMusic.db.global.SoundLibrary[neoSoundNameTemp] ~= nil then
																				--Name already used
																				return false
																			end
																		PetBattlePokemonMusic.db.global.SoundLibrary[neoSoundNameTemp] = {FileName = neoSoundFileTemp, Length = neoSoundLengthTemp}
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
													name	= "File Name: "..self.db.global.SoundLibrary[soundkey].FileName,
													order	= 1
												},
								SoundLength =	{
													type	= "description",
													name	= "Length: "..tostring(self.db.global.SoundLibrary[soundkey].Length).." seconds",
													order	= 2
												},
								PlayButton =	{
													type = "execute",
													name = "Play",
													func = function ()
																if soundPlaying == false then
																			previewTimer = self:ScheduleTimer("StopEvent", tonumber(self.db.global.SoundLibrary[soundkey].Length))
																			bla,stopSoundThing= PlaySoundFile(self.db.global.SoundLibrary[soundkey].FileName,"Master")  
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
																		if stopSoundThing ~= nil then
																		StopSound(stopSoundThing)
																		end	
																		PetBattlePokemonMusic:RemoveSoundFromAllAbilityOptions(soundkey)
																		self.db.global.SoundLibrary[soundkey] = nil  
																		SoundLibrary.args[soundkey] = nil 
																		if self.db.CustomTracks ~= nil then
																		for key, value in pairs(self.db.CustomTracks) do
																			if value.StartSoundKey == soundkey then
																				self.db.CustomTracks[key].StartSoundKey = nil
																				BattleMusic.args.WildHeader.args[key] = nil
																				BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.global.Wild.CustomTrack == key then
																					self.db.global.Wild.CustomTrack = nil
																				end
																				if self.db.global.Trainer.CustomTrack == key then
																					self.db.global.Trainer.CustomTrack = nil
																				end
																			end		
																			if value.MusicKey == soundkey then
																				self.db.CustomTracks[key].MusicKey = nil
																				BattleMusic.args.WildHeader.args[key] = nil
																				BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.global.Wild.CustomTrack == key then
																					self.db.global.Wild.CustomTrack = nil
																				end
																				if self.db.global.Trainer.CustomTrack == key then
																					self.db.global.Trainer.CustomTrack = nil
																				end
																			end	
																			if value.VictoryKey == soundkey then
																				self.db.CustomTracks[key].VictoryKey = nil
																				BattleMusic.args.WildHeader.args[key] = nil
																				BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.global.Wild.CustomTrack == key then
																					self.db.global.Wild.CustomTrack = nil
																				end
																				if self.db.global.Trainer.CustomTrack == key then
																					self.db.global.Trainer.CustomTrack = nil
																				end
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
																	if stopSoundThing ~= nil then
																	StopSound(stopSoundThing)  
		end
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
															set		=		function (info, val) PetBattlePokemonMusic.db.global.SoundEffects.HealingSound.Enabled = valu end,
															get		=		function () return PetBattlePokemonMusic.db.global.SoundEffects.HealingSound.Enabled end
														},
									HealingPets =		{
															type	= "select",
															name	= "Healing Pet Sound",
															values	= HealingSoundNames,
															get		= function() return PetBattlePokemonMusic.db.global.SoundEffects.HealingSound.Value end,
															set		= function(info, val) PetBattlePokemonMusic.db.global.SoundEffects.HealingSound.Value = val end,
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
		if self.db.global.CustomTracks[neoTrackName] ~= nil then
			CreateCustomTrack.args.BadTrack.name = "Track name already used"
			return false
		else
			--neoTrackStartKey
			if self.db.global.SoundLibrary[neoTrackStartKey] == nil then
				CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Start sound not selected"))
			else
				if self.db.global.SoundLibrary[neoTrackMusic] == nil then
					CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Music Track not selected"))
				else
					if self.db.global.SoundLibrary[neoTrackVictory] == nil then
						CreateCustomTrack.args.BadTrack.name = ("|cffFF0000%s|r"):format(tostring("Victory Sound not selected"))
					else
						CreateCustomTrack.args.BadTrack.name =""
						
							self.db.global.CustomTracks[neoTrackName] ={StartSoundKey = neoTrackStartKey,
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
	
	for key, val in pairs (self.db.global.SoundLibrary) do
			CreateCustomTrack.args.StartSoundGroup.args[key] = {
																	type = "group",
																	name = key,
																	--name = ("|cffffd200%s|r"):format(tostring(key)),
																	--disabled = PetBattlePokemonMusic.db.global.Wild.Custom,
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
																	--disabled = PetBattlePokemonMusic.db.global.Wild.Custom,
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
																	--disabled = PetBattlePokemonMusic.db.global.Wild.Custom,
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
	for key, val in pairs (self.db.global.CustomTracks) do
		if BattleMusic.args.WildHeader.args[key]~= nil then
			BattleMusic.args.WildHeader.args[key].disabled = wer
		end
	end
end
---
--
--@param wer
function PetBattlePokemonMusic:ToggleCustomTrainer(wer)
	for key, val in pairs (self.db.global.CustomTracks) do
		if BattleMusic.args.TrainerHeader.args[key] ~= nil then
			BattleMusic.args.TrainerHeader.args[key].disabled = wer
		end
	end
end
--- This function fills up the Custom list for the wild tab with the custom tracks.
--
function PetBattlePokemonMusic:FillCustomWild()
	for key, val in pairs (self.db.global.CustomTracks) do
	if self.db.global.CustomTracks[key].StartSoundKey~= nil or self.db.global.CustomTracks[key].MusicKey~= nil or self.db.global.CustomTracks[key].VictoryKey~=nil then
		BattleMusic.args.WildHeader.args[key] = {
														type		= "group",
														name		= key,
														disabled	= self.db.global.Wild.Custom==false,
														args	= {
																	SetTrack = {
																					type	= "execute",
																					name	= "Select",
																					order	= 1,
																					func	=	function () 
																									BattleMusic.args.WildHeader.args.WildCustom.name= "Custom Track: "..key  
																									self.db.global.Wild.CustomTrack = key	  
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
	for key, val in pairs (self.db.global.CustomTracks) do
	if self.db.global.CustomTracks[key].StartSoundKey~= nil or self.db.global.CustomTracks[key].MusicKey~= nil or self.db.global.CustomTracks[key].VictoryKey~=nil then
		BattleMusic.args.TrainerHeader.args[key] = {
													type = "group",
													name = key,
													disabled = self.db.global.Trainer.Custom==false,
													args = 	{
																SetTrack = {
																				type = "execute",
																				name = "Select",
																				order = 1,
																				func = function () BattleMusic.args.TrainerHeader.args.TrainerCustom.name= "Custom Track: "..key  self.db.global.Trainer.CustomTrack = key	  end
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

	if self.db.global.CustomTracks[key] ~= nil and self.db.global.CustomTracks[key].StartSoundKey~= nil and self.db.global.CustomTracks[key].MusicKey~= nil and self.db.global.CustomTracks[key].VictoryKey~=nil then
		CustomTrackLibrary.args[key] =	{
											type		= "group",
											childGroups = "tab",
											name		= key,
											args		=	{
																	StartDesc = {--CustomTrackLibrary.args[key].args.StartDesc
																					type = "description",
																					name = "Start Sound: "..self.db.global.CustomTracks[key].StartSoundKey,
																					order = 2
																				},
																	MusicDesc = { --CustomTrackLibrary.args[key].args.MusicDesc
																					type = "description",
																					name = "Music Track: "..self.db.global.CustomTracks[key].MusicKey,
																					order = 3
																				},
																VictoryDesc =	{--CustomTrackLibrary.args[key].args.VictoryDesc
																					type = "description",
																					name = "Victory Sound: "..self.db.global.CustomTracks[key].VictoryKey,
																					order = 4
																				},

																DeleteBut =		{
																					type	= "execute",
																					name	= "Delete",
																					order	= 6,
																					func	=	function () 
																									self.db.global.CustomTracks[key]= nil  
																									CustomTrackLibrary.args[key] = nil 
																									BattleMusic.args.TrainerHeader.args[key] = nil 
																									BattleMusic.args.WildHeader.args[key] = nil 
																									if self.db.global.Wild.CustomTrack == key then
																										--TODO set custom track to another, if there is one.
																									end
																									if self.db.global.Trainer.CustomTrack == key then
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

		for k, v in pairs (self.db.global.SoundLibrary) do
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
																														self.db.global.CustomTracks[key].StartSoundKey   = k 
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
																														self.db.global.CustomTracks[key].MusicKey    = k  
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
																															self.db.global.CustomTracks[key].VictoryKey   = k 
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
	for key,val in pairs (self.db.global.CustomTracks) do
		PetBattlePokemonMusic:AddCustomTrackToLibrary (key)
	end
end

local BattlePetAbilitySoundSettings =	{
											type = "group",
											name = "Battle Pet Sounds",
											args = {
														BPAbilitySounds ={
																			type = "toggle",
																			name = "Enabled",
																			get = function () return PetBattlePokemonMusic.db.global.BPAbilitySoundsOn end,
																			set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySoundsOn = val end,
																			order = 1
														},
														descbox =		{
																			type = "description",
																			name = "Spell: ",
																			order = 4,
																			image = "INTERFACE\BUTTONS\UI-EmptySlot.blp"
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
																					--print(a2)
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
																			func = function() PetBattlePokemonMusic:AddAbility(idtemp) idtemp = ""  end
														
														
																		}
													}
										}

function PetBattlePokemonMusic:AddAbility(id)
	if tonumber(id) == nil then
		return false
	end
	if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(id)] == nil then
		PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(id)] = {	Damage = {File = "", On = true},
																			Healing ={File = "", On = true},
																			Applied ={File = "", On = true},
																			Dodged = {File = "", On = true},
																			Missed = {File = "", On = true},
																			Faded = {File = "", On = true},
																			Blocked ={File = "", On = true}
																			}
		PetBattlePokemonMusic:AddAbilityUI(id)
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
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.File] end, -- error on mod overwrite
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 1
																					},
																		damon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.On = val end,
																						order =2
																		
																					},
																		healIn =	{
																						type = "select",
																						name = "Healing sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 3
																					},
																		healon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.On = val end,
																						order =4
																		
																					},
																		applIn =	{
																						type = "select",
																						name = "Applied sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 5
																					},
																		appon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.On = val end,
																						order =6
																		
																					},
																		missIn =	{
																						type = "select",
																						name = "Missed sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 7
																					},
																		misson 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.On = val end,
																						order =8
																		
																					},
																		dodgeIn =	{
																						type = "select",
																						name = "Dodged sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 9
																					},
																			dodgeon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.On = val end,
																						order =10
																		
																					},
																		blockIn =	{
																						type = "select",
																						name = "Block sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 11
																					},
																		blockon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.On = val end,
																						order =12
																		
																					},
																		fadeIn =	{
																						type = "select",
																						name = "Fade sound",
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Faded.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Faded.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 13
																					},
																		fadeon 	= {
																						type = "toggle",
																						name = "Enabled",
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Faded.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Faded.On = val end,
																						order =14
																		
																					}
																		}
															}
															
	end
	end
	
	
function PetBattlePokemonMusic:ClearAbilities()

end
function PetBattlePokemonMusic:FILLSOUNDLIST ()
	str =""
	for key, val in pairs(PetBattlePokemonMusic.db.global.SoundLibrary) do
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
	BattlePetAbilitySoundSettings.args = {
														BPAbilitySounds ={
																			type = "toggle",
																			name = "Enabled",
																			get = function () return PetBattlePokemonMusic.db.global.BPAbilitySoundsOn end,
																			set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySoundsOn = val end,
																			order = 1
														},
														descbox =		{
																			type = "description",
																			name = "Spell: ",
																			order = 4,
																			image = "INTERFACE\BUTTONS\UI-EmptySlot.blp"
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
																					--print(a2)
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
																			func = function() PetBattlePokemonMusic:AddAbility(idtemp) idtemp = ""  end
														
														
																		}
													}
										
	for key, val in pairs (PetBattlePokemonMusic.db.global.BPAbilitySounds) do
		PetBattlePokemonMusic:AddAbilityUI(key)
	end
end

				--self.db.global.Wild.CustomTrack		
-- ================================================================================================================================================================================================================================================ --
--					Database Defaults
-- ================================================================================================================================================================================================================================================ --
-- Wild is a table that holds data for battles with wild pets.
-- Trainer is a table that holds data for battles with other trainers or tamers (either a player or an NPC)
-- SoundLibrary holds all of the sound file addresses and their durations.
-- SoundEffects is a table that indexs sound files by the spell ID that plays them.
local defaults = {
					global={	
									StartSoundOn = true,
									VictorySoundOn = true,
									Wild = {
												Track		= 3,
												On			= true,
												Always		= true,
												Custom		= false,
												CustomTrack = 1,
												Volume = {Music = 0.5, Master = 0.5}
											},
								Trainer =	{
												Track		= 2,
												On			= true,
												Always		= true,
												Custom		= false,
												CustomTrack = 1,
												Volume = {Music = 0.5, Master = 0.5}
											},
								PlayLists = {},
								SoundLibrary	= {},	-- {FileName, Length}
								CustomTracks	= {},
								TrackNames		= {},
								BPAbilitySoundsOn = true,
								BPAbilitySounds = {},
								RegisteredMods = {},
								SoundEffects	=	{
														HealingSound = {Value =3, Enabled = true}
													} --PetBattlePokemonMusic.db.global.SoundEffects.HealingSound
				
			}
}
--db.global.SoundLibrary[Sound Name].FileName
--Built in sound files.
--CustomTracks   SoundLibrary   SoundEffects   BPAbilitySounds
----------------------------------Red, Blue, Yellow Sound Files----------------------------------
defaults.global.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle Start"] = {	
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild Start.ogg",
	Length = 2.8}
																					
defaults.global.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle"] = {		
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Wild.ogg",
	Length = 78.5}		
																					
defaults.global.SoundLibrary["Red, Blue, & Yellow Wild Pokemon Battle Victory"] = {
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\Poke RBY Victory Wild.ogg",
	Length = 8}

defaults.global.SoundLibrary["Red, Blue, & Yellow Trainer Start"] = {				
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Trainer Start.ogg",
	Length = 3}

defaults.global.SoundLibrary["Red, Blue, & Yellow Trainer Battle"] = {				
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Trainer.ogg",
	Length = 95.5}

defaults.global.SoundLibrary["Red, Blue, & Yellow Trainer Victory"] = {			
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RBY\\RBY Trainer Victory.ogg",
	Length = 7}
----------------------------------Gold and Silver Sound Files----------------------------------
defaults.global.SoundLibrary["Gold & Silver Wild Pokemon Battle Start"] = {	
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild Start.ogg",
	Length = 2.65}
																				
defaults.global.SoundLibrary["Gold & Silver Wild Pokemon Battle"] = {			
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Wild.ogg",
	Length = 78}	
																				
defaults.global.SoundLibrary["Gold & Silver Wild Pokemon Battle Victory"] = {	
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Victory Wild.ogg",
	Length = 8}
																				
defaults.global.SoundLibrary["Gold & Silver Trainer Battle Start"] = {			
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Trainer Start.ogg",
	Length = 2.75}																							
																						
defaults.global.SoundLibrary["Gold & Silver Trainer Battle"] = {				
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Trainer.ogg",
	Length = 210}																						

defaults.global.SoundLibrary["Gold & Silver Trainer Battle Victory"] = {		
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\GS\\GS Trainer Victory.ogg",																			
	Length = 7.0}																				
																				
----------------------------------Ruby, Saphire, Emerald Sound Files----------------------------------
																				
defaults.global.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle Start"] = {		
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Start.ogg",																						
	Length = 2.685}
																						
defaults.global.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle"] = {			
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild.ogg",																					
	Length = 78.5}	
																							
defaults.global.SoundLibrary["Ruby, Saphire, & Emerald Wild Pokemon Battle Victory"] = {	
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Wild Victory.ogg",
	Length = 8}
																																											
defaults.global.SoundLibrary["Ruby, Saphire, & Emerald Trainer Start"] = {					
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Trainer Start.ogg",																						
	Length = 2.685}
																							
defaults.global.SoundLibrary["Ruby, Saphire, & Emerald Trainer Battle"] = {				
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Trainer.ogg",																						
	Length = 168.5}	
																							
defaults.global.SoundLibrary["Ruby, Saphire, & Emerald Trainer Victory"] = {				
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\RSE\\RSE Trainer Victory.ogg",																						
	Length = 7.5}																						
----------------------------------FireRed and LeafGreen Sound Files----------------------------------
defaults.global.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle Start"] = {		
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Start.ogg",
	Length = 2.485}
					
defaults.global.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle"] = {			
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild.ogg",
	Length = 82.5}																							
								
defaults.global.SoundLibrary["FireRed & LifeGreen Wild Pokemon Battle Victory"] = {	
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Wild Victory.ogg",
	Length = 8}
				
defaults.global.SoundLibrary["FireRed & LifeGreen Trainer Battle Start"] = {			
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Trainer Start.ogg",
	Length = 3.005}
																					
defaults.global.SoundLibrary["FireRed & LifeGreen Trainer Battle"] = {					
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Trainer.ogg",
	Length = 201.25}	

defaults.global.SoundLibrary["FireRed & LifeGreen Trainer Battle Victory"] = {			
	FileName = "Interface\\AddOns\\PetBattlePokemonMusic\\Music\\FR LG\\FR LG Trainer Victory.ogg",
	Length = 8.3}																				
----------------------------------------------------------------------------------------------------------------------------------------
	--PetBattlePokemonMusic.db.global.BPAbilitySounds[key]																		
function PetBattlePokemonMusic:SetUpSL()
	for key,val in pairs (PetBattlePokemonMusic.db.global.SoundLibrary) do
		PetBattlePokemonMusic:AddSoundToConfig(key)
	end
end
function PetBattlePokemonMusic:FillSoundListUI()
	SoundListUI = {}
	SoundListUIKeys = {}
	for k, v in pairs (PetBattlePokemonMusic.db.global.SoundLibrary) do
		tinsert(SoundListUI,k)
		SoundListUIKeys[k] = #SoundListUI
	end
	for k, v in pairs (PetBattlePokemonMusic.db.global.BPAbilitySounds) do
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

local PBPMMods = {
		type = "group",
		name = "Mods",
		args = {}
	
		}
function PetBattlePokemonMusic:OnInitialize()
	---------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------- Database and Configuration setup  --------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------
	self.db = LibStub("AceDB-3.0"):New("PBPM", defaults)
	--PetBattlePokemonMusic.db.global.BPAbilitySounds = {}	

	PetBattlePokemonMusic:createLocalizedPatterns()
	--CustomTracks   SoundLibrary   SoundEffects   BPAbilitySounds
	if self.db.profile.CustomTracks ~= nil then
		for k,y in pairs (self.db.profile.CustomTracks) do
			self.db.global.CustomTracks[k] = y;
		end
		self.db.profile.CustomTracks = nil
	end
	if self.db.profile.SoundLibrary ~= nil then
		for k,y in pairs (self.db.profile.SoundLibrary) do
			self.db.global.SoundLibrary[k] = y;
		end
		self.db.profile.SoundLibrary = nil
	end
	if self.db.profile.SoundEffects ~= nil then
		for k,y in pairs (self.db.profile.SoundEffects) do
			self.db.global.SoundEffects[k] = y;
		end
		self.db.profile.SoundEffects = nil
	end
	if self.db.profile.BPAbilitySounds ~= nil then
		for k,y in pairs (self.db.profile.BPAbilitySounds) do
			self.db.global.BPAbilitySounds[k] = y;
		end
		self.db.profile.BPAbilitySounds = nil
	end
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
	registry:RegisterOptionsTable("Mods",PBPMMods)
	

	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionFrames = {
							main		= dialog:AddToBlizOptions("PetBattlePokemonMusic Main", "Pet Battle Pokemon Mod"),
							Wild		= dialog:AddToBlizOptions("Pet Battle Music", "Pet Battle Music", "Pet Battle Pokemon Mod"),
							OtherS		=  dialog:AddToBlizOptions("Other Sounds", "Other Sounds", "Pet Battle Pokemon Mod"),
							Library		= dialog:AddToBlizOptions("Sound Library", "Sound Library", "Pet Battle Pokemon Mod"),
							CreateCust	= dialog:AddToBlizOptions("Create Custom Track", "Create Custom Track", "Pet Battle Pokemon Mod"),
							Custs		= dialog:AddToBlizOptions("Custom Tracks", "Custom Tracks", "Pet Battle Pokemon Mod"),
							BPS			= dialog:AddToBlizOptions("Battle Pet Sounds", "Battle Pet Sounds", "Pet Battle Pokemon Mod"),
							mods		= dialog:AddToBlizOptions("Mods", "Mods", "Pet Battle Pokemon Mod")
	}
	---------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------- Register Events ----------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------
	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	self:RegisterEvent("PET_BATTLE_OVER")
	self:RegisterEvent("PET_BATTLE_FINAL_ROUND")
	self:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
	self:RegisterEvent("PET_BATTLE_PET_ROUND_RESULTS")
	self:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
	self:RegisterEvent("CHAT_MSG_PET_BATTLE_INFO")




	---------------------------------------------------------------------------------------------------------------------------------------------
	--  Set up Functions.
	PetBattlePokemonMusic:SetUpMods()
	PetBattlePokemonMusic:SetUpSL()
	PetBattlePokemonMusic:FillCustomWild()
	PetBattlePokemonMusic:FillCustomTrainer()
	PetBattlePokemonMusic:SetUpCustomCreator()
	PetBattlePokemonMusic:FillCustomLib()
	
end



function PetBattlePokemonMusic:OnEnable()

end

function PetBattlePokemonMusic:OnDisable()
    -- Called when the addon is disabled
end

function PetBattlePokemonMusic:IsStartEnabled()
	return PetBattlePokemonMusic.db.global.StartSoundOn;
end
function PetBattlePokemonMusic:IsVictoryEnabled()
	return PetBattlePokemonMusic.db.global.VictorySoundOn;
end

function PetBattlePokemonMusic:Reset()
	PetBattlePokemonMusic.db.global.CustomTracks = {}
	PetBattlePokemonMusic.db.global.RegisteredMods = {}
end
---
--
--@param event The name of the event.
--@param
function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_INFO(event, ...)

end
function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_COMBAT_LOG(...)
	demo = {...}

	str = ""
	--Basic Damage Dealing  INTERFACE\\.*\\.*.%BLP:14|
	--print(strfind((demo[2]),"INTERFACE\\.*\\.*.%BLP:14|"))
	w,ty = strfind((demo[2]),"HbattlePetAbil:(%d*):%d*:%d*:%d*|h%[.*%]|h|r")
	if ty ~= nil then
		rwr , qwe= strfind((strsub((demo[2]),1,ty)),"INTERFACE\\.*\\.*.%BLP:14.*")
	end

	--Test for localization

--	local damagePattern = ""
--local missPattern = ""
--local dodgePattern =""
--local healedPattern = ""
--local auraAppliedPattern = ""
--local auraFadesPattern = ""
--local weatherChangePattern = ""
--local weatherFadePattern = ""
	if strfind(tostring(demo[2]),auraAppliedPattern)~= nil then
	--	print("Matches applied")
	end
	if strfind(tostring(demo[2]),damagePattern)~= nil then
		--print("Match damage "..damagePattern)
		liner = ""
		if strfind(tostring(demo[2]),damagePattern)~= nil then
			q1,q2,q3,q4,q5,q6,q7,q8,q9 =strfind(tostring(demo[2]),damagePattern)
			tabs = {strfind(tostring(demo[2]),damagePattern)}
			-- tabs = unpack(strfind(tostring(demo[2]),damagePattern))
			--print(#tabs)
			if q1~=nil then
				liner = liner .." 1: "..q1
				--print("1 "..q1)
			end
			if q2~=nil then
				liner = liner .." 2: "..q2
			end
			if q3~=nil then
				liner = liner .." 3: "..q3
			end
			if q4~=nil then
				liner = liner .." 4: "..q4
			end
			if q5~=nil then
				liner = liner .." 5: "..q5
			end
			if q6~=nil then
				liner = liner .." 6: "..q6
			end
			if q7~=nil then
				liner = liner .." 7: "..q7
			end
			if q8~=nil then
				liner = liner .." 8: "..q8
			end
			if q9~=nil then
				liner = liner .." 9: "..q9
			end
		end
		--print(liner)
	end
	if strfind(tostring(demo[2]),missPattern)~= nil then
		--print("Match miss")
		liner = ""
		if strfind(tostring(demo[2]),missPattern)~= nil then
			q1,q2,q3,q4,q5,q6,q7,q8,q9 =strfind(tostring(demo[2]),missPattern)
			if q1~=nil then
				liner = liner .." 1: "..q1
				--print("1 "..q1)
			end
			if q2~=nil then
				liner = liner .." 2: "..q2
			end
			if q3~=nil then
				liner = liner .." 3: "..q3
			end
			if q4~=nil then
				liner = liner .." 4: "..q4
			end
			if q5~=nil then
				liner = liner .." 5: "..q5
			end
			if q6~=nil then
				liner = liner .." 6: "..q6
			end
			if q7~=nil then
				liner = liner .." 7: "..q7
			end
			if q8~=nil then
				liner = liner .." 8: "..q8
			end
			if q9~=nil then
				liner = liner .." 9: "..q9
			end
		end
	--	print(liner)
	end
	if strfind(tostring(demo[2]),dodgePattern)~= nil then
		--print("Match dodge")
		liner = ""
		if strfind(tostring(demo[2]),dodgePattern)~= nil then
			q1,q2,q3,q4,q5,q6,q7,q8,q9 =strfind(tostring(demo[2]),dodgePattern)
			if q1~=nil then
				liner = liner .." 1: "..q1
				--print("1 "..q1)
			end
			if q2~=nil then
				liner = liner .." 2: "..q2
			end
			if q3~=nil then
				liner = liner .." 3: "..q3
			end
			if q4~=nil then
				liner = liner .." 4: "..q4
			end
			if q5~=nil then
				liner = liner .." 5: "..q5
			end
			if q6~=nil then
				liner = liner .." 6: "..q6
			end
			if q7~=nil then
				liner = liner .." 7: "..q7
			end
			if q8~=nil then
				liner = liner .." 8: "..q8
			end
			if q9~=nil then
				liner = liner .." 9: "..q9
			end
		end
		--print(liner)
	end
	if strfind(tostring(demo[2]),healedPattern)~= nil then

		liner = ""
		if strfind(tostring(demo[2]),healedPattern)~= nil then
			q1,q2,q3,q4,q5,q6,q7,q8,q9 =strfind(tostring(demo[2]),healedPattern)
			if q1~=nil then
				liner = liner .." 1: "..q1
				--print("1 "..q1)
			end
			if q2~=nil then
				liner = liner .." 2: "..q2
			end
			if q3~=nil then
				liner = liner .." 3: "..q3
			end
			if q4~=nil then
				liner = liner .." 4: "..q4
			end
			if q5~=nil then
				liner = liner .." 5: "..q5
			end
			if q6~=nil then
				liner = liner .." 6: "..q6
			end
			if q7~=nil then
				liner = liner .." 7: "..q7
			end
			if q8~=nil then
				liner = liner .." 8: "..q8
			end
			if q9~=nil then
				liner = liner .." 9: "..q9
			end
		end
		--print(liner)
	end
	remake = PET_BATTLE_COMBAT_LOG_DAMAGE;
	remake = string.gsub(remake, " %%s ", " (%%a*) ")
	remake = string.gsub(remake, "%%s", "(.*)")
	remake = string.gsub(remake, "%%d", "%(%%d%*%)")
	remake = string.gsub(remake, "%)%.", "%)%%.")
--	print("Remake: "..remake);
	
	-- ================================================================================================================================================================================= --
	--   Damage
	-- ================================================================================================================================================================================= --
	if strfind(tostring(demo[2]),BPAPatternDealtYour) ~= nil then
		e1, e2, goal = strfind(demo[2],BPAPatternDealtYour)
		sd, rqw, qrr = strfind(goal,BPApattern)
			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
				end
			end
	end
	-- Damage to enemy.
	if strfind(demo[2],BPAPatternDealtEnemy) ~= nil then
		e1, e2, goal = strfind(demo[2],BPAPatternDealtEnemy)
		e1, e2, goal = strfind(demo[2],BPAPatternDealtEnemy)
		sd, rqw, qrr = strfind(goal,BPApattern)
			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
				end
			end
	end
	-- ================================================================================================================================================================================= --
	--MISSED
	-- ================================================================================================================================================================================= --
	if strfind(demo[2],BPAPatternYourMiss  ) ~= nil then
		e1, e2, goal,g2 = strfind(demo[2],BPAPatternYourMiss )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternYourMiss )
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)
			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Missed.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Missed.File].FileName,"Master")
				end
			end
	end
	if strfind(demo[2],BPAPatternEnemyMiss  ) ~= nil then
		e1, e2, goal,g2 = strfind(demo[2],BPAPatternEnemyMiss )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternEnemyMiss )
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)
			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Missed.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Missed.File].FileName,"Master")
				end
			end
	end	
	-- ================================================================================================================================================================================= --
	--HEALED
	-- ================================================================================================================================================================================= --
	if strfind(tostring(demo[2]),BPAPatternHealYour) ~= nil then
		e1, e2, goal = strfind(demo[2],BPAPatternHealYour)
		sd, rqw, qrr = strfind(goal,BPApattern)

			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
				PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
				end
			end
	end
	if strfind(demo[2],BPAPatternHealEnemy) ~= nil then

		e1, e2, goal = strfind(demo[2],BPAPatternHealEnemy)
		e1, e2, goal = strfind(demo[2],BPAPatternHealEnemy)
		sd, rqw, qrr = strfind(goal,BPApattern)

			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
				end
			end
	end
	-- ================================================================================================================================================================================= --
	--Dodge
	-- ================================================================================================================================================================================= --
	if strfind(tostring(demo[2]),BPAPatternYourDodged) ~= nil then
		e1, e2, goal = strfind(demo[2],BPAPatternYourDodged)
		sd, rqw, qrr = strfind(goal,BPApattern)

			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
				end
			end
	end
	if strfind(demo[2],BPAPatternEnemyDodged) ~= nil then
		e1, e2, goal = strfind(demo[2],BPAPatternEnemyDodged)
		e1, e2, goal = strfind(demo[2],BPAPatternEnemyDodged)
		sd, rqw, qrr = strfind(goal,BPApattern)
	
			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
				end
			end
	end
	-- ================================================================================================================================================================================= --
	--- APPLIED
	-- ================================================================================================================================================================================= --
	if strfind(demo[2],BPAPatternYourApp ) ~= nil then
		e1, e2, goal,g2 = strfind(demo[2],BPAPatternYourApp)
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternYourApp)
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)
			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Applied.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Applied.File].FileName,"Master")
				end
			end
		
	end
	if strfind(demo[2],BPAPatternEnemyApp  ) ~= nil then

		e1, e2, goal,g2 = strfind(demo[2],BPAPatternEnemyApp )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternEnemyApp )
		sd, rqw, qrr, a2, a3 = strfind(g2,BPApattern)

			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Applied.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Applied.File].FileName,"Master")
				end
			end
	end
	-- ================================================================================================================================================================================= --
	--FADE
	-- ================================================================================================================================================================================= --
	-- Fades from enemy.
	if strfind(demo[2],BPAPatternEnemyFade ) ~= nil then
		e1, e2, goal,g2 = strfind(demo[2],BPAPatternEnemyFade)
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternEnemyFade)
		sd, rqw, qrr, a2, a3 = strfind(goal,BPApattern)

			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Faded.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Faded.File].FileName,"Master")
				end
			end
	end
	--fade
	if strfind(demo[2],BPAPatternYourFade  ) ~= nil then

		e1, e2, goal,g2 = strfind(demo[2],BPAPatternYourFade )
		e1, e2, goal, g2 = strfind(demo[2],BPAPatternYourFade )
		sd, rqw, qrr, a2, a3 = strfind(goal,BPApattern)

			if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
				if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Faded.File]~= nil then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Faded.File].FileName,"Master")
				end
			end
	end
	iorww = strfind(demo[2],"HbattlePetAbil:")
	if iorww ~= nil then
		str = strsub(demo[2],iorww)
		werer = strfind(strsub(str,16),":")
		if werer ~= nil then
		--	print(strsub(strsub(str,16),1,werer-1))
		end
	end
	--"|cff4e96f7|HbattlePetAbil:abilityID:maxHealth:power:speed|h[text]|h|r"
	--ICON battlePetAbil " dealt " # " damage to enemy " ICON2 EnemyName
end

---This function handles the event when a pet battle starts.
--@param event Event Name
function PetBattlePokemonMusic:PET_BATTLE_OPENING_START(event,...)
	--TODO adjust volumes of music and master.
	OldMusicVolume = GetCVar("Sound_MusicVolume")
	OldMasterVolume = GetCVar("Sound_MasterVolume")

	if C_PetBattles.IsWildBattle() then

		if PetBattlePokemonMusic.db.global.Wild.Custom then
			if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.CustomTrack] ~= nil then
				SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music )
				SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master )
				if PetBattlePokemonMusic:IsStartEnabled() then
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.CustomTrack].StartSoundKey].FileName, "Master")
					battleTimer =	self:ScheduleTimer("PlayBattleTrack",PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.CustomTrack].StartSoundKey].Length)
				else
					PetBattlePokemonMusic:PlayBattleTrack()
				end
			end
		else
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music )
			SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master )
			if PetBattlePokemonMusic:IsStartEnabled() then

				bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].FileName, "Master")
				battleTimer = self:ScheduleTimer("PlayBattleTrack",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].Length)
			else
				PetBattlePokemonMusic:PlayBattleTrack()
			end
		end
	else
		SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music )
		SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
		if PetBattlePokemonMusic:IsStartEnabled() then
			bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].FileName, "Master")
			battleTimer =	self:ScheduleTimer("PlayBattleTrack",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].Length)
		else
			PetBattlePokemonMusic:PlayBattleTrack()
		end
	end
end
--@param event The event name.
function PetBattlePokemonMusic:PET_BATTLE_OVER(event,...)
	demo = {...}
end
---
--
function PetBattlePokemonMusic:PET_BATTLE_CLOSE(...)

	StopMusic();
	SetCVar("Sound_EnableMusic", OldMusicValue )
	SetCVar("Sound_MusicVolume", OldMusicVolume )
	SetCVar("Sound_MasterVolume", OldMasterVolume )
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
	
	if outcomenumber == 1 and PetBattlePokemonMusic:IsVictoryEnabled() then
	
		if C_PetBattles.IsWildBattle() then
			if PetBattlePokemonMusic.db.global.Wild.Custom then
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.CustomTrack] ~= nil then
					if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.CustomTrack].VictoryKey] ~= nil then
						PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.CustomTrack].VictoryKey].FileName, "Master")					
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.CustomTrack].VictoryKey].Length)
					else
						SetCVar("Sound_MasterVolume", OldMasterVolume )
					end
				end
			else
				PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].VictoryKey].FileName, "Master")
				self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].VictoryKey].Length)
			end

		else
			if PetBattlePokemonMusic.db.global.Trainer.Custom then
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.CustomTrack] ~= nil then
					if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.CustomTrack].VictoryKey] ~= nil then
						PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.CustomTrack].VictoryKey].FileName, "Master")					
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.CustomTrack].VictoryKey].Length)
					else
						SetCVar("Sound_MasterVolume", OldMasterVolume )
					end
				end
			else
				PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].VictoryKey].FileName, "Master")
				self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].VictoryKey].Length)
			end
			--	SetCVar("Sound_MasterVolume", OldMasterVolume )
			
		end
	end
end
function PetBattlePokemonMusic:VictoryExpire(info,val)
	SetCVar("Sound_MasterVolume", OldMasterVolume )
end
function PetBattlePokemonMusic:UNIT_SPELLCAST_SUCCEEDED(eveName, unitID, spell, rank, lineID, spellID)
	

end

-- Music Functions

function PetBattlePokemonMusic:SwitchTrack()
--TODO
end

function PetBattlePokemonMusic:PlayBattleTrack()
	OldMusicValue = GetCVar("Sound_EnableMusic")

	if C_PetBattles.IsWildBattle() then
		if PetBattlePokemonMusic.db.global.Wild.Always then
			SetCVar("Sound_EnableMusic", 1 )
		end
		if PetBattlePokemonMusic.db.global.Wild.On then
			if PetBattlePokemonMusic.db.global.Wild.Custom == false then
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName)
			else
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.CustomTrack].MusicKey].FileName)
			end
		end
	else
		if PetBattlePokemonMusic.db.global.Trainer.Always then
			SetCVar("Sound_EnableMusic", 1 )
		end
		if PetBattlePokemonMusic.db.global.Trainer.On then
			if PetBattlePokemonMusic.db.global.Trainer.Custom == false then
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
			else
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.CustomTrack].MusicKey].FileName)
			end
		end
	end
end
--------------
--Mod functions
function PetBattlePokemonMusic:AddModToUI (modname, tes)
	size = #PBPMMods.args
	PBPMMods.args[modname] = {
								type = "group",
								name = modname,
								args = {
									activa = {
										type = "execute",
										name = "Overwrite Effects",
										confirmText = "Doing this will overwrite all the sound effects for pet abilities you already have.  Do you want to continue?",
										confirm =  true,
										func = function ()
											PetBattlePokemonMusic.db.global.BPAbilitySounds = {}
											for m, g in pairs (PetBattlePokemonMusic.db.global.RegisteredMods[modname].Effects) do
											PetBattlePokemonMusic.db.global.BPAbilitySounds[m] = g
										end
										PetBattlePokemonMusic:FillSoundListUI()
											PetBattlePokemonMusic:SetUpAbilities()
										end,
										order = 2
									},
									activa2 = {
										type = "execute",
										name = "Overwrite-Merge Effects",
										confirmText = "Doing this will overwrite all sound effects for pet abilities you already have that are done in this mod.  Do you want to continue?",
										confirm =  true,
										func = function () 
										for m, g in pairs (PetBattlePokemonMusic.db.global.RegisteredMods[modname].Effects) do
											PetBattlePokemonMusic.db.global.BPAbilitySounds[m] = g
										end
										PetBattlePokemonMusic:FillSoundListUI()
										PetBattlePokemonMusic:SetUpAbilities()
										end,
										order = 2
									},activa3 = {
										type = "execute",
										name = "Append",
										confirmText = "Doing this will add sounds to any abilities that are not already in the list.  Do you want to continue?",
										confirm =  true,
										func = function () 
										for m, g in pairs (PetBattlePokemonMusic.db.global.RegisteredMods[modname].Effects) do
											if PetBattlePokemonMusic.db.global.BPAbilitySounds[m] == nil then
												PetBattlePokemonMusic.db.global.BPAbilitySounds[m] = g
											end
										end
										PetBattlePokemonMusic:FillSoundListUI()
										PetBattlePokemonMusic:SetUpAbilities()
										end,
										order = 2
									},
									removeMod = {
										type = "execute",
										name = "Remove Mod",
										func = function () end,
										order =3
									},
									moddesc = {
										type = "description",
										name = tes,
										order = 1
	},
									AddNewSoundHeader = {
															type = "header",
															name = "Mod Ability Sounds",
															order = 4,
															desc = "The sounds added by this mod."
														}
									}
	}
	for k, v in pairs (PetBattlePokemonMusic.db.global.RegisteredMods[modname].Effects) do
		demo,a1,a2,a3,a4,a5,a6 = C_PetBattles.GetAbilityInfoByID(tonumber(k))
		dams = "|cffffd800<|r|cffffd200Damage: |r|cffffd800>|r"
		--|cffffd800|r|cffffd200%s|r|cffffd800|r

		soune = ": ".."|cffffd800|r|cffffd200Damage: |r|cffffd800|r"..v.Damage.File..": ".."|cffffd800|r|cffffd200Healing: |r|cffffd800|r"..v.Healing.File..": ".."|cffffd800|r|cffffd200Applied: |r|cffffd800|r"..v.Applied.File..": ".." |cffffd800|r|cffffd200Dodged: |r|cffffd800|r"..v.Dodged.File..": ".."|cffffd800|r|cffffd200Missed: |r|cffffd800|r"..v.Missed.File..": ".."|cffffd800|r|cffffd200Faded: |r|cffffd800|r"..v.Faded.File..": ".."|cffffd800|r|cffffd200Blocked: |r|cffffd800|r"..v.Blocked.File
--|cffffd800
		PBPMMods.args[modname].args[tostring(k)] = {type = "description", name = a1.."  "..soune,order = 5,width		=	"full", image = a2}
	end
--PetBattlePokemonMusic.db.global.RegisteredMods[modname].Effects
	--demo,a1,a2,a3,a4,a5,a6 = C_PetBattles.GetAbilityInfoByID(tonumber(id))
end
--BPAbilitySounds
--PetBattlePokemonMusic.db.global.RegisteredMods[modname].Effects[k]
function PetBattlePokemonMusic:ImportSound(soundName, soundFile, soundLength)
	
end
function PetBattlePokemonMusic:SetUpMods()
	for k,v in pairs (PetBattlePokemonMusic.db.global.RegisteredMods) do
		PetBattlePokemonMusic:AddModToUI (k,PetBattlePokemonMusic.db.global.RegisteredMods[k].Description)
	end
end

	--	PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(id)] = {	Damage = {File = "", On = true},
		--																	Healing ={File = "", On = true},
		--																	Applied ={File = "", On = true},
		--																	Dodged = {File = "", On = true},
		--																	Missed = {File = "", On = true},
		--																	Faded = {File = "", On = true},
			--																Blocked ={File = "", On = true}
			--																}
	
function PetBattlePokemonMusic:RegisterPremade(modname, desc, version, soundTable, trackTable, abilityTable)


	--PetBattlePokemonMusic.db.global.RegisteredMods
	if PetBattlePokemonMusic.db.global.RegisteredMods[modname] == nil then
		-- new mod
			PetBattlePokemonMusic.db.global.RegisteredMods[modname] = {Version = version, Description = desc, Effects = {}}
	else
		if PetBattlePokemonMusic.db.global.RegisteredMods[modname].Version < version then
		
		else
			return false
		end

	end

	
	--unusableSoundNames
	


	nameConversionSoundFiles = {}
	nameConversionTracks = {}

	--Adding sound file data.
	for k, v in pairs (soundTable) do
		counter = 1;
		tempName = k
		sdbpassed = false
		reservedpassed = false

		while sdbpassed == false or reservedpassed == false do
			if PetBattlePokemonMusic.db.global.SoundLibrary[tempName] == nil then
				sdbpassed = true

			else
				if PetBattlePokemonMusic.db.global.SoundLibrary[tempName].FileName == v.FileName then
					nameConversionSoundFiles[k] = tempName
				--	print(k.." was already in the database under the name "..tempName)
					sdbpassed = true
					reservedpassed = true
				else
					sdbpassed = false
				end

			end
			if unusableSoundNames[tempName] == nil then

				reservedpassed = true
			else
				reservedpassed = false

			end

			if sdbpassed and reservedpassed then
				--print(k.." cleared both sound database and reserved words as "..tempName)
				if k ~= tempName then
					nameConversionSoundFiles[k] = tempName
				end
			else
				tempName = k..counter
				counter = counter+1
			end

		end
		PetBattlePokemonMusic.db.global.SoundLibrary[tempName] = v
		PetBattlePokemonMusic:AddSoundToConfig(tempName)
		
	end
--TODO track check
	for k, v in pairs (trackTable) do
		startKey = v.StartSoundKey
		musicKey = v.MusicKey
		victorykey = v.VictoryKey

		if nameConversionSoundFiles[startKey] then
			startKey=nameConversionSoundFiles[startKey]
		end
		if nameConversionSoundFiles[musicKey] then
			musicKey=nameConversionSoundFiles[musicKey]
		end
		if nameConversionSoundFiles[victorykey] then
			victorykey=nameConversionSoundFiles[victorykey]
		end


	
		counter = 1;
		tempName = k
		sdbpassed = true
		reservedpassed = true
		while sdbpassed or reservedpassed do
			if PetBattlePokemonMusic.db.global.CustomTracks[tempName] == nil then
				sdbpassed = false
			else
				if PetBattlePokemonMusic.db.global.CustomTracks[tempName].StartSoundKey == startKey and PetBattlePokemonMusic.db.global.CustomTracks[tempName].MusicKey == musicKey   and PetBattlePokemonMusic.db.global.CustomTracks[tempName].VictoryKey == victorykey  then
					sdbpassed = false
				else
					sdbpassed = true
				end
			end
			if unusableSoundNames[tempName] == nil then
				reservedpassed = false
			else
				reservedpassed = true
			end

			if sdbpassed or reservedpassed then
				tempName = k..counter
				counter = counter +1
			end
				
		end
		obg = {}
		obg.StartSoundKey = startKey
		obg.MusicKey =musicKey
		obg.VictoryKey = victorykey
		PetBattlePokemonMusic.db.global.CustomTracks[tempName] = obg
		PetBattlePokemonMusic:AddCustomTrackToLibrary (tempName)

		
		
		--PetBattlePokemonMusic.db.global.CustomTracks
--StartSoundKey, MusicKey, and VictoryKey
		
		--PetBattlePokemonMusic.db.global.SoundLibrary[tempName] = v
			--PokemonBattleMusicEffects[1] =	{	Name = "Red, Blue, & Yellow Wild Pokemon Battle", 
				--						StartSoundKey = "Red, Blue, & Yellow Wild Pokemon Battle Start",
					--					MusicKey = "Red, Blue, & Yellow Wild Pokemon Battle",
					--					VictoryKey = "Red, Blue, & Yellow Wild Pokemon Battle Victory"

		--PetBattlePokemonMusic:AddCustomTrackToLibrary (key)
	end
		PetBattlePokemonMusic:FillCustomWild()
	PetBattlePokemonMusic:FillCustomTrainer()
	for k, v in pairs (abilityTable) do
		copyability = v


		--nameConversionSoundFiles
		if nameConversionSoundFiles[copyability.Damage.File] ~= nil then
			copyability.Damage.File = nameConversionSoundFiles[copyability.Damage.File]
		end

		if nameConversionSoundFiles[copyability.Healing.File] ~= nil then
			copyability.Healing.File = nameConversionSoundFiles[copyability.Healing.File]
		end

		if nameConversionSoundFiles[copyability.Applied.File] ~= nil then
			copyability.Applied.File = nameConversionSoundFiles[copyability.Applied.File]
		end

		if nameConversionSoundFiles[copyability.Dodged.File] ~= nil then
			copyability.Dodged.File = nameConversionSoundFiles[copyability.Dodged.File]
		end

		if nameConversionSoundFiles[copyability.Missed.File] ~= nil then
			copyability.Missed.File = nameConversionSoundFiles[copyability.Missed.File]
		end

		if nameConversionSoundFiles[copyability.Faded.File] ~= nil then
			copyability.Faded.File = nameConversionSoundFiles[copyability.Faded.File]
		end

		if nameConversionSoundFiles[copyability.Blocked.File] ~= nil then
			copyability.Blocked.File = nameConversionSoundFiles[copyability.Blocked.File]
		end
		PetBattlePokemonMusic.db.global.RegisteredMods[modname].Effects[k] = copyability
	end
	PetBattlePokemonMusic:AddModToUI (modname,desc)
	--
end

	--	PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(id)] = {	Damage = {File = "", On = true},
		--																	Healing ={File = "", On = true},
		--																	Applied ={File = "", On = true},
		--																	Dodged = {File = "", On = true},
		--																	Missed = {File = "", On = true},
		--																	Faded = {File = "", On = true},
			--																Blocked ={File = "", On = true}
			--																}
function PetBattlePokemonMusic:ResetToDefaults()

end