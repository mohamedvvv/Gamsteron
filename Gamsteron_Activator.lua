
local Menu = SDK.Menu
local Math = SDK.Math
local Data = SDK.Data
local Object, Target, Orbwalker, Cursor

SDK.Init.Activator = function()
    Object = SDK.ObjectManager
    Target = SDK.TargetSelector
    Orbwalker = SDK.Orbwalker
    Cursor = SDK.Cursor
end

local LevelUp, SummonerSpell, Item

LevelUp =
{
    SpellToKey =
    {
        [_Q] = HK_Q,
        [_W] = HK_W,
        [_E] = HK_E,
        [_R] = HK_R,
    },
    
    Level =
    0,
    
    QCount =
    0,
    
    WCount =
    0,
    
    ECount =
    0,
    
    RCount =
    0,
    
    Enabled =
    nil,
    
    Timer =
    0,
}

do
    function LevelUp:Init()
        self.Enabled = Menu.AutoLevelUp.Enabled
        self.StartAt = Menu.AutoLevelUp.StartAt
        self.SkillOrderMenu = Menu.SkillOrder
        local skillOrders = Data.SKILL_ORDERS[myHero.charName:lower()]
        self.SkillOrder1 = skillOrders['M']
        self.SkillOrder2 = skillOrders['W']
        self.CurrentOrder = self.SkillOrder2
        
        table.insert(SDK.Tick, function()
            self:Tick()
        end)
    end
    
    function LevelUp:Tick()
        if not self.Enabled:Value() then
            return
        end
        
        if Cursor.Step > 0 then
            return
        end
        
        local levelData = myHero.levelData
        
        if levelData.lvlPts <= 0 then
            return
        end
        
        if levelData.lvl < self.StartAt:Value() then
            return
        end
        
        if GetTickCount() < self.Timer then
            return
        end
        self.Timer = GetTickCount() + math.random(500, 1000)
        
        if levelData.lvl > self.Level then
            self.Level = levelData.lvl
            if self.SkillOrderMenu:Value() == 1 then
                self.CurrentOrder = self.SkillOrder1
            else
                self.CurrentOrder = self.SkillOrder2
            end
            self.QCount = 0
            self.WCount = 0
            self.ECount = 0
            self.RCount = 0
            for i = 1, self.Level do
                local currentSpell = self.CurrentOrder[i]
                if currentSpell == _Q then
                    self.QCount = self.QCount + 1
                elseif currentSpell == _W then
                    self.WCount = self.WCount + 1
                elseif currentSpell == _E then
                    self.ECount = self.ECount + 1
                elseif currentSpell == _R then
                    self.RCount = self.RCount + 1
                end
            end
        end
        
        local rData = myHero:GetSpellData(_R)
        local rLevel = rData.level
        if self.RCount > rLevel then
            self:PressKeys(self.SpellToKey[_R])
            return
        end
        
        local qData = myHero:GetSpellData(_Q)
        local qLevel = qData.level
        if self.QCount > qLevel then
            self:PressKeys(self.SpellToKey[_Q])
            return
        end
        
        local wData = myHero:GetSpellData(_W)
        local wLevel = wData.level
        if self.WCount > wLevel then
            self:PressKeys(self.SpellToKey[_W])
            return
        end
        
        local eData = myHero:GetSpellData(_E)
        local eLevel = eData.level
        if self.ECount > eLevel then
            self:PressKeys(self.SpellToKey[_E])
            return
        end
    end
    
    function LevelUp:PressKeys(spellKey)
        Control.KeyDown(HK_LUS)
        Control.KeyDown(spellKey)
        Control.KeyUp(spellKey)
        Control.KeyUp(HK_LUS)
    end
end

SummonerSpell =
{
    SpellNames =
    {
        'SummonerHeal', --1 heal
        'SummonerHaste', --2 ghost
        'SummonerBarrier', --3 barrier
        'SummonerExhaust', --4 exhaust
        'SummonerFlash', --5 flash
        'SummonerTeleport', --6 teleport
        'SummonerSmite', --7 smite
        'SummonerBoost', --8 cleanse
        'SummonerDot', --9 ignite
    },
    Spell =
    {
        {
            Id = 0,
            Ready = false,
        },
        {
            Id = 0,
            Ready = false,
        },
    },
    CleanseStartTime = GetTickCount(),
}

