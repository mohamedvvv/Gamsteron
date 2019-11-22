
local _Q, _W, _E, _R = _Q, _W, _E, _R
local Buff, myHero = SDK.BuffManager, myHero

return {
    JungleTeam =
    300,
    
    AllyTeam =
    myHero.team,
    
    EnemyTeam =
    300 - myHero.team,
    
    HeroName =
    myHero.charName:lower(),
    
    ChannelingBuffs =
    {
        ['caitlyn'] = function()
            return Buff:HasBuff(myHero, 'CaitlynAceintheHole')
        end,
        ['fiddlesticks'] = function()
            return Buff:HasBuff(myHero, 'Drain') or Buff:HasBuff(myHero, 'Crowstorm')
        end,
        ['galio'] = function()
            return Buff:HasBuff(myHero, 'GalioIdolOfDurand')
        end,
        ['janna'] = function()
            return Buff:HasBuff(myHero, 'ReapTheWhirlwind')
        end,
        ['kaisa'] = function()
            return Buff:HasBuff(myHero, 'KaisaE')
        end,
        ['karthus'] = function()
            return Buff:HasBuff(myHero, 'karthusfallenonecastsound')
        end,
        ['katarina'] = function()
            return Buff:HasBuff(myHero, 'katarinarsound')
        end,
        ['lucian'] = function()
            return Buff:HasBuff(myHero, 'LucianR')
        end,
        ['malzahar'] = function()
            return Buff:HasBuff(myHero, 'alzaharnethergraspsound')
        end,
        ['masteryi'] = function()
            return Buff:HasBuff(myHero, 'Meditate')
        end,
        ['missfortune'] = function()
            return Buff:HasBuff(myHero, 'missfortunebulletsound')
        end,
        ['nunu'] = function()
            return Buff:HasBuff(myHero, 'AbsoluteZero')
        end,
        ['pantheon'] = function()
            return Buff:HasBuff(myHero, 'pantheonesound') or Buff:HasBuff(myHero, 'PantheonRJump')
        end,
        ['shen'] = function()
            return Buff:HasBuff(myHero, 'shenstandunitedlock')
        end,
        ['twistedfate'] = function()
            return Buff:HasBuff(myHero, 'Destiny')
        end,
        ['urgot'] = function()
            return Buff:HasBuff(myHero, 'UrgotSwap2')
        end,
        ['varus'] = function()
            return Buff:HasBuff(myHero, 'VarusQ')
        end,
        ['velkoz'] = function()
            return Buff:HasBuff(myHero, 'VelkozR')
        end,
        ['vi'] = function()
            return Buff:HasBuff(myHero, 'ViQ')
        end,
        ['vladimir'] = function()
            return Buff:HasBuff(myHero, 'VladimirE')
        end,
        ['warwick'] = function()
            return Buff:HasBuff(myHero, 'infiniteduresssound')
        end,
        ['xerath'] = function()
            return Buff:HasBuff(myHero, 'XerathArcanopulseChargeUp') or Buff:HasBuff(myHero, 'XerathLocusOfPower2')
        end,
    },
    
    SpecialWindup =
    {
        ['twistedfate'] = function()
            if Buff:HasBuff(myHero, 'BlueCardPreAttack') or Buff:HasBuff(myHero, 'RedCardPreAttack') or Buff:HasBuff(myHero, 'GoldCardPreAttack') then
                return 0.125
            end
            return nil
        end,
        ['jayce'] = function()
            if Buff:HasBuff(myHero, 'JayceHyperCharge') then
                return 0.125
            end
            return nil
        end
    },
    
    AllowMovement =
    {
        ['kaisa'] = function()
            return Buff:HasBuff(myHero, 'KaisaE')
        end,
        ['lucian'] = function()
            return Buff:HasBuff(myHero, 'LucianR')
        end,
        ['varus'] = function()
            return Buff:HasBuff(myHero, 'VarusQ')
        end,
        ['vi'] = function()
            return Buff:HasBuff(myHero, 'ViQ')
        end,
        ['vladimir'] = function()
            return Buff:HasBuff(myHero, 'VladimirE')
        end,
        ['xerath'] = function()
            return Buff:HasBuff(myHero, 'XerathArcanopulseChargeUp')
        end,
    },
    
    DisableAttackBuffs =
    {
        ['urgot'] = function()
            return Buff:HasBuff(myHero, 'UrgotW')
        end,
        ['darius'] = function()
            return Buff:HasBuff(myHero, 'dariusqcast')
        end,
        ['graves'] = function()
            if myHero.hudAmmo == 0 then
                return true
            end
            return false
        end,
        ['jhin'] = function()
            if Buff:HasBuff(myHero, 'JhinPassiveReload') then
                return true
            end
            if myHero.hudAmmo == 0 then
                return true
            end
            return false
        end,
    },
    
    SpecialMissileSpeeds =
    {
        ['caitlyn'] = function()
            if Buff:HasBuff(myHero, 'caitlynheadshot') then
                return 3000
            end
            return nil
        end,
        ['graves'] = function()
            return 3800
        end,
        ['illaoi'] = function()
            if Buff:HasBuff(myHero, 'IllaoiW') then
                return 1600
            end
            return nil
        end,
        ['jayce'] = function()
            if Buff:HasBuff(myHero, 'jaycestancegun') then
                return 2000
            end
            return nil
        end,
        ['jhin'] = function()
            if Buff:HasBuff(myHero, 'jhinpassiveattackbuff') then
                return 3000
            end
            return nil
        end,
        ['jinx'] = function()
            if Buff:HasBuff(myHero, 'JinxQ') then
                return 2000
            end
            return nil
        end,
        ['poppy'] = function()
            if Buff:HasBuff(myHero, 'poppypassivebuff') then
                return 1600
            end
            return nil
        end,
        ['twitch'] = function()
            if Buff:HasBuff(myHero, 'TwitchFullAutomatic') then
                return 4000
            end
            return nil
        end,
        ['kayle'] = function()
            if Buff:HasBuff(myHero, 'KayleE') then
                return 1750
            end
            return nil
        end,
    },
    
    --9.23.1
    SKILL_ORDERS={aatrox={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},ahri={M={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},akali={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},alistar={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},amumu={M={1,2,0,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={1,2,0,1,2,3,1,2,1,1,3,2,2,0,0,3,0,0},},anivia={M={0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},annie={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,0,2,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},ashe={M={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={1,0,0,2,1,3,1,1,1,0,3,0,0,2,2,3,2,2},},aurelionsol={M={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={1,0,2,1,1,3,1,2,1,0,3,0,0,0,2,3,2,2},},azir={M={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},bard={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},blitzcrank={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},brand={M={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},braum={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},caitlyn={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},camille={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},cassiopeia={M={2,0,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={2,0,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},chogath={M={2,0,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},corki={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},darius={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={1,0,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},diana={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,0,2,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},draven={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},drmundo={M={1,2,0,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},ekko={M={1,0,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},elise={M={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={2,1,0,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},evelynn={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,1,1,3,1,0,0,0,3,0,1,2,2,3,2,2},},ezreal={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,2,0,2,3,2,1,1,1,3,1},},fiddlesticks={M={2,0,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={2,0,2,1,2,3,0,0,0,0,3,2,2,1,1,3,1,1},},fiora={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},fizz={M={2,1,0,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},W={1,0,2,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},},galio={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},gangplank={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},garen={M={0,2,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,1,0,2,3,2,2,2,0,3,0,0,1,1,3,1,1},},gnar={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},gragas={M={1,0,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={1,0,2,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},graves={M={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,2,2,3,2,0,0,2,3,0,0,1,1,3,1,1},},hecarim={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,0,2,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},heimerdinger={M={0,1,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={0,1,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},illaoi={M={0,1,2,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={1,2,0,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},irelia={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},ivern={M={0,2,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},janna={M={1,2,0,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},W={1,0,1,2,1,3,1,2,1,2,3,2,2,0,0,3,0,0},},jarvaniv={M={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,2,0,3,0,0,0,2,3,2,2,1,1,3,1,1},},jax={M={2,0,1,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={0,2,1,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},jayce={M={0,2,1,0,0,1,0,1,0,1,0,1,1,2,2,2,2,2},W={1,0,2,0,0,1,0,1,0,1,0,1,1,2,2,2,2,2},},jhin={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,0,1,0,3,0,2,0,1,3,1,1,2,2,3,2,2},},jinx={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={2,0,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},kaisa={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,0,2,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},kalista={M={2,0,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={2,0,2,0,2,3,2,0,2,0,3,0,1,1,1,3,1,1},},karma={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},karthus={M={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},kassadin={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},katarina={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,2,2,2,2,3,0,0,1,1,3,1,1},},kayle={M={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,2,0,2,3,2,1,1,1,3,1},},kayn={M={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,1,0,3,0,2,1,2,3,0,2,2,0,3,1,1},},kennen={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={2,0,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},khazix={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,1,1,3,0,0,1,1,3,2,2,2,0,3,2,0},},kindred={M={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,2,3,0,0,0,2,3,1,1,1,1,3,2,2},},kled={M={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},kogmaw={M={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={1,0,1,2,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},leblanc={M={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={2,1,0,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},leesin={M={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,1,2,0,3,0,0,0,1,3,1,1,2,2,3,2,2},},leona={M={0,2,1,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},W={0,2,1,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},lissandra={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},lucian={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},lulu={M={2,0,1,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},W={0,2,1,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},lux={M={2,0,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},malphite={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={1,2,0,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},},malzahar={M={2,1,0,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},maokai={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,0,2,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},masteryi={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},missfortune={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,2,1,0,0,3,0,1,1,0,1,3,1,2,2,2,2,3},},monkeyking={M={2,1,0,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={2,1,0,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},mordekaiser={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},morgana={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},nami={M={1,0,2,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},W={1,0,1,2,1,3,1,2,1,2,3,2,2,0,0,3,0,0},},nasus={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},nautilus={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},neeko={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},nidalee={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},nocturne={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,2,3,0,0,2,3,2,2,1,1,3,1,1},},nunu={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,1,0,3,0,0,0,2,3,2,2,2,1,3,1,1},},olaf={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,0,2,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},orianna={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,2,0,1,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},ornn={M={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={0,1,2,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},},pantheon={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},poppy={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},pyke={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},qiyana={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},quinn={M={2,0,1,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},W={2,0,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},rakan={M={1,2,0,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},W={1,2,0,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},rammus={M={1,0,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={1,0,2,1,0,3,1,0,0,0,3,1,1,2,2,3,2,2},},reksai={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},renekton={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,1,0,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},rengar={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,1,0,3,0,0,0,2,3,2,2,2,1,3,1,1},},riven={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},rumble={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},ryze={M={1,2,0,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,1,0,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},sejuani={M={2,1,0,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={2,1,0,0,1,3,1,1,1,0,3,0,0,2,2,3,2,2},},senna={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},shaco={M={1,0,2,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={1,2,0,0,0,3,2,2,0,2,3,2,0,1,1,3,1,1},},shen={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},shyvana={M={2,1,0,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},W={2,1,0,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},singed={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},sion={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},sivir={M={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},skarner={M={0,2,1,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},W={0,2,1,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},sona={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},soraka={M={0,1,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},swain={M={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,1,0,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},sylas={M={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={2,0,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},syndra={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},tahmkench={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},taliyah={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},talon={M={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={1,0,0,2,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},taric={M={2,1,0,0,2,3,2,2,2,1,3,1,1,1,0,3,0,0},W={2,1,0,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},teemo={M={2,0,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},thresh={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,2,0,3,0,0,0,2,3,2,2,1,1,3,1,1},},tristana={M={2,1,0,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,1,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},trundle={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},tryndamere={M={2,0,0,1,0,3,0,2,0,2,2,2,1,1,1,1,3,3},W={2,0,0,1,0,3,0,2,0,2,2,2,1,1,1,1,3,3},},twistedfate={M={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,0,2,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},twitch={M={2,1,0,2,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={2,1,2,0,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},udyr={M={0,1,2,0,0,2,0,2,0,2,2,1,1,1,1,0,2,1},W={0,1,2,0,0,2,0,2,0,2,2,1,1,1,1,0,2,1},},urgot={M={1,2,0,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},W={2,1,0,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},varus={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={2,1,0,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},vayne={M={0,1,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={0,1,1,2,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},veigar={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},velkoz={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},vi={M={1,2,0,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},viktor={M={0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},W={0,2,2,1,2,3,2,0,2,0,3,0,0,1,1,3,1,1},},vladimir={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,0,2,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},volibear={M={1,2,0,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={1,2,0,1,1,3,1,2,1,0,3,0,0,0,2,3,2,2},},warwick={M={0,1,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},W={1,0,2,1,1,3,1,0,1,0,3,0,0,2,2,3,2,2},},xayah={M={0,2,1,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},W={1,0,2,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},},xerath={M={0,1,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},W={1,0,2,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},xinzhao={M={2,0,1,1,1,3,1,2,1,2,3,2,2,0,0,3,0,0},W={2,0,1,0,1,3,1,1,1,2,3,2,2,2,0,3,0,0},},yasuo={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,0,1,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},yorick={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,1,0,1,3,1,1,2,2,3,2,2},},yuumi={M={0,2,0,2,0,3,0,2,0,2,3,0,2,1,1,3,1,1},W={0,2,0,1,0,3,0,1,0,1,3,0,1,2,2,3,2,2},},zac={M={1,0,2,2,2,3,2,1,2,1,3,1,1,0,0,3,0,0},W={1,0,2,1,1,3,1,0,1,2,3,0,2,2,2,3,0,0},},zed={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},ziggs={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},zilean={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},zoe={M={0,2,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,0,1,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},zyra={M={0,1,2,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},W={2,1,0,0,0,3,0,2,0,2,3,2,2,1,1,3,1,1},},},
    HEROES={aatrox={3,true},ahri={4,false},akali={4,true},alistar={1,true},amumu={1,true},anivia={4,false},annie={4,false},ashe={5,false},aurelionsol={4,false},azir={4,true},bard={3,false},blitzcrank={1,true},brand={4,false},braum={1,true},caitlyn={5,false},camille={3,true},cassiopeia={4,false},chogath={1,true},corki={5,false},darius={2,true},diana={4,true},draven={5,false},drmundo={1,true},ekko={4,true},elise={3,false},evelynn={4,true},ezreal={5,false},fiddlesticks={3,false},fiora={3,true},fizz={4,true},galio={1,true},gangplank={4,true},garen={1,true},gnar={1,false},gragas={2,true},graves={4,false},hecarim={2,true},heimerdinger={3,false},illaoi={3,true},irelia={3,true},ivern={1,true},janna={2,false},jarvaniv={3,true},jax={3,true},jayce={4,false},jhin={5,false},jinx={5,false},kaisa={5,false},kalista={5,false},karma={4,false},karthus={4,false},kassadin={4,true},katarina={4,true},kayle={4,false},kayn={4,true},kennen={4,false},khazix={4,true},kindred={4,false},kled={2,true},kogmaw={5,false},leblanc={4,false},leesin={3,true},leona={1,true},lissandra={4,false},lucian={5,false},lulu={3,false},lux={4,false},malphite={1,true},malzahar={3,false},maokai={2,true},masteryi={5,true},missfortune={5,false},monkeyking={3,true},mordekaiser={4,true},morgana={3,false},nami={3,false},nasus={2,true},nautilus={1,true},neeko={4,false},nidalee={4,false},nocturne={4,true},nunu={2,true},olaf={2,true},orianna={4,false},ornn={2,true},pantheon={3,true},poppy={2,true},pyke={4,true},qiyana={4,true},quinn={5,false},rakan={3,true},rammus={1,true},reksai={2,true},renekton={2,true},rengar={4,true},riven={4,true},rumble={4,true},ryze={4,false},sejuani={2,true},senna={5,true},shaco={4,true},shen={1,true},shyvana={2,true},singed={1,true},sion={1,true},sivir={5,false},skarner={2,true},sona={3,false},soraka={3,false},swain={3,false},sylas={4,true},syndra={4,false},tahmkench={1,true},taliyah={4,false},talon={4,true},taric={1,true},teemo={4,false},thresh={1,true},tristana={5,false},trundle={2,true},tryndamere={4,true},twistedfate={4,false},twitch={5,false},udyr={2,true},urgot={2,true},varus={5,false},vayne={5,false},veigar={4,false},velkoz={4,false},vi={2,true},viktor={4,false},vladimir={3,false},volibear={2,true},warwick={2,true},xayah={5,false},xerath={4,false},xinzhao={3,true},yasuo={4,true},yorick={2,true},yuumi={3,false},zac={1,true},zed={4,true},ziggs={4,false},zilean={3,false},zoe={4,false},zyra={2,false},},

    HeroSpecialMelees =
    {
        ['elise'] = function()
            return myHero.range < 200
        end,
        ['gnar'] = function()
            return myHero.range < 200
        end,
        ['jayce'] = function()
            return myHero.range < 200
        end,
        ['kayle'] = function()
            return myHero.range < 200
        end,
        ['nidalee'] = function()
            return myHero.range < 200
        end,
    },
    
    IsAttackSpell =
    {
        ['CaitlynHeadshotMissile'] = true,
        ['GarenQAttack'] = true,
        ['KennenMegaProc'] = true,
        ['MordekaiserQAttack'] = true,
        ['MordekaiserQAttack1'] = true,
        ['MordekaiserQAttack2'] = true,
        ['QuinnWEnhanced'] = true,
        ['BlueCardPreAttack'] = true,
        ['RedCardPreAttack'] = true,
        ['GoldCardPreAttack'] = true,
        -- 9.9 patch
        ['RenektonSuperExecute'] = true,
        ['RenektonExecute'] = true,
        ['XinZhaoQThrust1'] = true,
        ['XinZhaoQThrust2'] = true,
        ['XinZhaoQThrust3'] = true,
        ['MasterYiDoubleStrike'] = true,
    },
    
    IsNotAttack =
    {
        ['GravesAutoAttackRecoil'] = true,
        ['LeonaShieldOfDaybreakAttack'] = true,
    },
    
    MinionRange =
    {
        ["SRU_ChaosMinionMelee"] = 110,
        ["SRU_ChaosMinionRanged"] = 550,
        ["SRU_ChaosMinionSiege"] = 300,
        ["SRU_ChaosMinionSuper"] = 170,
        ["SRU_OrderMinionMelee"] = 110,
        ["SRU_OrderMinionRanged"] = 550,
        ["SRU_OrderMinionSiege"] = 300,
        ["SRU_OrderMinionSuper"] = 170,
        ["HA_ChaosMinionMelee"] = 110,
        ["HA_ChaosMinionRanged"] = 550,
        ["HA_ChaosMinionSiege"] = 300,
        ["HA_ChaosMinionSuper"] = 170,
        ["HA_OrderMinionMelee"] = 110,
        ["HA_OrderMinionRanged"] = 550,
        ["HA_OrderMinionSiege"] = 300,
        ["HA_OrderMinionSuper"] = 170,
    },
    
    ExtraAttackRanges =
    {
        ["caitlyn"] = function(target)
            if target and Buff:HasBuff(target, "caitlynyordletrapinternal") then
                return 650
            end
            return 0
        end,
    },
    
    AttackResets =
    {
        ["blitzcrank"] = {Slot = _E, Key = HK_E},
        ["camille"] = {Slot = _Q, Key = HK_Q},
        ["chogath"] = {Slot = _E, Key = HK_E},
        ["darius"] = {Slot = _W, Key = HK_W},
        ["drmundo"] = {Slot = _E, Key = HK_E},
        ["elise"] = {Slot = _W, Key = HK_W, Name = "EliseSpiderW"},
        ["fiora"] = {Slot = _E, Key = HK_E},
        ["garen"] = {Slot = _Q, Key = HK_Q},
        ["graves"] = {Slot = _E, Key = HK_E, OnCast = true, CanCancel = true},
        ["kassadin"] = {Slot = _W, Key = HK_W},
        ["illaoi"] = {Slot = _W, Key = HK_W},
        ["jax"] = {Slot = _W, Key = HK_W},
        ["jayce"] = {Slot = _W, Key = HK_W, Name = "JayceHyperCharge"},
        ["kayle"] = {Slot = _E, Key = HK_E},
        ["katarina"] = {Slot = _E, Key = HK_E, CanCancel = true, OnCast = true},
        ["kindred"] = {Slot = _Q, Key = HK_Q},
        ["leona"] = {Slot = _Q, Key = HK_Q},
        ['lucian'] = {Slot = _E, Key = HK_E, Buff = 'LucianPassiveBuff', OnCast = true, CanCancel = true},
        ["masteryi"] = {Slot = _W, Key = HK_W},
        ["mordekaiser"] = {Slot = _Q, Key = HK_Q},
        ["nautilus"] = {Slot = _W, Key = HK_W},
        ["nidalee"] = {Slot = _Q, Key = HK_Q, Name = "Takedown"},
        ["nasus"] = {Slot = _Q, Key = HK_Q},
        ["reksai"] = {Slot = _Q, Key = HK_Q, Name = "RekSaiQ"},
        ["renekton"] = {Slot = _W, Key = HK_W},
        ["rengar"] = {Slot = _Q, Key = HK_Q},
        ["riven"] = {Slot = _Q, Key = HK_Q},
        -- RIVEN BUFFS ["riven"] = {'riventricleavesoundone', 'riventricleavesoundtwo', 'riventricleavesoundthree'},
        ["sejuani"] = {Slot = _E, Key = HK_E, ReadyCheck = true, ActiveCheck = true, SpellName = "SejuaniE2"},
        ["sivir"] = {Slot = _W, Key = HK_W},
        ["trundle"] = {Slot = _Q, Key = HK_Q},
        ["vayne"] = {Slot = _Q, Key = HK_Q, Buff = {'vaynetumblebonus'}, CanCancel = true},
        ["vi"] = {Slot = _E, Key = HK_E},
        ["volibear"] = {Slot = _Q, Key = HK_Q},
        ["monkeyking"] = {Slot = _Q, Key = HK_Q},
        ["xinzhao"] = {Slot = _Q, Key = HK_Q},
        ["yorick"] = {Slot = _Q, Key = HK_Q},
    },
}