-- Author      : Endar_Ren
-- Create Date : 6/30/2015 6:53:28 PM
local L						= LibStub("AceLocale-3.0"):GetLocale("PetBattlePokemonMusic")
local BPApattern = "|cff4e96f7|HbattlePetAbil:(%d*):%d*:%d*:%d*|h%[.*%]|h|r"
local iconpattern = "INTERFACE\\ICON\\.*%.BLP:%d*"

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
--This function handles the event when a pet battle starts.
--@param event Event Name
function PetBattlePokemonMusic:PET_BATTLE_OPENING_START(event,...)

	--Save the old volumes.
	--OldMusicVolume = GetCVar("Sound_MusicVolume")
	--OldMasterVolume = GetCVar("Sound_MasterVolume")
	PetBattlePokemonMusic:StoringPreBattleSettings()

	--Determine the type of battle.
	local battleType,opponentName = PetBattlePokemonMusic:IdentifyBattleType()

	PetBattlePokemonMusic:PlayOpening(battleType, opponentName)
	--[[
	print("Battle type is "..battleType)
	if battleType == L["WILD"]  then
		--Check to see if the 
		local possibleTamerName = PetBattlePokemonMusic:GetTamerName ()
		if (possibleTamerName == L["UNKNOWN"]) then
			local name, speciesName = C_PetBattles.GetName(2,1)
			PetBattlePokemonMusic:WildBattleOpening(name)
		else
			PetBattlePokemonMusic:UniversialBattleOpening(possibleTamerName,"Tamer", "Trainer", "TamerTracks")
		end
	end
	if battleType == L["TAMER"]  then
		--PetBattlePokemonMusic:TamerBattleOpening(PetBattlePokemonMusic:GetTamerName ())
		PetBattlePokemonMusic:UniversialBattleOpening(PetBattlePokemonMusic:GetTamerName (),"Tamer", "Trainer", "TamerTracks")
	end
	if battleType == "PvP"  then
		PetBattlePokemonMusic:PvPBattleOpening(duelistName)
	end]]--
end

---
--
--@param event The name of the event.
--@param
function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_INFO(event, ...)

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

function PetBattlePokemonMusic:CHAT_MSG_PET_BATTLE_COMBAT_LOG(...)
	local demo = {...}
	
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
function PetBattlePokemonMusic:UI_ERROR_MESSAGE(event, message)
	if strmatch( message, "ERR_PETBATTLE_DECLINED") then
		--Erase the playerTamer name in pending.
		PetBattlePokemonMusic:ClearDuelistName()
	end
end

---This handles an event that is thrown at the end of a pet battle.
--@param event Event name.
--@param outcomenumber This value is a number that appears to change depending on the winner.  1 seems to mean that you won.  2 seems to mean the other won.  
--More values may be possible.
function PetBattlePokemonMusic:PET_BATTLE_FINAL_ROUND(event,outcomenumber)
	StopMusic();
	SetCVar("Sound_EnableMusic", OldMusicValue )
	--self:CancelTimer(battleTimer,true)
	PetBattlePokemonMusic:StopPlayer()
	--if currentSound ~= nil then
	--	StopSound(currentSound)
	--	currentSound=nil
	--end

	if outcomenumber == 1 then
		PetBattlePokemonMusic:VictoryPlayer()

	end
	PetBattlePokemonMusic:RestoreSettings()
	--end
end