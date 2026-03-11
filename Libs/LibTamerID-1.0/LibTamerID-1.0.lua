local MAJOR, MINOR = "LibTamerID-1.0", 2
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end
lib.Tamers = {}
lib.Elites = {}
local function TableSize(tab)
	local count = 0
	for key, val in pairs (tab) do
		count = count +1
	end
	return count
end
function lib:GetEliteName()

end

function lib:IsNameATamer (name)

	for key,val in pairs (lib.Tamers) do
		if key == name then
			return true
		end
	end
	return false
end
function lib:GetTamerName ()

	local Pets = {}
	for i = 1, C_PetBattles.GetNumPets(2) do
		Pets[C_PetBattles.GetName(2,i)] = {Name = C_PetBattles.GetName(2,i),Level = C_PetBattles.GetLevel(2,i), Quality =  C_PetBattles.GetBreedQuality(2,i) }
	end
	for key,val in pairs (lib.Tamers) do
	local	matches = Battle_Pet_Tactics:TableSize(TamerNPCList[key].Pets)
		
		for petName, patData in pairs (Pets) do
			if TamerNPCList[key].Pets[petName] ~= nil then
				if Pets[petName].Level == TamerNPCList[key].Pets[petName].Level and Pets[petName].Quality == TamerNPCList[key].Pets[petName].Quality then
				matches = matches -1

				end
			end
		end
		if matches == 0 then
			return key
		end
	end
	return "Unknown"


end
function lib:GetTamerName2 ()

	local Pets = {}
	for i = 1, C_PetBattles.GetNumPets(2) do
		Pets[C_PetBattles.GetName(2,i)] = {Name = C_PetBattles.GetName(2,i),Level = C_PetBattles.GetLevel(2,i), Quality =  C_PetBattles.GetBreedQuality(2,i) }
	end
	for key,val in pairs (lib.Tamers) do
	local	matches = Battle_Pet_Tactics:TableSize(TamerNPCList[key].Pets)
		
		for petName, patData in pairs (Pets) do
			if TamerNPCList[key].Pets[petName] ~= nil then
				if Pets[petName].Level == TamerNPCList[key].Pets[petName].Level and Pets[petName].Quality == TamerNPCList[key].Pets[petName].Quality then
				matches = matches -1

				end
			end
		end
		if matches == 0 then
			return key
		end
	end
	return "Unknown"


end
function lib:GetAllTamerNames ()


	--return "Unknown"
	local tamerTable = {}
	
	return tamerTable
end
function lib:PROTOS ()
	local tamerTable = {}
	for key,val in pairs (lib.Tamers) do
		tinsert(tamerTable, key)
	end
	return tamerTable
end

-- ================================================================================================================================================================================================ --
--													NPC Tamers
-- ================================================================================================================================================================================================ --

-- - ~Eastern Kingdoms Tamers~2

--Eastern Kingdoms Tamers

lib.Tamers["Julia Stevens"] = {Pets = {}}
lib.Tamers["Julia Stevens"].Pets["Fangs"]						= {Name = "Fangs",				Level = 2, Quality = 2, Breed = 3, Type = 8}
lib.Tamers["Julia Stevens"].Pets["Slither"]					= {Name = "Slithers",			Level = 2, Quality = 2, Breed = 3, Type = 8}

lib.Tamers["Old MacDonald"] = {Pets = {}}
lib.Tamers["Old MacDonald"].Pets["Clucks"]					= {Name = "Clucks",				Level = 3, Quality = 2, Breed = 3, Type = 3}
lib.Tamers["Old MacDonald"].Pets["Foe Reaper 800"]			= {Name = "Foe Reaper 800",		Level = 3, Quality = 2, Breed = 3, Type = 10}
lib.Tamers["Old MacDonald"].Pets["Teensy"]					= {Name = "Teensy",				Level = 3, Quality = 2, Breed = 3, Type = 5}

lib.Tamers["Lindsay"] = {Pets = {}}
lib.Tamers["Lindsay"].Pets["Dipsy"]							= {Name = "Dipsy",				Level = 5, Quality = 2, Breed = 3, Type = 5}
lib.Tamers["Lindsay"].Pets["Flipsy"]							= {Name = "Flipsy",				Level = 5, Quality = 2, Breed = 9, Type = 5}
lib.Tamers["Lindsay"].Pets["Flufftail"]						= {Name = "Flufftail",			Level = 5, Quality = 2, Breed = 7, Type = 5}

lib.Tamers["Eric Davidson"] = {Pets = {}}
lib.Tamers["Eric Davidson"].Pets["Blackfang"]					= {Name = "Blackfang",			Level = 7, Quality = 2, Breed = 8, Type = 8}
lib.Tamers["Eric Davidson"].Pets["Darkwidow"]					= {Name = "Darkwidow",			Level = 7, Quality = 2, Breed = 7, Type = 8}
lib.Tamers["Eric Davidson"].Pets["Webwinder"]					= {Name = "Webwinder",			Level = 7, Quality = 2, Breed = 9, Type = 8}

