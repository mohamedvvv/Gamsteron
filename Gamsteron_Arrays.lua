
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
    
    SKILL_ORDERS =
    {
        ['aatrox'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['ahri'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['akali'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['alistar'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['amumu'] =
        {
            ['MostFrequent'] =
            {
                _W, _E, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _E, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['anivia'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _E, _W, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _E, _W, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['annie'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['ashe'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _W, _Q, _W, _R, _W, _E, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['aurelionsol'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _E, _W, _Q, _R, _Q, _Q, _Q, _E, _R, _E, _E,
            },
        },
        ['azir'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['bard'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['blitzcrank'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['brand'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['braum'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['caitlyn'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _W, _W, _W, _W, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['camille'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['cassiopeia'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _E, _W, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['chogath'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['corki'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['darius'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['diana'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['draven'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['drmundo'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['ekko'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['elise'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['evelynn'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['ezreal'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _E, _Q, _E, _R, _E, _W, _W, _W, _R, _W,
            },
        },
        ['fiddlesticks'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['fiora'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['fizz'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['galio'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['gangplank'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['garen'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _E, _R, _E, _E, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['gnar'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['gragas'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['graves'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['hecarim'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _E, _Q, _R, _Q, _Q, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['heimerdinger'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['illaoi'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _E, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _W, _R, _W,
            },
        },
        ['irelia'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['ivern'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _E, _W, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['janna'] =
        {
            ['MostFrequent'] =
            {
                _W, _E, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['jarvaniv'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _Q, _E, _W, _R, _Q, _Q, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['jax'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['jayce'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _W, _Q, _W, _Q, _W, _Q, _W, _W, _E, _E, _E, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _W, _Q, _W, _Q, _W, _Q, _W, _W, _E, _E, _E, _E, _E,
            },
        },
        ['jhin'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _W, _Q, _R, _Q, _E, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['jinx'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['kaisa'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['kalista'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _E, _W, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['karma'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['karthus'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['kassadin'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['katarina'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _E, _E, _E, _E, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['kayle'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['kayn'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _W, _W, _W, _W, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['kennen'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['khazix'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['kindred'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _W, _Q, _R, _Q, _Q, _Q, _E, _R, _E, _E, _E, _W, _R, _W, _W,
            },
        },
        ['kled'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['kogmaw'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _W, _E, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['leblanc'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['leesin'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _Q, _R, _Q, _Q, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['leona'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['lissandra'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['lucian'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['lulu'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['lux'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['malphite'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['malzahar'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['maokai'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['masteryi'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['missfortune'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['monkeyking'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['mordekaiser'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['morgana'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['nami'] =
        {
            ['MostFrequent'] =
            {
                _W, _E, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _W, _E, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['nasus'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['nautilus'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['neeko'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['nidalee'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _E, _Q, _R, _Q, _Q, _Q, _W, _R, _W, _W, _E, _W, _R, _E, _E,
            },
        },
        ['nocturne'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['nunu'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['olaf'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['orianna'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['ornn'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['pantheon'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['poppy'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['pyke'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['qiyana'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['quinn'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['rakan'] =
        {
            ['MostFrequent'] =
            {
                _W, _E, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['rammus'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _W, _Q, _R, _W, _Q, _W, _E, _R, _W, _E, _E, _E, _R, _Q, _Q,
            },
        },
        ['reksai'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['renekton'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['rengar'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['riven'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _E, _R, _E, _E, _E, _W, _R, _W, _W,
            },
        },
        ['rumble'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['ryze'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['sejuani'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _E, _E, _R, _W, _E, _E, _Q, _R, _W, _W, _W, _Q, _R, _Q, _Q,
            },
        },
        ['shaco'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _E, _E, _E, _E, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _E, _Q, _R, _E, _E, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['shen'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['shyvana'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['singed'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['sion'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['sivir'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['skarner'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['sona'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['soraka'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['swain'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['sylas'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _W, _R, _Q, _Q, _Q, _W, _R, _E, _W, _W, _E, _R, _E, _E,
            },
        },
        ['syndra'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['tahmkench'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['taliyah'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['talon'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _W, _Q, _R, _Q, _Q, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['taric'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['teemo'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _E, _W, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['thresh'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['tristana'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _W, _E, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['trundle'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['tryndamere'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _E, _E, _W, _W, _W, _W, _R, _R,
            },
            ['HighestWin'] =
            {
                _E, _Q, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _E, _E, _W, _W, _W, _W, _R, _R,
            },
        },
        ['twistedfate'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _W, _E, _Q, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['twitch'] =
        {
            ['MostFrequent'] =
            {
                _E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['udyr'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _E, _Q, _E, _Q, _E, _E, _W, _W, _W, _W, _Q, _E, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _E, _Q, _E, _Q, _E, _E, _W, _W, _W, _W, _Q, _E, _W,
            },
        },
        ['urgot'] =
        {
            ['MostFrequent'] =
            {
                _W, _E, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['varus'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['vayne'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _Q, _R, _W, _W, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['veigar'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['velkoz'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['vi'] =
        {
            ['MostFrequent'] =
            {
                _W, _E, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['viktor'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['vladimir'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _Q, _E, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['volibear'] =
        {
            ['MostFrequent'] =
            {
                _W, _E, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['warwick'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _W, _W, _R, _Q, _W, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E,
            },
        },
        ['xayah'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['xerath'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['xinzhao'] =
        {
            ['MostFrequent'] =
            {
                _E, _Q, _W, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['yasuo'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _E, _E, _E, _E, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
        ['yorick'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E,
            },
        },
        ['yuumi'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _Q, _E, _Q, _R, _Q, _E, _Q, _E, _R, _Q, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _E, _Q, _R, _Q, _E, _Q, _E, _R, _Q, _E, _W, _W, _R, _W, _W,
            },
        },
        ['zac'] =
        {
            ['MostFrequent'] =
            {
                _W, _Q, _E, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
            ['HighestWin'] =
            {
                _W, _Q, _E, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q,
            },
        },
        ['zed'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['ziggs'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['zilean'] =
        {
            ['MostFrequent'] =
            {
                _Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['zoe'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _E, _Q, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
        },
        ['zyra'] =
        {
            ['MostFrequent'] =
            {
                _Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,
            },
            ['HighestWin'] =
            {
                _Q, _W, _E, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,
            },
        },
    },
    
    --9.16.1
    HeroNames =
    {
        ['practicetool_targetdummy'] = true,
        ['aatrox'] = true,
        ['ahri'] = true,
        ['akali'] = true,
        ['alistar'] = true,
        ['amumu'] = true,
        ['anivia'] = true,
        ['annie'] = true,
        ['ashe'] = true,
        ['aurelionsol'] = true,
        ['azir'] = true,
        ['bard'] = true,
        ['blitzcrank'] = true,
        ['brand'] = true,
        ['braum'] = true,
        ['caitlyn'] = true,
        ['camille'] = true,
        ['cassiopeia'] = true,
        ['chogath'] = true,
        ['corki'] = true,
        ['darius'] = true,
        ['diana'] = true,
        ['draven'] = true,
        ['drmundo'] = true,
        ['ekko'] = true,
        ['elise'] = true,
        ['evelynn'] = true,
        ['ezreal'] = true,
        ['fiddlesticks'] = true,
        ['fiora'] = true,
        ['fizz'] = true,
        ['galio'] = true,
        ['gangplank'] = true,
        ['garen'] = true,
        ['gnar'] = true,
        ['gragas'] = true,
        ['graves'] = true,
        ['hecarim'] = true,
        ['heimerdinger'] = true,
        ['illaoi'] = true,
        ['irelia'] = true,
        ['ivern'] = true,
        ['janna'] = true,
        ['jarvaniv'] = true,
        ['jax'] = true,
        ['jayce'] = true,
        ['jhin'] = true,
        ['jinx'] = true,
        ['kaisa'] = true,
        ['kalista'] = true,
        ['karma'] = true,
        ['karthus'] = true,
        ['kassadin'] = true,
        ['katarina'] = true,
        ['kayle'] = true,
        ['kayn'] = true,
        ['kennen'] = true,
        ['khazix'] = true,
        ['kindred'] = true,
        ['kled'] = true,
        ['kogmaw'] = true,
        ['leblanc'] = true,
        ['leesin'] = true,
        ['leona'] = true,
        ['lissandra'] = true,
        ['lucian'] = true,
        ['lulu'] = true,
        ['lux'] = true,
        ['malphite'] = true,
        ['malzahar'] = true,
        ['maokai'] = true,
        ['masteryi'] = true,
        ['missfortune'] = true,
        ['monkeyking'] = true,
        ['mordekaiser'] = true,
        ['morgana'] = true,
        ['nami'] = true,
        ['nasus'] = true,
        ['nautilus'] = true,
        ['neeko'] = true,
        ['nidalee'] = true,
        ['nocturne'] = true,
        ['nunu'] = true,
        ['olaf'] = true,
        ['orianna'] = true,
        ['ornn'] = true,
        ['pantheon'] = true,
        ['poppy'] = true,
        ['pyke'] = true,
        ['qiyana'] = true,
        ['quinn'] = true,
        ['rakan'] = true,
        ['rammus'] = true,
        ['reksai'] = true,
        ['renekton'] = true,
        ['rengar'] = true,
        ['riven'] = true,
        ['rumble'] = true,
        ['ryze'] = true,
        ['sejuani'] = true,
        ['shaco'] = true,
        ['shen'] = true,
        ['shyvana'] = true,
        ['singed'] = true,
        ['sion'] = true,
        ['sivir'] = true,
        ['skarner'] = true,
        ['sona'] = true,
        ['soraka'] = true,
        ['swain'] = true,
        ['sylas'] = true,
        ['syndra'] = true,
        ['tahmkench'] = true,
        ['taliyah'] = true,
        ['talon'] = true,
        ['taric'] = true,
        ['teemo'] = true,
        ['thresh'] = true,
        ['tristana'] = true,
        ['trundle'] = true,
        ['tryndamere'] = true,
        ['twistedfate'] = true,
        ['twitch'] = true,
        ['udyr'] = true,
        ['urgot'] = true,
        ['varus'] = true,
        ['vayne'] = true,
        ['veigar'] = true,
        ['velkoz'] = true,
        ['vi'] = true,
        ['viktor'] = true,
        ['vladimir'] = true,
        ['volibear'] = true,
        ['warwick'] = true,
        ['xayah'] = true,
        ['xerath'] = true,
        ['xinzhao'] = true,
        ['yasuo'] = true,
        ['yorick'] = true,
        ['yuumi'] = true,
        ['zac'] = true,
        ['zed'] = true,
        ['ziggs'] = true,
        ['zilean'] = true,
        ['zoe'] = true,
        ['zyra'] = true,
    },
    
    --9.16.1
    HeroPriorities =
    {
        ['aatrox'] = 3,
        ['ahri'] = 4,
        ['akali'] = 4,
        ['alistar'] = 1,
        ['amumu'] = 1,
        ['anivia'] = 4,
        ['annie'] = 4,
        ['ashe'] = 5,
        ['aurelionsol'] = 4,
        ['azir'] = 4,
        ['bard'] = 3,
        ['blitzcrank'] = 1,
        ['brand'] = 4,
        ['braum'] = 1,
        ['caitlyn'] = 5,
        ['camille'] = 3,
        ['cassiopeia'] = 4,
        ['chogath'] = 1,
        ['corki'] = 5,
        ['darius'] = 2,
        ['diana'] = 4,
        ['draven'] = 5,
        ['drmundo'] = 1,
        ['ekko'] = 4,
        ['elise'] = 3,
        ['evelynn'] = 4,
        ['ezreal'] = 5,
        ['fiddlesticks'] = 3,
        ['fiora'] = 3,
        ['fizz'] = 4,
        ['galio'] = 1,
        ['gangplank'] = 4,
        ['garen'] = 1,
        ['gnar'] = 1,
        ['gragas'] = 2,
        ['graves'] = 4,
        ['hecarim'] = 2,
        ['heimerdinger'] = 3,
        ['illaoi'] = 3,
        ['irelia'] = 3,
        ['ivern'] = 1,
        ['janna'] = 2,
        ['jarvaniv'] = 3,
        ['jax'] = 3,
        ['jayce'] = 4,
        ['jhin'] = 5,
        ['jinx'] = 5,
        ['kaisa'] = 5,
        ['kalista'] = 5,
        ['karma'] = 4,
        ['karthus'] = 4,
        ['kassadin'] = 4,
        ['katarina'] = 4,
        ['kayle'] = 4,
        ['kayn'] = 4,
        ['kennen'] = 4,
        ['khazix'] = 4,
        ['kindred'] = 4,
        ['kled'] = 2,
        ['kogmaw'] = 5,
        ['leblanc'] = 4,
        ['leesin'] = 3,
        ['leona'] = 1,
        ['lissandra'] = 4,
        ['lucian'] = 5,
        ['lulu'] = 3,
        ['lux'] = 4,
        ['malphite'] = 1,
        ['malzahar'] = 3,
        ['maokai'] = 2,
        ['masteryi'] = 5,
        ['missfortune'] = 5,
        ['monkeyking'] = 3,
        ['mordekaiser'] = 4,
        ['morgana'] = 3,
        ['nami'] = 3,
        ['nasus'] = 2,
        ['nautilus'] = 1,
        ['neeko'] = 4,
        ['nidalee'] = 4,
        ['nocturne'] = 4,
        ['nunu'] = 2,
        ['olaf'] = 2,
        ['orianna'] = 4,
        ['ornn'] = 2,
        ['pantheon'] = 3,
        ['poppy'] = 2,
        ['pyke'] = 4,
        ['qiyana'] = 4,
        ['quinn'] = 5,
        ['rakan'] = 3,
        ['rammus'] = 1,
        ['reksai'] = 2,
        ['renekton'] = 2,
        ['rengar'] = 4,
        ['riven'] = 4,
        ['rumble'] = 4,
        ['ryze'] = 4,
        ['sejuani'] = 2,
        ['shaco'] = 4,
        ['shen'] = 1,
        ['shyvana'] = 2,
        ['singed'] = 1,
        ['sion'] = 1,
        ['sivir'] = 5,
        ['skarner'] = 2,
        ['sona'] = 3,
        ['soraka'] = 3,
        ['swain'] = 3,
        ['sylas'] = 4,
        ['syndra'] = 4,
        ['tahmkench'] = 1,
        ['taliyah'] = 4,
        ['talon'] = 4,
        ['taric'] = 1,
        ['teemo'] = 4,
        ['thresh'] = 1,
        ['tristana'] = 5,
        ['trundle'] = 2,
        ['tryndamere'] = 4,
        ['twistedfate'] = 4,
        ['twitch'] = 5,
        ['udyr'] = 2,
        ['urgot'] = 2,
        ['varus'] = 5,
        ['vayne'] = 5,
        ['veigar'] = 4,
        ['velkoz'] = 4,
        ['vi'] = 2,
        ['viktor'] = 4,
        ['vladimir'] = 3,
        ['volibear'] = 2,
        ['warwick'] = 2,
        ['xayah'] = 5,
        ['xerath'] = 4,
        ['xinzhao'] = 3,
        ['yasuo'] = 4,
        ['yorick'] = 2,
        ['yuumi'] = 3,
        ['zac'] = 1,
        ['zed'] = 4,
        ['ziggs'] = 4,
        ['zilean'] = 3,
        ['zoe'] = 4,
        ['zyra'] = 2,
    },
    
    -- 9.16.1
    HeroMelees =
    {
        ['aatrox'] = true,
        ['ahri'] = false,
        ['akali'] = true,
        ['alistar'] = true,
        ['amumu'] = true,
        ['anivia'] = false,
        ['annie'] = false,
        ['ashe'] = false,
        ['aurelionsol'] = false,
        ['azir'] = true,
        ['bard'] = false,
        ['blitzcrank'] = true,
        ['brand'] = false,
        ['braum'] = true,
        ['caitlyn'] = false,
        ['camille'] = true,
        ['cassiopeia'] = false,
        ['chogath'] = true,
        ['corki'] = false,
        ['darius'] = true,
        ['diana'] = true,
        ['draven'] = false,
        ['drmundo'] = true,
        ['ekko'] = true,
        ['elise'] = false,
        ['evelynn'] = true,
        ['ezreal'] = false,
        ['fiddlesticks'] = false,
        ['fiora'] = true,
        ['fizz'] = true,
        ['galio'] = true,
        ['gangplank'] = true,
        ['garen'] = true,
        ['gnar'] = false,
        ['gragas'] = true,
        ['graves'] = false,
        ['hecarim'] = true,
        ['heimerdinger'] = false,
        ['illaoi'] = true,
        ['irelia'] = true,
        ['ivern'] = true,
        ['janna'] = false,
        ['jarvaniv'] = true,
        ['jax'] = true,
        ['jayce'] = false,
        ['jhin'] = false,
        ['jinx'] = false,
        ['kaisa'] = false,
        ['kalista'] = false,
        ['karma'] = false,
        ['karthus'] = false,
        ['kassadin'] = true,
        ['katarina'] = true,
        ['kayle'] = false,
        ['kayn'] = true,
        ['kennen'] = false,
        ['khazix'] = true,
        ['kindred'] = false,
        ['kled'] = true,
        ['kogmaw'] = false,
        ['leblanc'] = false,
        ['leesin'] = true,
        ['leona'] = true,
        ['lissandra'] = false,
        ['lucian'] = false,
        ['lulu'] = false,
        ['lux'] = false,
        ['malphite'] = true,
        ['malzahar'] = false,
        ['maokai'] = true,
        ['masteryi'] = true,
        ['missfortune'] = false,
        ['monkeyking'] = true,
        ['mordekaiser'] = true,
        ['morgana'] = false,
        ['nami'] = false,
        ['nasus'] = true,
        ['nautilus'] = true,
        ['neeko'] = false,
        ['nidalee'] = false,
        ['nocturne'] = true,
        ['nunu'] = true,
        ['olaf'] = true,
        ['orianna'] = false,
        ['ornn'] = true,
        ['pantheon'] = true,
        ['poppy'] = true,
        ['pyke'] = true,
        ['qiyana'] = true,
        ['quinn'] = false,
        ['rakan'] = true,
        ['rammus'] = true,
        ['reksai'] = true,
        ['renekton'] = true,
        ['rengar'] = true,
        ['riven'] = true,
        ['rumble'] = true,
        ['ryze'] = false,
        ['sejuani'] = true,
        ['shaco'] = true,
        ['shen'] = true,
        ['shyvana'] = true,
        ['singed'] = true,
        ['sion'] = true,
        ['sivir'] = false,
        ['skarner'] = true,
        ['sona'] = false,
        ['soraka'] = false,
        ['swain'] = false,
        ['sylas'] = true,
        ['syndra'] = false,
        ['tahmkench'] = true,
        ['taliyah'] = false,
        ['talon'] = true,
        ['taric'] = true,
        ['teemo'] = false,
        ['thresh'] = true,
        ['tristana'] = false,
        ['trundle'] = true,
        ['tryndamere'] = true,
        ['twistedfate'] = false,
        ['twitch'] = false,
        ['udyr'] = true,
        ['urgot'] = true,
        ['varus'] = false,
        ['vayne'] = false,
        ['veigar'] = false,
        ['velkoz'] = false,
        ['vi'] = true,
        ['viktor'] = false,
        ['vladimir'] = false,
        ['volibear'] = true,
        ['warwick'] = true,
        ['xayah'] = false,
        ['xerath'] = false,
        ['xinzhao'] = true,
        ['yasuo'] = true,
        ['yorick'] = true,
        ['yuumi'] = false,
        ['zac'] = true,
        ['zed'] = true,
        ['ziggs'] = false,
        ['zilean'] = false,
        ['zoe'] = false,
        ['zyra'] = false,
    },
    
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