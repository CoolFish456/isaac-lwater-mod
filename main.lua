LWaterMod = RegisterMod("L Water",1)
-- put your scripts here
include("scripts.items.collectibles.itemid")
include("scripts.lib.tearfiredelay")
include("scripts.enums")
-- sfx
include("scripts.sfx.modsound")
-- EID
if EID then
    include("eid/cn/collectibles")
    include("eid/en/collectibles_en")
end