-- Author      : Endarren
-- Create Date : 6/30/2015 2:58:59 PM
local L						= LibStub("AceLocale-3.0"):GetLocale("PetBattlePokemonMusic")
local currentVolume = 0
local playlistTrackTimer = nil;

local currentMusicType = 0; --0 is None, 1 is premade, 2 is single track, 3 is playlist
local currentMusicIndex = 1
local currentPlaylistTrack = 1;

local currentBattleType = 0;
local currentOpponentName = nil;

function PetBattlePokemonMusic:CheckingIfWasInBattle()

end
function PetBattlePokemonMusic:StoringPreBattleSettings()
	if PetBattlePokemonMusic.db.global.InBattle == false then
		
		PetBattlePokemonMusic.db.global.OldMusicSettings.Volume = GetCVar("Sound_MusicVolume")
		PetBattlePokemonMusic.db.global.OldSoundSettings.Volume = GetCVar("Sound_MasterVolume")
		PetBattlePokemonMusic.db.global.OldMusicSettings.On = GetCVar("Sound_EnableMusic")
		PetBattlePokemonMusic.db.global.InBattle = true		
		--print("Saving volumes:  "..PetBattlePokemonMusic.db.global.OldSoundSettings.Volume)
	end
end
function PetBattlePokemonMusic:RestoreSettings()

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
end
function PetBattlePokemonMusic:ChangeVolume()

end

function PetBattlePokemonMusic:PlayOpening(battleType, opponentName)
	currentBattleType = battleType
	currentOpponentName = opponentName
	local trackKey = nil;
	local typeName =""
	local cbplType =""

	if currentBattleType == L["TAMER"] then
		trackKey = "TamerTracks"
		typeName = "Trainer"
		cbplType = "Tamer"
	end 
	if currentBattleType == L["WILD"] then
		trackKey = "WildTracks"
		typeName = "Wild"
		cbplType = "Wild"
	end 
	if currentBattleType == "PvP" then
		trackKey = "PvPTracks"
		typeName = "PvP"
		cbplType = "PvP"
	end

	PetBattlePokemonMusic:UniversialBattleOpening(opponentName, cbplType, typeName, trackKey)
end


	--TODO: if playlist type is normal to this.
		--TODO:  Increament current track by 1.
		--TODO:  Check to see if the current track is greater than then number of tracks.
			--TODO: If so, set current track to 1.
	--TODO:  If playlist type is random do this.
		--TODO run random selection and update tracks.
		--TODO: Set current track to the random.

	--TODO:  Play current track.
	--TODO: Start timer to go off at end of current track to run this function again.
	--[[
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
	
	
	]]--

function PetBattlePokemonMusic:PlaylistNext()
	if PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex] ~= nil then

	self:CancelTimer(playlistTrackTimer, true)
	--PetBattlePokemonMusic.db.global.PlayLists[playlistIndex]
	--{Tracks = {}, Type = 1, CurrentTrack = 1, PlayedRandom = {}, MissingTracks = {}, RemainingTracks = {}, Continuous = false, UseStart = false, UseVictory = false, StartTrack = 0, VictoryTrack = 0, RandomReuse = 0}
		if PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].Type == 1 then
	
			--Standard
			if #PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].Tracks > playlistCurrentTrack then
				playlistCurrentTrack = playlistCurrentTrack + 1
			else
				playlistCurrentTrack = 1
			end
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].Tracks[playlistCurrentTrack].track
			--print(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			SetCVar("Sound_MusicVolume", baseVol * PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].Tracks[playlistCurrentTrack].Vol )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			playlistTrackTimer = self:ScheduleTimer("PlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
		else
			
			local nextRandom = random(1,  #PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks)
			playlistCurrentTrack =  PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks[nextRandom]
			tinsert (PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].PlayedRandom, {Track = PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks[nextRandom], Wait = PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RandomReuse})
			--print("Playing Track: " .. PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks[nextRandom])
			local trackID = PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].Tracks[PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks[nextRandom]].track
			SetCVar("Sound_MusicVolume",baseVol * PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].Tracks[PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks[nextRandom]].Vol )
			PlayMusic(PetBattlePokemonMusic.db.global.SoundLibrary[trackID].FileName)
			playlistTrackTimer = self:ScheduleTimer("PlaylistNext", PetBattlePokemonMusic.db.global.SoundLibrary[trackID].Length)
			tremove (PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks, nextRandom)

			for k, v in pairs (PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].PlayedRandom) do
				PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].PlayedRandom[k].Wait = PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].PlayedRandom[k].Wait - 1
			end
			while #PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].PlayedRandom > PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RandomReuse do
				tinsert(PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].RemainingTracks, PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].PlayedRandom[1].Track)
				tremove(PetBattlePokemonMusic.db.global.PlayLists[currentMusicIndex].PlayedRandom, 1)
			end
		end
	end
end
function PetBattlePokemonMusic:StopPlayer()

end

