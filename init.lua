local HUDID = nil
local T_HUDID
local lastupdate = 0
local lastHP = 0
local TotalHPs = 0

minetest.register_globalstep(function(dtime)
  if not (minetest.localplayer) then return end
  HUDID = HUDID or minetest.localplayer:hud_add({
    hud_elem_type = "text",
    position      = {x = 1, y = 0},
    scale         = {x = 100, y = 100},
    text          = "",
    number        = 0xFFFFFF,
    offset        = {x = -10, y = 25},
    alignment     = {x = -10, y = 3}
  })
  T_HUDID = T_HUDID or minetest.localplayer:hud_add({
    hud_elem_type = "text",
    position      = {x = 1, y = 0},
    scale         = {x = 100, y = 100},
    text          = "Total: 0",
    number        = 0xFFFFFF,
    offset        = {x = -10, y = 25},
    alignment     = {x = -1, y = 3}
  })
  if (not HUDID) or (not T_HUDID)  then
    error("Show damage mod failed on HUD element creating!")
  end
  lastupdate = lastupdate - dtime
  if lastupdate < 0 and minetest.localplayer:hud_get(HUDID).text ~= "" then
    minetest.localplayer:hud_change(HUDID, "text", "")
  end
end)

minetest.register_on_hp_modification(function(hp)
  TotalHPs = hp
  local hpmod = hp - lastHP
  lastHP = hp
  if hpmod == 0 then return end
  if not HUDID then
    return
  end
  local hpstr = tostring(hpmod)
  local color = 0x00FF00
  if hpmod < 0 then
    color = 0xFF0000
  else
    hpstr = "+" .. hpstr
  end
  lastupdate = 5 -- Reset after 5 seconds
  minetest.localplayer:hud_change(HUDID, "number", color)
  minetest.localplayer:hud_change(HUDID, "text", hpstr)
  minetest.localplayer:hud_change(T_HUDID, "text", "Total: " .. tostring(TotalHPs))
end)

minetest.log("info","[Show Damage CSM] OK")
