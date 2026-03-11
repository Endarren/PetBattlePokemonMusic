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
--	Version 3.0
-- ================================================================================================================================================================================================================================================ --
--  Playlist function added
--  



PetBattlePokemonMusic = LibStub("AceAddon-3.0"):NewAddon("PetBattlePokemonMusic", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0");
local L						= LibStub("AceLocale-3.0"):GetLocale("PetBattlePokemonMusic")
local BPApattern = "|cff4e96f7|HbattlePetAbil:(%d*):%d*:%d*:%d*|h%[.*%]|h|r"
local iconpattern = "INTERFACE\\ICON\\.*%.BLP:%d*"
local tamerLib = LibStub("LibTamerID-1.0")

-- ====================================================================
-- Variables for localized pattern matching.

local damagePattern = ""
local missPattern = ""
local dodgePattern =""
local healedPattern = ""
local auraAppliedPattern = ""
local auraFadesPattern = ""
local weatherChangePattern = ""
local weatherFadePattern = ""

-- ====================================================================================================
-- Tamer Database
local pveDB = {}
pveDB.Tamers = {}
pveDB.Elites = {}

-- ================================================================================================================================================================================================ --
--													NPC Tamers
-- ================================================================================================================================================================================================ --

-- - ~Eastern Kingdoms Tamers~2

--Eastern Kingdoms Tamers

pveDB.Tamers[L["Julia Stevens"]] = {Pets = {}}
pveDB.Tamers[L["Julia Stevens"]].Pets[L["Fangs"]]						= {Name = L["Fangs"],				Level = 2, Quality = 2, Breed = 3, Type = 8}
pveDB.Tamers[L["Julia Stevens"]].Pets[L["Slithers"]]					= {Name = L["Slithers"],			Level = 2, Quality = 2, Breed = 3, Type = 8}

pveDB.Tamers["Old MacDonald"] = {Pets = {}}
pveDB.Tamers["Old MacDonald"].Pets["Clucks"]					= {Name = "Clucks",				Level = 3, Quality = 2, Breed = 3, Type = 3}
pveDB.Tamers["Old MacDonald"].Pets["Foe Reaper 800"]			= {Name = "Foe Reaper 800",		Level = 3, Quality = 2, Breed = 3, Type = 10}
pveDB.Tamers["Old MacDonald"].Pets["Teensy"]					= {Name = "Teensy",				Level = 3, Quality = 2, Breed = 3, Type = 5}

pveDB.Tamers["Lindsay"] = {Pets = {}}
pveDB.Tamers["Lindsay"].Pets["Dipsy"]							= {Name = "Dipsy",				Level = 5, Quality = 2, Breed = 3, Type = 5}
pveDB.Tamers["Lindsay"].Pets["Flipsy"]							= {Name = "Flipsy",				Level = 5, Quality = 2, Breed = 9, Type = 5}
pveDB.Tamers["Lindsay"].Pets["Flufftail"]						= {Name = "Flufftail",			Level = 5, Quality = 2, Breed = 7, Type = 5}

pveDB.Tamers["Eric Davidson"] = {Pets = {}}
pveDB.Tamers["Eric Davidson"].Pets["Blackfang"]					= {Name = "Blackfang",			Level = 7, Quality = 2, Breed = 8, Type = 8}
pveDB.Tamers["Eric Davidson"].Pets["Darkwidow"]					= {Name = "Darkwidow",			Level = 7, Quality = 2, Breed = 7, Type = 8}
pveDB.Tamers["Eric Davidson"].Pets["Webwinder"]					= {Name = "Webwinder",			Level = 7, Quality = 2, Breed = 9, Type = 8}

pveDB.Tamers["Steven Lisbane"] = {Pets = {}}
pveDB.Tamers["Steven Lisbane"].Pets["Emeralda"]					= {Name = "Emeralda",			Level = 9, Quality = 2, Breed = 6, Type = 6}
pveDB.Tamers["Steven Lisbane"].Pets["Moonstalker"]				= {Name = "Moonstalker",		Level = 9, Quality = 2, Breed = 8, Type = 6}
pveDB.Tamers["Steven Lisbane"].Pets["Nanners"]					= {Name = "Nanners",			Level = 9, Quality = 2, Breed = 8, Type = 6}

pveDB.Tamers["Bill Buckler"] = {Pets = {}}
pveDB.Tamers["Bill Buckler"].Pets["Burgle"]						= {Name = "Burgle",				Level = 11, Quality = 3, Breed = 2, Type = 1}
pveDB.Tamers["Bill Buckler"].Pets["Eyegouger"]					= {Name = "Eyegouger",			Level = 11, Quality = 3, Breed = 8, Type = 3}
pveDB.Tamers["Bill Buckler"].Pets["Young Beaky"]				= {Name = "Young Beaky",		Level = 11, Quality = 3, Breed = 9, Type = 3}

pveDB.Tamers["David Kosse"] = {Pets = {}}
pveDB.Tamers["David Kosse"].Pets["Corpsefeeder"]				= {Name = "Corpsefeeder",		Level = 13, Quality = 3, Breed = 6, Type = 8}
pveDB.Tamers["David Kosse"].Pets["Plop"]						= {Name = "Plop",				Level = 13, Quality = 3, Breed = 9, Type = 6}
pveDB.Tamers["David Kosse"].Pets["Subject 142"]					= {Name = "Subject 142",		Level = 13, Quality = 3, Breed = 5, Type = 5}

pveDB.Tamers["Deiza Plaguehorn"] = {Pets = {}}
pveDB.Tamers["Deiza Plaguehorn"].Pets["Bleakspinner"]			= {Name = "Bleakspinner",		Level = 14, Quality = 3, Breed = 8, Type = 8}
pveDB.Tamers["Deiza Plaguehorn"].Pets["Plaguebringer"]			= {Name = "Plaguebringer",		Level = 14, Quality = 3, Breed = 6, Type = 4}
pveDB.Tamers["Deiza Plaguehorn"].Pets["Carrion"]				= {Name = "Carrion",			Level = 14, Quality = 3, Breed = 3, Type = 8}

pveDB.Tamers["Kortas Darkhammer"] = {Pets = {}}
pveDB.Tamers["Kortas Darkhammer"].Pets["Garnestrasz"]			= {Name = "Garnestrasz",		Level = 15, Quality = 3, Breed = 7, Type = 2}
pveDB.Tamers["Kortas Darkhammer"].Pets["Obsidion"]				= {Name = "Obsidion",			Level = 15, Quality = 3, Breed = 8, Type = 2}
pveDB.Tamers["Kortas Darkhammer"].Pets["Verida"]				= {Name = "Verida",				Level = 15, Quality = 3, Breed = 9, Type = 2}

pveDB.Tamers["Everessa"] = {Pets = {}}
pveDB.Tamers["Everessa"].Pets["Anklor"]							= {Name = "Anklor",				Level = 16, Quality = 3, Breed = 8, Type = 8}
pveDB.Tamers["Everessa"].Pets["Croaker"]						= {Name = "Croaker",			Level = 16, Quality = 3, Breed = 6, Type = 9}
pveDB.Tamers["Everessa"].Pets["Dampwing"]						= {Name = "Dampwing",			Level = 16, Quality = 3, Breed = 9, Type = 3}

pveDB.Tamers["Durin Darkhammer"] = {Pets = {}}
pveDB.Tamers["Durin Darkhammer"].Pets["Comet"]					= {Name = "Comet",				Level = 17, Quality = 3, Breed = 5, Type = 3}
pveDB.Tamers["Durin Darkhammer"].Pets["Ignious"]				= {Name = "Ignious",			Level = 17, Quality = 3, Breed = 7, Type = 5}
pveDB.Tamers["Durin Darkhammer"].Pets["Moltar"]					= {Name = "Moltar",				Level = 17, Quality = 3, Breed = 6, Type = 7}

pveDB.Tamers["Lydia Accoste"] = {Pets = {}}
pveDB.Tamers["Lydia Accoste"].Pets["Bishibosh"]					= {Name = "Bishibosh",			Level = 19, Quality = 3, Breed = 5, Type = 4}
pveDB.Tamers["Lydia Accoste"].Pets["Jack"]						= {Name = "Jack",				Level = 19, Quality = 3, Breed = 8, Type = 7}
pveDB.Tamers["Lydia Accoste"].Pets["Nightstalker"]				= {Name = "Nightstalker",		Level = 19, Quality = 3, Breed = 9, Type = 4}


-- - ~Kalimdor Tamers~2

pveDB.Tamers["Zunta"] = {Pets = {}}
pveDB.Tamers["Zunta"].Pets["Mumtar"]							= {Name = "Mumtar",				Level = 2, Quality = 2, Breed = 3, Type = 5}
pveDB.Tamers["Zunta"].Pets["Spike"]								= {Name = "Spike",				Level = 2, Quality = 2, Breed = 3, Type = 8}

pveDB.Tamers["Dagra the Fierce"] = {Pets = {}}
pveDB.Tamers["Dagra the Fierce"].Pets["Springtail"]				= {Name = "Springtail",			Level = 3, Quality = 2, Breed = 8, Type = 5}
pveDB.Tamers["Dagra the Fierce"].Pets["Longneck"]				= {Name = "Longneck",			Level = 3, Quality = 2, Breed = 3, Type = 8}
pveDB.Tamers["Dagra the Fierce"].Pets["Ripper"]					= {Name = "Ripper",				Level = 3, Quality = 2, Breed = 5, Type = 8}

pveDB.Tamers["Analynn"] = {Pets = {}}
pveDB.Tamers["Analynn"].Pets["Flutterby"]						= {Name = "Flutterby",			Level = 5, Quality = 2, Breed = 5, Type = 3}
pveDB.Tamers["Analynn"].Pets["Mister Pinch"]					= {Name = "Mister Pinch",		Level = 5, Quality = 2, Breed = 6, Type = 9}
pveDB.Tamers["Analynn"].Pets["Oozer"]							= {Name = "Oozer",				Level = 5, Quality = 2, Breed = 8, Type = 5}

pveDB.Tamers["Zonya the Sadist"] = {Pets = {}}
pveDB.Tamers["Zonya the Sadist"].Pets["Acidous"]				= {Name = "Acidous",			Level = 7, Quality = 2, Breed = 9, Type = 8}
pveDB.Tamers["Zonya the Sadist"].Pets["Constrictor"]			= {Name = "Constrictor",		Level = 7, Quality = 2, Breed = 8, Type = 8}
pveDB.Tamers["Zonya the Sadist"].Pets["Odoron"]					= {Name = "Odoron",				Level = 7, Quality = 2, Breed = 3, Type = 5}

pveDB.Tamers["Merda Stronghoof"] = {Pets = {}}
pveDB.Tamers["Merda Stronghoof"].Pets["Ambershell"]				= {Name = "Ambershell",			Level = 9, Quality = 2, Breed = 6, Type = 7}
pveDB.Tamers["Merda Stronghoof"].Pets["Bounder"]				= {Name = "Bounder",			Level = 9, Quality = 2, Breed = 9, Type = 9}
pveDB.Tamers["Merda Stronghoof"].Pets["Rockhide"]				= {Name = "Rockhide",			Level = 9, Quality = 2, Breed = 6, Type = 5}

pveDB.Tamers["Cassandra Kaboom"] = {Pets = {}}
pveDB.Tamers["Cassandra Kaboom"].Pets["Cluckatron"]				= {Name = "Cluckatron",			Level = 11, Quality = 3, Breed = 8, Type = 10}
pveDB.Tamers["Cassandra Kaboom"].Pets["Gizmo"]					= {Name = "Gizmo",				Level = 11, Quality = 3, Breed = 5, Type = 10}
pveDB.Tamers["Cassandra Kaboom"].Pets["Whirls"]					= {Name = "Whirls",				Level = 11, Quality = 3, Breed = 9, Type = 10}

pveDB.Tamers["Traitor Gluk"] = {Pets = {}}
pveDB.Tamers["Traitor Gluk"].Pets["Glimmer"]					= {Name = "Glimmer",			Level = 13, Quality = 3, Breed = 5, Type = 2}
pveDB.Tamers["Traitor Gluk"].Pets["Prancer"]					= {Name = "Prancer",			Level = 13, Quality = 3, Breed = 9, Type = 5}
pveDB.Tamers["Traitor Gluk"].Pets["Rasp"]						= {Name = "Rasp",				Level = 13, Quality = 3, Breed = 8, Type = 8}

pveDB.Tamers["Grazzle the Great"] = {Pets = {}}
pveDB.Tamers["Grazzle the Great"].Pets["Firetooth"]				= {Name = "Firetooth",			Level = 14, Quality = 3, Breed = 7, Type = 2}
pveDB.Tamers["Grazzle the Great"].Pets["Blaze"]					= {Name = "Blaze",				Level = 14, Quality = 3, Breed = 8, Type = 2}
pveDB.Tamers["Grazzle the Great"].Pets["Flameclaw"]				= {Name = "Flameclaw",			Level = 14, Quality = 3, Breed = 4, Type = 2}

pveDB.Tamers["Kela Grimtotem"] = {Pets = {}}
pveDB.Tamers["Kela Grimtotem"].Pets["Cho'guana"]				= {Name = "Cho'guana",			Level = 15, Quality = 3, Breed = 7, Type = 8}
pveDB.Tamers["Kela Grimtotem"].Pets["Indigon"]					= {Name = "Indigon",			Level = 15, Quality = 3, Breed = 6, Type = 5}
pveDB.Tamers["Kela Grimtotem"].Pets["Plague"]					= {Name = "Plague",				Level = 15, Quality = 3, Breed = 8, Type = 5}

pveDB.Tamers["Zoltan"] = {Pets = {}}
pveDB.Tamers["Zoltan"].Pets["Beamer"]							= {Name = "Beamer",				Level = 16, Quality = 3, Breed = 4, Type = 6}
pveDB.Tamers["Zoltan"].Pets["Hatewalker"]						= {Name = "Hatewalker",			Level = 16, Quality = 3, Breed = 6, Type = 10}
pveDB.Tamers["Zoltan"].Pets["Ultramus"]							= {Name = "Ultramus",			Level = 16, Quality = 3, Breed = 7, Type = 6}

pveDB.Tamers["Elena Flutterfly"] = {Pets = {}}
pveDB.Tamers["Elena Flutterfly"].Pets["Willow"]					= {Name = "Willow",				Level = 17, Quality = 3, Breed = 8, Type = 2}
pveDB.Tamers["Elena Flutterfly"].Pets["Beacon"]					= {Name = "Beacon",				Level = 17, Quality = 3, Breed = 7, Type = 6}
pveDB.Tamers["Elena Flutterfly"].Pets["Lacewing"]				= {Name = "Lacewing",			Level = 17, Quality = 3, Breed = 9, Type = 3}

pveDB.Tamers["Stone Cold Trixxy"] = {Pets = {}}
pveDB.Tamers["Stone Cold Trixxy"].Pets["Blizzy"]				= {Name = "Blizzy",				Level = 19, Quality = 3, Breed = 5, Type = 3}
pveDB.Tamers["Stone Cold Trixxy"].Pets["Frostmaw"]				= {Name = "Frostmaw",			Level = 19, Quality = 3, Breed = 8, Type = 8}
pveDB.Tamers["Stone Cold Trixxy"].Pets["Tinygos"]				= {Name = "Tinygos",			Level = 19, Quality = 3, Breed = 9, Type = 2}


-- - ~Outlands Tamers~2

pveDB.Tamers["Nicki Tinytech"] = {Pets = {}}
pveDB.Tamers["Nicki Tinytech"].Pets["ED-005"]					= {Name = "ED-005",				Level = 20, Quality = 3, Breed = 7, Type = 10}
pveDB.Tamers["Nicki Tinytech"].Pets["Goliath"]					= {Name = "Goliath",			Level = 20, Quality = 3, Breed = 7, Type = 10}
pveDB.Tamers["Nicki Tinytech"].Pets["Sploder"]					= {Name = "Sploder",			Level = 20, Quality = 3, Breed = 6, Type = 10}

pveDB.Tamers["Ras'an"] = {Pets = {}}
pveDB.Tamers["Ras'an"].Pets["Fungor"]							= {Name = "Fungor",				Level = 21, Quality = 3, Breed = 6, Type = 1}
pveDB.Tamers["Ras'an"].Pets["Glitterfly"]						= {Name = "Glitterfly",			Level = 21, Quality = 3, Breed = 5, Type = 3}
pveDB.Tamers["Ras'an"].Pets["Tripod"]							= {Name = "Tripod",				Level = 21, Quality = 3, Breed = 3, Type = 6}

pveDB.Tamers["Narrok"] = {Pets = {}}
pveDB.Tamers["Narrok"].Pets["Stompy"]							= {Name = "Stompy",				Level = 22, Quality = 3, Breed = 6, Type = 8}
pveDB.Tamers["Narrok"].Pets["Prince Wart"]						= {Name = "Prince Wart",		Level = 22, Quality = 3, Breed = 3, Type = 9}
pveDB.Tamers["Narrok"].Pets["Dramaticus"]						= {Name = "Dramaticus",			Level = 22, Quality = 3, Breed = 8, Type = 5}

pveDB.Tamers["Morulu The Elder"] = {Pets = {}}
pveDB.Tamers["Morulu The Elder"].Pets["Chomps"]					= {Name = "Chomps",				Level = 23, Quality = 3, Breed = 4, Type = 9}
pveDB.Tamers["Morulu The Elder"].Pets["Cragmaw"]				= {Name = "Cragmaw",			Level = 23, Quality = 3, Breed = 8, Type = 9}
pveDB.Tamers["Morulu The Elder"].Pets["Gnasher"]				= {Name = "Gnasher",			Level = 23, Quality = 3, Breed = 4, Type = 9}

pveDB.Tamers["Bloodknight Antari"] = {Pets = {}}
pveDB.Tamers["Bloodknight Antari"].Pets["Arcanus"]				= {Name = "Arcanus",			Level = 24, Quality = 4, Breed = 3, Type = 6}
pveDB.Tamers["Bloodknight Antari"].Pets["Jadefire"]				= {Name = "Jadefire",			Level = 24, Quality = 4, Breed = 7, Type = 7}
pveDB.Tamers["Bloodknight Antari"].Pets["Netherbite"]			= {Name = "Netherbite",			Level = 24, Quality = 4, Breed = 8, Type = 2}

-- - ~Northrend Tamers~2

pveDB.Tamers["Beegle Blastfuse"] = {Pets = {}}
pveDB.Tamers["Beegle Blastfuse"].Pets["Dinner"]					= {Name = "Dinner",				Level = 25, Quality = 4, Breed = 8, Type = 3}
pveDB.Tamers["Beegle Blastfuse"].Pets["Goobles"]				= {Name = "Goobles",			Level = 25, Quality = 4, Breed = 9, Type = 3}
pveDB.Tamers["Beegle Blastfuse"].Pets["Warble"]					= {Name = "Warble",				Level = 25, Quality = 4, Breed = 3, Type = 9}

pveDB.Tamers["Nearly Headless Jacob"] = {Pets = {}}
pveDB.Tamers["Nearly Headless Jacob"].Pets["Spooky Strangler"]	= {Name = "Spooky Strangler",	Level = 25, Quality = 4, Breed = 8, Type = 4}
pveDB.Tamers["Nearly Headless Jacob"].Pets["Mort"]				= {Name = "Mort",				Level = 25, Quality = 4, Breed = 7, Type = 4}
pveDB.Tamers["Nearly Headless Jacob"].Pets["Stitch"]			= {Name = "Stitch",				Level = 25, Quality = 4, Breed = 9, Type = 4}

pveDB.Tamers["Okrut Dragonwaste"] = {Pets = {}}
pveDB.Tamers["Okrut Dragonwaste"].Pets["Drogar"]				= {Name = "Drogar",				Level = 25, Quality = 4, Breed = 8, Type = 2}
pveDB.Tamers["Okrut Dragonwaste"].Pets["Rot"]					= {Name = "Rot",				Level = 25, Quality = 4, Breed = 7, Type = 4}
pveDB.Tamers["Okrut Dragonwaste"].Pets["Sleet"]					= {Name = "Sleet",				Level = 25, Quality = 4, Breed = 9, Type = 4}

pveDB.Tamers["Gutretch"] = {Pets = {}}
pveDB.Tamers["Gutretch"].Pets["Blight"]							= {Name = "Blight",				Level = 25, Quality = 4, Breed = 8, Type = 5}
pveDB.Tamers["Gutretch"].Pets["Cadavus"]						= {Name = "Cadavus",			Level = 25, Quality = 4, Breed = 7, Type = 8}
pveDB.Tamers["Gutretch"].Pets["Fleshrender"]					= {Name = "Fleshrender",		Level = 25, Quality = 4, Breed = 6, Type = 8}

pveDB.Tamers["Major Payne"] = {Pets = {}}
pveDB.Tamers["Major Payne"].Pets["Beakmaster X-225"]			= {Name = "Beakmaster X-225",	Level = 25, Quality = 4, Breed = 8, Type = 10}
pveDB.Tamers["Major Payne"].Pets["Bloom"]						= {Name = "Bloom",				Level = 25, Quality = 4, Breed = 9, Type = 7}
pveDB.Tamers["Major Payne"].Pets["Grizzle"]						= {Name = "Grizzle",			Level = 25, Quality = 4, Breed = 6, Type = 8}

-- - ~Cataclysm Tamers
pveDB.Tamers["Brok"] = {Pets = {}}
pveDB.Tamers["Brok"].Pets["Ashtail"]							= {Name = "Ashtail",			Level = 25, Quality = 4, Breed = 8, Type = 8}
pveDB.Tamers["Brok"].Pets["Incinderous"]						= {Name = "Incinderous",		Level = 25, Quality = 4, Breed = 6, Type = 5}
pveDB.Tamers["Brok"].Pets["Kali"]								= {Name = "Kali",				Level = 25, Quality = 4, Breed = 5, Type = 6}

pveDB.Tamers["Bordin Steadyfist"] = {Pets = {}}
pveDB.Tamers["Bordin Steadyfist"].Pets["Crystallus"]			= {Name = "Crystallus",			Level = 25, Quality = 4, Breed = 9, Type = 5}
pveDB.Tamers["Bordin Steadyfist"].Pets["Fracture"]				= {Name = "Fracture",			Level = 25, Quality = 4, Breed = 6, Type = 7}
pveDB.Tamers["Bordin Steadyfist"].Pets["Ruby"]					= {Name = "Ruby",				Level = 25, Quality = 4, Breed = 7, Type = 7}

pveDB.Tamers["Goz Banefury"] = {Pets = {}}
pveDB.Tamers["Goz Banefury"].Pets["Amythel"]					= {Name = "Amythel",			Level = 25, Quality = 4, Breed = 9, Type = 6}
pveDB.Tamers["Goz Banefury"].Pets["Helios"]						= {Name = "Helios",				Level = 25, Quality = 4, Breed = 4, Type = 8}
pveDB.Tamers["Goz Banefury"].Pets["Twilight"]					= {Name = "Twilight",			Level = 25, Quality = 4, Breed = 8, Type = 7}

pveDB.Tamers["Obalis"] = {Pets = {}}
pveDB.Tamers["Obalis"].Pets["Clatter"]							= {Name = "Clatter",			Level = 25, Quality = 5, Breed = 9, Type = 5}
pveDB.Tamers["Obalis"].Pets["Spring"]							= {Name = "Spring",				Level = 25, Quality = 5, Breed = 5, Type = 3}
pveDB.Tamers["Obalis"].Pets["Pyth"]								= {Name = "Pyth",				Level = 25, Quality = 5, Breed = 8, Type = 8}

-- - ~Pandaria Tamers~2

pveDB.Tamers["Hyuna of the Shrines"] = {Pets = {}}
pveDB.Tamers["Hyuna of the Shrines"].Pets["Skyshaper"]					= {Name = "Skyshaper",			Level = 25, Quality = 5, Breed = 8, Type = 3}
pveDB.Tamers["Hyuna of the Shrines"].Pets["Dor the Wall"]				= {Name = "Dor the Wall",		Level = 25, Quality = 5, Breed = 6, Type = 9}
pveDB.Tamers["Hyuna of the Shrines"].Pets["Fangor"]						= {Name = "Fangor",				Level = 25, Quality = 5, Breed = 5, Type = 8}

pveDB.Tamers["Farmer Nishi"] = {Pets = {}}
pveDB.Tamers["Farmer Nishi"].Pets["Brood of Mothallus"]					= {Name = "Brood of Mothallus",			Level = 25, Quality = 5, Breed = 9, Type = 8}
pveDB.Tamers["Farmer Nishi"].Pets["Toothbreaker"]						= {Name = "Toothbreaker",				Level = 25, Quality = 5, Breed = 6, Type = 7}
pveDB.Tamers["Farmer Nishi"].Pets["Siren"]								= {Name = "Siren",						Level = 25, Quality = 5, Breed = 7, Type = 7}


pveDB.Tamers["Mo'ruk"] = {Pets = {}}
pveDB.Tamers["Mo'ruk"].Pets["Lightstalker"]							= {Name = "Lightstalker",			Level = 25, Quality = 5, Breed = 8, Type = 3}
pveDB.Tamers["Mo'ruk"].Pets["Needleback"]							= {Name = "Needleback",				Level = 25, Quality = 5, Breed = 6, Type = 9}
pveDB.Tamers["Mo'ruk"].Pets["Woodcarver"]							= {Name = "Woodcarver",				Level = 25, Quality = 5, Breed = 9, Type = 8}

pveDB.Tamers["Courageous Yon"] = {Pets = {}}
pveDB.Tamers["Courageous Yon"].Pets["Bleat"]						= {Name = "Bleat",					Level = 25, Quality = 5, Breed = 8, Type = 8}
pveDB.Tamers["Courageous Yon"].Pets["Piqua"]						= {Name = "Piqua",					Level = 25, Quality = 5, Breed = 9, Type = 3}
pveDB.Tamers["Courageous Yon"].Pets["Lapin"]						= {Name = "Lapin",					Level = 25, Quality = 5, Breed = 9, Type = 5}

pveDB.Tamers["Seeker Zusshi"] = {Pets = {}}
pveDB.Tamers["Seeker Zusshi"].Pets["Diamond"]						= {Name = "Diamond",				Level = 25, Quality = 5, Breed = 6, Type = 7}
pveDB.Tamers["Seeker Zusshi"].Pets["Mollus"]						= {Name = "Mollus",					Level = 25, Quality = 5, Breed = 9, Type = 5}
pveDB.Tamers["Seeker Zusshi"].Pets["Skimmer"]						= {Name = "Skimmer",				Level = 25, Quality = 5, Breed = 9, Type = 9}

pveDB.Tamers["Wastewalker Shu"] = {Pets = {}}
pveDB.Tamers["Wastewalker Shu"].Pets["Pounder"]						= {Name = "Pounder",				Level = 25, Quality = 5, Breed = 6, Type = 7}
pveDB.Tamers["Wastewalker Shu"].Pets["Crusher"]						= {Name = "Crusher",				Level = 25, Quality = 5, Breed = 7, Type = 9}
pveDB.Tamers["Wastewalker Shu"].Pets["Mutilator"]					= {Name = "Mutilator",				Level = 25, Quality = 5, Breed = 4, Type = 8}

pveDB.Tamers["Aki the Chosen"] = {Pets = {}}
pveDB.Tamers["Aki the Chosen"].Pets["Stormlash"]					= {Name = "Stormlash",				Level = 25, Quality = 6, Breed = 7, Type = 2}
pveDB.Tamers["Aki the Chosen"].Pets["Whiskers"]						= {Name = "Whiskers",				Level = 25, Quality = 6, Breed = 8, Type = 9}
pveDB.Tamers["Aki the Chosen"].Pets["Chirrup"]						= {Name = "Chirrup",				Level = 25, Quality = 6, Breed = 5, Type = 5}

-- _ ~Pandaren Elemental Spirits~2
pveDB.Tamers["Burning Pandaren Spirit"] = {Pets = {}}
pveDB.Tamers["Burning Pandaren Spirit"].Pets["Crimson"]						= {Name = "Crimson",				Level = 25, Quality = 6, Breed = 8, Type = 2}
pveDB.Tamers["Burning Pandaren Spirit"].Pets["Glowy"]						= {Name = "Glowy",					Level = 25, Quality = 6, Breed = 11, Type = 3}
pveDB.Tamers["Burning Pandaren Spirit"].Pets["Pandaren Fire Spirit"]		= {Name = "Pandaren Fire Spirit",	Level = 25, Quality = 6, Breed = 8, Type = 7}

pveDB.Tamers["Thundering Pandaren Spirit"] = {Pets = {}}
pveDB.Tamers["Thundering Pandaren Spirit"].Pets["Darnak the Tunneler"]		= {Name = "Darnak the Tunneler",	Level = 25, Quality = 6, Breed = 6, Type = 8}
pveDB.Tamers["Thundering Pandaren Spirit"].Pets["Pandaren Earth Spirit"]	= {Name = "Pandaren Earth Spirit",	Level = 25, Quality = 6, Breed = 7, Type = 7}
pveDB.Tamers["Thundering Pandaren Spirit"].Pets["Sludgy"]					= {Name = "Sludgy",					Level = 25, Quality = 6, Breed = 9, Type = 6}

pveDB.Tamers["Whispering Pandaren Spirit"] = {Pets = {}}
pveDB.Tamers["Whispering Pandaren Spirit"].Pets["Dusty"]					= {Name = "Dusty",					Level = 25, Quality = 6, Breed = 12, Type = 3}
pveDB.Tamers["Whispering Pandaren Spirit"].Pets["Pandaren Air Spirit"]		= {Name = "Pandaren Air Spirit",	Level = 25, Quality = 6, Breed = 3, Type = 7}
pveDB.Tamers["Whispering Pandaren Spirit"].Pets["Whispertail"]				= {Name = "Whispertail",			Level = 25, Quality = 6, Breed = 3, Type = 2}

pveDB.Tamers["Flowing Pandaren Spirit"] = {Pets = {}}
pveDB.Tamers["Flowing Pandaren Spirit"].Pets["Marley"]						= {Name = "Marley",					Level = 25, Quality = 6, Breed = 5, Type = 9}
pveDB.Tamers["Flowing Pandaren Spirit"].Pets["Pandaren Water Spirit"]		= {Name = "Pandaren Water Spirit",	Level = 25, Quality = 6, Breed = 9, Type = 7}
pveDB.Tamers["Flowing Pandaren Spirit"].Pets["Tiptoe"]						= {Name = "Tiptoe",					Level = 25, Quality = 6, Breed = 10, Type = 9}


-- _ ~Darkmoon Faire

pveDB.Tamers["Jeremy Feasel"] = {Pets = {}}
pveDB.Tamers["Jeremy Feasel"].Pets["Honky-Tonk"]						= {Name = "Honky-Tonk",				Level = 25, Quality = 5, Breed = 7, Type = 10}
pveDB.Tamers["Jeremy Feasel"].Pets["Judgement"]						= {Name = "Judgement",				Level = 25, Quality = 5, Breed = 8, Type = 6}
pveDB.Tamers["Jeremy Feasel"].Pets["Fezwick"]					= {Name = "Fezwick",				Level = 25, Quality = 5, Breed = 10, Type = 8}


-- _ ~Fabled Pandaren~2

pveDB.Elites["Ka'wi the Gorger"] = {Pets = {}}
pveDB.Elites["Ka'wi the Gorger"].Pets["Ka'wi the Gorger"]			= {Name = "Ka'wi the Gorger",		Level = 25, Quality = 6, Breed = 7, Type = 5}

pveDB.Elites["Gorespine"] = {Pets = {}}
pveDB.Elites["Gorespine"].Pets["Gorespine"]							= {Name = "Gorespine",				Level = 25, Quality = 6, Breed = 4, Type = 8}

pveDB.Elites["No-No"] = {Pets = {}}
pveDB.Elites["No-No"].Pets["No-No"]									= {Name = "No-No",					Level = 25, Quality = 6, Breed = 3, Type = 9}

pveDB.Elites["Greyhoof"] = {Pets = {}}
pveDB.Elites["Greyhoof"].Pets["Greyhoof"]							= {Name = "Greyhoof",				Level = 25, Quality = 6, Breed = 9, Type = 8}

pveDB.Elites["Lucky Yi"] = {Pets = {}}
pveDB.Elites["Lucky Yi"].Pets["Lucky Yi"]							= {Name = "Lucky Yi ",				Level = 25, Quality = 6, Breed = 11, Type = 5}

pveDB.Elites["Ti'un the Wanderer"] = {Pets = {}}
pveDB.Elites["Ti'un the Wanderer"].Pets["Ti'un the Wanderer"]		= {Name = "Ti'un the Wanderer",		Level = 25, Quality = 6, Breed = 6, Type = 9}

pveDB.Elites["Kafi"] = {Pets = {}}
pveDB.Elites["Kafi"].Pets["Kafi"]									= {Name = "Kafi",					Level = 25, Quality = 6, Breed = 10, Type = 8}

pveDB.Elites["Dos-Ryga"] = {Pets = {}}
pveDB.Elites["Dos-Ryga"].Pets["Dos-Ryga"]							= {Name = "Dos-Ryga",				Level = 25, Quality = 6, Breed = 12, Type = 9}

pveDB.Elites["Nitun"] = {Pets = {}}
pveDB.Elites["Nitun"].Pets["Nitun"]									= {Name = "Nitun",					Level = 25, Quality = 6, Breed = 8, Type = 5}

pveDB.Elites["Skitterer Xi'a"] = {Pets = {}}
pveDB.Elites["Skitterer Xi'a"].Pets["Skitterer Xi'a"]				= {Name = "Skitterer Xi'a",			Level = 25, Quality = 6, Breed = 5, Type = 9}

pveDB.Elites["Skitterer Xi'a"] = {Pets = {}}
pveDB.Elites["Skitterer Xi'a"].Pets["Skitterer Xi'a"]				= {Name = "Skitterer Xi'a",			Level = 25, Quality = 6, Breed = 5, Type = 9}


-- _ ~Timeless Isle Celestial Tournament~2

pveDB.Tamers["Little Tommy Newcomer"] = {Pets = {}}
pveDB.Tamers["Little Tommy Newcomer"].Pets["Lil' Oondasta"]		= {Name = "Lil' Oondasta",		Level = 25, Quality = 6, Breed = 3, Type = 8}


pveDB.Tamers["Lorewalker Cho"] = {Pets = {}}
pveDB.Tamers["Lorewalker Cho"].Pets["Knowledge"]				= {Name = "Knowledge",	Level = 25, Quality = 6, Breed = 4, Type = 2}
pveDB.Tamers["Lorewalker Cho"].Pets["Patience"]					= {Name = "Patience",	Level = 25, Quality = 6, Breed = 6, Type = 6}
pveDB.Tamers["Lorewalker Cho"].Pets["Wisdom"]					= {Name = "Wisdom",		Level = 25, Quality = 6, Breed = 5, Type = 3}

pveDB.Tamers["Shademaster Kiryn"] = {Pets = {}}
pveDB.Tamers["Shademaster Kiryn"].Pets["Summer"]				= {Name = "Summer",		Level = 25, Quality = 6, Breed = 5, Type = 8}
pveDB.Tamers["Shademaster Kiryn"].Pets["Nairn"]					= {Name = "Nairn",		Level = 25, Quality = 6, Breed = 6, Type = 1}
pveDB.Tamers["Shademaster Kiryn"].Pets["Stormoen"]				= {Name = "Stormoen",	Level = 25, Quality = 6, Breed = 4, Type = 10}

pveDB.Tamers["Sully \"The Pickle\" McLeary"] = {Pets = {}}
pveDB.Tamers["Sully \"The Pickle\" McLeary"].Pets["Monte"]		= {Name = "Monte",		Level = 25, Quality = 6, Breed = 4, Type = 5}
pveDB.Tamers["Sully \"The Pickle\" McLeary"].Pets["Rikki"]		= {Name = "Rikki",		Level = 25, Quality = 6, Breed = 3, Type = 9}
pveDB.Tamers["Sully \"The Pickle\" McLeary"].Pets["Socks"]		= {Name = "Socks",		Level = 25, Quality = 6, Breed = 3, Type = 4}

pveDB.Tamers["Taran Zhu"] = {Pets = {}}
pveDB.Tamers["Taran Zhu"].Pets["Bolo"]							= {Name = "Bolo",		Level = 25, Quality = 6, Breed = 7, Type = 1}
pveDB.Tamers["Taran Zhu"].Pets["Li"]							= {Name = "Li",			Level = 25, Quality = 6, Breed = 5, Type = 1}
pveDB.Tamers["Taran Zhu"].Pets["Yen"]							= {Name = "Yen",		Level = 25, Quality = 6, Breed = 8, Type = 1}

pveDB.Tamers["Blingtron 4000"] = {Pets = {}}
pveDB.Tamers["Blingtron 4000"].Pets["Au"]						= {Name = "Au",			Level = 25, Quality = 6, Breed = 4, Type = 7}
pveDB.Tamers["Blingtron 4000"].Pets["Banks"]					= {Name = "Banks",		Level = 25, Quality = 6, Breed = 6, Type = 5}
pveDB.Tamers["Blingtron 4000"].Pets["Lil' B"]					= {Name = "Lil' B",		Level = 25, Quality = 6, Breed = 5, Type = 6}

pveDB.Tamers["Dr. Ion Goldbloom"] = {Pets = {}}
pveDB.Tamers["Dr. Ion Goldbloom"].Pets["Chaos"]					= {Name = "Chaos",		Level = 25, Quality = 6, Breed = 5, Type = 6}
pveDB.Tamers["Dr. Ion Goldbloom"].Pets["Trike"]					= {Name = "Trike",		Level = 25, Quality = 6, Breed = 6, Type = 8}
pveDB.Tamers["Dr. Ion Goldbloom"].Pets["Screamer"]				= {Name = "Screamer",	Level = 25, Quality = 6, Breed = 4, Type = 3}

pveDB.Tamers["Wise Mari"] = {Pets = {}}
pveDB.Tamers["Wise Mari"].Pets["River"]							= {Name = "River",		Level = 25, Quality = 6, Breed = 5, Type = 7}
pveDB.Tamers["Wise Mari"].Pets["Carpe Diem"]					= {Name = "Carpe Diem",	Level = 25, Quality = 6, Breed = 6, Type = 9}
pveDB.Tamers["Wise Mari"].Pets["Spirus"]						= {Name = "Spirus",		Level = 25, Quality = 6, Breed = 4, Type = 6}

pveDB.Tamers["Chen Stormstout"] = {Pets = {}}
pveDB.Tamers["Chen Stormstout"].Pets["Tonsa"]					= {Name = "Tonsa",		Level = 25, Quality = 6, Breed = 8, Type = 8}
pveDB.Tamers["Chen Stormstout"].Pets["Chirps"]					= {Name = "Chirps",		Level = 25, Quality = 6, Breed = 5, Type = 5}
pveDB.Tamers["Chen Stormstout"].Pets["Brewly"]					= {Name = "Brewly",		Level = 25, Quality = 6, Breed = 6, Type = 7}

pveDB.Tamers["Wrathion"] = {Pets = {}}
pveDB.Tamers["Wrathion"].Pets["Cindy"]							= {Name = "Cindy",		Level = 25, Quality = 6, Breed = 5, Type = 4}
pveDB.Tamers["Wrathion"].Pets["Alex"]							= {Name = "Alex",		Level = 25, Quality = 6, Breed = 6, Type = 2}
pveDB.Tamers["Wrathion"].Pets["Dah'da"]							= {Name = "Dah'da",		Level = 25, Quality = 6, Breed = 4, Type = 2}


pveDB.Elites["Chi-Chi, Hatchling of Chi-Ji"] = {Pets = {}}
pveDB.Elites["Chi-Chi, Hatchling of Chi-Ji"].Pets["Chi-Chi, Hatchling of Chi-Ji"]	= {Name = "Chi-Chi, Hatchling of Chi-Ji",		Level = 25, Quality = 6, Breed = 8, Type = 3}

pveDB.Elites["Xu-Fu, Cub of Xuen"] = {Pets = {}}
pveDB.Elites["Xu-Fu, Cub of Xuen"].Pets["Xu-Fu, Cub of Xuen"]						= {Name = "Xu-Fu, Cub of Xuen",					Level = 25, Quality = 6, Breed = 8, Type = 8}

pveDB.Elites["Yu'la, Broodling of Yu'lon"] = {Pets = {}}
pveDB.Elites["Yu'la, Broodling of Yu'lon"].Pets["Yu'la, Broodling of Yu'lon"]		= {Name = "Yu'la, Broodling of Yu'lon",			Level = 25, Quality = 6, Breed = 8, Type = 2}

pveDB.Elites["Zao, Calfling of Niuzao"] = {Pets = {}}
pveDB.Elites["Zao, Calfling of Niuzao"].Pets["Zao, Calfling of Niuzao"]				= {Name = "Zao, Calfling of Niuzao ",			Level = 25, Quality = 6, Breed = 6, Type = 8}

 


--This function is supposed to take the client strings for the pet battle combat log,
--and make patterns that can be used to get information use they are used in the log.
function PetBattlePokemonMusic:makePattern(str)
	str2 =string.gsub(str, "%%s", "(.*)")
	str2 =string.gsub(str2, "%%d", "%(%%d%*%)")
	str2 =string.gsub(str2, "%)%.", "%)%%.")
	
	return str2
end

-- A prototype function for making pattern matching strings for each localization.
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

-- English pattern matching strings.  TODO
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

local spellIDs = {}
spellIDs[134644]= 1
spellIDs[134496]= 1
spellIDs[134482]= 1
spellIDs[134490]= 1
spellIDs[134488]= 1
spellIDs[134484]= 1
spellIDs[134486]= 1
spellIDs[134487]= 1
spellIDs[134492]= 1
spellIDs[134489]= 1
spellIDs[134448]= 1
spellIDs[134491]= 1
spellIDs[125801]= 1
spellIDs[133994]= 1
spellIDs[142205]= 1
spellIDs[142204]= 1
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

	UndeleteableSounds["FireRed & LifeGreen Trainer Battle Start"]				= true
	UndeleteableSounds["FireRed & LifeGreen Trainer Battle"]					= true
	UndeleteableSounds["FireRed & LifeGreen Trainer Battle Victory"]			= true	
				
	UndeleteableSounds["Red, Blue, & Yellow Trainer Start"]						= true
	UndeleteableSounds["Red, Blue, & Yellow Trainer Battle"]					= true
	UndeleteableSounds["Red, Blue, & Yellow Trainer Victory"]					= true	
																			
	UndeleteableSounds["Gold & Silver Trainer Battle Start"]					= true
	UndeleteableSounds["Gold & Silver Trainer Battle"]							= true
	UndeleteableSounds["Gold & Silver Trainer Battle Victory"]					= true	
	
	UndeleteableSounds["Ruby, Saphire, & Emerald Trainer Start"]				= true
	UndeleteableSounds["Ruby, Saphire, & Emerald Trainer Battle"]				= true
	UndeleteableSounds["Ruby, Saphire, & Emerald Trainer Victory"]				= true	
	
local CustomTrackList = {}

-- ==============================================================================
-- List Filling
-- ==============================================================================
function PetBattlePokemonMusic:FillCustomTrackList()

	for k, v in pairs (PetBattlePokemonMusic.db.global.CustomTracks) do

		CustomTrackList[k] = k
		PetBattlePokemonMusic:AddCustomTrack_NewUI (k)
	end
end
local PlaylistList = {}
function PetBattlePokemonMusic:FillPlaylistList()

	for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists) do

		PlaylistList[k] = k
	end
