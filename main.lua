-- 已知问题：使用luamod热重载本mod后，本mod道具不生效的问题（原因未知）
LWaterMod = RegisterMod("L Water",1)
-- put your scripts here
include("scripts.items.collectibles.itemid")
include("scripts.enums")
-- lib
include("scripts.lib.tearfiredelay")
include("scripts.lib.savedata")
-- sfx
include("scripts.sfx.modsound")
-- EID
if EID then
    include("eid/cn/collectibles")
    include("eid/en/collectibles_en")
end