lib.Tamers["Steven Lisbane"] = {Pets = {}}
lib.Tamers["Steven Lisbane"].Pets["Emeralda"]					= {Name = "Emeralda",			Level = 9, Quality = 2, Breed = 6, Type = 6}
lib.Tamers["Steven Lisbane"].Pets["Moonstalker"]				= {Name = "Moonstalker",		Level = 9, Quality = 2, Breed = 8, Type = 6}
lib.Tamers["Steven Lisbane"].Pets["Nanners"]					= {Name = "Nanners",			Level = 9, Quality = 2, Breed = 8, Type = 6}

lib.Tamers["Bill Buckler"] = {Pets = {}}
lib.Tamers["Bill Buckler"].Pets["Burgle"]						= {Name = "Burgle",				Level = 11, Quality = 3, Breed = 2, Type = 1}
lib.Tamers["Bill Buckler"].Pets["Eyegouger"]					= {Name = "Eyegouger",			Level = 11, Quality = 3, Breed = 8, Type = 3}
lib.Tamers["Bill Buckler"].Pets["Young Beaky"]				= {Name = "Young Beaky",		Level = 11, Quality = 3, Breed = 9, Type = 3}

lib.Tamers["David Kosse"] = {Pets = {}}
lib.Tamers["David Kosse"].Pets["Corpsefeeder"]				= {Name = "Corpsefeeder",		Level = 13, Quality = 3, Breed = 6, Type = 8}
lib.Tamers["David Kosse"].Pets["Plop"]						= {Name = "Plop",				Level = 13, Quality = 3, Breed = 9, Type = 6}
lib.Tamers["David Kosse"].Pets["Subject 142"]					= {Name = "Subject 142",		Level = 13, Quality = 3, Breed = 5, Type = 5}

lib.Tamers["Deiza Plaguehorn"] = {Pets = {}}
lib.Tamers["Deiza Plaguehorn"].Pets["Bleakspinner"]			= {Name = "Bleakspinner",		Level = 14, Quality = 3, Breed = 8, Type = 8}
lib.Tamers["Deiza Plaguehorn"].Pets["Plaguebringer"]			= {Name = "Plaguebringer",		Level = 14, Quality = 3, Breed = 6, Type = 4}
lib.Tamers["Deiza Plaguehorn"].Pets["Carrion"]				= {Name = "Carrion",			Level = 14, Quality = 3, Breed = 3, Type = 8}

lib.Tamers["Kortas Darkhammer"] = {Pets = {}}
lib.Tamers["Kortas Darkhammer"].Pets["Garnestrasz"]			= {Name = "Garnestrasz",		Level = 15, Quality = 3, Breed = 7, Type = 2}
lib.Tamers["Kortas Darkhammer"].Pets["Obsidion"]				= {Name = "Obsidion",			Level = 15, Quality = 3, Breed = 8, Type = 2}
lib.Tamers["Kortas Darkhammer"].Pets["Verida"]				= {Name = "Verida",				Level = 15, Quality = 3, Breed = 9, Type = 2}

lib.Tamers["Everessa"] = {Pets = {}}
lib.Tamers["Everessa"].Pets["Anklor"]							= {Name = "Anklor",				Level = 16, Quality = 3, Breed = 8, Type = 8}
lib.Tamers["Everessa"].Pets["Croaker"]						= {Name = "Croaker",			Level = 16, Quality = 3, Breed = 6, Type = 9}
lib.Tamers["Everessa"].Pets["Dampwing"]						= {Name = "Dampwing",			Level = 16, Quality = 3, Breed = 9, Type = 3}

lib.Tamers["Durin Darkhammer"] = {Pets = {}}
lib.Tamers["Durin Darkhammer"].Pets["Comet"]					= {Name = "Comet",				Level = 17, Quality = 3, Breed = 5, Type = 3}
lib.Tamers["Durin Darkhammer"].Pets["Ignious"]				= {Name = "Ignious",			Level = 17, Quality = 3, Breed = 7, Type = 5}
lib.Tamers["Durin Darkhammer"].Pets["Moltar"]					= {Name = "Moltar",				Level = 17, Quality = 3, Breed = 6, Type = 7}

lib.Tamers["Lydia Accoste"] = {Pets = {}}
lib.Tamers["Lydia Accoste"].Pets["Bishibosh"]					= {Name = "Bishibosh",			Level = 19, Quality = 3, Breed = 5, Type = 4}
lib.Tamers["Lydia Accoste"].Pets["Jack"]						= {Name = "Jack",				Level = 19, Quality = 3, Breed = 8, Type = 7}
lib.Tamers["Lydia Accoste"].Pets["Nightstalker"]				= {Name = "Nightstalker",		Level = 19, Quality = 3, Breed = 9, Type = 4}


-- - ~Kalimdor Tamers~2

lib.Tamers["Zunta"] = {Pets = {}}
lib.Tamers["Zunta"].Pets["Mumtar"]							= {Name = "Mumtar",				Level = 2, Quality = 2, Breed = 3, Type = 5}
lib.Tamers["Zunta"].Pets["Spike"]								= {Name = "Spike",				Level = 2, Quality = 2, Breed = 3, Type = 8}

lib.Tamers["Dagra the Fierce"] = {Pets = {}}
lib.Tamers["Dagra the Fierce"].Pets["Springtail"]				= {Name = "Springtail",			Level = 3, Quality = 2, Breed = 8, Type = 5}
lib.Tamers["Dagra the Fierce"].Pets["Longneck"]				= {Name = "Longneck",			Level = 3, Quality = 2, Breed = 3, Type = 8}
lib.Tamers["Dagra the Fierce"].Pets["Ripper"]					= {Name = "Ripper",				Level = 3, Quality = 2, Breed = 5, Type = 8}