end
--- A table for the pre-made tracks
local PokemonBattleMusicEffects = {}
	PokemonBattleMusicEffects[1] =	{	Name			= "Red, Blue, & Yellow Wild Pokemon Battle", 
										StartSoundKey	= "Red, Blue, & Yellow Wild Pokemon Battle Start",
										MusicKey		= "Red, Blue, & Yellow Wild Pokemon Battle",
										VictoryKey		= "Red, Blue, & Yellow Wild Pokemon Battle Victory"
									}
	PokemonBattleMusicEffects[2] =	{	Name			= "Gold & Silver Wild Pokemon Battle", 
										StartSoundKey	= "Gold & Silver Wild Pokemon Battle Start",
										MusicKey		= "Gold & Silver Wild Pokemon Battle",
										VictoryKey		= "Gold & Silver Wild Pokemon Battle Victory"										
									}
	PokemonBattleMusicEffects[3] =	{	Name			= "Ruby, Saphire, & Emerald Wild Pokemon Battle", 
										StartSoundKey	= "Ruby, Saphire, & Emerald Wild Pokemon Battle Start",
										MusicKey		= "Ruby, Saphire, & Emerald Wild Pokemon Battle",
										VictoryKey		= "Ruby, Saphire, & Emerald Wild Pokemon Battle Victory"
									}
	PokemonBattleMusicEffects[4] =	{	Name			= "FireRed & LifeGreen Wild Pokemon Battle", 
										StartSoundKey	= "FireRed & LifeGreen Wild Pokemon Battle Start",
										MusicKey		= "FireRed & LifeGreen Wild Pokemon Battle",
										VictoryKey		= "FireRed & LifeGreen Wild Pokemon Battle Victory"
									}
	-- TRAINER
	PokemonBattleMusicEffects[5] =	{	Name			= "Red, Blue, & Yellow Trainer Battle", 
										StartSoundKey	= "Red, Blue, & Yellow Trainer Start",
										MusicKey		= "Red, Blue, & Yellow Trainer Battle",
										VictoryKey		= "Red, Blue, & Yellow Trainer Victory"
									}
	PokemonBattleMusicEffects[6] =	{	Name			= "Gold & Silver Trainer Battle", 
										StartSoundKey	= "Gold & Silver Trainer Battle Start",
										MusicKey		= "Gold & Silver Trainer Battle",
										VictoryKey		= "Gold & Silver Trainer Battle Victory"
									}
	PokemonBattleMusicEffects[7] =	{	Name			= "Ruby, Saphire, & Emerald Trainer Battle", 
										StartSoundKey	= "Ruby, Saphire, & Emerald Trainer Start",
										MusicKey		= "Ruby, Saphire, & Emerald Trainer Battle",
										VictoryKey		= "Ruby, Saphire, & Emerald Trainer Victory"
									}
	
	PokemonBattleMusicEffects[8] =	{	Name			= "FireRed & LifeGreen Trainer Battle", 
										StartSoundKey	= "FireRed & LifeGreen Trainer Battle Start",
										MusicKey		= "FireRed & LifeGreen Trainer Battle",
										VictoryKey		= "FireRed & LifeGreen Trainer Battle Victory"
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
	name = L["ADDON_NAME"],
	type = "group",
	handler = PetBattlePokemonMusic,
	args = {
--StartSoundOn
		StartSoundOp = {
							type		= "toggle",
							name		= L["START_SOUND"],
							desc		= L["START_SOUND_DESC"],
							order		= 1,
							set			= function (info, val) PetBattlePokemonMusic.db.global.StartSoundOn = val end,
							get			= function () return PetBattlePokemonMusic.db.global.StartSoundOn end
						},
		VictorySoundOp = {
							type		= "toggle",
							name		= L["VICTORY_SOUND"],
							desc		= L["VICTORY_SOUND_DESC"],
							order		= 1,
							set			= function (info, val) PetBattlePokemonMusic.db.global.VictorySoundOn = val end,
							get			= function () return PetBattlePokemonMusic.db.global.VictorySoundOn end
						},
		resetbut = {
							type = "execute",
							name = L["ADDON_RESET"],
							func = function () PetBattlePokemonMusic:Reset() end
						},
		TrainerCustom = {
							order		=	8,
							type		= "description",
							name		= testersd.." ",
							cmdHidden	= true
						}
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
						name = L["UI_FRAME_LIBRARY"],
						type = "group",
						handler = PetBattlePokemonMusic,
						args = {
									AddNewSoundHeader = {
															type = "header",
															name = L["ADD_NEW_SOUND"],
															order = 1,
															desc = L["ADD_NEW_SOUND_DESC"]
														},
									AddNewSoundName =	{
															name = L["ADD_NEW_SOUND_NAME"],
															type = "input",
															get = function()  return neoSoundNameTemp end,
															set = function (info, val)neoSoundNameTemp = val  end,
															order = 2
														},
								AddNewSoundFileName =	{
															name =L["ADD_NEW_SOUND_FILE"],
															type = "input",
															get = function()  return neoSoundFileTemp end,
															set = function (info, val) neoSoundFileTemp = val end,
															order = 2
														},
									AddNewSoundLength = {
															name = L["ADD_NEW_SOUND_LENGTH"],
															type = "input",
															desc = L["ADD_NEW_SOUND_LENGTH_DESC"],
															get = function()  return neoSoundLengthTemp end,
															set = function (info, val) neoSoundLengthTemp = val end,
															order = 2
														},
									AddNewSoundButton = {
															name = L["ADD_NEW_SOUND_BUTTON"],
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
																		PetBattlePokemonMusic.db.global.SoundLibrary[neoSoundNameTemp] = {FileName = neoSoundFileTemp, Length = tonumber(neoSoundLengthTemp)}
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
													name	= L["SOUND_FILE_NAME"]..self.db.global.SoundLibrary[soundkey].FileName,
													order	= 1
												},
								SoundLength =	{
													type	= "description",
													name	= L["SOUND_FILE_LENGTH"]..tostring(self.db.global.SoundLibrary[soundkey].Length).." seconds",
													order	= 2
												},
								PlayButton =	{
													type = "execute",
													name = L["SOUND_FILE_PLAY"],
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
													name		= L["SOUND_FILE_DELETE"],
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
																				--BattleMusic.args.WildHeader.args[key] = nil
																				--BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.global.Wild.CustomTrack == key then
																					self.db.global.Wild.CustomTrack = nil
																				end
																				if self.db.global.Trainer.CustomTrack == key then
																					self.db.global.Trainer.CustomTrack = nil
																				end
																			end		
																			if value.MusicKey == soundkey then
																				self.db.CustomTracks[key].MusicKey = nil
																				--BattleMusic.args.WildHeader.args[key] = nil
																				--BattleMusic.args.TrainerHeader.args[key] = nil

																				if self.db.global.Wild.CustomTrack == key then
																					self.db.global.Wild.CustomTrack = nil
																				end
																				if self.db.global.Trainer.CustomTrack == key then
																					self.db.global.Trainer.CustomTrack = nil
																				end
																			end	
																			if value.VictoryKey == soundkey then
																				self.db.CustomTracks[key].VictoryKey = nil
																				--BattleMusic.args.WildHeader.args[key] = nil
																				--BattleMusic.args.TrainerHeader.args[key] = nil

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
													name = L["SOUND_FILE_STOP"],
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

local newCustTrackNewName = ""
local newCustTracks = {type = "group", name = L["CUST_TRACKS"] , args = {	AddNewTrackButton = {
																				type = "execute", 
																				name = L["CREATE_CUST_TRACKS"],
																				order = 2, 
																				func = function ()
																							if PetBattlePokemonMusic.db.global.CustomTracks[newCustTrackNewName] == nil then
																								PetBattlePokemonMusic.db.global.CustomTracks[newCustTrackNewName] ={
																									StartSoundKey = 1,
																									StartVol = 1,
																									MusicKey = 1,
																									MusicVol = 1,
																									VictoryKey = 1,
																									VictoryVol = 1
																								}
																								PetBattlePokemonMusic:AddCustomTrack_NewUI (newCustTrackNewName)
																								PetBattlePokemonMusic:FillCustomTrackList()
																								newCustTrackNewName = ""

																							end
																				end },
																			AddNewTrackText = {
																				type = "input", 
																				name = L["CREATE_CUST_TRACKS_NAME"], 
																				order = 1, 
																				width = "double",
																				get = function () return newCustTrackNewName end , 
																				set = function (info, val) newCustTrackNewName = val end }




}}
function PetBattlePokemonMusic:RemoveCustomTrack_NewUI(trackID)
	newCustTracks.args[trackID] = nil
end
local customSoundID = 0
local customTrackTestTimer = nil
function PetBattlePokemonMusic:CustomTrackTestVolumeReset()
			PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
		

end
function PetBattlePokemonMusic:AddCustomTrack_NewUI (trackID)
	newCustTracks.args[trackID] = {type = "group", name = trackID, args = {StartSound = {type = "select", 
		name = L["CREATE_CUST_TRACKS_START_GROUP"], 
		values = SoundListUI, 
		get = function () return PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartSoundKey end,
		set = function (info, val) PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartSoundKey = val end,
		order = 10,
		width = "full"},
		StartVolume = {		type = "range", 
							min  = 0,
							max  = 1,
							step = 0.1, 
							name = L["CUST_TRACKS_START_VOL"], 
							order = 11, 
							get = function ()	if PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartVol == nil then
													PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartVol = 1
												end
												return PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartVol end,
							set = function (info, val) PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartVol = val  end},
		PlayStart = {type = "execute", name = L["SOUND_FILE_PLAY"], order = 12, func = function() 
			PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
			SetCVar("Sound_MasterVolume",PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartVol)
			bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartSoundKey].FileName, "Master")
			
			customTrackTestTimer = PetBattlePokemonMusic:ScheduleTimer(	"CustomTrackTestVolumeReset", 
										PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[trackID].StartSoundKey].Length,
										playlistIndex)
		
		end, width = "half"},
		StopStart = {type = "execute", name = L["SOUND_FILE_STOP"], order = 13, func = function() 
		
		
		if currentSound ~= nil then
			StopSound(currentSound)
			currentSound=nil
			SetCVar("Sound_MasterVolume",PetBattlePokemonMusic.db.global.OldSoundSettings.Volume)
			self:CancelTimer(customTrackTestTimer,true)
		end
		
		end, width = "half"},
		MusicTrack = {	type = "select", 
						name = L["CREATE_CUST_TRACKS_MUSIC_GROUP"], 
						values = SoundListUI, 
						get = function ()  return PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey end,
						set = function (info, val)  PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey = SoundListUI[val] end,
						order = 15,
						width = "full"},

		MusicVolume = {	type = "range", 
						min  = 0,
						max  = 1,
						step = 0.1, 
						name = L["CUST_TRACKS_MUSIC_VOL"], 
						order = 16, 
						get = function ()	if PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicVol == nil then
												PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicVol = 1
											end
											return PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicVol 
						end,
						set = function (info, val) PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicVol = val  
						end},
		PlayMusic = {	type = "execute", 
						name = L["SOUND_FILE_PLAY"], 
						order = 17, 
						func = function()
						PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
			SetCVar("Sound_MasterVolume",PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicVol)
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey].FileName, "Master")
						customTrackTestTimer = PetBattlePokemonMusic:ScheduleTimer(	"CustomTrackTestVolumeReset", 
										PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey].Length,
										playlistIndex)
						end, 
						width = "half"},
		StopMusic = {	type = "execute", 
						name = L["SOUND_FILE_STOP"], 
						order = 18, 
						func = function()if currentSound ~= nil then
			StopSound(currentSound)
			currentSound=nil
							SetCVar("Sound_MasterVolume",PetBattlePokemonMusic.db.global.OldSoundSettings.Volume)
							self:CancelTimer(customTrackTestTimer,true)
		end end, 
						width = "half"},
		


		VictorySound = {type = "select", 
						name = L["CREATE_CUST_TRACKS_VICTORY_GROUP"], 
						values = SoundListUI, 
						get = function () return PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryKey end,
						set = function (info, val) PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryKey = val end,
						order = 20,
						width = "full"},
		VictoryVolume = {	type = "range", 
							min  = 0,
							max  = 1,
							step = 0.1, 
							name = L["CUST_TRACKS_VICT_VOL"], 
							order = 21, 
							get = function ()	if PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryVol == nil then
													PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryVol = 1
												end
												return PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryVol end,
							set = function (info, val) PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryVol = val  end},
		PlayVictory = {		type = "execute", 
							name = L["SOUND_FILE_PLAY"], 
							order = 22, func = function()
								PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
			SetCVar("Sound_MasterVolume",PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryVol)
								bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryKey].FileName, "Master") 
							customTrackTestTimer = PetBattlePokemonMusic:ScheduleTimer(	"CustomTrackTestVolumeReset", 
										PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[trackID].VictoryKey].Length,
										playlistIndex)
							end, 
							width = "half"},
		StopVictory = {		type = "execute", 
							name = L["SOUND_FILE_STOP"], 
							order = 23, 
							func = function() 
								if currentSound ~= nil then
									StopSound(currentSound)
									currentSound=nil
									SetCVar("Sound_MasterVolume",PetBattlePokemonMusic.db.global.OldSoundSettings.Volume)
									self:CancelTimer(customTrackTestTimer,true)
								end end, 
							width = "half"},

		DeleteButton = {	type = "execute", 
							name = L["SOUND_FILE_DELETE"], 
							func = function ()	self.db.global.CustomTracks[trackID]= nil  
												PetBattlePokemonMusic:RemoveCustomTrack_NewUI(trackID) 
							end,  
							order = 40}
	} }


	--self.db.global.CustomTracks[neoTrackName] ={StartSoundKey = neoTrackStartKey,
	--								MusicKey = neoTrackMusic,
		--							VictoryKey = neoTrackVictory}

	--values = SoundListUI, 
