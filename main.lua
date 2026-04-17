LWaterMod = RegisterMod("L Water",1)
-- put your scripts here
-- item
include("scripts.items.itemid")
include("scripts.lib.tearfiredelay")
include("scripts.items.ganshenme")
include("scripts.items.onelwater")
include("scripts.items.virtualshare")
include("scripts.items.somebodysquotation")
include("scripts.items.classictasteshavedice")
include("scripts.items.stopfemaleclothing")
-- sfx
include("scripts.sfx.modsound")
-- EID
if EID then
    include("eid/cn/collectibles")
    include("eid/en/collectibles_en")
end