lib.Tamers["Analynn"] = {Pets = {}}
lib.Tamers["Analynn"].Pets["Flutterby"]						= {Name = "Flutterby",			Level = 5, Quality = 2, Breed = 5, Type = 3}
lib.Tamers["Analynn"].Pets["Mister Pinch"]					= {Name = "Mister Pinch",		Level = 5, Quality = 2, Breed = 6, Type = 9}
lib.Tamers["Analynn"].Pets["Oozer"]							= {Name = "Oozer",				Level = 5, Quality = 2, Breed = 8, Type = 5}

lib.Tamers["Zonya the Sadist"] = {Pets = {}}
lib.Tamers["Zonya the Sadist"].Pets["Acidous"]				= {Name = "Acidous",			Level = 7, Quality = 2, Breed = 9, Type = 8}
lib.Tamers["Zonya the Sadist"].Pets["Constrictor"]			= {Name = "Constrictor",		Level = 7, Quality = 2, Breed = 8, Type = 8}
lib.Tamers["Zonya the Sadist"].Pets["Odoron"]					= {Name = "Odoron",				Level = 7, Quality = 2, Breed = 3, Type = 5}

lib.Tamers["Merda Stronghoof"] = {Pets = {}}
lib.Tamers["Merda Stronghoof"].Pets["Ambershell"]				= {Name = "Ambershell",			Level = 9, Quality = 2, Breed = 6, Type = 7}
lib.Tamers["Merda Stronghoof"].Pets["Bounder"]				= {Name = "Bounder",			Level = 9, Quality = 2, Breed = 9, Type = 9}
lib.Tamers["Merda Stronghoof"].Pets["Rockhide"]				= {Name = "Rockhide",			Level = 9, Quality = 2, Breed = 6, Type = 5}

lib.Tamers["Cassandra Kaboom"] = {Pets = {}}
lib.Tamers["Cassandra Kaboom"].Pets["Cluckatron"]				= {Name = "Cluckatron",			Level = 11, Quality = 3, Breed = 8, Type = 10}
lib.Tamers["Cassandra Kaboom"].Pets["Gizmo"]					= {Name = "Gizmo",				Level = 11, Quality = 3, Breed = 5, Type = 10}
lib.Tamers["Cassandra Kaboom"].Pets["Whirls"]					= {Name = "Whirls",				Level = 11, Quality = 3, Breed = 9, Type = 10}

lib.Tamers["Traitor Gluk"] = {Pets = {}}
lib.Tamers["Traitor Gluk"].Pets["Glimmer"]					= {Name = "Glimmer",			Level = 13, Quality = 3, Breed = 5, Type = 2}
lib.Tamers["Traitor Gluk"].Pets["Prancer"]					= {Name = "Prancer",			Level = 13, Quality = 3, Breed = 9, Type = 5}
lib.Tamers["Traitor Gluk"].Pets["Rasp"]						= {Name = "Rasp",				Level = 13, Quality = 3, Breed = 8, Type = 8}

lib.Tamers["Grazzle the Great"] = {Pets = {}}
lib.Tamers["Grazzle the Great"].Pets["Firetooth"]				= {Name = "Firetooth",			Level = 14, Quality = 3, Breed = 7, Type = 2}
lib.Tamers["Grazzle the Great"].Pets["Blaze"]					= {Name = "Blaze",				Level = 14, Quality = 3, Breed = 8, Type = 2}
lib.Tamers["Grazzle the Great"].Pets["Flameclaw"]				= {Name = "Flameclaw",			Level = 14, Quality = 3, Breed = 4, Type = 2}

lib.Tamers["Kela Grimtotem"] = {Pets = {}}
lib.Tamers["Kela Grimtotem"].Pets["Cho'guana"]				= {Name = "Cho'guana",			Level = 15, Quality = 3, Breed = 7, Type = 8}
lib.Tamers["Kela Grimtotem"].Pets["Indigon"]					= {Name = "Indigon",			Level = 15, Quality = 3, Breed = 6, Type = 5}
lib.Tamers["Kela Grimtotem"].Pets["Plague"]					= {Name = "Plague",				Level = 15, Quality = 3, Breed = 8, Type = 5}

lib.Tamers["Zoltan"] = {Pets = {}}
lib.Tamers["Zoltan"].Pets["Beamer"]							= {Name = "Beamer",				Level = 16, Quality = 3, Breed = 4, Type = 6}
lib.Tamers["Zoltan"].Pets["Hatewalker"]						= {Name = "Hatewalker",			Level = 16, Quality = 3, Breed = 6, Type = 10}
lib.Tamers["Zoltan"].Pets["Ultramus"]							= {Name = "Ultramus",			Level = 16, Quality = 3, Breed = 7, Type = 6}

lib.Tamers["Elena Flutterfly"] = {Pets = {}}
lib.Tamers["Elena Flutterfly"].Pets["Willow"]					= {Name = "Willow",				Level = 17, Quality = 3, Breed = 8, Type = 2}
lib.Tamers["Elena Flutterfly"].Pets["Beacon"]					= {Name = "Beacon",				Level = 17, Quality = 3, Breed = 7, Type = 6}
lib.Tamers["Elena Flutterfly"].Pets["Lacewing"]				= {Name = "Lacewing",			Level = 17, Quality = 3, Breed = 9, Type = 3}