--get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex].track end,
	--set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex].track = val end,

end


-- ================================================================================================================================================================================================================================================ --
--		Other Sounds Table
-- ================================================================================================================================================================================================================================================ --
--  This table will be used for other sounds for pet battles that might be added in in future releases of the addon.																																--
--  Currently, it only has the stablemaster healing your pets.																																														--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local OtherSounds = {
							name	= L["CUST_TRACKS"],
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
															name	=		L["ENABLED"],
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

-- ================================================================================================================================================================================================================================================ --

---
--

---
--
--@param wer
function PetBattlePokemonMusic:ToggleCustomWild(wer)
	for key, val in pairs (self.db.global.CustomTracks) do
	--	if BattleMusic.args.WildHeader.args[key]~= nil then
	--		BattleMusic.args.WildHeader.args[key].disabled = wer
	--	end
	end
end
---
--
--@param wer
function PetBattlePokemonMusic:ToggleCustomTrainer(wer)
	for key, val in pairs (self.db.global.CustomTracks) do
		--if BattleMusic.args.TrainerHeader.args[key] ~= nil then
		--	BattleMusic.args.TrainerHeader.args[key].disabled = wer
		--end
	end
end
--- This function fills up the Custom list for the wild tab with the custom tracks.
--
function PetBattlePokemonMusic:FillCustomWild()
	
end
--- This function fills up the Custom list for the trainer tab with the custom tracks.
--
function PetBattlePokemonMusic:FillCustomTrainer()
	
end

---This table is used to hold the data for the UI objects in the Custom Track Library.
-- It is empty now because the items have to be added in for each entry in the custom track list.
local CustomTrackLibrary =	{
								name = L["CUST_TRACKS"],
								type = "group",
								args =		{}
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
																					name = L["CREATE_CUST_TRACKS_START"]..self.db.global.CustomTracks[key].StartSoundKey,
																					order = 2
																				},
																	MusicDesc = { --CustomTrackLibrary.args[key].args.MusicDesc
																					type = "description",
																					name = L["CREATE_CUST_TRACKS_MUSIC"]..self.db.global.CustomTracks[key].MusicKey,
																					order = 3
																				},
																VictoryDesc =	{--CustomTrackLibrary.args[key].args.VictoryDesc
																					type = "description",
																					name = L["CREATE_CUST_TRACKS_VICTORY"]..self.db.global.CustomTracks[key].VictoryKey,
																					order = 4
																				},

																DeleteBut =		{
																					type	= "execute",
																					name	= L["SOUND_FILE_DELETE"],
																					order	= 6,
																					func	=	function () 
																									self.db.global.CustomTracks[key]= nil 
																									CustomTrackList[key] = nil
																									CustomTrackLibrary.args[key] = nil 
																									--BattleMusic.args.TrainerHeader.args[key] = nil 
																									--BattleMusic.args.WildHeader.args[key] = nil 
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
																					name	= L["START_SOUND"],
																					order	= 7,
																					args	= {}
																				},
															MusicTrack	=		{
																					type ="group",
																					name = L["CREATE_CUST_TRACKS_MUSIC_GROUP"],
																					order = 8,
																					args = {}
																				},
															VictorySound	=	{
																					type ="group",
																					name = L["VICTORY_SOUND"],
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
																											name = L["CREATE_CUST_TRACKS_SET_START"],
																											order = 3,
																											func =	function () 
																														CustomTrackLibrary.args[key].args.StartDesc.name = L["CREATE_CUST_TRACKS_START"]..k    
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
																											name = L["CREATE_CUST_TRACKS_SET_MUSIC"],
																											order = 3,
																											func =	function () 
																														CustomTrackLibrary.args[key].args.MusicDesc.name = L["CREATE_CUST_TRACKS_MUSIC"]..k    
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
																												name = L["CREATE_CUST_TRACKS_SET_VICT"],
																												order = 3,
																												func =	function () 
																															CustomTrackLibrary.args[key].args.VictoryDesc.name =  L["CREATE_CUST_TRACKS_VICTORY"]..k    
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
-- =========================
-- Ability Sounds

local BattlePetAbilitySoundSettings =	{
											type = "group",
											name = L["BP_SOUNDS"],
											args = {
														BPAbilitySounds ={
																			type = "toggle",
																			name = L["ENABLED"],
																			get = function () return PetBattlePokemonMusic.db.global.BPAbilitySoundsOn end,
																			set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySoundsOn = val end,
																			order = 1
														},
														descbox =		{
																			type = "description",
																			name = L["BP_SOUNDS_SPELL"],
																			order = 4,
																			image = "INTERFACE\BUTTONS\UI-EmptySlot.blp"
																		},
														BPAInputBox =	{
																			type = "input",
																			name = L["BP_SOUNDS_ID_INPUT"],
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
																			name = L["BP_SOUNDS_ADD"],
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
																						name = L["BP_DAMAGE_SOUND"],
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.File] end, -- error on mod overwrite
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 1
																					},
																		damon 	= {
																						type = "toggle",
																						name = L["ENABLED"],
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Damage.On = val end,
																						order =2
																		
																					},
																		healIn =	{
																						type = "select",
																						name = L["BP_HEALING_SOUND"] ,
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 3
																					},
																		healon 	= {
																						type = "toggle",
																						name = L["ENABLED"],
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Healing.On = val end,
																						order =4
																		
																					},
																		applIn =	{
																						type = "select",
																						name = L["BP_APP_SOUND"],
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 5
																					},
																		appon 	= {
																						type = "toggle",
																						name = L["ENABLED"],
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Applied.On = val end,
																						order =6
																		
																					},
																		missIn =	{
																						type = "select",
																						name = L["BP_MISS_SOUND"],
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 7
																					},
																		misson 	= {
																						type = "toggle",
																						name = L["ENABLED"],
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Missed.On = val end,
																						order =8
																		
																					},
																		dodgeIn =	{
																						type = "select",
																						name = L["BP_DODGE_SOUND"],
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 9
																					},
																			dodgeon 	= {
																						type = "toggle",
																						name = L["ENABLED"],
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Dodged.On = val end,
																						order =10
																		
																					},
																		blockIn =	{
																						type = "select",
																						name = L["BP_BLOCK_SOUND"],
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 11
																					},
																		blockon 	= {
																						type = "toggle",
																						name = L["ENABLED"],
																						get = function() return PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.On end,
																						set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Blocked.On = val end,
																						order =12
																		
																					},
																		fadeIn =	{
																						type = "select",
																						name = L["BP_FADE_SOUND"],
																						get = function() return SoundListUIKeys[PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Faded.File] end,
																						set = function(info, val) PetBattlePokemonMusic.db.global.BPAbilitySounds[id].Faded.File = SoundListUI[val] end,
																						values = SoundListUI,
																						order = 13
																					},
																		fadeon 	= {
																						type = "toggle",
																						name = L["ENABLED"],
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
	BattlePetAbilitySoundSettings.args.descbox.name = L["BP_SOUNDS_SPELL"]..tostring(key)
	BattlePetAbilitySoundSettings.args.descbox.image = img
end		
function PetBattlePokemonMusic:UpdateDescoINVALID()
	BattlePetAbilitySoundSettings.args.descbox.name = L["INVALID_ID"] 
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
																			name = L["ENABLED"],
																			get = function () return PetBattlePokemonMusic.db.global.BPAbilitySoundsOn end,
																			set = function (info, val) PetBattlePokemonMusic.db.global.BPAbilitySoundsOn = val end,
																			order = 1
														},
														descbox =		{
																			type = "description",
																			name = L["BP_SOUNDS_SPELL"],
																			order = 4,
																			image = "INTERFACE\BUTTONS\UI-EmptySlot.blp"
																		},
														BPAInputBox =	{
																			type = "input",
																			name = L["BP_SOUNDS_ID_INPUT"],
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
																			name = L["BP_SOUNDS_ADD"],
																			order = 3,
																			func = function() PetBattlePokemonMusic:AddAbility(idtemp) idtemp = ""  end
														
														
																		}
													}
										
	for key, val in pairs (PetBattlePokemonMusic.db.global.BPAbilitySounds) do
		PetBattlePokemonMusic:AddAbilityUI(key)
	end
end

function PetBattlePokemonMusic:DetermineBattleType ()

	if C_PetBattles.IsWildBattle() == true then
	
		--local petname, speciesname = C_PetBattles.GetName(2, 1)
		return L["WILD"] 
	else
		if C_PetBattles.IsPlayerNPC(2) == true then
			--Tamer
			return L["TAMER"]
		else
			return "PvP"
		end

	end

end
-- ======================================================================================
-- New Music Setting Panel
-- ======================================================================================
local MusicTypes = {}
MusicTypes[1] = L["NEW_MUSIC_SELECT_PREMADE"]
MusicTypes[2] = L["NEW_MUSIC_SELECT_PLAYLIST"]
MusicTypes[3] = L["NEW_MUSIC_SELECT_CUST"]


local wildNewName = ""
local pvpNewName = ""
local MusicSetter = {type= "group", name = L["NEW_MUSIC_SETTINGS"], args = {

TamerMusicSelections = {
						type = "group", 
						name = L["TAMER"], 
						args = {
								GlobalTamerPremadeTracks = {
																type		=	"select",
																order		=	6,
																style		=	"dropdown",
																name		=	L["NEW_MUSIC_SELECT_PREMADES"],
																values		=	trackNames,
																width		=	"full",
																set			=	function(info, val) PetBattlePokemonMusic.db.global.Trainer.Track = val  end,
																get			=	function() return PetBattlePokemonMusic.db.global.Trainer.Track end,
																hidden = true
															},
								GlobalTamerCustomTracks = {
																type		=	"select",
																order		=	6,
																style		=	"dropdown",
																name		=	L["CUST_TRACKS"],
																values		=	CustomTrackList ,
																width		=	"full",
																set			=	function(info, val) PetBattlePokemonMusic.db.global.Trainer.Track = val  end,
																get			=	function() return PetBattlePokemonMusic.db.global.Trainer.Track end,
																hidden = true
															},
								GlobalTamerPlaylistTracks = {
																type		=	"select",
																order		=	6,
																style		=	"dropdown",
																name		=	L["NEW_MUSIC_SELECT_PLAYLISTS"],
																values		=	function () PlaylistList = {}
																							PetBattlePokemonMusic:FillPlaylistList() 
																				return PlaylistList end,
																width		=	"full",
																set			=	function(info, val) PetBattlePokemonMusic.db.global.Trainer.Track = val  end,
																get			=	function() return PetBattlePokemonMusic.db.global.Trainer.Track end,
																hidden = true
															},
							TrainerMusicOn =	{
																type		=	"toggle",
																name		=	L["ENABLED"],
																desc		=	L["NEW_MUSIC_SELECT_ON_TOG_TAMER"],
																order		=	3,
																set			=	function (info, val) PetBattlePokemonMusic.db.global.Trainer.On = val end,
																get			=	function () return PetBattlePokemonMusic.db.global.Trainer.On end
																						},
										TrainerAlwaysOn =	{
																type		=	"toggle",
																name		=	L["ALWAYS_ON"],
																desc		=	L["NEW_MUSIC_SELECT_ALWAYS_TOG_TAMER"],
																order		=	3,
																set			=	function (info, val) PetBattlePokemonMusic.db.global.Trainer.Always = val end,
																get			=	function () return PetBattlePokemonMusic.db.global.Trainer.Always end
																	},
										GlobalTamerMusicType = {
																type = "select", name = L["NEW_MUSIC_SELECT_MUSIC_TYPE"], values = MusicTypes, width = "full",
																get = function ()PetBattlePokemonMusic:UpdateTamerHidden (PetBattlePokemonMusic.db.global.Trainer.MusicType) 
																		return  PetBattlePokemonMusic.db.global.Trainer.MusicType  
																	  end, 
																set = function (info, val)PetBattlePokemonMusic.db.global.Trainer.MusicType = val  
																		PetBattlePokemonMusic:UpdateTamerHidden (val) 
																	 end,
																order = 5
										},
									GlobalTamerMusicVolume = {	
																type = "range",
																name = L["NEW_MUSIC_SELECT_MUSIC_VOLUME"],
																min  = 0,
																max  = 1,
																step = 0.1,
																get = function() return  PetBattlePokemonMusic.db.global.Trainer.Volume.Music; 
																	 end,
																set = function (info, val)PetBattlePokemonMusic.db.global.Trainer.Volume.Music = val;
																			--TODO update current volume if in battle.
																			if C_PetBattles.IsInBattle() then
																				SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music )
																			end
																		end,
																order = 4
			
															},
									GlobalTamerSoundVolume = {
																type = "range",
																name = L["NEW_MUSIC_SELECT_SOUND_VOLUME"],
																min  = 0,
																max  = 1,
																step = 0.1,
																get = function() return  PetBattlePokemonMusic.db.global.Trainer.Volume.Master; 
																		end,
																set = function (info, val)PetBattlePokemonMusic.db.global.Trainer.Volume.Master = val;
																	--TODO update current volume if in battle.
																	if C_PetBattles.IsInBattle() then
																		SetCVar("Sound_MusicVolume",PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
																	end
																end,
																order = 4
															}
} },
WildMusicSelections = {
						type = "group", 
						name = L["WILD"] , 
						args = {
								GlobalWildPremadeTracks = {
																type		=	"select",
																order		=	6,
																style		=	"dropdown",
																name		=	L["NEW_MUSIC_SELECT_PREMADES"],
																values		=	trackNames,
																width		=	"full",
																set			=	function(info, val) PetBattlePokemonMusic.db.global.Wild.Track = val  end,
																get			=	function() return PetBattlePokemonMusic.db.global.Wild.Track end,
																hidden = true
															},
								GlobalWildCustomTracks = {
																type		=	"select",
																order		=	6,
																style		=	"dropdown",
																name		=	L["CUST_TRACKS"],
																values		=	CustomTrackList ,
																width		=	"full",
																set			=	function(info, val) PetBattlePokemonMusic.db.global.Wild.Track = val  end,
																get			=	function() return PetBattlePokemonMusic.db.global.Wild.Track end,
																hidden = true
														},
								GlobalWildPlaylistTracks = {
																type		=	"select",
																order		=	6,
																style		=	"dropdown",
																name		=	L["NEW_MUSIC_SELECT_PLAYLISTS"],
																values		=	function () PlaylistList = {}
																							PetBattlePokemonMusic:FillPlaylistList()
																							return PlaylistList 
																				end,
																width		=	"full",
																set			=	function(info, val) PetBattlePokemonMusic.db.global.Wild.Track = val  end,
																get			=	function() return PetBattlePokemonMusic.db.global.Wild.Track end,
																hidden		=   true
														},
										WildMusicOn =	{
																type		=	"toggle",
																name		=	L["ENABLED"],
																desc		=	L["NEW_MUSIC_SELECT_ON_TOG_WILD"],
																order		=	3,
																set			=	function (info, val) PetBattlePokemonMusic.db.global.Wild.On = val end,
																get			=	function () return PetBattlePokemonMusic.db.global.Wild.On end
																	},
										WildAlwaysOn =	{
																type		=	"toggle",
																name		=	L["ALWAYS_ON"],
																desc		=	L["NEW_MUSIC_SELECT_ALWAYS_TOG_TAMER"],
																order		=	3,
																set			=	function (info, val) PetBattlePokemonMusic.db.global.Wild.Always = val end,
																get			=	function () return PetBattlePokemonMusic.db.global.Wild.Always end
													},
								GlobalWildMusicType = {
																type = "select", 
																name = L["NEW_MUSIC_SELECT_MUSIC_TYPE"], 
																values = MusicTypes, 
																width = "full",
																get = function ()PetBattlePokemonMusic:UpdateWildHidden (PetBattlePokemonMusic.db.global.Wild.MusicType) 
																	  return  PetBattlePokemonMusic.db.global.Wild.MusicType 
																	  end, 
																set = function (info, val)PetBattlePokemonMusic.db.global.Wild.MusicType = val  
																		PetBattlePokemonMusic:UpdateWildHidden (val) 
																	  end,
																order = 5
														},
			GlobalWildMusicVolume = {	
																type = "range",
																name = L["NEW_MUSIC_SELECT_MUSIC_VOLUME"],
																min  = 0,
																max  = 1,
																step = 0.1,
																get = function() return  PetBattlePokemonMusic.db.global.Wild.Volume.Music; end,
																set = function (info, val)PetBattlePokemonMusic.db.global.Wild.Volume.Music = val;
																	--TODO update current volume if in battle.
																	if C_PetBattles.IsInBattle() then
																		SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music )
																	end
																end,
																order = 4
															},
			GlobalWildSoundVolume = {
																type = "range",
																name = L["NEW_MUSIC_SELECT_SOUND_VOLUME"],
																min  = 0,
																max  = 1,
																step = 0.1,
																get = function() return  PetBattlePokemonMusic.db.global.Wild.Volume.Master; end,
																set = function (info, val)PetBattlePokemonMusic.db.global.Wild.Volume.Master = val;
																	--TODO update current volume if in battle.
																	if C_PetBattles.IsInBattle() then
																		SetCVar("Sound_MusicVolume",PetBattlePokemonMusic.db.global.Wild.Volume.Master )
																	end
																end,
																order = 4
													},
										AddWildText = {
																type	= "input", 
																get		= function() return wildNewName end, 
																set		= function (info, val) wildNewName = val end, 
																name	= L["NEW_MUSIC_SELECT_NEW_WILD_SPEC"], 
																order	= 10 
},
AddWildTextButton = {type = "execute",func = function () if PetBattlePokemonMusic.db.global.WildTracks[wildNewName] == nil then  PetBattlePokemonMusic:AddNewWildTrack(wildNewName)  PetBattlePokemonMusic:AddSpecificWildUI(wildNewName)  wildNewName = "" end end, name = L["BP_SOUNDS_ADD"], order = 11  }
} },
PvPMusicSelections ={type = "group", name = "PvP", args = {
			GlobalPvPPremadeTracks = {
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	L["NEW_MUSIC_SELECT_PREMADES"],
																							values		=	trackNames,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.PvP.Track = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.global.PvP.Track end,
																							hidden = true
			},
			GlobalPvPCustomTracks = {
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	L["CUST_TRACKS"],
																							values		=	CustomTrackList ,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.PvP.Track = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.global.PvP.Track end,
																							hidden = true
			},
	GlobalPvPPlaylistTracks = {
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	L["NEW_MUSIC_SELECT_PLAYLISTS"],
																							values		=	function () PlaylistList = {}
PetBattlePokemonMusic:FillPlaylistList() return PlaylistList end,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.PvP.Track = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.global.PvP.Track end,
																							hidden = true
	},
	PvPMusicOn =	{
																							type		=	"toggle",
																							name		=	L["ENABLED"],
																							desc		=	L["PVP_ALWAYS_ON"],
																							order		=	3,
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.PvP.On = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.PvP.On end
																						},
																	PvPAlwaysOn =	{
																							type		=	"toggle",
																							name		=	L["ALWAYS_ON"],
																							desc		=	L["NEW_MUSIC_SELECT_ALWAYS_TOG_TAMER"],
																							order		=	3,
																							set			=	function (info, val) PetBattlePokemonMusic.db.global.PvP.Always = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.PvP.Always end
																	},
			GlobalPvPMusicType = {
									type = "select", name = L["NEW_MUSIC_SELECT_MUSIC_TYPE"], values = MusicTypes, width = "full",
									get = function ()PetBattlePokemonMusic:UpdatePvPHidden (PetBattlePokemonMusic.db.global.PvP.MusicType) return  PetBattlePokemonMusic.db.global.PvP.MusicType  end, 
									set = function (info, val)PetBattlePokemonMusic.db.global.PvP.MusicType = val  PetBattlePokemonMusic:UpdatePvPHidden (val) end,
				order = 5},
			GlobalPvPMusicVolume = {	type = "range",
										name = L["NEW_MUSIC_SELECT_MUSIC_VOLUME"],
										min  = 0,
										max  = 1,
										step = 0.1,
										get = function() return  PetBattlePokemonMusic.db.global.PvP.Volume.Music; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.PvP.Volume.Music = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Music )
																								end
																							end,
										order = 4
			
			},
			GlobalPvPSoundVolume = {type = "range",
										name = L["NEW_MUSIC_SELECT_SOUND_VOLUME"],
										min  = 0,
										max  = 1,
										step = 0.1,
										get = function() return  PetBattlePokemonMusic.db.global.PvP.Volume.Master; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.PvP.Volume.Master = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MusicVolume",PetBattlePokemonMusic.db.global.PvP.Volume.Master )
																								end
																							end,
										order = 4},
	AddPvPText = {type = "input", get = function() return pvpNewName end, set = function (info, val) pvpNewName = val end, name = L["NEW_MUSIC_SELECT_NEW_PVP_SPEC"], order = 10 },
AddPvPTextButton = {type = "execute",func = function () if PetBattlePokemonMusic.db.global.PvPTracks[pvpNewName] == nil then  PetBattlePokemonMusic:AddNewPvPTrack(pvpNewName)  PetBattlePokemonMusic:AddSpecificPvPUI(pvpNewName)  pvpNewName = "" end end, name = L["BP_SOUNDS_ADD"], order = 11  }

} }
}}
function PetBattlePokemonMusic:UpdateTamerHidden (val)
	if val == 1 then
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerPlaylistTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerPremadeTracks.hidden = false
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerCustomTracks.hidden = true
	end
	if val == 2 then
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerPremadeTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerCustomTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerPlaylistTracks.hidden = false
	end
	if val == 3 then
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerPremadeTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerPlaylistTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args.GlobalTamerCustomTracks.hidden = false
	end