do
    function SummonerSpell:Init
        ()
        
        self.MenuCleanse = Menu.SummonerSpells.Cleanse
        self.MenuCleanseBuffs = Menu.SummonerSpells.Cleanse.BuffTypes
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function SummonerSpell:OnLoad
        ()
        
        print('loaded')
        table.insert(SDK.Tick, function()
            self:OnTick()
        end)
    end
    
    function SummonerSpell:OnTick
        ()
        
        if Cursor.Step > 0 then return false end
        local sd1 = myHero:GetSpellData(SUMMONER_1)
        local sd2 = myHero:GetSpellData(SUMMONER_2)
        local success1 = false
        local success2 = false
        for i = 1, 9 do
            if not success1 and sd1.name == self.SpellNames[i] then
                self.Spell[1].Id = i
                self.Spell[1].Ready = sd1.currentCd == 0 and Game.CanUseSpell(SUMMONER_1) == 0
                success1 = true
            elseif not success2 and sd2.name == self.SpellNames[i] then
                self.Spell[2].Id = i
                self.Spell[2].Ready = sd2.currentCd == 0 and Game.CanUseSpell(SUMMONER_2) == 0
                success2 = true
            end
        end
        if not success1 and not success2 then return end
        if not success1 then self.Spell[1].Ready = false end
        if not success2 then self.Spell[2].Ready = false end
        local s1 = self.Spell[1]
        local s2 = self.Spell[2]
        if not s1.Ready and not s2.Ready then return end
        
        -- cleanse
        if self:UseCleanse(s1, s2) then return end
    end
    
    function SummonerSpell:UseCleanse
        (s1, s2)
        
        local hk
        if s1.Id == 8 and s1.Ready then hk = HK_SUMMONER_1 end
        if s2.Id == 8 and s2.Ready then hk = HK_SUMMONER_2 end
        if hk == nil then return false end
        
        if GetTickCount() < Item.CleanseStartTime + 200 then return false end
        
        if not self.MenuCleanse.Enabled:Value() then
            return false
        end
        
        local enemiesCount = 0
        local menuDistance = self.MenuCleanse.Distance:Value()
        
        for i = 1, Game.HeroCount() do
            local hero = Game.Hero(i)
            if Object:IsValid(hero, Obj_AI_Hero) and hero.isEnemy and hero.distance <= menuDistance then
                enemiesCount = enemiesCount + 1
            end
        end
        
        if enemiesCount < self.MenuCleanse.Count:Value() then
            return false
        end
        
        local menuDuration = self.MenuCleanse.Duration:Value() * 0.001
        
        local menuBuffs = {
            [5] = self.MenuCleanseBuffs.Stun:Value(),
            [11] = self.MenuCleanseBuffs.Snare:Value(),
            [24] = self.MenuCleanseBuffs.Supress:Value(),
            [29] = self.MenuCleanseBuffs.Knockup:Value(),
            [21] = self.MenuCleanseBuffs.Fear:Value(),
            [22] = self.MenuCleanseBuffs.Charm:Value(),
            [8] = self.MenuCleanseBuffs.Taunt:Value(),
            [30] = self.MenuCleanseBuffs.Knockback:Value(),
            [25] = self.MenuCleanseBuffs.Blind:Value(),
            [31] = self.MenuCleanseBuffs.Disarm:Value(),
            [10] = self.MenuCleanseBuffs.Slow:Value(),
        }
        
        for i = 0, myHero.buffCount do
            local buff = myHero:GetBuff(i)
            if buff and buff.count > 0 then
                local buffType = buff.type
                local buffDuration = buff.duration
                if buffType == 10 then
                    if menuBuffs[buffType] and buffDuration >= 1 and myHero.ms <= 200 then
                        Control.CastSpell(hk)
                        self.CleanseStartTime = GetTickCount()
                        return true
                    end
                elseif menuBuffs[buffType] and buffDuration >= menuDuration then
                    Control.CastSpell(hk)
                    self.CleanseStartTime = GetTickCount()
                    return true
                end
            end
        end
        
        return false
    end
end

