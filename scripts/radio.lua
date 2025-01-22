radioAlive = true
radioOn = false
manuallyTurnedOff = false  -- Új változó a manuális kikapcsolás nyomon követésére
songToPlay = 1
volume = 0.5

textcooldown = 300
counter = 0
songTimer = 0  -- Új változó a dal lejátszási idejének nyomon követésére
songMaxTime = 100  -- Másodpercben a dal maximális lejátszási ideje
staticDuration = 3  -- Statikus hang hossza másodpercben
staticTimer = 0  -- Statikus hang időzítője
isPlayingStatic = false  -- Jelzi, hogy éppen statikus hangot játszik-e
--                                            JUST ADD "SONG.OGG" FILES BELOW AND COPY THE FILE IN THE "RADIO" FOLDER THE SCRIPT HANDLES THE REST
songs ={"MOD/sounds/env/music/radio/MUS_Radio_Track_1.ogg",
        "MOD/sounds/env/music/radio/MUS_Radio_Track_2.ogg",
        "MOD/sounds/env/music/radio/aihell3.ogg",
		    "MOD/sounds/env/music/radio/MUS_Radio_Track_Unknown_2.ogg",
		    "MOD/sounds/env/music/radio/MUS_Radio_Track_Warp_3.ogg"}

function init()
  channels = {}
  for i=1, #songs do
    channels[i] = LoadLoop(songs[i])
  end
  breakSound = LoadSound("radioBreaksSound.ogg")
  nextSongSound = LoadSound("MOD/sounds/env/music/radio/effects/BTN_radio_next.ogg")
  OnOffSound = LoadSound("MOD/sounds/env/music/radio/harryhouseknradioONOFF")
  trigger = FindTrigger("trigger")
  trigger2 = FindTrigger("trigger2")
  static = LoadLoop("MOD/sounds/env/music/radio/effects/Radio_Static_Loop_05.ogg")

  myRadio = FindShape("myradio", true)
  powerbutton = FindShape("radiopowerbutton", true)
  myButtonGreen = FindShape("radioButtonGreen", true)
  myVolUp = FindShape("radiovolupbutton", true)
  myVolDown = FindShape("radiovoldownbutton", true)
  myRandom = FindShape("radioButtonRandom", true)
  mylast = FindShape("radioButtonUndo", true)
  songToPlay = math.random(#songs)
end

function tick()
  local interactShape = GetPlayerInteractShape()
  local p = GetPlayerPos()

  -- Csak akkor kapcsol be a rádió, ha a trigger-ben van a játékos, ÉS nem lett manuálisan kikapcsolva
  if IsPointInTrigger(trigger, p) and not manuallyTurnedOff then
    radioOn = true
  end
  if IsPointInTrigger(trigger2, p) and not manuallyTurnedOff then
    radioOn = false
  end  

  if interactShape == 0 then interactShape = nil end
  if radioAlive then
    t = GetShapeWorldTransform(myRadio)

    if InputPressed("interact") and interactShape == myButtonGreen then
      PlaySound(nextSongSound, t.pos, 0.2)
      if radioOn then
        DrawShapeOutline(myRadio, 1, 1, 1, 1)
        songToPlay = songToPlay + 1
        StopMusic()

        if songToPlay > #songs then
          songToPlay = 1
        end
        schreib(songs[songToPlay])
        songTimer = 0  -- Időzítő visszaállítása
      end
    end

    if InputPressed("interact") and interactShape == powerbutton then
      PlaySound(OnOffSound, t.pos, 0.2)
      DrawShapeOutline(myRadio, 1, 1, 1, 1)
      if radioOn then
        radioOn = false
        manuallyTurnedOff = true  -- Manuális kikapcsolás jelzése
        StopMusic()
      else
        radioOn = true
        manuallyTurnedOff = false -- Manuális kikapcsolás törlése, ha újra bekapcsolják
        schreib(songs[songToPlay])
        songTimer = 0  -- Időzítő visszaállítása
      end
    end

    if InputPressed("interact") and interactShape == myVolUp then
      PlaySound(nextSongSound, t.pos, 0.2)
      songToPlay = songToPlay + 1
      if songToPlay > #songs then
        songToPlay = 1
      end
      schreib(songs[songToPlay])
      songTimer = 0  -- Időzítő visszaállítása
    end

    if InputPressed("interact") and interactShape == myVolDown then
      PlaySound(nextSongSound, t.pos, 0.2)
      songToPlay = songToPlay - 1
      if songToPlay < 1 then
        songToPlay = #songs
      end
      schreib(songs[songToPlay])
      songTimer = 0  -- Időzítő visszaállítása
    end

    if InputPressed("interact") and interactShape == mylast then
      PlaySound(nextSongSound, t.pos, 0.2)
      if radioOn then
        DrawShapeOutline(myRadio, 1, 1, 1, 1)
        songToPlay = songToPlay - 1
        StopMusic()
        if songToPlay < 1 then
          songToPlay = #songs
        end
        schreib(songs[songToPlay])
        songTimer = 0  -- Időzítő visszaállítása
      end
    end

    if InputPressed("interact") and interactShape == myRandom then
      if radioOn then
        playRandom()
        DrawShapeOutline(myRadio, 1, 1, 1, 1)
      end
      PlaySound(nextSongSound, t.pos, 0.2)
    end

    if radioOn then
      if isPlayingStatic then
        -- Statikus hang lejátszása
        PlayLoop(static, t.pos, volume)
        staticTimer = staticTimer + GetTimeStep()
        if staticTimer >= staticDuration then
          isPlayingStatic = false
          staticTimer = 0
          songTimer = 0  -- Új dal időzítőjének indítása
        end
      else
        -- Normál dal lejátszása
        PlayLoop(channels[songToPlay], t.pos, volume)
        songTimer = songTimer + GetTimeStep()  -- Időzítő növelése
        if songTimer >= songMaxTime then
          -- Következő dal indítása statikus hanggal
          StopMusic()
          isPlayingStatic = true  -- Statikus hang bekapcsolása
          songToPlay = songToPlay + 1
          if songToPlay > #songs then
            songToPlay = 1
          end
          schreib(songs[songToPlay])
        end
      end
    end

    if IsShapeBroken(myRadio) then
        killRadio()
        radioAlive = false
    end
  end

  if counter == 0 then
    for i=0 , 50 do
      DebugPrint(" ")
    end
  end

  if counter >= 0 then
    counter = counter - 1
  end
end

function killRadio()
  StopMusic()
  PlaySound(breakSound, t.pos, 0.4)
  for i=0, 50 do
    spawnParticles()
  end
end

function spawnParticles()
  local factor = 5
  local v = Vec(math.random() * factor, math.random() * factor, math.random() * factor)
  math.random()
  local life = math.random()
  life = life*life * 5

  ParticleReset()
  ParticleEmissive(5, 0, "easeout")
  ParticleGravity(-10)
  ParticleRadius(0.03, 0.0, "easein")
  ParticleColor(1, 0.4, 0.3)
  ParticleTile(4)
  ParticleSticky(0,0.1)
  SpawnParticle(t.pos, v, life)
end

function playRandom()
  local rand = math.random(#songs)
  while rand == songToPlay do
    rand = math.random(#songs)
  end
  songToPlay = rand
  schreib(songs[songToPlay])
  songTimer = 0  -- Időzítő visszaállítása
end

function schreib(text)
  counter = textcooldown
  for i=0 , 50 do
    DebugPrint(" ")
  end
  if GetBool('savegame.mod.debug.show.nowplaying') then
    DebugPrint("Now Playing:  " .. text)
  end
end