end
function PetBattlePokemonMusic:UpdateWildHidden (val)
	if val == 1 then
		MusicSetter.args.WildMusicSelections.args.GlobalWildPlaylistTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args.GlobalWildPremadeTracks.hidden = false
		MusicSetter.args.WildMusicSelections.args.GlobalWildCustomTracks.hidden = true
	end
	if val == 2 then
		MusicSetter.args.WildMusicSelections.args.GlobalWildPremadeTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args.GlobalWildCustomTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args.GlobalWildPlaylistTracks.hidden = false
	end
	if val == 3 then
		MusicSetter.args.WildMusicSelections.args.GlobalWildPremadeTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args.GlobalWildPlaylistTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args.GlobalWildCustomTracks.hidden = false
	end
end
function PetBattlePokemonMusic:UpdatePvPHidden (val)
	if val == 1 then
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPPlaylistTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPPremadeTracks.hidden = false
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPCustomTracks.hidden = true
	end
	if val == 2 then
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPPremadeTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPCustomTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPPlaylistTracks.hidden = false
	end
	if val == 3 then
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPPremadeTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPPlaylistTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args.GlobalPvPCustomTracks.hidden = false
	end
end
--MusicType
local PlayListTypes = {}
PlayListTypes[1] = L["PLAYLIST_TYPE_1"]
PlayListTypes[2] = L["PLAYLIST_TYPE_2"]


-- ====================
-- Playlist panel

local newPlaylistName = ""
local tempNewTrack = 1
local playListMaker = {type = "group", name = L["NEW_MUSIC_SELECT_PLAYLISTS"], 
	args = {newPlaylistNameText = {	type = "input", 
									width = "double", 
									name =L["PLAYLIST_NEW_NAME"], 
									get = function () return newPlaylistName end, 
									set = function (info, val) newPlaylistName = val end},
	
	
			newPlayList = {			
									type = "execute", 
									name = L["PLAYLIST_NEW_LIST"], 
									func = function () 

												local success = PetBattlePokemonMusic:NewPlaylist (newPlaylistName)
												if success == true then
													PetBattlePokemonMusic:AddPlaylistToUI (newPlaylistName)
												else
													print(L["PLAYLIST_NAME_ALREADY"])
												end

											end
			}}}


--PetBattlePokemonMusic.db.global.TamerTracks[tamerName] = {	Type = 1, 
--																Premade = 1, 
--																Custom = 1, 
--																Playlist = 1, 
--																Enabled =true, 
--																Always = true,
--																Volume = {Music = 0.5, Master = 0.5}, 
--																Start ={}, 
--																Victory = {}}




function PetBattlePokemonMusic:FillTamerList ()


	for k, v in pairs (PetBattlePokemonMusic.db.global.TamerTracks) do

		MusicSetter.args.TamerMusicSelections.args[k] = { 
															type = "group", 
															name = k, 
															args = { GlobalTamerPremadeTracks = {
																								type		=	"select",
																								order		=	6,
																								style		=	"dropdown",
																								name		=	L["NEW_MUSIC_SELECT_PREMADES"],
																								values		=	trackNames,
																								width		=	"full",
																								set			=	function(info, val) PetBattlePokemonMusic.db.global.TamerTracks[k].Premade = val  end,
																								get			=	function() return PetBattlePokemonMusic.db.global.TamerTracks[k].Premade end,
																								hidden = true
																								},
																		GlobalTamerCustomTracks = {
																								type		=	"select",
																								order		=	6,
																								style		=	"dropdown",
																								name		=	L["CUST_TRACKS"],
																								values		=	CustomTrackList ,
																								width		=	"full",
																								set			=	function(info, val) PetBattlePokemonMusic.db.global.TamerTracks[k].Custom = val  end,
																								get			=	function() return PetBattlePokemonMusic.db.global.TamerTracks[k].Custom end,
																								hidden = true
																								},
																	GlobalTamerPlaylistTracks = {
																								type		=	"select",
																								order		=	6,
																								style		=	"dropdown",
																								name		=	L["NEW_MUSIC_SELECT_PLAYLISTS"],
																								values		=	function () PlaylistList = {}
																															PetBattlePokemonMusic:FillPlaylistList() 
																															return PlaylistList 
																												end,
																								width		=	"full",
																								set			=	function(info, val) PetBattlePokemonMusic.db.global.TamerTracks[k].Playlist = val  end,
																								get			=	function() return  PetBattlePokemonMusic.db.global.TamerTracks[k].Playlist end,
																								hidden = true
																								},
																			TrainerMusicOn =	{
																								type		=	"toggle",
																								name		=	L["ENABLED"],
																								desc		=	L["NEW_MUSIC_SELECT_ON_TOG_TAMER"],
																								order		=	3,
																								set			=	function (info, val)  PetBattlePokemonMusic.db.global.TamerTracks[k].Enabled = val end,
																								get			=	function () return PetBattlePokemonMusic.db.global.TamerTracks[k].Enabled end
																							},
																		TrainerAlwaysOn =	{
																								type		=	"toggle",
																								name		=	L["ALWAYS_ON"],
																								desc		=	L["NEW_MUSIC_SELECT_ALWAYS_TOG_TAMER"],
																								order		=	3,
																								set			=	function (info, val)PetBattlePokemonMusic.db.global.TamerTracks[k].Always = val end,
																								get			=	function () return PetBattlePokemonMusic.db.global.TamerTracks[k].Always  end
																							},
																	GlobalTamerMusicType = {
																								type = "select", 
																								name = L["NEW_MUSIC_SELECT_MUSIC_TYPE"], 
																								values = MusicTypes, 
																								width = "full",
																								get = function () PetBattlePokemonMusic:UpdateTamerSpecificHidden (PetBattlePokemonMusic.db.global.TamerTracks[k].Type, k) 
																												return  PetBattlePokemonMusic.db.global.TamerTracks[k].Type  
																										end, 
																								set = function (info, val)PetBattlePokemonMusic.db.global.TamerTracks[k].Type = val  
																															PetBattlePokemonMusic:UpdateTamerSpecificHidden (val, k) 
																										end,
																								order = 5
																								},
																		GlobalTamerMusicVolume = {	
																								type = "range",
																								name = L["NEW_MUSIC_SELECT_MUSIC_VOLUME"],
																								min  = 0,
																								max  = 1,
																								step = 0.1,
																								get = function() return  PetBattlePokemonMusic.db.global.TamerTracks[k].Volume.Music; end,
																								set = function (info, val)PetBattlePokemonMusic.db.global.TamerTracks[k].Volume.Music = val;
																								--TODO update current volume if in battle.
																										if C_PetBattles.IsInBattle() then
																											SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.TamerTracks[k].Volume.Music )
																										end
																									end,
																								order = 4
			
																								},
																		GlobalTamerSoundVolume = {
																								type = "range",
																								name = L["NEW_MUSIC_SELECT_SOUND_VOLUME"],
																								min  = 0,
																								max  = 1,
																								step = 0.1,
																								get = function() return  PetBattlePokemonMusic.db.global.TamerTracks[k].Volume.Master; end,
																								set = function (info, val) PetBattlePokemonMusic.db.global.TamerTracks[k].Volume.Master = val;
																									--TODO update current volume if in battle.
																									if C_PetBattles.IsInBattle() then
																										SetCVar("Sound_MusicVolume",PetBattlePokemonMusic.db.global.TamerTracks[k].Volume.Master )
																									end
																								end,
																								order = 4
																								}
		}
		}
	end

end
function PetBattlePokemonMusic:DeleteSpecificWildUI(k)
	MusicSetter.args.WildMusicSelections.args[k] = {}
	PetBattlePokemonMusic.db.global.WildTracks[k] = nil