lib.Tamers["Stone Cold Trixxy"] = {Pets = {}}
lib.Tamers["Stone Cold Trixxy"].Pets["Blizzy"]				= {Name = "Blizzy",				Level = 19, Quality = 3, Breed = 5, Type = 3}
lib.Tamers["Stone Cold Trixxy"].Pets["Frostmaw"]				= {Name = "Frostmaw",			Level = 19, Quality = 3, Breed = 8, Type = 8}
lib.Tamers["Stone Cold Trixxy"].Pets["Tinygos"]				= {Name = "Tinygos",			Level = 19, Quality = 3, Breed = 9, Type = 2}


-- - ~Outlands Tamers~2

lib.Tamers["Nicki Tinytech"] = {Pets = {}}
lib.Tamers["Nicki Tinytech"].Pets["ED-005"]					= {Name = "ED-005",				Level = 20, Quality = 3, Breed = 7, Type = 10}
lib.Tamers["Nicki Tinytech"].Pets["Goliath"]					= {Name = "Goliath",			Level = 20, Quality = 3, Breed = 7, Type = 10}
lib.Tamers["Nicki Tinytech"].Pets["Sploder"]					= {Name = "Sploder",			Level = 20, Quality = 3, Breed = 6, Type = 10}

lib.Tamers["Ras'an"] = {Pets = {}}
lib.Tamers["Ras'an"].Pets["Fungor"]							= {Name = "Fungor",				Level = 21, Quality = 3, Breed = 6, Type = 1}
lib.Tamers["Ras'an"].Pets["Glitterfly"]						= {Name = "Glitterfly",			Level = 21, Quality = 3, Breed = 5, Type = 3}
lib.Tamers["Ras'an"].Pets["Tripod"]							= {Name = "Tripod",				Level = 21, Quality = 3, Breed = 3, Type = 6}

lib.Tamers["Narrok"] = {Pets = {}}
lib.Tamers["Narrok"].Pets["Stompy"]							= {Name = "Stompy",				Level = 22, Quality = 3, Breed = 6, Type = 8}
lib.Tamers["Narrok"].Pets["Prince Wart"]						= {Name = "Prince Wart",		Level = 22, Quality = 3, Breed = 3, Type = 9}
lib.Tamers["Narrok"].Pets["Dramaticus"]						= {Name = "Dramaticus",			Level = 22, Quality = 3, Breed = 8, Type = 5}

lib.Tamers["Morulu The Elder"] = {Pets = {}}
lib.Tamers["Morulu The Elder"].Pets["Chomps"]					= {Name = "Chomps",				Level = 23, Quality = 3, Breed = 4, Type = 9}
lib.Tamers["Morulu The Elder"].Pets["Cragmaw"]				= {Name = "Cragmaw",			Level = 23, Quality = 3, Breed = 8, Type = 9}
lib.Tamers["Morulu The Elder"].Pets["Gnasher"]				= {Name = "Gnasher",			Level = 23, Quality = 3, Breed = 4, Type = 9}

lib.Tamers["Bloodknight Antari"] = {Pets = {}}
lib.Tamers["Bloodknight Antari"].Pets["Arcanus"]				= {Name = "Arcanus",			Level = 24, Quality = 4, Breed = 3, Type = 6}
lib.Tamers["Bloodknight Antari"].Pets["Jadefire"]				= {Name = "Jadefire",			Level = 24, Quality = 4, Breed = 7, Type = 7}
lib.Tamers["Bloodknight Antari"].Pets["Netherbite"]			= {Name = "Netherbite",			Level = 24, Quality = 4, Breed = 8, Type = 2}

-- - ~Northrend Tamers~2

lib.Tamers["Beegle Blastfuse"] = {Pets = {}}
lib.Tamers["Beegle Blastfuse"].Pets["Dinner"]					= {Name = "Dinner",				Level = 25, Quality = 4, Breed = 8, Type = 3}
lib.Tamers["Beegle Blastfuse"].Pets["Goobles"]				= {Name = "Goobles",			Level = 25, Quality = 4, Breed = 9, Type = 3}
lib.Tamers["Beegle Blastfuse"].Pets["Warble"]					= {Name = "Warble",				Level = 25, Quality = 4, Breed = 3, Type = 9}

lib.Tamers["Nearly Headless Jacob"] = {Pets = {}}
lib.Tamers["Nearly Headless Jacob"].Pets["Spooky Strangler"]	= {Name = "Spooky Strangler",	Level = 25, Quality = 4, Breed = 8, Type = 4}
lib.Tamers["Nearly Headless Jacob"].Pets["Mort"]				= {Name = "Mort",				Level = 25, Quality = 4, Breed = 7, Type = 4}
lib.Tamers["Nearly Headless Jacob"].Pets["Stitch"]			= {Name = "Stitch",				Level = 25, Quality = 4, Breed = 9, Type = 4}