Item =
{
    ItemSlots =
    {
        ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6, ITEM_7,
    },
    
    ItemKeys =
    {
        HK_ITEM_1, HK_ITEM_2, HK_ITEM_3, HK_ITEM_4, HK_ITEM_5, HK_ITEM_6, HK_ITEM_7
    },
    
    ItemBotrk =
    {
        3153, 3144, 3389,
    },
    
    ItemQss =
    {
        3139, 3140,
    },
    
    ItemGunblade = 3146,
    
    --[[
    ITEM_HYDRA =
    {
        ['tia'] = {name = 'Tiamat', id = 3077, range = 300},
        ['hyd'] = {name = 'Ravenous Hydra', id = 3074, range = 300},
        ['tit'] = {name = 'Titanic Hydra', id = 3748, range = 300},
    },
 
    ITEM_SKILLSHOT =
    {
        ['pro'] = {name = 'Hextech Protobelt-01', id = 3152, range = 800},
        ['glp'] = {name = 'Hextech GLP-800', id = 3030, range = 800},
    },]]
    
    CachedItems = {},
    
    Hotkey = nil,
    
    CleanseStartTime = GetTickCount(),
}

do
    function Item:Init
        ()
        self.MenuQss = Menu.Main.Items.Qss
        self.MenuQssBuffs = Menu.Main.Items.Qss.BuffTypes
        self.MenuBotrk = Menu.Main.Items.Botrk
        self.MenuGunblade = Menu.Main.Items.HexGun
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Item:OnLoad
        ()
        table.insert(SDK.Tick, function()
            if self:UseQss() then
                return
            end
            
            if Orbwalker.Modes[Orbwalker.ORBWALKER_MODE_COMBO] then
                if self:UseGunblade() then
                    return
                end
                
                if self:UseBotrk() then
                    return
                end
            end
        end)
        
        table.insert(SDK.Tick, function()
            self.CachedItems = {}
        end)
    end
    
    function Item:GetItemById
        (unit, id)
        local networkID = unit.networkID
        if self.CachedItems[networkID] == nil then
            local t = {}
            for i = 1, #self.ItemSlots do
                local slot = self.ItemSlots[i]
                local item = unit:GetItemData(slot)
                if item ~= nil and item.itemID ~= nil and item.itemID > 0 then
                    t[item.itemID] = i
                end
            end
            self.CachedItems[networkID] = t
        end
        return self.CachedItems[networkID][id]
    end
    
    function Item:IsReady
        (unit, id)
        local item = self:GetItemById(unit, id)
        if item and myHero:GetSpellData(self.ItemSlots[item]).currentCd == 0 then
            self.Hotkey = self.ItemKeys[item]
            return true
        end
        return false
    end
    
    function Item:UseBotrk
        ()
        if not self.MenuBotrk.Enabled:Value() then
            return false
        end
        
        local botrkReady = false
        for _, id in pairs(self.ItemBotrk) do
            if self:IsReady(myHero, id) then
                botrkReady = true
                break
            end
        end
        
        if not botrkReady then
            return false
        end
        
        local bbox = myHero.boundingRadius
        local target = Target:GetTarget(550 - 35 + bbox, 0, true)
        
        if target == nil then
            return false
        end
        
        if target.distance < self.MenuBotrk.TargetDistance:Value() then
            Control.CastSpell(self.Hotkey, target)
            return true
        end
        
        if self.MenuBotrk.AntiMelee:Value() then
            local meleeHeroes = {}
            for i = 1, Game.HeroCount() do
                local hero = Game.Hero(i)
                if Object:IsValid(hero, Obj_AI_Hero) and hero.isEnemy then
                    local heroRange = hero.range
                    if heroRange < 400 and hero.distance < heroRange + bbox + hero.boundingRadius then
                        table.insert(meleeHeroes, hero)
                    end
                end
            end
            if #meleeHeroes > 0 then
                table.sort(meleeHeroes, function(a, b) return a.health + (a.totalDamage * 2) + (a.attackSpeed * 100) > b.health + (b.totalDamage * 2) + (b.attackSpeed * 100) end)
                Control.CastSpell(self.Hotkey, meleeHeroes[1])
                return true
            end
        end
        
        local myHeroHealth = 100 * (myHero.health / myHero.maxHealth)
        if myHeroHealth <= self.MenuBotrk.HeroHealth:Value() then
            Control.CastSpell(self.Hotkey, target)
            return true
        end
        
        if target.distance >= self.MenuBotrk.FleeRange:Value() and 100 * (target.health / target.maxHealth) <= self.MenuBotrk.FleeHealth:Value() and Math:IsFacing(myHero, target, 90) and not Math:IsFacing(target, myHero, 90) then
            Control.CastSpell(self.Hotkey, target)
            return true
        end
        
        return false
    end
    
    function Item:UseGunblade
        ()
        if not self.MenuGunblade.Enabled:Value() then
            return false
        end
        
        if not self:IsReady(myHero, self.ItemGunblade) then
            return false
        end
        
        local target = Target:GetTarget(700 - 35, 1, false)
        
        if target == nil then
            return false
        end
        
        if target.distance < self.MenuGunblade.TargetDistance:Value() then
            Control.CastSpell(self.Hotkey, target)
            return true
        end
        
        if self.MenuGunblade.AntiMelee:Value() then
            local meleeHeroes = {}
            local bbox = myHero.boundingRadius
            for i = 1, Game.HeroCount() do
                local hero = Game.Hero(i)
                if Object:IsValid(hero, Obj_AI_Hero) and hero.isEnemy then
                    local heroRange = hero.range
                    if heroRange < 400 and hero.distance < heroRange + bbox + hero.boundingRadius then
                        table.insert(meleeHeroes, hero)
                    end
                end
            end
            if #meleeHeroes > 0 then
                table.sort(meleeHeroes, function(a, b) return a.health + (a.totalDamage * 2) + (a.attackSpeed * 100) > b.health + (b.totalDamage * 2) + (b.attackSpeed * 100) end)
                Control.CastSpell(self.Hotkey, meleeHeroes[1])
                return true
            end
        end
        
        local myHeroHealth = 100 * (myHero.health / myHero.maxHealth)
        if myHeroHealth <= self.MenuGunblade.HeroHealth:Value() then
            Control.CastSpell(self.Hotkey, target)
            return true
        end
        
        if target.distance >= self.MenuGunblade.FleeRange:Value() and 100 * (target.health / target.maxHealth) <= self.MenuGunblade.FleeHealth:Value() and Math:IsFacing(myHero, target, 90) and not Math:IsFacing(target, myHero, 90) then
            Control.CastSpell(self.Hotkey, target)
            return true
        end
        
        return false
    end
    
    function Item:UseQss
        ()
        
        if GetTickCount() < SummonerSpell.CleanseStartTime + 200 then return false end
        
        if not self.MenuQss.Enabled:Value() then
            return false
        end
        
        local qssReady = false
        for _, id in pairs(self.ItemQss) do
            if self:IsReady(myHero, id) then
                qssReady = true
                break
            end
        end
        
        if not qssReady then
            return false
        end
        
        local enemiesCount = 0
        local menuDistance = self.MenuQss.Distance:Value()
        
        for i = 1, Game.HeroCount() do
            local hero = Game.Hero(i)
            if Object:IsValid(hero, Obj_AI_Hero) and hero.isEnemy and hero.distance <= menuDistance then
                enemiesCount = enemiesCount + 1
            end
        end
        
        if enemiesCount < self.MenuQss.Count:Value() then
            return false
        end
        
        local menuDuration = self.MenuQss.Duration:Value() * 0.001
        
        local menuBuffs = {
            [5] = self.MenuQssBuffs.Stun:Value(),
            [11] = self.MenuQssBuffs.Snare:Value(),
            [24] = self.MenuQssBuffs.Supress:Value(),
            [29] = self.MenuQssBuffs.Knockup:Value(),
            [21] = self.MenuQssBuffs.Fear:Value(),
            [22] = self.MenuQssBuffs.Charm:Value(),
            [8] = self.MenuQssBuffs.Taunt:Value(),
            [30] = self.MenuQssBuffs.Knockback:Value(),
            [25] = self.MenuQssBuffs.Blind:Value(),
            [31] = self.MenuQssBuffs.Disarm:Value(),
            [10] = self.MenuQssBuffs.Slow:Value(),
        }
        
        for i = 0, myHero.buffCount do
            local buff = myHero:GetBuff(i)
            if buff and buff.count > 0 then
                local buffType = buff.type
                local buffDuration = buff.duration
                if buffType == 10 then
                    if menuBuffs[buffType] and buffDuration >= 1 and myHero.ms <= 200 then
                        Control.CastSpell(self.Hotkey)
                        self.CleanseStartTime = GetTickCount()
                        return true
                    end
                elseif menuBuffs[buffType] and buffDuration >= menuDuration then
                    Control.CastSpell(self.Hotkey)
                    self.CleanseStartTime = GetTickCount()
                    return true
                end
            end
        end
        
        return false
    end
    
    function Item:HasItem
        (unit, id)
        return self:GetItemById(unit, id) ~= nil
    end
end

SDK.LevelUp = LevelUp
SDK.SummonerSpell = SummonerSpell
SDK.ItemManager = Item