end
function PetBattlePokemonMusic:AddSpecificWildUI(k)
	

		MusicSetter.args.WildMusicSelections.args[k] = {	type = "group", 
															name = k, 
															args = { GlobalWildPremadeTracks = {
																								type		=	"select",
																								order		=	6,
																								style		=	"dropdown",
																								name		=	L["NEW_MUSIC_SELECT_PREMADES"],
																								values		=	trackNames,
																								width		=	"full",
																								set			=	function(info, val) PetBattlePokemonMusic.db.global.WildTracks[k].Premade = val  end,
																								get			=	function() return PetBattlePokemonMusic.db.global.WildTracks[k].Premade end,
																								hidden = true
																								},
																		GlobalWildCustomTracks = {
																								type		=	"select",
																								order		=	6,
																								style		=	"dropdown",
																								name		=	L["CUST_TRACKS"],
																								values		=	CustomTrackList ,
																								width		=	"full",
																								set			=	function(info, val) PetBattlePokemonMusic.db.global.WildTracks[k].Custom = val  end,
																								get			=	function() return PetBattlePokemonMusic.db.global.WildTracks[k].Custom end,
																								hidden = true
																								},
																		GlobalWildPlaylistTracks = {
																								type		=	"select",
																								order		=	6,
																								style		=	"dropdown",
																								name		=	L["NEW_MUSIC_SELECT_PLAYLISTS"],
																								values		=	function () PlaylistList = {}
																															PetBattlePokemonMusic:FillPlaylistList() 
																															return PlaylistList end,
																								width		=	"full",
																								set			=	function(info, val) PetBattlePokemonMusic.db.global.WildTracks[k].Playlist = val  end,
																								get			=	function() return  PetBattlePokemonMusic.db.global.WildTracks[k].Playlist end,
																								hidden = true
																									},
																SpecificWildDeleteButton = {	
																								type = "execute",
																								order = 7,
																								name = "Delete",
																								func = function () PetBattlePokemonMusic:DeleteSpecificWildUI(k)  end
			
																						},
																		WildMusicOn =	{
																							type		=	"toggle",
																							name		=	L["ENABLED"],
																							desc		=	L["UI_FRAME_MUSIC_WILD_ENABLED_DESC"],
																							order		=	3,
																							set			=	function (info, val)  PetBattlePokemonMusic.db.global.WildTracks[k].Enabled = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.WildTracks[k].Enabled end
																						},
																		WildAlwaysOn =	{
																							type		=	"toggle",
																							name		=	L["ALWAYS_ON"],
																							desc		=	L["NEW_MUSIC_SELECT_ALWAYS_TOG_TAMER"],
																							order		=	3,
																							set			=	function (info, val)PetBattlePokemonMusic.db.global.WildTracks[k].Always = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.WildTracks[k].Always  end
																						},
																	GlobalWildMusicType = {
																							type = "select", name = L["NEW_MUSIC_SELECT_MUSIC_TYPE"], values = MusicTypes, width = "full",
																							get = function ()PetBattlePokemonMusic:UpdateWildSpecificHidden (PetBattlePokemonMusic.db.global.WildTracks[k].Type, k) return  PetBattlePokemonMusic.db.global.WildTracks[k].Type  end, 
																							set = function (info, val)PetBattlePokemonMusic.db.global.WildTracks[k].Type = val  PetBattlePokemonMusic:UpdateWildSpecificHidden (val, k) end,
																							order = 5
																							},
																	GlobalWildMusicVolume = {	
																							type = "range",
																							name = L["NEW_MUSIC_SELECT_MUSIC_VOLUME"],
																							min  = 0,
																							max  = 1,
																							step = 0.1,
																							get = function() return  PetBattlePokemonMusic.db.global.WildTracks[k].Volume.Music; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.WildTracks[k].Volume.Music = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.WildTracks[k].Volume.Music )
																								end
																							end,
																							order = 4
			
																							},
																	GlobalWildSoundVolume = {
																							type = "range",
																							name = L["NEW_MUSIC_SELECT_SOUND_VOLUME"],
																							min  = 0,
																							max  = 1,
																							step = 0.1,
																							get = function() return  PetBattlePokemonMusic.db.global.WildTracks[k].Volume.Master; end,
																							set = function (info, val) PetBattlePokemonMusic.db.global.WildTracks[k].Volume.Master = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MusicVolume",PetBattlePokemonMusic.db.global.WildTracks[k].Volume.Master )
																								end
																							end,
																							order = 4
																							}
																		}
		}
	

end
--TODO PVP
function PetBattlePokemonMusic:AddSpecificPvPUI(k)
	

		MusicSetter.args.PvPMusicSelections.args[k] = { type = "group", name = k, args = { GlobalPvPPremadeTracks = {
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	L["NEW_MUSIC_SELECT_PREMADES"],
																							values		=	trackNames,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.PvPTracks[k].Premade = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.global.PvPTracks[k].Premade end,
																							hidden = true
			},
			GlobalPvPCustomTracks = {
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	L["CUST_TRACKS"],
																							values		=	CustomTrackList ,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.PvPTracks[k].Custom = val  end,
																							get			=	function() return PetBattlePokemonMusic.db.global.PvPTracks[k].Custom end,
																							hidden = true
			},
	GlobalPvPPlaylistTracks = {
																							type		=	"select",
																							order		=	6,
																							style		=	"dropdown",
																							name		=	L["NEW_MUSIC_SELECT_PLAYLISTS"],
																							values		=	function () PlaylistList = {}
PetBattlePokemonMusic:FillPlaylistList() return PlaylistList end,
																							width		=	"full",
																							set			=	function(info, val) PetBattlePokemonMusic.db.global.PvPTracks[k].Playlist = val  end,
																							get			=	function() return  PetBattlePokemonMusic.db.global.PvPTracks[k].Playlist end,
																							hidden = true
	},
	TrainerMusicOn =	{
																							type		=	"toggle",
																							name		=	L["ENABLED"],
																							desc		=	L["NEW_MUSIC_SELECT_ON_TOG_PVP"],
																							order		=	3,
																							set			=	function (info, val)  PetBattlePokemonMusic.db.global.PvPTracks[k].Enabled = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.PvPTracks[k].Enabled end
																						},
																	TrainerAlwaysOn =	{
																							type		=	"toggle",
																							name		=	L["ALWAYS_ON"],
																							desc		=	L["NEW_MUSIC_SELECT_ALWAYS_TOG_TAMER"],
																							order		=	3,
																							set			=	function (info, val)PetBattlePokemonMusic.db.global.PvPTracks[k].Always = val end,
																							get			=	function () return PetBattlePokemonMusic.db.global.PvPTracks[k].Always  end
																	},
			GlobalPvPMusicType = {
									type = "select", name = L["NEW_MUSIC_SELECT_MUSIC_TYPE"], values = MusicTypes, width = "full",
									get = function ()PetBattlePokemonMusic:UpdatePvPSpecificHidden (PetBattlePokemonMusic.db.global.PvPTracks[k].Type, k) return  PetBattlePokemonMusic.db.global.PvPTracks[k].Type  end, 
									set = function (info, val)PetBattlePokemonMusic.db.global.PvPTracks[k].Type = val  PetBattlePokemonMusic:UpdatePvPSpecificHidden (val, k) end,
				order = 5},
			GlobalPvPMusicVolume = {	type = "range",
										name = L["NEW_MUSIC_SELECT_MUSIC_VOLUME"],
										min  = 0,
										max  = 1,
										step = 0.1,
										get = function() return  PetBattlePokemonMusic.db.global.PvPTracks[k].Volume.Music; end,
																							set = function (info, val)PetBattlePokemonMusic.db.global.PvPTracks[k].Volume.Music = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvPTracks[k].Volume.Music )
																								end
																							end,
										order = 4
			
			},
			GlobalWildSoundVolume = {type = "range",
										name = L["NEW_MUSIC_SELECT_SOUND_VOLUME"],
										min  = 0,
										max  = 1,
										step = 0.1,
										get = function() return  PetBattlePokemonMusic.db.global.PvPTracks[k].Volume.Master; end,
																							set = function (info, val) PetBattlePokemonMusic.db.global.PvPTracks[k].Volume.Master = val;
																								--TODO update current volume if in battle.
																								if C_PetBattles.IsInBattle() then
																									SetCVar("Sound_MusicVolume",PetBattlePokemonMusic.db.global.PvPTracks[k].Volume.Master )
																								end
																							end,
										order = 4}
		}
		}
	

end
function PetBattlePokemonMusic:FillWildList ()
	for k, v in pairs (PetBattlePokemonMusic.db.global.WildTracks) do
		PetBattlePokemonMusic:AddSpecificWildUI(k)
	end
end

function PetBattlePokemonMusic:UpdateTamerSpecificHidden (val, k)
	if val == 1 then
		
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerPlaylistTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerPremadeTracks.hidden = false
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerCustomTracks.hidden = true
	end
	if val == 2 then
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerPremadeTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerCustomTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerPlaylistTracks.hidden = false
	end
	if val == 3 then
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerPremadeTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerPlaylistTracks.hidden = true
		MusicSetter.args.TamerMusicSelections.args[k].args.GlobalTamerCustomTracks.hidden = false
	end
end
function PetBattlePokemonMusic:UpdateWildSpecificHidden (val, k)
	if val == 1 then
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildPlaylistTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildPremadeTracks.hidden = false
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildCustomTracks.hidden = true
	end
	if val == 2 then
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildPremadeTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildCustomTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildPlaylistTracks.hidden = false
	end
	if val == 3 then
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildPremadeTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildPlaylistTracks.hidden = true
		MusicSetter.args.WildMusicSelections.args[k].args.GlobalWildCustomTracks.hidden = false
	end
end
function PetBattlePokemonMusic:UpdatePvPSpecificHidden (val, k)
	if val == 1 then
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPPlaylistTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPPremadeTracks.hidden = false
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPCustomTracks.hidden = true
	end
	if val == 2 then
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPPremadeTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPCustomTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPPlaylistTracks.hidden = false
	end
	if val == 3 then
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPPremadeTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPPlaylistTracks.hidden = true
		MusicSetter.args.PvPMusicSelections.args[k].args.GlobalPvPCustomTracks.hidden = false
	end
end
function PetBattlePokemonMusic:NewPlaylist (playlistIndex)
	if  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex] == nil then
		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex] = {Tracks = {}, 
																	Type = 1, 
																	CurrentTrack = 1, 
																	PlayedRandom = {}, 
																	MissingTracks = {}, 
																	RemainingTracks = {}, 
																	Continuous = false, 
																	UseStart = false, 
																	UseVictory = false, 
																	StartTracks = {}, 
																	VictoryTracks = {}, 
																	RandomReuse = 0}
		return true
	else
		return false
	end
end

function PetBattlePokemonMusic:AddTrackToPlaylist(playlistIndex, trackID)
	
	tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks, {track = trackID, Vol = 1})
	tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks, {track = 1, Vol = 1})
	tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks, {track = 1, Vol = 1})
	PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks = {}
	for k,v in pairs (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks) do
		tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks, k)
	end
	PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom = {}
end
--TODO  switch volume
function PetBattlePokemonMusic:SwitchTracksUI(playlistIndex, trackIndex1, trackIndex2)
	if playListMaker.args[playlistIndex].args["track"..trackIndex2.."_A_Name"] ~= nil and playListMaker.args[playlistIndex].args["track"..trackIndex1.."_A_Name"] ~= nil then
	playListMaker.args[playlistIndex].args["track"..trackIndex1.."_A_Name"].name = trackIndex1..". "..PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1].track
	playListMaker.args[playlistIndex].args["track"..trackIndex2.."_A_Name"].name = trackIndex2..". "..PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2].track
	playListMaker.args[playlistIndex].args["track"..trackIndex1.."_D_Volume"].get =  function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1].Vol end
	playListMaker.args[playlistIndex].args["track"..trackIndex2.."_D_Volume"].get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2].Vol end
	
	playListMaker.args[playlistIndex].args["track"..trackIndex1.."_D_Volume"].set = function (info, val)  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1].Vol = val end
	playListMaker.args[playlistIndex].args["track"..trackIndex2.."_D_Volume"].set = function (info, val)  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2].Vol = val end
	
	playListMaker.args[playlistIndex].args["track"..trackIndex1.."_H_NoStart"].set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1].UseStart = val end
	playListMaker.args[playlistIndex].args["track"..trackIndex1.."_H_NoStart"].get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1].UseStart end
	
	playListMaker.args[playlistIndex].args["track"..trackIndex2.."_H_NoStart"].set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2].UseStart = val end 
	playListMaker.args[playlistIndex].args["track"..trackIndex2.."_H_NoStart"].get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2].UseStart end
	
	--get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].UseStart end,
	--set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].UseStart = val end
	
	
	--playListMaker.args[playlistIndex].args["track"..trackIndex1.."_I_StartSound"].set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex1].track = val  end
	--playListMaker.args[playlistIndex].args["track"..trackIndex1.."_I_StartSound"].get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex1].track end

	--playListMaker.args[playlistIndex].args["track"..trackIndex2.."_I_StartSound"].set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex2].track = val  end
	--playListMaker.args[playlistIndex].args["track"..trackIndex2.."_I_StartSound"].get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex2].track end
	end
end
--TODO FIX Start Track
function PetBattlePokemonMusic:SwitchTracks(playlistIndex, trackIndex1, trackIndex2)
	if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1] ~= nil and  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2] ~= nil then
		local track1 = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1]
		local track2 = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2]
		
		local oldStartTrack= PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex1].track
		local oldVictTrack = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex1].track
		local newStartTrack= PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex2].track
		local newVictTrack = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex2].track

		local oldStartVol= PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex1].Vol
		local oldVictVol = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex1].Vol
		local newStartVol= PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex2].Vol
		local newVictVol = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex2].Vol

		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1] = track2
		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2] = track1
	

		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex2] = {track = oldVictTrack, Vol = oldVictVol}
			
			--oldVict
		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex2] ={track = oldStartTrack, Vol = oldStartVol}

		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex1] ={track = newVictTrack, Vol = newVictVol}
		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex1] ={track = newStartTrack, Vol = newStartVol}
		
		return 0
	else
		local returnSum = 0
		if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex1] ~= nil then
			returnSum= returnSum + 1
		end
		if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex2] ~= nil then
			returnSum =returnSum + 2
		end
		return returnSun
	end
end
--TODO
--PetBattlePokemonMusic.db.global.SoundLibrary[curr].Length
--PetBattlePokemonMusic:ScheduleTimer(	"PlayNextTrack", 
--										PetBattlePokemonMusic.db.global.SoundLibrary[curr].Length,
--										playlistIndex)
local PlaylistTimer = nil
function PetBattlePokemonMusic:PlayCurrentTrack(playlistIndex)
	print("CUR")
	local curr = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack
	local trackName = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[curr].track
	if PetBattlePokemonMusic.db.global.SoundLibrary[trackName] ~= nil then
		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackName].FileName)
		
		PetBattlePokemonMusic:ScheduleTimer(	"PlayNextTrack", 
												PetBattlePokemonMusic.db.global.SoundLibrary[trackName].Length,
												playlistIndex)
	else
	
		print("The sound track requested \""..trackName.."\" is not in the sound library.  Going to next track.")
		
	end
end
function PetBattlePokemonMusic:PlayCurrentTrackWithStart(playlistIndex, current)
	PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack = current
	if PetBattlePokemonMusic.db.global.SoundLibrary[current] ~= nil then
		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[current].FileName)
		PetBattlePokemonMusic:ScheduleTimer(	"PlayNextTrack", 
												PetBattlePokemonMusic.db.global.SoundLibrary[current].Length,
												playlistIndex)
	else
	
		print("The sound track requested \""..current.."\" is not in the sound library.  Going to next track.")
		
	end
end

function  PetBattlePokemonMusic:PlayNextTrack (playlistIndex)
	if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Type == 1 then
		local curr = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack + 1
		if curr > #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks then
			PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack = 1
		else
			PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack = curr
		end
	else
		local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks)
		while  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[nextRandom] ~= nil do
			nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks)
		end
		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[nextRandom] = 1
	end
end

function PetBattlePokemonMusic:CheckPlaylistsForDeletedTrack(trackID)
	for k,v in pairs (PetBattlePokemonMusic.db.global.PlayLists) do
		for trackIndex, track in pairs (PetBattlePokemonMusic.db.global.PlayLists[k].Tracks) do
			if track == trackID then
				tinsert(PetBattlePokemonMusic.db.global.PlayLists[k].MissingTracks, trackID)
			end
		end
	end
end
function PetBattlePokemonMusic:RemoveTrackUI(playlistIndex, trackIndex)
	local trackI = 1
	while playListMaker.args[playlistIndex].args["track"..trackI.."_A_Name"] ~= nil do
		if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackI] ~= nil then
			playListMaker.args[playlistIndex].args["track"..trackI.."_A_Name"].name = trackI..". "..PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackI].track
			playListMaker.args[playlistIndex].args["track"..trackI.."_A_Name"].order	=  13 +( 17* trackI)
			playListMaker.args[playlistIndex].args["track"..trackI.."_B_Up"].order		=  14 +( 17* trackI)
			playListMaker.args[playlistIndex].args["track"..trackI.."_C_Down"].order	=  15 +( 17* trackI)
			playListMaker.args[playlistIndex].args["track"..trackI.."_E_Remove"].order	=  17 +( 17* trackI)

			playListMaker.args[playlistIndex].args["track"..trackI.."_D_Volume"].order	= 16 +( 17* trackI)
			playListMaker.args[playlistIndex].args["track"..trackI.."_F_Full"].order	= 18 +( 17* trackI)
			playListMaker.args[playlistIndex].args["track"..trackI.."_G_Full"].order	= 29 +( 17* trackI)
			playListMaker.args[playlistIndex].args["track"..trackI.."_H_NoStart"].order	= 19 +( 17* trackI)
			playListMaker.args[playlistIndex].args["track"..trackI.."_I_StartSound"].order	= 20 +( 17* trackI)

			playListMaker.args[playlistIndex].args["track"..trackI.."_K_NoVict"].order 	= 22 +( 17* trackI)
				playListMaker.args[playlistIndex].args["track"..trackI.."_L_VictSound"].order 	= 23 +( 17* trackI)
		else
			playListMaker.args[playlistIndex].args["track"..trackI.."_A_Name"]		= nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_B_Up"]		= nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_C_Down"]		= nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_E_Remove"]	= nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_D_Volume"]	= nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_F_Full"]		= nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_G_Full"]		= nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_H_NoStart"] = nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_I_StartSound"] = nil
			playListMaker.args[playlistIndex].args["track"..trackI.."_K_NoVict"] = nil
				playListMaker.args[playlistIndex].args["track"..trackI.."_L_VictSound"]= nil
		end
		trackI = trackI + 1
	end
	--playListMaker.args[playlistIndex].args["track"..trackIndex.."_A_Name"]
	playListMaker.args[playlistIndex].args.PlaylistReuseRange.max = playListMaker.args[playlistIndex].args.PlaylistReuseRange.max - 1
end

function PetBattlePokemonMusic:RemoveTrack(playlistIndex, trackIndex)
	local removedTrackID = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex]
	tremove(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks, trackIndex)
	tremove(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks, trackIndex)
	tremove(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks, trackIndex)
	for k,v in pairs (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks) do
		tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks, k)
	end
	PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom = {}
	local removedOnce = false
	for trackIndex, track in pairs (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].MissingTracks) do
		if removedOnce == false then
			if track == removedTrackID then
				tremove (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].MissingTracks, trackIndex)
				removedOnce = true
			end
		end
	end

end

function PetBattlePokemonMusic:AddTrackToPlaylistUI(playlistIndex, trackIndex)
	
	playListMaker.args[playlistIndex].args["track"..trackIndex.."_A_Name"] = {
																type = "description", 
																width = "normal", 
																name = trackIndex..". "..PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].track, 
																order = 13 +( 17 * trackIndex)}

	playListMaker.args[playlistIndex].args["track"..trackIndex.."_D_Volume"] = {name = "Volume",
		
		desc = "Track "..trackIndex.. " Volume",
		order =16 +( 17* trackIndex),
		type = "range", min =0, max = 1, step = 0.1,
		get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].Vol end , 
		set = function (info, val)  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].Vol = val end 
	}
	playListMaker.args[playlistIndex].args["track"..trackIndex.."_B_Up"] = {
																type= "execute", 
																width = "half",
																name = "+", 
																desc = L["PLAYLIST_TRACK_UP_DESC"],
																order = 14 +( 17 * trackIndex),
																func = function () 
	
																		PetBattlePokemonMusic:SwitchTracks(playlistIndex, trackIndex, trackIndex-1)
																		PetBattlePokemonMusic:SwitchTracksUI(playlistIndex, trackIndex, trackIndex-1)
	
																		end
	}

	playListMaker.args[playlistIndex].args["track"..trackIndex.."_C_Down"] = {
																type= "execute",
																width = "half",
																name = "-",  
																desc = L["PLAYLIST_TRACK_DOWN_DESC"],
																order = 15 +( 17* trackIndex), 
																func = function () 
																			PetBattlePokemonMusic:SwitchTracks(playlistIndex, trackIndex, trackIndex+1)
																			PetBattlePokemonMusic:SwitchTracksUI(playlistIndex,trackIndex, trackIndex+1)
	end}
playListMaker.args[playlistIndex].args["track"..trackIndex.."_E_Remove"] = {desc = L["PLAYLIST_TRACK_REMOVE_DESC"]..trackIndex,type= "execute", name = "X", width = "half", order =17 +( 17* trackIndex), func = function () 

PetBattlePokemonMusic:RemoveTrack(playlistIndex, trackIndex)
PetBattlePokemonMusic:RemoveTrackUI(playlistIndex, trackIndex)
end}
	playListMaker.args[playlistIndex].args["track"..trackIndex.."_F_Full"] = {type= "execute", name = ">>", width = "half", order =18 +( 17* trackIndex), desc = L["PLAYLIST_MORE_OPT"],
		func = function () if playListMaker.args[playlistIndex].args["track"..trackIndex.."_H_NoStart"].hidden == true then
								playListMaker.args[playlistIndex].args["track"..trackIndex.."_H_NoStart"].hidden = false
								playListMaker.args[playlistIndex].args["track"..trackIndex.."_I_StartSound"].hidden = false
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_J_StartVol"].hidden = false
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_K_NoVict"].hidden = false
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_L_VictSound"].hidden = false
			playListMaker.args[playlistIndex].args["track"..trackIndex.."_M_VictVol"].hidden = false
			else
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_H_NoStart"].hidden = true
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_I_StartSound"].hidden = true
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_J_StartVol"].hidden = true
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_K_NoVict"].hidden = true
				playListMaker.args[playlistIndex].args["track"..trackIndex.."_L_VictSound"].hidden = true

				playListMaker.args[playlistIndex].args["track"..trackIndex.."_M_VictVol"].hidden = true
			end
		
		end }