lib.Tamers["Okrut Dragonwaste"] = {Pets = {}}
lib.Tamers["Okrut Dragonwaste"].Pets["Drogar"]				= {Name = "Drogar",				Level = 25, Quality = 4, Breed = 8, Type = 2}
lib.Tamers["Okrut Dragonwaste"].Pets["Rot"]					= {Name = "Rot",				Level = 25, Quality = 4, Breed = 7, Type = 4}
lib.Tamers["Okrut Dragonwaste"].Pets["Sleet"]					= {Name = "Sleet",				Level = 25, Quality = 4, Breed = 9, Type = 4}

lib.Tamers["Gutretch"] = {Pets = {}}
lib.Tamers["Gutretch"].Pets["Blight"]							= {Name = "Blight",				Level = 25, Quality = 4, Breed = 8, Type = 5}
lib.Tamers["Gutretch"].Pets["Cadavus"]						= {Name = "Cadavus",			Level = 25, Quality = 4, Breed = 7, Type = 8}
lib.Tamers["Gutretch"].Pets["Fleshrender"]					= {Name = "Fleshrender",		Level = 25, Quality = 4, Breed = 6, Type = 8}

lib.Tamers["Major Payne"] = {Pets = {}}
lib.Tamers["Major Payne"].Pets["Beakmaster X-225"]			= {Name = "Beakmaster X-225",	Level = 25, Quality = 4, Breed = 8, Type = 10}
lib.Tamers["Major Payne"].Pets["Bloom"]						= {Name = "Bloom",				Level = 25, Quality = 4, Breed = 9, Type = 7}
lib.Tamers["Major Payne"].Pets["Grizzle"]						= {Name = "Grizzle",			Level = 25, Quality = 4, Breed = 6, Type = 8}

-- - ~Cataclysm Tamers
lib.Tamers["Brok"] = {Pets = {}}
lib.Tamers["Brok"].Pets["Ashtail"]							= {Name = "Ashtail",			Level = 25, Quality = 4, Breed = 8, Type = 8}
lib.Tamers["Brok"].Pets["Incinderous"]						= {Name = "Incinderous",		Level = 25, Quality = 4, Breed = 6, Type = 5}
lib.Tamers["Brok"].Pets["Kali"]								= {Name = "Kali",				Level = 25, Quality = 4, Breed = 5, Type = 6}

lib.Tamers["Bordin Steadyfist"] = {Pets = {}}
lib.Tamers["Bordin Steadyfist"].Pets["Crystallus"]			= {Name = "Crystallus",			Level = 25, Quality = 4, Breed = 9, Type = 5}
lib.Tamers["Bordin Steadyfist"].Pets["Fracture"]				= {Name = "Fracture",			Level = 25, Quality = 4, Breed = 6, Type = 7}
lib.Tamers["Bordin Steadyfist"].Pets["Ruby"]					= {Name = "Ruby",				Level = 25, Quality = 4, Breed = 7, Type = 7}

lib.Tamers["Goz Banefury"] = {Pets = {}}
lib.Tamers["Goz Banefury"].Pets["Amythel"]					= {Name = "Amythel",			Level = 25, Quality = 4, Breed = 9, Type = 6}
lib.Tamers["Goz Banefury"].Pets["Helios"]						= {Name = "Helios",				Level = 25, Quality = 4, Breed = 4, Type = 8}
lib.Tamers["Goz Banefury"].Pets["Twilight"]					= {Name = "Twilight",			Level = 25, Quality = 4, Breed = 8, Type = 7}

lib.Tamers["Obalis"] = {Pets = {}}
lib.Tamers["Obalis"].Pets["Clatter"]							= {Name = "Clatter",			Level = 25, Quality = 5, Breed = 9, Type = 5}
lib.Tamers["Obalis"].Pets["Spring"]							= {Name = "Spring",				Level = 25, Quality = 5, Breed = 5, Type = 3}
lib.Tamers["Obalis"].Pets["Pyth"]								= {Name = "Pyth",				Level = 25, Quality = 5, Breed = 8, Type = 8}

-- - ~Pandaria Tamers~2

lib.Tamers["Hyuna of the Shrines"] = {Pets = {}}
lib.Tamers["Hyuna of the Shrines"].Pets["Skyshaper"]					= {Name = "Skyshaper",			Level = 25, Quality = 5, Breed = 8, Type = 3}
lib.Tamers["Hyuna of the Shrines"].Pets["Dor the Wall"]				= {Name = "Dor the Wall",		Level = 25, Quality = 5, Breed = 6, Type = 9}
lib.Tamers["Hyuna of the Shrines"].Pets["Fangor"]						= {Name = "Fangor",				Level = 25, Quality = 5, Breed = 5, Type = 8}

lib.Tamers["Farmer Nishi"] = {Pets = {}}
lib.Tamers["Farmer Nishi"].Pets["Brood of Mothallus"]					= {Name = "Brood of Mothallus",			Level = 25, Quality = 5, Breed = 9, Type = 8}
lib.Tamers["Farmer Nishi"].Pets["Toothbreaker"]						= {Name = "Toothbreaker",				Level = 25, Quality = 5, Breed = 6, Type = 7}
lib.Tamers["Farmer Nishi"].Pets["Siren"]								= {Name = "Siren",						Level = 25, Quality = 5, Breed = 7, Type = 7}


