-- 仅供模板使用
local mod = LWaterMod --引用mod的全局变量，表明这个文件的代码属于此mod。注意：如果你修改了templatemod，请把templatemod改为对应的全局变量！
local SuperPotion = {} --如果想要让道具兼容EID的话，需要这个数组来收集有关此道具的信息
SuperPotion.name = "Super Potion" --道具名称
SuperPotion.ID = Isaac.GetItemIdByName("Super Potion") --道具ID
local game = Game() --引用游戏本身，包含游戏当中最基础的功能，如获取当前房间的GetRoom()函数等

function SuperPotion:statchange(player, flag)
	if player:HasCollectible(SuperPotion.ID) then --如果玩家持有超级药水
		local itemcount = player:GetCollectibleNum(SuperPotion.ID) --统计道具持有量，据此改变玩家的属性
		local increasedspeed = 0.15 * itemcount --每个道具增加0.15的移速
		local increasedluck = 1.2 * itemcount --每个道具增加1.2的幸运
		local increasedfiredelay = 0.75 * itemcount --每个道具减少0.75的射击延迟
		local increasedtearrange = 60 * itemcount --每个道具增加1.5的射程
		local increasedshotspeed = 0.08 * itemcount --每个道具增加0.08的弹速
		local increaseddamage = 0.5 * itemcount --每个道具增加0.5的伤害
		--之后用上面的变量，在玩家已有的属性之上进行修改即可，方法和修改玩家的初始属性是一致的
		if flag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + increasedspeed
		end
		if flag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + increasedluck
		end
		if flag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - increasedfiredelay
		end
		if flag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + increasedtearrange
		end
		if flag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + increasedshotspeed
		end
		if flag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + increaseddamage
		end
	end
end

--修改玩家属性只是被动道具最基础的用法。想要给被动道具更多效果的话，就得利用各种函数、条件、循环来达成了
--另外，关于该道具所使用的蝗虫的特殊效果的代码最好要跟道具本身的代码放在一起。不过给蝗虫单独开一个lua文件可能会更好......？
--此处不做过多延伸，毕竟制作mod时花费的时间大多是在参考API文档、参考他人mod、发挥想象力和多多尝试上的，只有自己去做才能够弄明白其中的原理

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SuperPotion.statchange) --这段代码用于调整上面的函数的触发条件，格式一般为（函数触发条件，触发的函数，指定参数）。此处的条件为进行属性缓存检测时触发

return SuperPotion --道具代码加载完后，返回数组