playListMaker.args[playlistIndex].args["track"..trackIndex.."_G_Full"] = {type = "header" ,order = 25  +( 17* trackIndex),name= ""}
playListMaker.args[playlistIndex].args.PlaylistReuseRange.max = #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks
playListMaker.args[playlistIndex].args["track"..trackIndex.."_H_NoStart"] = {hidden = true, width = "full", type = "toggle", name = L["PLAYLIST_USE_START"], 
	get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].UseStart end,
	set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].UseStart = val end,
	order = 19  +( 17* trackIndex) }

playListMaker.args[playlistIndex].args["track"..trackIndex.."_I_StartSound"] = {name = L["CREATE_CUST_TRACKS_START_GROUP"], hidden = true, width = "full", type = "select", values = SoundListUI, 
get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex].track end,
	set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex].track = val end,
	order  = 20  +( 17* trackIndex) }

playListMaker.args[playlistIndex].args["track"..trackIndex.."_J_StartVol"] =  {name = L["PLAYLIST_START_VOL"], hidden = true, width = "full", type = "range", min =0, max = 1, step = 0.1,
get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex].Vol end,
	set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[trackIndex].Vol = val end,
	order  = 22  +( 17* trackIndex) }

playListMaker.args[playlistIndex].args["track"..trackIndex.."_K_NoVict"] = {hidden = true, width = "full", type = "toggle", name = L["PLAYLIST_USE_VICT"] , 
	get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].UseVictory end,
	set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].UseVictory = val end,
	order = 22  +( 17* trackIndex) }
	playListMaker.args[playlistIndex].args["track"..trackIndex.."_L_VictSound"] = {name = L["CREATE_CUST_TRACKS_VICTORY"], hidden = true, width = "full", type = "select", values = SoundListUI, 
get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex].track end,
	set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex].track = val end,
	order  = 23  +( 17* trackIndex) }
playListMaker.args[playlistIndex].args["track"..trackIndex.."_M_VictVol"] =  {name = L["PLAYLIST_VICT_VOL"], hidden = true, width = "full", type = "range", min =0, max = 1, step = 0.1,
get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex].Vol end,
	set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].VictoryTracks[trackIndex].Vol = val end,
	order  = 24  +( 17* trackIndex) }
	--.StartTracks[trackIndex2] ={track = oldStartTrack, Vol = oldStartVol}
end
--playListMaker.args[playlistIndex].args.PlaylistReuseRange.max

local testingPlaylist = nil
local testingCurrentTrack = 1
local testingTimer = nil
local testingPlaylistOldVolume = 1
local testingMusicOn = true
function PetBattlePokemonMusic:TestPlaylistPlayAfterStart(playlistIndex)
	testingPlaylist = playlistIndex
	--TODO Change Sound Volume for AFTER Start Sound ends
	local trackID = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].track
	SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].Vol )
	PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
	testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)

end
function PetBattlePokemonMusic:TestPlaylistPlay(playlistIndex)
	PetBattlePokemonMusic:TestPlaylistStop()
	
	testingPlaylistOldVolume = GetCVar("Sound_MusicVolume")

	testingMusicOn = GetCVar("Sound_EnableMusic")
	SetCVar("Sound_EnableMusic", 1 )
	--SetCVar("Sound_MusicVolume", OldMusicVolume )
	testingPlaylist = playlistIndex
	PetBattlePokemonMusic:disableTrackControls(playlistIndex, true)
	playListMaker.args[playlistIndex].args.PlaylistReuseRange.disabled = true
	if PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Type == 1 then
	
	--Standard
			
	local trackID = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].track

		if  PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].UseStart then
				local startEffect = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].StartTracks[testingCurrentTrack].track

				if PetBattlePokemonMusic.db.global.SoundLibrary[startEffect] ~= nil then
					--TODO Change Sound Volume for Start Sound
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
					testingTimer = self:ScheduleTimer("TestPlaylistPlayAfterStart", PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length,testingPlaylist )
				else
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].Vol )
					PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
					testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
				end
		else
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].Vol )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		end
	--print(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		
	else
		PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks = {}
		for k,v in pairs (PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks) do
			tinsert(PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks, k)
		end
		local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks)
		testingCurrentTrack =  PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom]
		tinsert (PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom, {Track = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom], Wait = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RandomReuse})
		--print("Playing Track: " .. PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom])
		local trackID = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom]].track
		if  PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].UseStart then
				local startEffect = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].StartTracks[testingCurrentTrack].track

				if PetBattlePokemonMusic.db.global.SoundLibrary[startEffect] ~= nil then
					--TODO Change Sound Volume for Start Sound
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
					testingTimer = self:ScheduleTimer("TestPlaylistPlayAfterStart", PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length,testingPlaylist )
				else
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].Vol )
					PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
					testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
				end
		else
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].Vol )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		end
		--SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom]].Vol )
		--PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		--testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		tremove (PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks, nextRandom)

		for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom) do
			PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Wait = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Wait - 1
			
			
			--print("On Wait: "..PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Track.." Wait = "..PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Wait )
		end
		while #PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom > PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RandomReuse do
			tinsert(PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks, PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[1].Track)
			tremove(PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom, 1)
		end

	end

end
function PetBattlePokemonMusic:disableTrackControls(playlistIndex, boo)
	if playListMaker.args[playlistIndex] ~= nil then
		playListMaker.args[playlistIndex].args.PlaylistReuseRange.disabled = boo
		for trackIndex, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks) do
			playListMaker.args[playlistIndex].args["track"..trackIndex.."_A_Name"].disabled = boo

			--playListMaker.args[playlistIndex].args["track"..trackIndex.."_D_Volume"].disabled = boo

			playListMaker.args[playlistIndex].args["track"..trackIndex.."_B_Up"].disabled = boo
			playListMaker.args[playlistIndex].args["track"..trackIndex.."_C_Down"].disabled = boo
			playListMaker.args[playlistIndex].args["track"..trackIndex.."_E_Remove"].disabled = boo
			playListMaker.args[playlistIndex].args["track"..trackIndex.."_F_Full"].disabled = boo
			playListMaker.args[playlistIndex].args["track"..trackIndex.."_G_Full"].disabled = boo
		end
	end
end
function PetBattlePokemonMusic:TestPlaylistStop()

	if testingPlaylist ~= nil then
		playListMaker.args[testingPlaylist].args.PlaylistReuseRange.disabled = false
		PetBattlePokemonMusic:disableTrackControls(testingPlaylist, false)
		testingCurrentTrack = 1
		StopMusic();
		SetCVar("Sound_EnableMusic", testingMusicOn )
		SetCVar("Sound_MusicVolume", testingPlaylistOldVolume )
		testingPlaylist = nil
		if testingTimer ~= nil then
			self:CancelTimer(testingTimer,true)
		end
	end
	
end
function PetBattlePokemonMusic:TestPlaylistPrev ()
	if PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist] ~= nil then
	
		self:CancelTimer(testingTimer, true)
	--PetBattlePokemonMusic.db.global.PlayLists[playlistIndex]
	--{Tracks = {}, Type = 1, CurrentTrack = 1, PlayedRandom = {}, MissingTracks = {}, RemainingTracks = {}, Continuous = false, UseStart = false, UseVictory = false, StartTrack = 0, VictoryTrack = 0, RandomReuse = 0}
		if PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Type == 1 then
	
			--Standard
			if 1 < testingCurrentTrack then
				testingCurrentTrack = testingCurrentTrack - 1
			else
				testingCurrentTrack = #PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks
			end
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].track
			--print(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].Vol )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		else
	
		end
	end
end
function PetBattlePokemonMusic:RemovePlaylistUI(playlistIndex)
	playListMaker.args[playlistIndex] = nil
end
function PetBattlePokemonMusic:DeletePlaylist(playlistIndex)
	if testingPlaylist == playlistIndex then
		PetBattlePokemonMusic:TestPlaylistStop()
		testingPlaylist = nil

	end
	 PetBattlePokemonMusic.db.global.PlayLists[playlistIndex] = nil
end
function PetBattlePokemonMusic:TestPlaylistNext()
	if PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist] ~= nil then

	self:CancelTimer(testingTimer, true)
	--PetBattlePokemonMusic.db.global.PlayLists[playlistIndex]
	--{Tracks = {}, Type = 1, CurrentTrack = 1, PlayedRandom = {}, MissingTracks = {}, RemainingTracks = {}, Continuous = false, UseStart = false, UseVictory = false, StartTrack = 0, VictoryTrack = 0, RandomReuse = 0}
		if PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Type == 1 then
	
			--Standard
			if #PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks > testingCurrentTrack then
				testingCurrentTrack = testingCurrentTrack + 1
			else
				testingCurrentTrack = 1
			end
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].track
			--print(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[testingCurrentTrack].Vol )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		else
			
		local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks)
		testingCurrentTrack =  PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom]
		tinsert (PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom, {Track = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom], Wait = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RandomReuse})
		--print("Playing Track: " .. PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom])
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom]].track
		SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks[nextRandom]].Vol )
		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		testingTimer = self:ScheduleTimer("TestPlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		tremove (PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks, nextRandom)

			for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom) do
			PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Wait = PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Wait - 1
			
			
			--print("On Wait: "..PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Track.." Wait = "..PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[k].Wait )
		end
		while #PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom > PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RandomReuse do
			tinsert(PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].RemainingTracks, PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom[1].Track)
			tremove(PetBattlePokemonMusic.db.global.PlayLists[testingPlaylist].PlayedRandom, 1)
		end
		end
	end
end

function PetBattlePokemonMusic:AddPlaylistToUI (playlistIndex)
	--TODO  add to Playlists dropdown

	PlaylistList = {}
PetBattlePokemonMusic:FillPlaylistList()

playListMaker.args[playlistIndex] = {type = "group", name = playlistIndex, args = {
						PlayListTypeSelect = {	width = "full",
												order = 1 ,
												type = "select", 
												values = PlayListTypes, 
												name = L["PLAYLIST_TYPE"], 
												get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Type end, 
												set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Type = val end},
						--PlaylistUsesStartSound = {type = "toggle", order = 2, name = L["START_SOUND"], get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].UseStart end, set = function (info, val)  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].UseStart = val end},
						--PlaylistUsesVictorySound = {type = "toggle", order = 2, name = L["VICTORY_SOUND"], get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].UseVictory end, set = function (info, val)  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].UseVictory = val end},
						PlaylistContinuous = {type = "toggle", order = 2, name =L["PLAYLIST_CONT"], get = function () return PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Continuous end, set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Continuous = val end},
						PlaylistReuseRange = {type = "range", name = L["PLAYLIST_RAND_WAIT"], order = 3, get = function () return  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RandomReuse end, set = function (info, val) PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RandomReuse = val end, min  = 0,
																							max  = #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks,
										
													step = 1},
						PlaylistAddTrackList = {type = "select", name = L["PLAYLIST_NEW_TRACK"], order = 4, values = SoundListUI, get = function () return tempNewTrack end, set = function (info, val) tempNewTrack = val end, width = "full"},
						PlaylistAddTrackButton = {type = "execute", name = L["BP_SOUNDS_ADD"], order = 5, func = function ()
							
							PetBattlePokemonMusic:AddTrackToPlaylist(playlistIndex, SoundListUI[tempNewTrack])
							PetBattlePokemonMusic:AddTrackToPlaylistUI(playlistIndex, #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks)
						
						end, width = "full"},
						PlaylistPrevious = {type = "execute", 
											name = L["PLAYLIST_PREV"], 
											order = 7,
											width = "half",
											func = function () PetBattlePokemonMusic:TestPlaylistPrev() end},
						PlaylistStop = {	type = "execute", 
											name = "Stop", 
											order = 8,
											width = "half",
											func = function () PetBattlePokemonMusic:TestPlaylistStop() end},
						PlaylistPlay = {	type = "execute", 
											name = L["SOUND_FILE_PLAY"], 
											order = 9,
											width = "half",
											func = function () PetBattlePokemonMusic:TestPlaylistPlay(playlistIndex) end},
						PlaylistSkip = {	type = "execute", 
											name = L["PLAYLIST_SKIP"], 
											order = 10,
											width = "half",
											func = function ()PetBattlePokemonMusic:TestPlaylistNext() end},
						PlaylistDelete = {	type ="execute",
											name = L["SOUND_FILE_DELETE"],
											width = "full",
											order = 11,
											func = function ()
											PetBattlePokemonMusic:RemovePlaylistUI(playlistIndex)
											PetBattlePokemonMusic:DeletePlaylist(playlistIndex)
											end},
						PlaylistTrackHeader = {type ="header", name =L["PLAYLIST_TRACKS"], order =12}
	
	}



}

end

function PetBattlePokemonMusic:FillPlayLists ()

	

	for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists) do
		PetBattlePokemonMusic:AddPlaylistToUI (k)
		for k2, v2 in pairs (PetBattlePokemonMusic.db.global.PlayLists[k].Tracks) do
			PetBattlePokemonMusic:AddTrackToPlaylistUI(k, k2)
		end
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

--WildTracks[x] = {Type = <1,2,3>, Premade = #, Custom = #, Playlist = <name>, Enabled =<true,false>, Always = <true, false>,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}

local defaults = {
					global={	
								StartSoundOn = true,
								VictorySoundOn = true,
								OldMusicSettings = {Volume = 1, On = true},
								OldSoundSettings = {Volume = 1, On = true},
								InBattle = false,
								WildTracks	= {},
								TamerTracks = {},
								PvPTracks	= {},
								Wild =		{
												MusicType = 1,
												Track		= 3,
												On			= true,
												Always		= true,
												Custom		= false,
												CustomTrack = 1,
												Volume = {Music = 0.5, Master = 0.5},
												Playlist = false,
												PlaylistSelected = 1
											},
								Trainer =	{
												MusicType = 1,
												Track		= 2,
												On			= true,
												Always		= true,
												Custom		= false,
												CustomTrack = 1,
												Volume = {Music = 0.5, Master = 0.5},
												Playlist = false,
												PlaylistSelected = 1
								},
								PvP =	{
												MusicType = 1,
												Track		= 2,
												On			= true,
												Always		= true,
												Custom		= false,
												CustomTrack = 1,
												Volume = {Music = 0.5, Master = 0.5},
												Playlist = false,
												PlaylistSelected = 1
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

function PetBattlePokemonMusic:AddNewWildTrack(wildName)
	PetBattlePokemonMusic.db.global.WildTracks[wildName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
end
function PetBattlePokemonMusic:AddNewTamerTrack(tamerName)
	PetBattlePokemonMusic.db.global.TamerTracks[tamerName] = {	Type = 1, 
																Premade = 1, 
																Custom = 1, 
																Playlist = 1, 
																Enabled =false, 
																Always = false,
																Volume = {Music = 0.5, Master = 0.5}, 
																Start ={}, 
																Victory = {}}
end
function PetBattlePokemonMusic:FillSpecificTamersDB ()
	for k, v in pairs (pveDB.Tamers) do
		if PetBattlePokemonMusic.db.global.TamerTracks[k] == nil then
			PetBattlePokemonMusic:AddNewTamerTrack(k)
		end
	end
end
function PetBattlePokemonMusic:AddNewPvPTrack(playerName)
	PetBattlePokemonMusic.db.global.PvPTracks[playerName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
end
--WildTracks[x] = {Type = <1,2,3>, Premade = #, Custom = #, Playlist = <name>, Enabled =<true,false>, Always = <true, false>,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
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
		--tinsert(SoundListUI,k)
		SoundListUI[k] = k
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
		name = L["MODS"],
		args = {}
	
}
--PvP player name detection method 1
local duelistName = ""
function PetBattlePokemonMusic:DuelCheck(a1, a2)
	if a1 ~= nil then
		if a1.value ~= nil then
			if strmatch( a1.value, "PET_BATTLE_PVP_DUEL") ~= nil then
				name, realm = UnitName("target")
				if realm == nil then
					realm = GetRealmName()
				end
				duelistName = name.."-"..realm
			end
		end
	end
	
end

function PetBattlePokemonMusic:OnInitialize()

	---------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------- Database and Configuration setup  --------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------
	self.db = LibStub("AceDB-3.0"):New("PBPM", defaults)
	self.lt = LibStub("LibTamerID-1.0")
	--PetBattlePokemonMusic.db.global.BPAbilitySounds = {}	

	--TODO Check to see if this line can be removed.
	--PetBattlePokemonMusic:createLocalizedPatterns()
	
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
	local config	= LibStub("AceConfig-3.0")
	local registry	= LibStub("AceConfigRegistry-3.0")

	PetBattlePokemonMusic:FILLSOUNDLIST ()
	PetBattlePokemonMusic:SetUpAbilities()

	registry:RegisterOptionsTable(L["UI_FRAME_MAIN"], main)
	registry:RegisterOptionsTable(L["UI_FRAME_MUSIC"], MusicSetter)
	registry:RegisterOptionsTable(L["UI_FRAME_OTHER"], OtherSounds)
	registry:RegisterOptionsTable(L["UI_FRAME_LIBRARY"],SoundLibrary)

	--registry:RegisterOptionsTable(L["CUST_TRACKS"],CustomTrackLibrary)
	registry:RegisterOptionsTable(L["BP_SOUNDS"],BattlePetAbilitySoundSettings)
	registry:RegisterOptionsTable(L["CUST_TRACKS"],newCustTracks)
	registry:RegisterOptionsTable(L["MODS"],PBPMMods)
	registry:RegisterOptionsTable(L["NEW_MUSIC_SELECT_PLAYLISTS"],playListMaker)
	--MusicSetter

	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionFrames = {
							main		= dialog:AddToBlizOptions(L["UI_FRAME_MAIN"], L["ADDON_NAME"]),
							Wild		= dialog:AddToBlizOptions(L["UI_FRAME_MUSIC"], L["UI_FRAME_MUSIC"], L["ADDON_NAME"]),
							OtherS		=  dialog:AddToBlizOptions(L["UI_FRAME_OTHER"], L["UI_FRAME_OTHER"], L["ADDON_NAME"]),
							Library		= dialog:AddToBlizOptions(L["UI_FRAME_LIBRARY"], L["UI_FRAME_LIBRARY"], L["ADDON_NAME"]),
							playL		= dialog:AddToBlizOptions(L["NEW_MUSIC_SELECT_PLAYLISTS"], L["NEW_MUSIC_SELECT_PLAYLISTS"], L["ADDON_NAME"]),
							Cu			= dialog:AddToBlizOptions(L["CUST_TRACKS"],L["CUST_TRACKS"], L["ADDON_NAME"]),
							--CreateCust	= dialog:AddToBlizOptions(L["UI_FRAME_CREATE_CUST"], L["UI_FRAME_CREATE_CUST"], L["ADDON_NAME"]),
							--Custs		= dialog:AddToBlizOptions(L["CUST_TRACKS"], L["CUST_TRACKS"], L["ADDON_NAME"]),
							BPS			= dialog:AddToBlizOptions(L["BP_SOUNDS"], L["BP_SOUNDS"], L["ADDON_NAME"]),
							mods		= dialog:AddToBlizOptions(L["MODS"], L["MODS"], L["ADDON_NAME"])
							
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
	self:RegisterEvent("UI_ERROR_MESSAGE")
	self:SecureHook("UnitPopup_OnClick","DuelCheck")



	---------------------------------------------------------------------------------------------------------------------------------------------
	PetBattlePokemonMusic:FillSpecificTamersDB ()
	--  Set up Functions.
	PetBattlePokemonMusic:FillCustomTrackList()
	PetBattlePokemonMusic:FillPlaylistList()
	PetBattlePokemonMusic:SetUpMods()
	PetBattlePokemonMusic:SetUpSL()
	PetBattlePokemonMusic:FillCustomWild()
	PetBattlePokemonMusic:FillCustomTrainer()
	
	PetBattlePokemonMusic:FillCustomLib()
	local tempos = LibStub("LibTamerID-1.0")
	PetBattlePokemonMusic:FillTamerList ()
	PetBattlePokemonMusic:FillWildList ()
	PetBattlePokemonMusic:FillPlayLists ()

	--OldMusicSettings = {Volume = 1, On = true},
								--OldSoundSettings = {Volume = 1, On = true},
								--InBattle = false,

end

function PetBattlePokemonMusic:UI_ERROR_MESSAGE(event, message)
	if strmatch( message, "ERR_PETBATTLE_DECLINED") then
		--Erase the playerTamer name in pending.
		duelistName = ""
	end
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

function PetBattlePokemonMusic:GetTamerName ()

	local Pets = {}
	for i = 1, C_PetBattles.GetNumPets(2) do
		Pets[C_PetBattles.GetName(2,i)] = {	Name = C_PetBattles.GetName(2,i),
											Level = C_PetBattles.GetLevel(2,i), 
											Quality =  C_PetBattles.GetBreedQuality(2,i) }
	end
	for key,val in pairs (pveDB.Tamers) do
	local	matches = PetBattlePokemonMusic:TableSize(pveDB.Tamers[key].Pets)
		
		for petName, patData in pairs (Pets) do
			if pveDB.Tamers[key].Pets[petName] ~= nil then
				if Pets[petName].Level == pveDB.Tamers[key].Pets[petName].Level and Pets[petName].Quality == pveDB.Tamers[key].Pets[petName].Quality then
				
				
					matches = matches -1

				end
			end
		end
		if matches == 0 then
			return key
		end
	end
	return L["UNKNOWN"]


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
	local  rere = L["PERT"] (demo[2])
	
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
	
	remake = PET_BATTLE_COMBAT_LOG_DAMAGE;
	remake = string.gsub(remake, " %%s ", " (%%a*) ")
	remake = string.gsub(remake, "%%s", "(.*)")
	remake = string.gsub(remake, "%%d", "%(%%d%*%)")
	remake = string.gsub(remake, "%)%.", "%)%%.")
--	print("Remake: "..remake);
	
	-- ================================================================================================================================================================================= --
	--   Damage
	-- ================================================================================================================================================================================= --
	if rere == nil then
		return false
	end
--"Damage Yours"
if rere.Type == "Damage Yours" then
	d, rqw, qrr = strfind(rere.Ability,BPApattern)
	--print(qrr)
	if PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)]~= nil then
		if PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File]~= nil then
			PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.BPAbilitySounds[tonumber(qrr)].Damage.File].FileName,"Master")
		end
	end
end
if rere.Type == "Damage Enemy" then
	d, rqw, qrr = strfind(rere.Ability,BPApattern)
	--print(qrr)
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

-- PLAYLIST FUNCTIONS


local currentPlaylist = nil
local playlistCurrentTrack = 1
local PlaylistTimer = nil
local currentPlaylistOldVolume = 1
local PlaylistMusicOn = true
local baseVol = 1
function PetBattlePokemonMusic:PlaylistPlay(playlistIndex)
	PetBattlePokemonMusic:PlaylistStop()
	
	currentPlaylistOldVolume = GetCVar("Sound_MusicVolume")

	PlaylistMusicOn = GetCVar("Sound_EnableMusic")
	
	
	--SetCVar("Sound_MusicVolume", OldMusicVolume )
	currentPlaylist = playlistIndex
	SetCVar("Sound_EnableMusic", 1   )
	PetBattlePokemonMusic:disableTrackControls(playlistIndex, true)
	
	if PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Type == 1 then
	
	--Standard
			
	local trackID = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[playlistCurrentTrack].track
		SetCVar("Sound_MusicVolume",baseVol *  PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[playlistCurrentTrack].Vol )
		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		PlaylistTimer = self:ScheduleTimer("PlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
	else
		if PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Continuous == false then
			PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom = {}
			PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks = {}
			for k,v in pairs (PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks) do
				tinsert(PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks, k)
			end
		end
		local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks)
		playlistCurrentTrack =  PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom]
		tinsert (PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom, {Track = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom], Wait = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RandomReuse})
		--print("Playing Track: " .. PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom])
		local trackID = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom]].track
		SetCVar("Sound_MusicVolume",baseVol * PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom]].Vol )
		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		PlaylistTimer = self:ScheduleTimer("PlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		tremove (PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks, nextRandom)

		for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom) do
			PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Wait = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Wait - 1
			
			
			--print("On Wait: "..PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Track.." Wait = "..PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Wait )
		end
		while #PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom > PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RandomReuse do
			tinsert(PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks, PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[1].Track)
			tremove(PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom, 1)
		end

	end