lib.Tamers["Mo'ruk"] = {Pets = {}}
lib.Tamers["Mo'ruk"].Pets["Lightstalker"]							= {Name = "Lightstalker",			Level = 25, Quality = 5, Breed = 8, Type = 3}
lib.Tamers["Mo'ruk"].Pets["Needleback"]							= {Name = "Needleback",				Level = 25, Quality = 5, Breed = 6, Type = 9}
lib.Tamers["Mo'ruk"].Pets["Woodcarver"]							= {Name = "Woodcarver",				Level = 25, Quality = 5, Breed = 9, Type = 8}

lib.Tamers["Courageous Yon"] = {Pets = {}}
lib.Tamers["Courageous Yon"].Pets["Bleat"]						= {Name = "Bleat",					Level = 25, Quality = 5, Breed = 8, Type = 8}
lib.Tamers["Courageous Yon"].Pets["Piqua"]						= {Name = "Piqua",					Level = 25, Quality = 5, Breed = 9, Type = 3}
lib.Tamers["Courageous Yon"].Pets["Lapin"]						= {Name = "Lapin",					Level = 25, Quality = 5, Breed = 9, Type = 5}

lib.Tamers["Seeker Zusshi"] = {Pets = {}}
lib.Tamers["Seeker Zusshi"].Pets["Diamond"]						= {Name = "Diamond",				Level = 25, Quality = 5, Breed = 6, Type = 7}
lib.Tamers["Seeker Zusshi"].Pets["Mollus"]						= {Name = "Mollus",					Level = 25, Quality = 5, Breed = 9, Type = 5}
lib.Tamers["Seeker Zusshi"].Pets["Skimmer"]						= {Name = "Skimmer",				Level = 25, Quality = 5, Breed = 9, Type = 9}

lib.Tamers["Wastewalker Shu"] = {Pets = {}}
lib.Tamers["Wastewalker Shu"].Pets["Pounder"]						= {Name = "Pounder",				Level = 25, Quality = 5, Breed = 6, Type = 7}
lib.Tamers["Wastewalker Shu"].Pets["Crusher"]						= {Name = "Crusher",				Level = 25, Quality = 5, Breed = 7, Type = 9}
lib.Tamers["Wastewalker Shu"].Pets["Mutilator"]					= {Name = "Mutilator",				Level = 25, Quality = 5, Breed = 4, Type = 8}

lib.Tamers["Aki the Chosen"] = {Pets = {}}
lib.Tamers["Aki the Chosen"].Pets["Stormlash"]					= {Name = "Stormlash",				Level = 25, Quality = 6, Breed = 7, Type = 2}
lib.Tamers["Aki the Chosen"].Pets["Whiskers"]						= {Name = "Whiskers",				Level = 25, Quality = 6, Breed = 8, Type = 9}
lib.Tamers["Aki the Chosen"].Pets["Chirrup"]						= {Name = "Chirrup",				Level = 25, Quality = 6, Breed = 5, Type = 5}

-- _ ~Pandaren Elemental Spirits~2
lib.Tamers["Burning Pandaren Spirit"] = {Pets = {}}
lib.Tamers["Burning Pandaren Spirit"].Pets["Crimson"]						= {Name = "Crimson",				Level = 25, Quality = 6, Breed = 8, Type = 2}
lib.Tamers["Burning Pandaren Spirit"].Pets["Glowy"]						= {Name = "Glowy",					Level = 25, Quality = 6, Breed = 11, Type = 3}
lib.Tamers["Burning Pandaren Spirit"].Pets["Pandaren Fire Spirit"]		= {Name = "Pandaren Fire Spirit",	Level = 25, Quality = 6, Breed = 8, Type = 7}

lib.Tamers["Thundering Pandaren Spirit"] = {Pets = {}}
lib.Tamers["Thundering Pandaren Spirit"].Pets["Darnak the Tunneler"]		= {Name = "Darnak the Tunneler",	Level = 25, Quality = 6, Breed = 6, Type = 8}
lib.Tamers["Thundering Pandaren Spirit"].Pets["Pandaren Earth Spirit"]	= {Name = "Pandaren Earth Spirit",	Level = 25, Quality = 6, Breed = 7, Type = 7}
lib.Tamers["Thundering Pandaren Spirit"].Pets["Sludgy"]					= {Name = "Sludgy",					Level = 25, Quality = 6, Breed = 9, Type = 6}

lib.Tamers["Whispering Pandaren Spirit"] = {Pets = {}}
lib.Tamers["Whispering Pandaren Spirit"].Pets["Dusty"]					= {Name = "Dusty",					Level = 25, Quality = 6, Breed = 12, Type = 3}
lib.Tamers["Whispering Pandaren Spirit"].Pets["Pandaren Air Spirit"]		= {Name = "Pandaren Air Spirit",	Level = 25, Quality = 6, Breed = 3, Type = 7}
lib.Tamers["Whispering Pandaren Spirit"].Pets["Whispertail"]				= {Name = "Whispertail",			Level = 25, Quality = 6, Breed = 3, Type = 2}

lib.Tamers["Flowing Pandaren Spirit"] = {Pets = {}}
lib.Tamers["Flowing Pandaren Spirit"].Pets["Marley"]						= {Name = "Marley",					Level = 25, Quality = 6, Breed = 5, Type = 9}
lib.Tamers["Flowing Pandaren Spirit"].Pets["Pandaren Water Spirit"]		= {Name = "Pandaren Water Spirit",	Level = 25, Quality = 6, Breed = 9, Type = 7}
lib.Tamers["Flowing Pandaren Spirit"].Pets["Tiptoe"]						= {Name = "Tiptoe",					Level = 25, Quality = 6, Breed = 10, Type = 9}


-- _ ~Darkmoon Faire

lib.Tamers["Jeremy Feasel"] = {Pets = {}}
lib.Tamers["Jeremy Feasel"].Pets["Honky-Tonk"]						= {Name = "Honky-Tonk",				Level = 25, Quality = 5, Breed = 7, Type = 10}
lib.Tamers["Jeremy Feasel"].Pets["Judgement"]						= {Name = "Judgement",				Level = 25, Quality = 5, Breed = 8, Type = 6}
lib.Tamers["Jeremy Feasel"].Pets["Fezwick"]					= {Name = "Fezwick",				Level = 25, Quality = 5, Breed = 10, Type = 8}


-- _ ~Fabled Pandaren~2

lib.Elites["Ka'wi the Gorger"] = {Pets = {}}
lib.Elites["Ka'wi the Gorger"].Pets["Ka'wi the Gorger"]			= {Name = "Ka'wi the Gorger",		Level = 25, Quality = 6, Breed = 7, Type = 5}

lib.Elites["Gorespine"] = {Pets = {}}
lib.Elites["Gorespine"].Pets["Gorespine"]							= {Name = "Gorespine",				Level = 25, Quality = 6, Breed = 4, Type = 8}

lib.Elites["No-No"] = {Pets = {}}
lib.Elites["No-No"].Pets["No-No"]									= {Name = "No-No",					Level = 25, Quality = 6, Breed = 3, Type = 9}

lib.Elites["Greyhoof"] = {Pets = {}}
lib.Elites["Greyhoof"].Pets["Greyhoof"]							= {Name = "Greyhoof",				Level = 25, Quality = 6, Breed = 9, Type = 8}

lib.Elites["Lucky Yi"] = {Pets = {}}
lib.Elites["Lucky Yi"].Pets["Lucky Yi"]							= {Name = "Lucky Yi ",				Level = 25, Quality = 6, Breed = 11, Type = 5}

lib.Elites["Ti'un the Wanderer"] = {Pets = {}}
lib.Elites["Ti'un the Wanderer"].Pets["Ti'un the Wanderer"]		= {Name = "Ti'un the Wanderer",		Level = 25, Quality = 6, Breed = 6, Type = 9}

lib.Elites["Kafi"] = {Pets = {}}
lib.Elites["Kafi"].Pets["Kafi"]									= {Name = "Kafi",					Level = 25, Quality = 6, Breed = 10, Type = 8}

lib.Elites["Dos-Ryga"] = {Pets = {}}
lib.Elites["Dos-Ryga"].Pets["Dos-Ryga"]							= {Name = "Dos-Ryga",				Level = 25, Quality = 6, Breed = 12, Type = 9}

lib.Elites["Nitun"] = {Pets = {}}
lib.Elites["Nitun"].Pets["Nitun"]									= {Name = "Nitun",					Level = 25, Quality = 6, Breed = 8, Type = 5}

lib.Elites["Skitterer Xi'a"] = {Pets = {}}
lib.Elites["Skitterer Xi'a"].Pets["Skitterer Xi'a"]				= {Name = "Skitterer Xi'a",			Level = 25, Quality = 6, Breed = 5, Type = 9}

lib.Elites["Skitterer Xi'a"] = {Pets = {}}
lib.Elites["Skitterer Xi'a"].Pets["Skitterer Xi'a"]				= {Name = "Skitterer Xi'a",			Level = 25, Quality = 6, Breed = 5, Type = 9}


-- _ ~Timeless Isle Celestial Tournament~2

lib.Tamers["Little Tommy Newcomer"] = {Pets = {}}
lib.Tamers["Little Tommy Newcomer"].Pets["Lil' Oondasta"]		= {Name = "Lil' Oondasta",		Level = 25, Quality = 6, Breed = 3, Type = 8}


lib.Tamers["Lorewalker Cho"] = {Pets = {}}
lib.Tamers["Lorewalker Cho"].Pets["Knowledge"]				= {Name = "Knowledge",	Level = 25, Quality = 6, Breed = 4, Type = 2}
lib.Tamers["Lorewalker Cho"].Pets["Patience"]					= {Name = "Patience",	Level = 25, Quality = 6, Breed = 6, Type = 6}
lib.Tamers["Lorewalker Cho"].Pets["Wisdom"]					= {Name = "Wisdom",		Level = 25, Quality = 6, Breed = 5, Type = 3}

lib.Tamers["Shademaster Kiryn"] = {Pets = {}}
lib.Tamers["Shademaster Kiryn"].Pets["Summer"]				= {Name = "Summer",		Level = 25, Quality = 6, Breed = 5, Type = 8}
lib.Tamers["Shademaster Kiryn"].Pets["Nairn"]					= {Name = "Nairn",		Level = 25, Quality = 6, Breed = 6, Type = 1}
lib.Tamers["Shademaster Kiryn"].Pets["Stormoen"]				= {Name = "Stormoen",	Level = 25, Quality = 6, Breed = 4, Type = 10}