end

function PetBattlePokemonMusic:PlaylistStop()

	if currentPlaylist ~= nil then
		playListMaker.args[currentPlaylist].args.PlaylistReuseRange.disabled = false
		PetBattlePokemonMusic:disableTrackControls(currentPlaylist, false)
		playlistCurrentTrack = 1
		StopMusic();
		SetCVar("Sound_EnableMusic", PlaylistMusicOn )
		SetCVar("Sound_MusicVolume", currentPlaylistOldVolume )
		currentPlaylist = nil
		if PlaylistTimer ~= nil then
			self:CancelTimer(PlaylistTimer,true)
		end
	end
	
end

function PetBattlePokemonMusic:PlaylistNext()
	if PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist] ~= nil then

	self:CancelTimer(PlaylistTimer, true)
	--PetBattlePokemonMusic.db.global.PlayLists[playlistIndex]
	--{Tracks = {}, Type = 1, CurrentTrack = 1, PlayedRandom = {}, MissingTracks = {}, RemainingTracks = {}, Continuous = false, UseStart = false, UseVictory = false, StartTrack = 0, VictoryTrack = 0, RandomReuse = 0}
		if PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Type == 1 then
	
			--Standard
			if #PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks > playlistCurrentTrack then
				playlistCurrentTrack = playlistCurrentTrack + 1
			else
				playlistCurrentTrack = 1
			end
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[playlistCurrentTrack].track
			--print(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			SetCVar("Sound_MusicVolume", baseVol * PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[playlistCurrentTrack].Vol )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			PlaylistTimer = self:ScheduleTimer("PlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		else
			
		local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks)
		playlistCurrentTrack =  PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom]
		tinsert (PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom, {Track = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom], Wait = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RandomReuse})
		--print("Playing Track: " .. PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom])
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom]].track
		SetCVar("Sound_MusicVolume",baseVol * PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].Tracks[PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks[nextRandom]].Vol )
		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		PlaylistTimer = self:ScheduleTimer("PlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		tremove (PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks, nextRandom)

			for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom) do
			PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Wait = PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Wait - 1
			
			
			--print("On Wait: "..PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Track.." Wait = "..PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[k].Wait )
		end
		while #PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom > PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RandomReuse do
			tinsert(PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].RemainingTracks, PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom[1].Track)
			tremove(PetBattlePokemonMusic.db.global.PlayLists[currentPlaylist].PlayedRandom, 1)
		end
		end
	end
end



















function PetBattlePokemonMusic:StartPlaylist(index, mVol, sVol)
	PetBattlePokemonMusic:PlayBattlePlaylist(index, mVol, sVol)
end
local currentBattlePlaylist = {}
--MusicTypes[1] = L["NEW_MUSIC_SELECT_PREMADE"]
--MusicTypes[2] = L["NEW_MUSIC_SELECT_PLAYLIST"]
--MusicTypes[3] = L["NEW_MUSIC_SELECT_CUST"]

--
function PetBattlePokemonMusic:UniversialBattleOpening(name, cbplType, typeName, typeTracks)

		currentBattlePlaylist.Type = cbplType
	if PetBattlePokemonMusic.db.global[typeName].On == false then
		return false
	end
	
	if PetBattlePokemonMusic.db.global[typeTracks][name] ~= nil then
		currentBattlePlaylist.Target = name
		if PetBattlePokemonMusic.db.global[typeTracks][name].Enabled == true then
			--PetBattlePokemonMusic.db.global[typeTracks][wildName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
			if  PetBattlePokemonMusic.db.global[typeTracks][name].Type == 1 then
				--Premade
				
				
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeTracks][name].Premade] ~= nil then
					--print(PetBattlePokemonMusic.db.global[typeTracks][name].Premade)
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Music * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Music)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Master)
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeTracks][name].Premade].StartSoundKey ] .FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )

							
																	PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeTracks][name].Premade].MusicKey].FileName) end,
																	PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeTracks][name].Premade].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeTracks][name].Premade]].MusicKey].FileName)
					end
				end
			end
			if  PetBattlePokemonMusic.db.global[typeTracks][name].Type == 2 then
				--Playlist
				
				local playlistKey = PetBattlePokemonMusic.db.global[typeTracks][name].Playlist
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global[typeName].Volume.Music * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Music, PetBattlePokemonMusic.db.global[typeName].Volume.Master * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global[typeTracks][name].Type == 3 then
				--Custom
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeTracks][name].Custom] ~= nil then
					
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Music * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Music *  PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeTracks][name].Custom].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Master)
					if PetBattlePokemonMusic:IsStartEnabled() then
						SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeTracks][name].Custom].StartVol)
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeTracks][name].Custom].StartSoundKey ] .FileName, "Master")
						--PetBattlePokemonMusic.db.global.CustomTracks[
						--print(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeTracks][name].Premade])
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master * PetBattlePokemonMusic.db.global[typeTracks][name].Volume.Master)
							--PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeTracks][name].Custom].MusicKey].FileName) 
end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeTracks][name].Custom].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeTracks][name].Custom].MusicKey].FileName) 
					
					end
			--		if PetBattlePokemonMusic.db.global[typeName].Custom == false then
		--		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName)
	--		else
	--			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName)
--			end
				end
			end
		else
				--	Trainer =	{
			--									MusicType = 1,
			--									Track		= 2,
			--									On			= true,
			--									Always		= true,
			--									Custom		= false,
			--									CustomTrack = 1,
			--									Volume = {Music = 0.5, Master = 0.5},
			--									Playlist = false,
			--									PlaylistSelected = 1

			if  PetBattlePokemonMusic.db.global[typeName].MusicType == 2 then
				
				local playlistKey = PetBattlePokemonMusic.db.global[typeName].Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global[typeName].Volume.Music , PetBattlePokemonMusic.db.global[typeName].Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global[typeName].MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName)
					end
				end

			end
			
			
			if  PetBattlePokemonMusic.db.global[typeName].MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global[typeName].CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Music* PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].MusicVol )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].StartVol)
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName)
					end

				end
			end

		end
	else

	if  PetBattlePokemonMusic.db.global[typeName].MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName) end
							,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName)
					end
				end

	end
		
			if  PetBattlePokemonMusic.db.global[typeName].MusicType == 2 then
				

				local playlistKey = PetBattlePokemonMusic.db.global[typeName].Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global[typeName].Volume.Music , PetBattlePokemonMusic.db.global[typeName].Volume.Master)
			end
		if  PetBattlePokemonMusic.db.global[typeName].MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global[typeName].CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Music * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].StartVol)
					--PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track]
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global[typeName].Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global[typeName].Track].MusicKey].FileName)
					end

				end
			end
	end
end
function PetBattlePokemonMusic:TamerBattleOpening(name)

		currentBattlePlaylist.Type = "Tamer"
	if PetBattlePokemonMusic.db.global.Trainer.On == false then
		return false
	end
	
	if PetBattlePokemonMusic.db.global.TamerTracks[name] ~= nil then
		currentBattlePlaylist.Target = name
		if PetBattlePokemonMusic.db.global.TamerTracks[name].Enabled == true then
			--PetBattlePokemonMusic.db.global.TamerTracks[wildName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
			if  PetBattlePokemonMusic.db.global.TamerTracks[name].Type == 1 then
				--Premade
				
				
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[name].Premade] ~= nil then
					--print(PetBattlePokemonMusic.db.global.TamerTracks[name].Premade)
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Music)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Master)
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[name].Premade].StartSoundKey ] .FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () 
							SetCVar("Sound_EnableMusic", 1 )
							
																	
							PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[name].Premade].MusicKey].FileName) end,
																	
							PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[name].Premade].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[name].Premade]].MusicKey].FileName)
					end
				end
			end
			if  PetBattlePokemonMusic.db.global.TamerTracks[name].Type == 2 then
				--Playlist
				
				local playlistKey = PetBattlePokemonMusic.db.global.TamerTracks[name].Playlist
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.Trainer.Volume.Music * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Music, PetBattlePokemonMusic.db.global.Trainer.Volume.Master * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global.TamerTracks[name].Type == 3 then
				--Custom
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[name].Custom] ~= nil then
					
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Music  * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[name].Custom].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Master )
					if PetBattlePokemonMusic:IsStartEnabled() then
						SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[name].Custom].StartVol )
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[name].Custom].StartSoundKey ] .FileName, "Master")
						--PetBattlePokemonMusic.db.global.CustomTracks[
						--print(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[name].Premade])
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master * PetBattlePokemonMusic.db.global.TamerTracks[name].Volume.Master )
							--PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[name].Custom].MusicKey].FileName) 
end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[name].Custom].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[name].Custom].MusicKey].FileName) 
					
					end
			--		if PetBattlePokemonMusic.db.global.Trainer.Custom == false then
		--		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
	--		else
	--			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
--			end
				end
			end
		else
				--	Trainer =	{
			--									MusicType = 1,
			--									Track		= 2,
			--									On			= true,
			--									Always		= true,
			--									Custom		= false,
			--									CustomTrack = 1,
			--									Volume = {Music = 0.5, Master = 0.5},
			--									Playlist = false,
			--									PlaylistSelected = 1
			print( PetBattlePokemonMusic.db.global.Trainer.MusicType)
			if  PetBattlePokemonMusic.db.global.Trainer.MusicType == 2 then
				
				local playlistKey = PetBattlePokemonMusic.db.global.Trainer.Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.Trainer.Volume.Music , PetBattlePokemonMusic.db.global.Trainer.Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global.Trainer.MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
					end
				end

			end
			
			
			if  PetBattlePokemonMusic.db.global.Trainer.MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global.Trainer.CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
					if PetBattlePokemonMusic:IsStartEnabled() then
						SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master* PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].StartVol )
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
					end

				end
			end

		end
	else

	if  PetBattlePokemonMusic.db.global.Trainer.MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName) end
							,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
					end
				end

	end
		
			if  PetBattlePokemonMusic.db.global.Trainer.MusicType == 2 then
				

				local playlistKey = PetBattlePokemonMusic.db.global.Trainer.Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.Trainer.Volume.Music , PetBattlePokemonMusic.db.global.Trainer.Volume.Master)
			end
		if  PetBattlePokemonMusic.db.global.Trainer.MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global.Trainer.CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Music * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then
						SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].StartVol)
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
					end

				end
			end
	end
end
function PetBattlePokemonMusic:PvPBattleOpening(name)

		currentBattlePlaylist.Type = "PvP"
	if PetBattlePokemonMusic.db.global.PvP.On == false then
		return false
	end
	
	if PetBattlePokemonMusic.db.global.PvPTracks[name] ~= nil then
		currentBattlePlaylist.Target = name
		if PetBattlePokemonMusic.db.global.PvPTracks[name].Enabled == true then
			--PetBattlePokemonMusic.db.global.PvPTracks[PvPName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
			if  PetBattlePokemonMusic.db.global.PvPTracks[name].Type == 1 then
				--Premade
				
				
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[name].Premade] ~= nil then
					--print(PetBattlePokemonMusic.db.global.PvPTracks[name].Premade)
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Music * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Music)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Master)
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[name].Premade].StartSoundKey ] .FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )

							
																	PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[name].Premade].MusicKey].FileName) end,
																	PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[name].Premade].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[name].Premade]].MusicKey].FileName)
					end
				end
			end
			if  PetBattlePokemonMusic.db.global.PvPTracks[name].Type == 2 then
				--Playlist
				
				local playlistKey = PetBattlePokemonMusic.db.global.PvPTracks[name].Playlist
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.PvP.Volume.Music * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Music, PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global.PvPTracks[name].Type == 3 then
				--Custom
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[name].Custom] ~= nil then
					
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Music * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Music *  PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[name].Custom].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Master)
					if PetBattlePokemonMusic:IsStartEnabled() then
						SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[name].Custom].StartVol)
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[name].Custom].StartSoundKey ] .FileName, "Master")
						--PetBattlePokemonMusic.db.global.CustomTracks[
						--print(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[name].Premade])
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.PvPTracks[name].Volume.Master)
							--PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[name].Custom].MusicKey].FileName) 
end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[name].Custom].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[name].Custom].MusicKey].FileName) 
					
					end
			--		if PetBattlePokemonMusic.db.global.PvP.Custom == false then
		--		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName)
	--		else
	--			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName)
--			end
				end
			end
		else
				--	Trainer =	{
			--									MusicType = 1,
			--									Track		= 2,
			--									On			= true,
			--									Always		= true,
			--									Custom		= false,
			--									CustomTrack = 1,
			--									Volume = {Music = 0.5, Master = 0.5},
			--									Playlist = false,
			--									PlaylistSelected = 1
			print( PetBattlePokemonMusic.db.global.PvP.MusicType)
			if  PetBattlePokemonMusic.db.global.PvP.MusicType == 2 then
				
				local playlistKey = PetBattlePokemonMusic.db.global.PvP.Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.PvP.Volume.Music , PetBattlePokemonMusic.db.global.PvP.Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global.PvP.MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName)
					end
				end

			end
			
			
			if  PetBattlePokemonMusic.db.global.PvP.MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global.PvP.CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Music* PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].MusicVol )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].StartVol)
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName)
					end

				end
			end

		end
	else

	if  PetBattlePokemonMusic.db.global.PvP.MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName) end
							,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName)
					end
				end

	end
		
			if  PetBattlePokemonMusic.db.global.PvP.MusicType == 2 then
				

				local playlistKey = PetBattlePokemonMusic.db.global.PvP.Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.PvP.Volume.Music , PetBattlePokemonMusic.db.global.PvP.Volume.Master)
			end
		if  PetBattlePokemonMusic.db.global.PvP.MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global.PvP.CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Music * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].StartVol)
					--PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track]
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName)
					end

				end
			end
	end
end
function PetBattlePokemonMusic:WildBattleOpening(name)

		currentBattlePlaylist.Type = "Wild"
	if PetBattlePokemonMusic.db.global.Wild.On == false then
		return false
	end
	
	if PetBattlePokemonMusic.db.global.WildTracks[name] ~= nil then
		currentBattlePlaylist.Target = name
		if PetBattlePokemonMusic.db.global.WildTracks[name].Enabled == true then
			--PetBattlePokemonMusic.db.global.WildTracks[wildName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
			if  PetBattlePokemonMusic.db.global.WildTracks[name].Type == 1 then
				--Premade
				
				
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[name].Premade] ~= nil then
					--print(PetBattlePokemonMusic.db.global.WildTracks[name].Premade)
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Music)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Master)
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[name].Premade].StartSoundKey ] .FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )

							
																	PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[name].Premade].MusicKey].FileName) end,
																	PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[name].Premade].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[name].Premade]].MusicKey].FileName)
					end
				end
			end
			if  PetBattlePokemonMusic.db.global.WildTracks[name].Type == 2 then
				--Playlist
				
				local playlistKey = PetBattlePokemonMusic.db.global.WildTracks[name].Playlist
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.Wild.Volume.Music * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Music, PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global.WildTracks[name].Type == 3 then
				--Custom
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[name].Custom] ~= nil then
					
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Music *  PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[name].Custom].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Master)
					if PetBattlePokemonMusic:IsStartEnabled() then
						SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[name].Custom].StartVol)
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[name].Custom].StartSoundKey ] .FileName, "Master")
						--PetBattlePokemonMusic.db.global.CustomTracks[
						--print(PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[name].Premade])
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.WildTracks[name].Volume.Master)
							--PetBattlePokemonMusic.db.global.CustomTracks[trackID].MusicKey
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[name].Custom].MusicKey].FileName) 
end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[name].Custom].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[name].Custom].MusicKey].FileName) 
					
					end
			--		if PetBattlePokemonMusic.db.global.Wild.Custom == false then
		--		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName)
	--		else
	--			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName)
--			end
				end
			end
		else
				--	Trainer =	{
			--									MusicType = 1,
			--									Track		= 2,
			--									On			= true,
			--									Always		= true,
			--									Custom		= false,
			--									CustomTrack = 1,
			--									Volume = {Music = 0.5, Master = 0.5},
			--									Playlist = false,
			--									PlaylistSelected = 1
			print( PetBattlePokemonMusic.db.global.Wild.MusicType)
			if  PetBattlePokemonMusic.db.global.Wild.MusicType == 2 then
				
				local playlistKey = PetBattlePokemonMusic.db.global.Wild.Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.Wild.Volume.Music , PetBattlePokemonMusic.db.global.Wild.Volume.Master)
			end
			if  PetBattlePokemonMusic.db.global.Wild.MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName)
					end
				end

			end
			
			
			if  PetBattlePokemonMusic.db.global.Wild.MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global.Wild.CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music* PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].MusicVol )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].StartVol)
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName)
					end

				end
			end

		end
	else

	if  PetBattlePokemonMusic.db.global.Wild.MusicType == 1 then
				--Premade
				if PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music )
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master )
					
					if PetBattlePokemonMusic:IsStartEnabled() then

						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName) end
							,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName)
					end
				end

	end
		
			if  PetBattlePokemonMusic.db.global.Wild.MusicType == 2 then
				

				local playlistKey = PetBattlePokemonMusic.db.global.Wild.Track
				PetBattlePokemonMusic:StartPlaylist(playlistKey, PetBattlePokemonMusic.db.global.Wild.Volume.Music , PetBattlePokemonMusic.db.global.Wild.Volume.Master)
			end
		if  PetBattlePokemonMusic.db.global.Wild.MusicType == 3 then
				--Custom
				--PetBattlePokemonMusic.db.global.Wild.CustomTrack
				if PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track] ~= nil then
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Music * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].MusicVol)
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].StartVol)
					--PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track]
					if PetBattlePokemonMusic:IsStartEnabled() then
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].FileName, "Master")
						battleTimer =	self:ScheduleTimer(function () SetCVar("Sound_EnableMusic", 1 )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName) end,PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].StartSoundKey].Length)
					else
						SetCVar("Sound_EnableMusic", 1 )
						PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].MusicKey].FileName)
					end

				end
			end
	end
end

---This function handles the event when a pet battle starts.
--@param event Event Name
function PetBattlePokemonMusic:PET_BATTLE_OPENING_START(event,...)

	--Save the old volumes.
	--OldMusicVolume = GetCVar("Sound_MusicVolume")
	--OldMasterVolume = GetCVar("Sound_MasterVolume")
	if PetBattlePokemonMusic.db.global.InBattle == false then
		
		PetBattlePokemonMusic.db.global.OldMusicSettings.Volume = GetCVar("Sound_MusicVolume")
		PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
		PetBattlePokemonMusic.db.global.OldMusicSettings.On = GetCVar("Sound_EnableMusic")
		PetBattlePokemonMusic.db.global.InBattle = true		
		--print("Saving volumes:  "..PetBattlePokemonMusic.db.global.OldSoundSettings.Volume)
	end

	--Determine the type of battle.
	local battleType = PetBattlePokemonMusic:DetermineBattleType ()
	if battleType == L["WILD"]  then
		--Check to see if the 
		
		local name, speciesName = C_PetBattles.GetName(2,1)
		PetBattlePokemonMusic:WildBattleOpening(name)
	end
	if battleType == L["TAMER"]  then
		--PetBattlePokemonMusic:TamerBattleOpening(PetBattlePokemonMusic:GetTamerName ())
		PetBattlePokemonMusic:UniversialBattleOpening(PetBattlePokemonMusic:GetTamerName (),"Tamer", "Trainer", "TamerTracks")
	end
	if battleType == "PvP"  then
		PetBattlePokemonMusic:PvPBattleOpening(duelistName)

	end
end
--@param event The event name.
function PetBattlePokemonMusic:PET_BATTLE_OVER(event,...)
	demo = {...}
end
---
--
function PetBattlePokemonMusic:VictoryPlayer()
	PetBattlePokemonMusic:EndBattlePlayList()

	StopMusic();
	if PetBattlePokemonMusic.db.global.VictorySoundOn then
		if currentBattlePlaylist.Type == "PvP" then
			if currentBattlePlaylist.Target ~= nil then
				if PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Type == 1 then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Premade].VictoryKey].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Premade].VictoryKey].Length)
					--Premade
				end
				if PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Type == 2 then
					--Playlist
					local currTrack = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].CurrentTrack
					if PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].Tracks[currTrack].UseVictory then
						local startEffect = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].VictoryTracks[currTrack].track
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length)
					end
					--.VictoryTrack[currTrack].track
				end
				if PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Type == 3 then
					--Custom
					--PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Premade
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.PvP.Volume.Master * PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Custom].VictoryVol )
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvPTracks[currentBattlePlaylist.Target].Custom].VictoryKey ] .FileName, "Master")
--SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].VictoryVol)
					--PetBattlePokemonMusic.db.global.CustomTracks[trackID]
				end
			else
				if PetBattlePokemonMusic.db.global.PvP.MusicType == 1 then

					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].VictoryKey].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].VictoryKey].Length)
				end
				if PetBattlePokemonMusic.db.global.PvP.MusicType == 2 then
					--Playlist

					local currTrack = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].CurrentTrack
					if PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].Tracks[currTrack].UseVictory then
						local startEffect = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].VictoryTracks[currTrack].track
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length)
					end
				end
				if PetBattlePokemonMusic.db.global.PvP.MusicType == 3 then
					local volMultiplier = PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].VictoryVol
					
					local victoryEffect =  PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.Track].VictoryKey
					--TODO victory expire timer
					SetCVar("Sound_MasterVolume", GetCVar("Sound_MasterVolume") * volMultiplier )
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[victoryEffect].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[victoryEffect].Length)
					--self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.CustomTrack].VictoryKey].Length)
					--"VictoryExpire"
				end
			end
			local playlistIndex = currentBattlePlaylist.A
		end
		if currentBattlePlaylist.Type == "Tamer" then
			if currentBattlePlaylist.Target ~= nil then
				if PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Type == 1 then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Premade].VictoryKey].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Premade].VictoryKey].Length)
					--Premade
				end
				if PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Type == 2 then

					--PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[trackIndex].UseVictory 
					
					--Playlist
					local currTrack = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].CurrentTrack
					if PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].Tracks[currTrack].UseVictory then
						local startEffect = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].VictoryTracks[currTrack].track
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length)
					--.VictoryTrack[currTrack].track
					end
				end
				if PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Type == 3 then
					--Custom
					--PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Premade
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Trainer.Volume.Master * PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Custom].VictoryVol )
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Custom].VictoryKey ] .FileName, "Master")
--SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].VictoryVol)
					--PetBattlePokemonMusic.db.global.CustomTracks[trackID]
				end
			else
				if PetBattlePokemonMusic.db.global.Trainer.MusicType == 1 then

					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].VictoryKey].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].VictoryKey].Length)
				end
				if PetBattlePokemonMusic.db.global.Trainer.MusicType == 2 then
					--Playlist
					local currTrack = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].CurrentTrack
					if PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].Tracks[currTrack].UseVictory then
						local startEffect = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].VictoryTracks[currTrack].track
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length)
					end
				end
				if PetBattlePokemonMusic.db.global.Trainer.MusicType == 3 then
					local volMultiplier = PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].VictoryVol
					
					local victoryEffect =  PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.Track].VictoryKey
					--TODO victory expire timer
					SetCVar("Sound_MasterVolume", GetCVar("Sound_MasterVolume") * volMultiplier )
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[victoryEffect].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[victoryEffect].Length)
					--self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.CustomTrack].VictoryKey].Length)
					--"VictoryExpire"
				end
			end
			local playlistIndex = currentBattlePlaylist.A
		end
		if currentBattlePlaylist.Type == "Wild" then
			if currentBattlePlaylist.Target ~= nil  then
				if PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target] ~= nil then
				if PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Type == 1 then
					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Premade].VictoryKey].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Premade].VictoryKey].Length)
					--Premade
				end
				if PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Type == 2 then
					--Playlist
					local currTrack = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].CurrentTrack
					if PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].Tracks[currTrack].UseVictory then
						local startEffect = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].VictoryTracks[currTrack].track
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length)
					end
					--.VictoryTrack[currTrack].track
				end
				if PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Type == 3 then
					--Custom
					SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.Wild.Volume.Master * PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Volume.Master * PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Custom].VictoryVol )
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary [ 
						PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Custom].VictoryKey ] .FileName, "Master")
					--PetBattlePokemonMusic.db.global.CustomTracks[trackID]
				end
				end
			else
				if PetBattlePokemonMusic.db.global.Wild.MusicType == 1 then

					PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].VictoryKey].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.Track].VictoryKey].Length)
				end
				if PetBattlePokemonMusic.db.global.Wild.MusicType == 2 then
					--Playlist
					local currTrack = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].CurrentTrack
					if PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].Tracks[currTrack].UseVictory then
						local startEffect = PetBattlePokemonMusic.db.global.PlayLists[currentBattlePlaylist.A].VictoryTracks[currTrack].track
						bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
						self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length)
					end
				end
				if PetBattlePokemonMusic.db.global.Wild.MusicType == 3 then
					local volMultiplier = PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].VictoryVol
					
					local victoryEffect =  PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Wild.Track].VictoryKey
					--TODO victory expire timer
					SetCVar("Sound_MasterVolume", GetCVar("Sound_MasterVolume") * volMultiplier )
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[victoryEffect].FileName, "Master")
					self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[victoryEffect].Length)
					--self:ScheduleTimer("VictoryExpire",PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Wild.CustomTrack].VictoryKey].Length)
					--"VictoryExpire"
				end
			end
			local playlistIndex = currentBattlePlaylist.A
		end
	
	end

end
function PetBattlePokemonMusic:PET_BATTLE_CLOSE(...)

	--PetBattlePokemonMusic:PlaylistStop()
	
	--PetBattlePokemonMusic:VictoryPlayer()
	--PetBattlePokemonMusic.db.global.OldMusicSettings.Volume = GetCVar("Sound_MusicVolume")
	--	PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
	--TODO  Victory check
--	SetCVar("Sound_EnableMusic", PetBattlePokemonMusic.db.global.OldMusicSettings.On )
	--SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.OldMusicSettings.Volume )
--	SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.OldSoundSettings.Volume )
	-- PetBattlePokemonMusic.db.global.InBattle = false
	
	--currentBattlePlaylist = {}
	--TODO:  cancel playlist timer if it is active.
	--TODO:  Reset used playlist if set to.
	--if currentSound ~= nil then
	--	StopSound(currentSound)
	--	currentSound=nil
	--end
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
		PetBattlePokemonMusic:VictoryPlayer()

	end
	
		if PetBattlePokemonMusic.db.global.InBattle == true then
			PetBattlePokemonMusic:EndBattlePlayList()
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.OldMusicSettings.Volume )
			SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.OldSoundSettings.Volume )
			SetCVar("Sound_EnableMusic", PetBattlePokemonMusic.db.global.OldSoundSettings.On )
			PetBattlePokemonMusic.db.global.OldMusicSettings.Volume = GetCVar("Sound_MusicVolume")
			PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
			PetBattlePokemonMusic.db.global.OldSoundSettings.On = GetCVar("Sound_EnableMusic")
			PetBattlePokemonMusic.db.global.InBattle = false

		end
	--end
end
function PetBattlePokemonMusic:VictoryExpire(info,val)
	if PetBattlePokemonMusic.db.global.InBattle == true then
		self:CancelTimer(battleTimer,true)
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.OldMusicSettings.Volume )
			SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.OldSoundSettings.Volume )
			SetCVar("Sound_EnableMusic", PetBattlePokemonMusic.db.global.OldSoundSettings.On )
			PetBattlePokemonMusic.db.global.OldMusicSettings.Volume = GetCVar("Sound_MusicVolume")
			PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
			PetBattlePokemonMusic.db.global.OldSoundSettings.On = GetCVar("Sound_EnableMusic")
			PetBattlePokemonMusic.db.global.InBattle = false

		end
end
function PetBattlePokemonMusic:UNIT_SPELLCAST_SUCCEEDED(eveName, unitID, spell, rank, lineID, spellID)
	
	if spellIDs[spellID] ~= nil then
		local mess = "Spell Name: "..spell..", "
		if unitID ~= nil then
			mess = mess .. "Caster = "..unitID
		else
			mess = mess .. "Caster = nil. "
		end
		--print(mess)
	end
end

-- Music Functions

function PetBattlePokemonMusic:SwitchTrack()
--TODO
end
--MusicTypes[1] = L["NEW_MUSIC_SELECT_PREMADE"]
--MusicTypes[2] = L["NEW_MUSIC_SELECT_PLAYLIST"]
--MusicTypes[3] = L["NEW_MUSIC_SELECT_CUST"]
function PetBattlePokemonMusic:PlayBattleTrackSpecific(type, target)
	
	if type == L["WILD"]  then
		--PetBattlePokemonMusic.db.global.WildTracks[wildName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
		if PetBattlePokemonMusic.db.global.WildTracks[target].Type == 1 then
		--Check if play start.

			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.WildTracks[target].Volume.Music )
			SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.WildTracks[target].Volume.Master )
			if PetBattlePokemonMusic:IsStartEnabled() then
				bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[target].Premade].StartSoundKey].FileName, "Master")
				battleTimer = self:ScheduleTimer(function ()
				if PetBattlePokemonMusic.db.global.WildTracks[target].Always then
					SetCVar("Sound_EnableMusic", 1 )
				end
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[target].Premade].MusicKey].FileName)
				end,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[target].Premade].StartSoundKey].Length)
			else
						
							end
		end
		if PetBattlePokemonMusic.db.global.WildTracks[target].Type == 2 then
		
		end
		if PetBattlePokemonMusic.db.global.WildTracks[target].Type == 3 then
			--Check if play start.
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.WildTracks[target].Volume.Music )
			SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.WildTracks[target].Volume.Master )
			if PetBattlePokemonMusic:IsStartEnabled() then
				bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[target].Custom].StartSoundKey].FileName, "Master")
				battleTimer = self:ScheduleTimer(function ()
				if PetBattlePokemonMusic.db.global.WildTracks[target].Always then
					SetCVar("Sound_EnableMusic", 1 )
				end
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[target].Custom].MusicKey].FileName)
				end,PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.WildTracks[target].Custom].StartSoundKey].Length)
			else
							
							end
		end
		
	end

	--if PetBattlePokemonMusic.db.global.Trainer.Custom == false then
		--		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.Trainer.Track].MusicKey].FileName)
			--else
			--	PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.Trainer.CustomTrack].MusicKey].FileName)
			--end
	if type == "Trainer" then
		--PetBattlePokemonMusic.db.global.WildTracks[wildName] = {Type = 1, Premade = 1, Custom = 1, Playlist = 1, Enabled =true, Always = true,Volume = {Music = 0.5, Master = 0.5}, Start ={}, Victory = {}}
		if PetBattlePokemonMusic.db.global.TamerTracks[target].Type == 1 then
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.TamerTracks[target].Volume.Music )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.TamerTracks[target].Volume.Master )
			if PetBattlePokemonMusic.db.global.TamerTracks[target].Always then
			SetCVar("Sound_EnableMusic", 1 )
		end
	
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[target].Premade].MusicKey].FileName)
		end
		if PetBattlePokemonMusic.db.global.TamerTracks[target].Type == 2 then

		end
		if PetBattlePokemonMusic.db.global.TamerTracks[target].Type == 3 then
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.TamerTracks[target].Volume.Music )
							SetCVar("Sound_MasterVolume", PetBattlePokemonMusic.db.global.TamerTracks[target].Volume.Master )
			if PetBattlePokemonMusic.db.global.TamerTracks[target].Always then
			SetCVar("Sound_EnableMusic", 1 )
			end
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.TamerTracks[target].Custom].MusicKey].FileName)
			--PlayMusic(PetBattlePokemonMusic.db.global.CustomTracks[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.TamerTracks[target].Custom].MusicKey].FileName)
		end
		
	end

end
function PetBattlePokemonMusic:PlayBattleTrackPvP()
	if PetBattlePokemonMusic.db.global.PvP.Always then
			SetCVar("Sound_EnableMusic", 1 )
	end
	if PetBattlePokemonMusic.db.global.PvP.On then
			if PetBattlePokemonMusic.db.global.PvP.Custom == false then
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PokemonBattleMusicEffects[PetBattlePokemonMusic.db.global.PvP.Track].MusicKey].FileName)
			else
				PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[PetBattlePokemonMusic.db.global.CustomTracks[PetBattlePokemonMusic.db.global.PvP.CustomTrack].MusicKey].FileName)
			end
		end
end
function PetBattlePokemonMusic:PlayBattleTrack()
	--OldMusicValue = GetCVar("Sound_EnableMusic")

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
										name = L["MODS_OVERWRITE"],
										confirmText = L["MODS_OVERWRITE_CONFIRM_TEXT"],
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
										name = L["MODS_OVERWRITE_MERGE"],
										confirmText = L["MODS_OVERWRITE_MERGE_CONFIRM_TEXT"],
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
										name = L["MODS_OVERWRITE_APP"],
										confirmText = L["MODS_OVERWRITE_APP_CONFIRM_TEXT"],
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
										name = L["REMOVE_MODS"],
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
															name = L["MODS_ABILITY_SOUNDS"],
															order = 4,
															desc = L["MODS_ABILITY_SOUNDS_DESC"]
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
function PetBattlePokemonMusic:TableSize(tab)
	local count = 0
	for key, val in pairs (tab) do
		count = count +1
	end
	return count
end

function PetBattlePokemonMusic:PlaylistMusicEnabler()
	if currentBattlePlaylist.Type == "Wild" then
		if  PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target] ~= nil then
			if PetBattlePokemonMusic.db.global.WildTracks[currentBattlePlaylist.Target].Always then
				SetCVar("Sound_EnableMusic", 1 )
			end
		else
			if PetBattlePokemonMusic.db.global.Wild.Always then
				SetCVar("Sound_EnableMusic", 1 )
			end
		end
	end
	if currentBattlePlaylist.Type == "Tamer" then
		if  PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target] ~= nil then
			if PetBattlePokemonMusic.db.global.TamerTracks[currentBattlePlaylist.Target].Always then
				SetCVar("Sound_EnableMusic", 1 )
			end
		else
			if PetBattlePokemonMusic.db.global.Trainer.Always then
				SetCVar("Sound_EnableMusic", 1 )
			end
		end
	end
end
function PetBattlePokemonMusic:PlayBattlePlaylist(playlistIndex, baseVolume, soundVol)

	PetBattlePokemonMusic:TestPlaylistStop()
	currentBattlePlaylist.A = playlistIndex
	currentBattlePlaylist.B = baseVolume
	currentBattlePlaylist.C = soundVol
	--
	--
	playlistIndexOldVolume = GetCVar("Sound_MusicVolume")

	--testingMusicOn = GetCVar("Sound_EnableMusic")
	--SetCVar("Sound_EnableMusic", 1 )
	--SetCVar("Sound_MusicVolume", OldMusicVolume )

	PetBattlePokemonMusic:disableTrackControls(playlistIndex, true)
	playListMaker.args[playlistIndex].args.PlaylistReuseRange.disabled = true
	if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Type == 1 then
	
	--Standard
		local currentTrack = 1
		if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Continuous == true then
			currentTrack = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack
		end
		local trackID = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].track

		if  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].UseStart then
				local startEffect = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[1].track

				if PetBattlePokemonMusic.db.global.SoundLibrary[startEffect] ~= nil and PetBattlePokemonMusic.db.global.StartSoundOn == true then
					--TODO Change Sound Volume for Start Sound
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
					BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlayAfterStart", PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length,{A = playlistIndex, B = baseVolume} )
				else
					PetBattlePokemonMusic:PlaylistMusicEnabler()
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].Vol *baseVolume)
					PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
					BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length,{A = playlistIndex, B = baseVolume})
				end
		else

			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].Vol * baseVolume )
			PetBattlePokemonMusic:PlaylistMusicEnabler()
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length,{A = playlistIndex, B = baseVolume})
		end
	--print(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		
	else
		if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Continuous == false or (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Continuous == true and PetBattlePokemonMusic:TableSize(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks)==0 ) then
			PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks = {}
			for k,v in pairs (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks) do
				tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks, k)
			end
		end
		

		local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks)
	
		local nextRandomTrack =  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom]
		tinsert (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom, {Track = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom], Wait = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RandomReuse})
		--print("Playing Track: " .. PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom])
		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack = nextRandom
		local trackID = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom]].track
		if  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[nextRandomTrack].UseStart then
				local startEffect = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].StartTracks[nextRandomTrack].track

				if PetBattlePokemonMusic.db.global.SoundLibrary[startEffect] ~= nil and PetBattlePokemonMusic.db.global.StartSoundOn == true then
					--TODO Change Sound Volume for Start Sound
					bla, currentSound = PlaySoundFile(PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].FileName, "Master")
					BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlayAfterStart", PetBattlePokemonMusic.db.global.SoundLibrary[startEffect].Length,{A = playlistIndex, B = baseVolume} )
				else
					PetBattlePokemonMusic:PlaylistMusicEnabler()
					SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[nextRandomTrack].Vol * baseVolume)
					PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
					BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length,{A = playlistIndex, B = baseVolume})
				end
		else
			PetBattlePokemonMusic:PlaylistMusicEnabler()
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[nextRandomTrack].Vol*baseVolume )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length,{A = playlistIndex, B = baseVolume})
		end
		--SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom]].Vol )
		--PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		--BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		tremove (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks, nextRandom)

		for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom) do
			PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[k].Wait = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[k].Wait - 1
		end
		while #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom > PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RandomReuse do
			tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks, PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[1].Track)
			tremove(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom, 1)
		end

	end

end

function PetBattlePokemonMusic:EndBattlePlayList()

	--PetBattlePokemonMusic.db.global.OldMusicSettings.Volume = GetCVar("Sound_MusicVolume")
		--PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
		--PetBattlePokemonMusic.db.global.OldMusicSettings.On
		StopMusic();
		self:CancelTimer(BattlePlaylistTimer,true)
	PetBattlePokemonMusic:disableTrackControls(currentBattlePlaylist.A, false)
end

function PetBattlePokemonMusic:PlayBattlePlayAfterStart(bat)

	local playlistIndex = bat.A 
	local baseVol = bat.B 
	local curr = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack
	--TODO Change Sound Volume for AFTER Start Sound ends
	local trackID = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[curr].track
	SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[curr].Vol )
	PetBattlePokemonMusic:PlaylistMusicEnabler()
	PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
	
	BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length, currentBattlePlaylist)

end
function PetBattlePokemonMusic:PlayBattlePlaylistNext(bat)
	
	local playlistIndex = currentBattlePlaylist.A
	local baseVol = currentBattlePlaylist.B 
	
	if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex] ~= nil then

	self:CancelTimer(BattlePlaylistTimer, true)
	--PetBattlePokemonMusic.db.global.PlayLists[playlistIndex]
	--{Tracks = {}, Type = 1, CurrentTrack = 1, PlayedRandom = {}, MissingTracks = {}, RemainingTracks = {}, Continuous = false, UseStart = false, UseVictory = false, StartTrack = 0, VictoryTrack = 0, RandomReuse = 0}
		if PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Type == 1 then
			local currentTrack = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack
			--Standard
			if #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks > currentTrack then
				currentTrack = currentTrack + 1
			else
				currentTrack = 1
			end
			PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack = currentTrack
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].track
			--print(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].Vol * baseVol)
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		else
			
		local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks)
		local currentTrack =  PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom]
		PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].CurrentTrack = currentTrack
		tinsert (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom, {Track = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom], Wait = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RandomReuse})
		--print("Playing Track: " .. PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks[nextRandom])
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].track
		SetCVar("Sound_MusicVolume", PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].Tracks[currentTrack].Vol *baseVol)
		PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
		BattlePlaylistTimer = self:ScheduleTimer("PlayBattlePlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		tremove (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks, nextRandom)

			for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom) do
			PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[k].Wait = PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[k].Wait - 1
			
			
			--print("On Wait: "..PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[k].Track.." Wait = "..PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[k].Wait )
		end
		while #PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom > PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RandomReuse do
			tinsert(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].RemainingTracks, PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom[1].Track)
			tremove(PetBattlePokemonMusic.db.global.PlayLists[playlistIndex].PlayedRandom, 1)
		end
		end
	end
end