lib.Tamers["Sully \"The Pickle\" McLeary"] = {Pets = {}}
lib.Tamers["Sully \"The Pickle\" McLeary"].Pets["Monte"]		= {Name = "Monte",		Level = 25, Quality = 6, Breed = 4, Type = 5}
lib.Tamers["Sully \"The Pickle\" McLeary"].Pets["Rikki"]		= {Name = "Rikki",		Level = 25, Quality = 6, Breed = 3, Type = 9}
lib.Tamers["Sully \"The Pickle\" McLeary"].Pets["Socks"]		= {Name = "Socks",		Level = 25, Quality = 6, Breed = 3, Type = 4}

lib.Tamers["Taran Zhu"] = {Pets = {}}
lib.Tamers["Taran Zhu"].Pets["Bolo"]							= {Name = "Bolo",		Level = 25, Quality = 6, Breed = 7, Type = 1}
lib.Tamers["Taran Zhu"].Pets["Li"]							= {Name = "Li",			Level = 25, Quality = 6, Breed = 5, Type = 1}
lib.Tamers["Taran Zhu"].Pets["Yen"]							= {Name = "Yen",		Level = 25, Quality = 6, Breed = 8, Type = 1}


lib.Tamers["Blingtron 4000"] = {Pets = {}}
lib.Tamers["Blingtron 4000"].Pets["Au"]						= {Name = "Au",			Level = 25, Quality = 6, Breed = 4, Type = 7}
lib.Tamers["Blingtron 4000"].Pets["Banks"]					= {Name = "Banks",		Level = 25, Quality = 6, Breed = 6, Type = 5}
lib.Tamers["Blingtron 4000"].Pets["Lil' B"]					= {Name = "Lil' B",		Level = 25, Quality = 6, Breed = 5, Type = 6}

lib.Tamers["Dr. Ion Goldbloom"] = {Pets = {}}
lib.Tamers["Dr. Ion Goldbloom"].Pets["Chaos"]					= {Name = "Chaos",		Level = 25, Quality = 6, Breed = 5, Type = 6}
lib.Tamers["Dr. Ion Goldbloom"].Pets["Trike"]					= {Name = "Trike",		Level = 25, Quality = 6, Breed = 6, Type = 8}
lib.Tamers["Dr. Ion Goldbloom"].Pets["Screamer"]				= {Name = "Screamer",	Level = 25, Quality = 6, Breed = 4, Type = 3}

lib.Tamers["Wise Mari"] = {Pets = {}}
lib.Tamers["Wise Mari"].Pets["River"]							= {Name = "River",		Level = 25, Quality = 6, Breed = 5, Type = 7}
lib.Tamers["Wise Mari"].Pets["Carpe Diem"]					= {Name = "Carpe Diem",	Level = 25, Quality = 6, Breed = 6, Type = 9}
lib.Tamers["Wise Mari"].Pets["Spirus"]						= {Name = "Spirus",		Level = 25, Quality = 6, Breed = 4, Type = 6}

lib.Tamers["Chen Stormstout"] = {Pets = {}}
lib.Tamers["Chen Stormstout"].Pets["Tonsa"]					= {Name = "Tonsa",		Level = 25, Quality = 6, Breed = 8, Type = 8}
lib.Tamers["Chen Stormstout"].Pets["Chirps"]					= {Name = "Chirps",		Level = 25, Quality = 6, Breed = 5, Type = 5}
lib.Tamers["Chen Stormstout"].Pets["Brewly"]					= {Name = "Brewly",		Level = 25, Quality = 6, Breed = 6, Type = 7}

lib.Tamers["Wrathion"] = {Pets = {}}
lib.Tamers["Wrathion"].Pets["Cindy"]							= {Name = "Cindy",		Level = 25, Quality = 6, Breed = 5, Type = 4}
lib.Tamers["Wrathion"].Pets["Alex"]							= {Name = "Alex",		Level = 25, Quality = 6, Breed = 6, Type = 2}
lib.Tamers["Wrathion"].Pets["Dah'da"]							= {Name = "Dah'da",		Level = 25, Quality = 6, Breed = 4, Type = 2}


lib.Elites["Chi-Chi, Hatchling of Chi-Ji"] = {Pets = {}}
lib.Elites["Chi-Chi, Hatchling of Chi-Ji"].Pets["Chi-Chi, Hatchling of Chi-Ji"]	= {Name = "Chi-Chi, Hatchling of Chi-Ji",		Level = 25, Quality = 6, Breed = 8, Type = 3}

lib.Elites["Xu-Fu, Cub of Xuen"] = {Pets = {}}
lib.Elites["Xu-Fu, Cub of Xuen"].Pets["Xu-Fu, Cub of Xuen"]						= {Name = "Xu-Fu, Cub of Xuen",					Level = 25, Quality = 6, Breed = 8, Type = 8}

lib.Elites["Yu'la, Broodling of Yu'lon"] = {Pets = {}}
lib.Elites["Yu'la, Broodling of Yu'lon"].Pets["Yu'la, Broodling of Yu'lon"]		= {Name = "Yu'la, Broodling of Yu'lon",			Level = 25, Quality = 6, Breed = 8, Type = 2}

lib.Elites["Zao, Calfling of Niuzao"] = {Pets = {}}
lib.Elites["Zao, Calfling of Niuzao"].Pets["Zao, Calfling of Niuzao"]				= {Name = "Zao, Calfling of Niuzao ",			Level = 25, Quality = 6, Breed = 6, Type = 8}

 