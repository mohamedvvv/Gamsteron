
local Menu, Color, Action, Orbwalker, Buff, Damage, Math, Data, Attack

SDK.Init.ObjectManager = function()
    Menu = SDK.Menu
    Color = SDK.Color
    Action = SDK.Action
    Orbwalker = SDK.Orbwalker
    Buff = SDK.BuffManager
    Damage = SDK.Damage
    Math = SDK.Math
    Data = SDK.Data
    Attack = SDK.Attack
end

local Object, Target, Health

Object =
{
    UndyingBuffs =
    {
        ['zhonyasringshield'] = true,
        ['kindredrnodeathbuff'] = true,
        ['ChronoShift'] = true,
        ['UndyingRage'] = true,
        ['JaxCounterStrike'] = true,
    },
    
    AllyBuildings =
    {
    },
    
    EnemyBuildings =
    {
    },
    
    AllyHeroesInGame =
    {
    },
    
    EnemyHeroesInGame =
    {
    },
    
    EnemyHeroCb =
    {
    },
    
    AllyHeroCb =
    {
    },
    
    IsKalista =
    myHero.charName == "Kalista",
    
    IsCaitlyn =
    myHero.charName == "Caitlyn",
    
    IsRiven =
    myHero.charName == "Riven",
    
    IsKindred =
    myHero.charName == "Kindred",
}

do
    function Object:Init
        ()
        self:OnEnemyHeroLoad(function(args)
            if args.charName == 'Kayle' then
                self.UndyingBuffs['JudicatorIntervention'] = true
                return
            end
            if args.charName == 'Taric' then
                self.UndyingBuffs['TaricR'] = true
                return
            end
            if args.charName == 'Kindred' then
                self.UndyingBuffs['kindredrnodeathbuff'] = true
                return
            end
            if args.charName == 'Zilean' then
                self.UndyingBuffs['ChronoShift'] = true
                self.UndyingBuffs['chronorevive'] = true
                return
            end
            if args.charName == 'Tryndamere' then
                self.UndyingBuffs['UndyingRage'] = true
                return
            end
            if args.charName == 'Jax' then
                self.UndyingBuffs['JaxCounterStrike'] = true
                return
            end
            if args.charName == 'Fiora' then
                self.UndyingBuffs['FioraW'] = true
                return
            end
            if args.charName == 'Aatrox' then
                self.UndyingBuffs['aatroxpassivedeath'] = true
                return
            end
            if args.charName == 'Vladimir' then
                self.UndyingBuffs['VladimirSanguinePool'] = true
                return
            end
            if args.charName == 'KogMaw' then
                self.UndyingBuffs['KogMawIcathianSurprise'] = true
                return
            end
            if args.charName == 'Karthus' then
                self.UndyingBuffs['KarthusDeathDefiedBuff'] = true
                return
            end
        end)
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Object:OnLoad
        ()
        for i = 1, Game.ObjectCount() do
            local object = Game.Object(i)
            if object and (object.type == Obj_AI_Barracks or object.type == Obj_AI_Nexus) then
                if object.isEnemy then
                    table.insert(self.EnemyBuildings, object)
                elseif object.isAlly then
                    table.insert(self.AllyBuildings, object)
                end
            end
        end
        Action:Add(function()
            local success = false
            for i = 1, Game.HeroCount() do
                local args = Data:GetHeroData(Game.Hero(i))
                if args.valid and args.isAlly and self.AllyHeroesInGame[args.networkID] == nil then
                    self.AllyHeroesInGame[args.networkID] = true
                    for j, func in pairs(self.AllyHeroCb) do
                        func(args)
                    end
                end
                if args.valid and args.isEnemy and self.EnemyHeroesInGame[args.networkID] == nil then
                    self.EnemyHeroesInGame[args.networkID] = true
                    for j, func in pairs(self.EnemyHeroCb) do
                        func(args)
                    end
                    success = true
                end
            end
            return success
        end, 0, 100)
    end
    
    function Object:OnAllyHeroLoad
        
        (cb)
        table.insert(self.AllyHeroCb, cb)
    end
    
    function Object:OnEnemyHeroLoad
        (cb)
        table.insert(self.EnemyHeroCb, cb)
    end
    
    function Object:IsHeroImmortal
        (unit, jaxE)
        local hp
        hp = 100 * (unit.health / unit.maxHealth)
        self.UndyingBuffs['kindredrnodeathbuff'] = hp < 10
        self.UndyingBuffs['ChronoShift'] = hp < 15
        self.UndyingBuffs['chronorevive'] = hp < 15
        self.UndyingBuffs['UndyingRage'] = hp < 15
        self.UndyingBuffs['JaxCounterStrike'] = jaxE
        for buffName, isActive in pairs(self.UndyingBuffs) do
            if isActive and Buff:HasBuff(unit, buffName) then
                return true
            end
        end
        --[[ anivia passive, olaf R, ...
    if unit.isImmortal and not Buff:HasBuff(unit, 'willrevive') and not Buff:HasBuff(unit, 'zacrebirthready') then
        return true
    end--]]
        return false
    end
    
    function Object:IsValid
        (obj, type, visible, immortal, jaxE)
        if obj == nil then
            return false
        end
        local objID, objType
        objID = obj.networkID
        if objID == nil or objID <= 0 then
            return false
        end
        objType = obj.type
        if objType == nil or (type and type ~= objType) then
            return false
        end
        if (objType == Obj_AI_Hero or objType == Obj_AI_Minion or objType == Obj_AI_Turret) and not obj.valid then
            return false
        end
        if immortal then
            if objType == Obj_AI_Hero then
                if self:IsHeroImmortal(obj, jaxE) then
                    return false
                end
            elseif obj.isImmortal then
                return false
            end
        end
        if (visible and not obj.visible) or obj.dead or not obj.isTargetable then
            return false
        end
        return true
    end
    
    function Object:GetObjectsFromTable
        (t, func)
        local result = {}
        for i, obj in pairs(t) do
            if func(obj) then
                table.insert(result, obj)
            end
        end
        return result
    end
    
    function Object:GetHeroes
        (range, bbox, visible, immortal, jaxE, func)
        local result = {}
        local a = self:GetEnemyHeroes(range, bbox, visible, immortal, jaxE, func)
        local b = self:GetAllyHeroes(range, bbox, visible, immortal, jaxE, func)
        for i = 1, #a do
            table.insert(result, a[i])
        end
        for i = 1, #b do
            table.insert(result, b[i])
        end
        return result
    end
    
    function Object:GetEnemyHeroes
        (range, bbox, visible, immortal, jaxE, func)
        local result = {}
        for i = 1, Game.HeroCount() do
            local obj = Game.Hero(i)
            if self:IsValid(obj, Obj_AI_Hero, visible, immortal, jaxE) and obj.isEnemy then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetAllyHeroes
        (range, bbox, visible, immortal, jaxE, func)
        local result = {}
        for i = 1, Game.HeroCount() do
            local obj = Game.Hero(i)
            if self:IsValid(obj, Obj_AI_Hero, visible, immortal, jaxE) and obj.isAlly then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetMinions
        (range, bbox, visible, immortal, func)
        local result = {}
        local a = self:GetEnemyMinions(range, bbox, visible, immortal, func)
        local b = self:GetAllyMinions(range, bbox, visible, immortal, func)
        for i = 1, #a do
            table.insert(result, a[i])
        end
        for i = 1, #b do
            table.insert(result, b[i])
        end
        return result
    end
    
    function Object:GetEnemyMinions
        (range, bbox, visible, immortal, func)
        local result = {}
        for i = 1, Game.MinionCount() do
            local obj = Game.Minion(i)
            if self:IsValid(obj, Obj_AI_Minion, visible, immortal) and obj.isEnemy and obj.team < 300 then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetAllyMinions
        (range, bbox, visible, immortal, func)
        local result = {}
        for i = 1, Game.MinionCount() do
            local obj = Game.Minion(i)
            if self:IsValid(obj, Obj_AI_Minion, visible, immortal) and obj.isAlly and obj.team < 300 then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetOtherMinions
        (range, bbox, visible, immortal, func)
        local result = {}
        local a = self:GetOtherAllyMinions(range, bbox, visible, immortal, func)
        local b = self:GetOtherEnemyMinions(range, bbox, visible, immortal, func)
        for i = 1, #a do
            table.insert(result, a[i])
        end
        for i = 1, #b do
            table.insert(result, b[i])
        end
        return result
    end
    
    function Object:GetOtherAllyMinions
        (range, bbox, visible, immortal, func)
        local result = {}
        for i = 1, Game.WardCount() do
            local obj = Game.Ward(i)
            if self:IsValid(obj, nil, visible, immortal) and obj.isAlly then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetOtherEnemyMinions
        (range, bbox, visible, immortal, func)
        local result = {}
        for i = 1, Game.WardCount() do
            local obj = Game.Ward(i)
            if self:IsValid(obj, nil, visible, immortal) and obj.isEnemy then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetMonsters
        (range, bbox, visible, immortal, func)
        local result = {}
        for i = 1, Game.MinionCount() do
            local obj = Game.Minion(i)
            if self:IsValid(obj, Obj_AI_Minion, visible, immortal) and obj.team == 300 then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetTurrets
        (range, bbox, visible, immortal, func)
        local result = {}
        local a = self:GetEnemyTurrets(range, bbox, visible, immortal, func)
        local b = self:GetAllyTurrets(range, bbox, visible, immortal, func)
        for i = 1, #a do
            table.insert(result, a[i])
        end
        for i = 1, #b do
            table.insert(result, b[i])
        end
        return result
    end
    
    function Object:GetEnemyTurrets
        (range, bbox, visible, immortal, func)
        local result = {}
        for i = 1, Game.TurretCount() do
            local obj = Game.Turret(i)
            if self:IsValid(obj, Obj_AI_Turret, visible, immortal) and obj.isEnemy then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetAllyTurrets
        (range, bbox, visible, immortal, func)
        local result = {}
        for i = 1, Game.TurretCount() do
            local obj = Game.Turret(i)
            if self:IsValid(obj, Obj_AI_Turret, visible, immortal) and obj.isAlly then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetEnemyBuildings
        (range, bbox, visible, immortal, func)
        local result = {}
        for i, obj in pairs(self.EnemyBuildings) do
            if self:IsValid(obj, nil, visible, immortal) then
                if (not range or obj.distance < range + (bbox and Data:GetBuildingBBox(obj) or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetAllyBuildings
        (range, bbox, visible, immortal, func)
        local result = {}
        for i, obj in pairs(self.AllyBuildings) do
            if self:IsValid(obj, nil, visible, immortal) then
                if (not range or obj.distance < range + (bbox and Data:GetBuildingBBox(obj) or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
    
    function Object:GetAllStructures
        (range, bbox, visible, immortal, func)
        
        local result = {}
        for i, obj in pairs(self.AllyBuildings) do
            if self:IsValid(obj, nil, visible, immortal) then
                if (not range or obj.distance < range + (bbox and Data:GetBuildingBBox(obj) or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        for i, obj in pairs(self.EnemyBuildings) do
            if self:IsValid(obj, nil, visible, immortal) then
                if (not range or obj.distance < range + (bbox and Data:GetBuildingBBox(obj) or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        for i = 1, Game.TurretCount() do
            local obj = Game.Turret(i)
            if self:IsValid(obj, Obj_AI_Turret, visible, immortal) then
                if (not range or obj.distance < range + (bbox and obj.boundingRadius or 0)) and (not func or func(obj)) then
                    table.insert(result, obj)
                end
            end
        end
        return result
    end
end

Target =
{
    SelectionTick =
    0,
    
    Selected =
    nil,
    
    CurrentSort =
    nil,
    
    CurrentSortMode =
    0,
    
    CurrentDamage =
    nil,
    
    SORT_AUTO =
    1,
    
    SORT_CLOSEST =
    2,
    
    SORT_NEAR_MOUSE =
    3,
    
    SORT_LOWEST_HEALTH =
    4,
    
    SORT_LOWEST_MAX_HEALTH =
    5,
    
    SORT_HIGHEST_PRIORITY =
    6,
    
    SORT_MOST_STACK =
    7,
    
    SORT_MOST_AD =
    8,
    
    SORT_MOST_AP =
    9,
    
    SORT_LESS_CAST =
    10,
    
    SORT_LESS_ATTACK =
    11,
    
    ActiveStackBuffs =
    {
        'BraumMark',
    },
    
    StackBuffs =
    {
        ['Vayne'] = {'VayneSilverDebuff'},
        ['TahmKench'] = {'tahmkenchpdebuffcounter'},
        ['Kennen'] = {'kennenmarkofstorm'},
        ['Darius'] = {'DariusHemo'},
        ['Ekko'] = {'EkkoStacks'},
        ['Gnar'] = {'GnarWProc'},
        ['Kalista'] = {'KalistaExpungeMarker'},
        ['Kindred'] = {'KindredHitCharge', 'kindredecharge'},
        ['Tristana'] = {'tristanaecharge'},
        ['Twitch'] = {'TwitchDeadlyVenom'},
        ['Varus'] = {'VarusWDebuff'},
        ['Velkoz'] = {'VelkozResearchStack'},
        ['Vi'] = {'ViWProc'},
    },
}

do
    function Target:Init
        ()
        self.MenuPriorities = Menu.Target.Priorities
        self.MenuDrawSelected = Menu.Main.Drawings.SelectedTarget
        self.MenuTableSortMode = Menu.Target['SortMode' .. myHero.charName]
        self.MenuCheckSelected = Menu.Target.SelectedTarget
        self.MenuCheckSelectedOnly = Menu.Target.OnlySelectedTarget
        
        Object:OnEnemyHeroLoad(function(args)
            local priority = Data:GetHeroPriority(args.charName) or 1
            self.MenuPriorities:MenuElement({id = args.charName, name = args.charName, value = priority, min = 1, max = 5, step = 1})
        end)
        
        if self.StackBuffs[myHero.charName] then
            for i, buffName in pairs(self.StackBuffs[myHero.charName]) do
                table.insert(self.ActiveStackBuffs, buffName)
            end
        end
        
        self.SortModes =
        {
            [self.SORT_AUTO] = function(a, b)
                local aMultiplier = 1.75 - self:GetPriority(a) * 0.15
                local bMultiplier = 1.75 - self:GetPriority(b) * 0.15
                local aDef, bDef = 0, 0
                if self.CurrentDamage == Damage.DAMAGE_TYPE_MAGICAL then
                    local magicPen, magicPenPercent = myHero.magicPen, myHero.magicPenPercent
                    aDef = math.max(0, aMultiplier * (a.magicResist - magicPen) * magicPenPercent)
                    bDef = math.max(0, bMultiplier * (b.magicResist - magicPen) * magicPenPercent)
                elseif self.CurrentDamage == Damage.DAMAGE_TYPE_PHYSICAL then
                    local armorPen, bonusArmorPenPercent = myHero.armorPen, myHero.bonusArmorPenPercent
                    aDef = math.max(0, aMultiplier * (a.armor - armorPen) * bonusArmorPenPercent)
                    bDef = math.max(0, bMultiplier * (b.armor - armorPen) * bonusArmorPenPercent)
                end
                return (a.health * aMultiplier * ((100 + aDef) / 100)) - a.ap - (a.totalDamage * a.attackSpeed * 2) < (b.health * bMultiplier * ((100 + bDef) / 100)) - b.ap - (b.totalDamage * b.attackSpeed * 2)
            end,
            
            [self.SORT_CLOSEST] = function(a, b)
                return a.distance < b.distance
            end,
            
            [self.SORT_NEAR_MOUSE] = function(a, b)
                return a.pos:DistanceTo(Vector(mousePos)) < b.pos:DistanceTo(Vector(mousePos))
            end,
            
            [self.SORT_LOWEST_HEALTH] = function(a, b)
                return a.health < b.health
            end,
            
            [self.SORT_LOWEST_MAX_HEALTH] = function(a, b)
                return a.maxHealth < b.maxHealth
            end,
            
            [self.SORT_HIGHEST_PRIORITY] = function(a, b)
                return self:GetPriority(a) > self:GetPriority(b)
            end,
            
            [self.SORT_MOST_STACK] = function(a, b)
                local aMax = 0
                for i, buffName in pairs(self.ActiveStackBuffs) do
                    local buff = Buff:GetBuff(a, buffName)
                    if buff then
                        aMax = math.max(aMax, math.max(buff.Count, buff.Stacks))
                    end
                end
                local bMax = 0
                for i, buffName in pairs(self.ActiveStackBuffs) do
                    local buff = Buff:GetBuff(b, buffName)
                    if buff then
                        bMax = math.max(bMax, math.max(buff.Count, buff.Stacks))
                    end
                end
                return aMax > bMax
            end,
            
            [self.SORT_MOST_AD] = function(a, b)
                return a.totalDamage > b.totalDamage
            end,
            
            [self.SORT_MOST_AP] = function(a, b)
                return a.ap > b.ap
            end,
            
            [self.SORT_LESS_CAST] = function(a, b)
                local aMultiplier = 1.75 - self:GetPriority(a) * 0.15
                local bMultiplier = 1.75 - self:GetPriority(b) * 0.15
                local aDef, bDef = 0, 0
                local magicPen, magicPenPercent = myHero.magicPen, myHero.magicPenPercent
                aDef = math.max(0, aMultiplier * (a.magicResist - magicPen) * magicPenPercent)
                bDef = math.max(0, bMultiplier * (b.magicResist - magicPen) * magicPenPercent)
                return (a.health * aMultiplier * ((100 + aDef) / 100)) - a.ap - (a.totalDamage * a.attackSpeed * 2) < (b.health * bMultiplier * ((100 + bDef) / 100)) - b.ap - (b.totalDamage * b.attackSpeed * 2)
            end,
            
            [self.SORT_LESS_ATTACK] = function(a, b)
                local aMultiplier = 1.75 - self:GetPriority(a) * 0.15
                local bMultiplier = 1.75 - self:GetPriority(b) * 0.15
                local aDef, bDef = 0, 0
                local armorPen, bonusArmorPenPercent = myHero.armorPen, myHero.bonusArmorPenPercent
                aDef = math.max(0, aMultiplier * (a.armor - armorPen) * bonusArmorPenPercent)
                bDef = math.max(0, bMultiplier * (b.armor - armorPen) * bonusArmorPenPercent)
                return (a.health * aMultiplier * ((100 + aDef) / 100)) - a.ap - (a.totalDamage * a.attackSpeed * 2) < (b.health * bMultiplier * ((100 + bDef) / 100)) - b.ap - (b.totalDamage * b.attackSpeed * 2)
            end,
        }
        
        self.CurrentSortMode = self.MenuTableSortMode:Value()
        self.CurrentSort = self.SortModes[self.CurrentSortMode]
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Target:OnLoad
        ()
        table.insert(SDK.WndMsg, function(msg, wParam)
            if msg == WM_LBUTTONDOWN and self.MenuCheckSelected:Value() and GetTickCount() > self.SelectionTick + 100 then
                self.Selected = nil
                local num = 10000000
                local pos = Vector(mousePos)
                for i, unit in pairs(Object:GetEnemyHeroes(20000, false, true)) do
                    if unit.pos:ToScreen().onScreen then
                        local distance = pos:DistanceTo(unit.pos)
                        if distance < 150 and distance < num then
                            self.Selected = unit
                            num = distance
                        end
                    end
                end
                self.SelectionTick = GetTickCount()
            end
        end)
        
        table.insert(SDK.Draw, function()
            if self.MenuDrawSelected:Value() and Object:IsValid(self.Selected, Obj_AI_Hero, true) then
                Draw.Circle(self.Selected.pos, 150, 1, Color.DarkRed)
            end
        end)
        
        table.insert(SDK.Tick, function()
            local sortMode = self.MenuTableSortMode:Value()
            if sortMode ~= self.CurrentSortMode then
                self.CurrentSortMode = sortMode
                self.CurrentSort = self.SortModes[sortMode]
            end
        end)
    end
    
    function Target:GetTarget
        (a, dmgType, bbox, visible, immortal, jaxE, func)
        
        a = a or 20000
        dmgType = dmgType or 1
        self.CurrentDamage = dmgType
        visible = visible == nil and true or visible
        immortal = immortal == nil and true or immortal
        
        local only = self.MenuCheckSelectedOnly:Value()
        if self.MenuCheckSelected:Value() and Object:IsValid(self.Selected, Obj_AI_Hero, not only and visible, immortal, not only and jaxE) then
            if type(a) == 'number' then
                if self.Selected.distance < a + (bbox and self.Selected.boundingRadius or 0) then
                    return self.Selected
                end
            else
                table.sort(a, function(i, j) return i.distance > j.distance end)
                if #a > 0 and self.Selected.distance <= a[1].distance then
                    return self.Selected
                end
            end
            if only then
                return nil
            end
        end
        
        if type(a) == 'number' then
            a = Object:GetEnemyHeroes(a, bbox, visible, immortal, jaxE, func)
        end
        
        if self.CurrentSortMode == self.SORT_MOST_STACK then
            local stackA = Object:GetObjectsFromTable(a, function(unit)
                for i, buffName in pairs(self.ActiveStackBuffs) do
                    if Buff:HasBuff(unit, buffName) then
                        return true
                    end
                end
                return false
            end)
            local sortMode = (#stackA == 0 and self.SORT_AUTO or self.SORT_MOST_STACK)
            if sortMode == self.SORT_MOST_STACK then
                a = stackA
            end
            table.sort(a, self.SortModes[sortMode])
        else
            table.sort(a, self.CurrentSort)
        end
        
        return (#a == 0 and nil or a[1])
    end
    
    function Target:GetPriority
        (unit)
        local name = unit.charName
        if self.MenuPriorities[name] then
            return self.MenuPriorities[name]:Value()
        end
        if Data.HeroPriorities[name:lower()] then
            return Data.HeroPriorities[name:lower()]
        end
        return 1
    end
    
    function Target:GetKalistaTarget
        ()
        local range, radius, objects
        
        range = myHero.range - 35
        radius = myHero.boundingRadius
        
        objects = Object:GetEnemyMinions(range + radius, true, true, true)
        if #objects > 0 then
            return objects[1]
        end
        
        objects = Object:GetEnemyTurrets(range + radius, true, true, true)
        if #objects > 0 then
            return objects[1]
        end
        
        objects = Object:GetEnemyBuildings(range, true, true, true)
        if #objects > 0 then
            return objects[1]
        end
        
        return nil
    end
    
    function Target:GetComboTarget
        (dmgType)
        
        local t, range
        
        dmgType = dmgType or Damage.DAMAGE_TYPE_PHYSICAL
        range = myHero.range + myHero.boundingRadius - 35
        
        t = self:GetTarget(Object:GetEnemyHeroes(false, false, true, true, true, function(hero)
            if hero.distance < range + ((Object.IsCaitlyn and Buff:HasBuff(hero, 'caitlynyordletrapinternal')) and 600 or hero.boundingRadius) then
                return true
            end
            return false
        end), dmgType)
        
        if Object.IsKalista and t == nil then
            t = self:GetKalistaTarget()
        end
        
        return t
    end
end

Health =
{
}

do
    function Health:Init
        ()
        self.ExtraFarmDelay = Menu.Orbwalker.Farming.ExtraFarmDelay
        self.MenuDrawings = Menu.Main.Drawings
        
        self.IsLastHitable = false
        self.ShouldRemoveObjects = false
        
        self.ShouldWaitTime = 0
        self.OnUnkillableC = {}
        
        self.HighestEndTime = {}
        self.ActiveAttacks = {}
        
        self.AllyTurret = nil
        self.AllyTurretHandle = nil
        self.StaticAutoAttackDamage = nil
        self.FarmMinions = {}
        self.Handles = {}
        self.AllyMinionsHandles = {}
        self.EnemyWardsInAttackRange = {}
        self.EnemyMinionsInAttackRange = {}
        self.JungleMinionsInAttackRange = {}
        self.EnemyStructuresInAttackRange = {}
        
        self.TargetsHealth = {}
        self.AttackersDamage = {}
        
        self.Spells = {}
        self.LastHitHandle = 0
        self.LaneClearHandle = 0
    end
    
    --ok
    function Health:AddSpell
        (class)
        
        table.insert(self.Spells, class)
    end
    
    --ok
    function Health:OnTick()
        local attackRange, structures, pos, speed, windup, time, anim
        
        -- RESET ALL
        if self.ShouldRemoveObjects then
            self.ShouldRemoveObjects = false
            
            self.AllyTurret = nil
            self.AllyTurretHandle = nil
            self.StaticAutoAttackDamage = nil
            
            for i = 1, #self.FarmMinions do
                table.remove(self.FarmMinions, i)
            end
            
            for i = 1, #self.EnemyWardsInAttackRange do
                table.remove(self.EnemyWardsInAttackRange, i)
            end
            
            for i = 1, #self.EnemyMinionsInAttackRange do
                table.remove(self.EnemyMinionsInAttackRange, i)
            end
            
            for i = 1, #self.JungleMinionsInAttackRange do
                table.remove(self.JungleMinionsInAttackRange, i)
            end
            
            for i = 1, #self.EnemyStructuresInAttackRange do
                table.remove(self.EnemyStructuresInAttackRange, i)
            end
            
            for k, v in pairs(self.AttackersDamage) do
                for k2, v2 in pairs(v) do
                    self.AttackersDamage[k][k2] = nil
                end
                self.AttackersDamage[k] = nil
            end
            
            for k, v in pairs(self.AllyMinionsHandles) do
                self.AllyMinionsHandles[k] = nil
            end
            
            for k, v in pairs(self.TargetsHealth) do
                self.TargetsHealth[k] = nil
            end
            
            for k, v in pairs(self.Handles) do
                self.Handles[k] = nil
            end
        end
        
        -- SPELLS
        for i = 1, #self.Spells do
            self.Spells[i]:Reset()
        end
        
        if Orbwalker.Modes[Orbwalker.ORBWALKER_MODE_COMBO] then return end--or Orbwalker.IsNone
        
        self.IsLastHitable = false
        self.ShouldRemoveObjects = true
        self.StaticAutoAttackDamage = Damage:GetStaticAutoAttackDamage(myHero, true)
        
        -- SET OBJECTS
        attackRange = myHero.range + myHero.boundingRadius - 35
        
        for i = 1, Game.MinionCount() do
            local obj = Game.Minion(i)
            if Object:IsValid(obj, Obj_AI_Minion, true) and Math:IsInRange(myHero, obj, 2000) then
                local handle = obj.handle
                self.Handles[handle] = obj
                local team = obj.team
                if team == Data.AllyTeam then
                    self.AllyMinionsHandles[handle] = obj
                elseif team == Data.EnemyTeam then
                    if not obj.isImmortal and Math:IsInRange(myHero, obj, attackRange + obj.boundingRadius) then
                        table.insert(self.EnemyMinionsInAttackRange, obj)
                    end
                elseif team == Data.JungleTeam then
                    if not obj.isImmortal and Math:IsInRange(myHero, obj, attackRange + obj.boundingRadius) then
                        table.insert(self.JungleMinionsInAttackRange, obj)
                    end
                end
            end
        end
        
        structures = Object:GetAllStructures(2000, false, true)
        
        for i = 1, #structures do
            local obj = structures[i]
            local objType = obj.type
            
            if objType == Obj_AI_Turret then
                self.Handles[obj.handle] = obj
                if obj.team == Data.AllyTeam then
                    self.AllyTurret = obj
                    self.AllyTurretHandle = obj.handle
                end
            end
            
            if obj.team == Data.EnemyTeam then
                local objRadius = 0
                
                if objType == Obj_AI_Barracks then
                    objRadius = 270
                elseif objType == Obj_AI_Nexus then
                    objRadius = 380
                elseif objType == Obj_AI_Turret then
                    objRadius = obj.boundingRadius
                end
                
                if not obj.isImmortal and Math:IsInRange(myHero, obj, attackRange + objRadius) then
                    table.insert(self.EnemyStructuresInAttackRange, obj)
                end
            end
        end
        
        for i = 1, Game.WardCount() do
            local obj = Game.Ward(i)
            if obj and obj.team == Data.EnemyTeam and obj.visible and obj.alive and Math:IsInRange(myHero, obj, attackRange + 35) then
                table.insert(self.EnemyWardsInAttackRange, obj)
            end
        end
        
        -- ON ATTACK
        local timer = Game.Timer()
        for handle, obj in pairs(self.Handles) do
            local s = obj.activeSpell
            if s and s.valid and s.isAutoAttack then
                if self.ActiveAttacks[handle] == nil then
                    self.ActiveAttacks[handle] = {}
                end
                local endTime = s.endTime
                local speed = s.speed
                local animation = s.animation
                local windup = s.windup
                local target = s.target
                if endTime and self.ActiveAttacks[handle][endTime] == nil and speed and animation and windup and target and endTime > timer and math.abs(endTime - timer - animation) < 0.05 then
                    self.ActiveAttacks[handle][endTime] =
                    {
                        Speed = speed,
                        EndTime = endTime,
                        AnimationTime = animation,
                        WindUpTime = windup,
                        StartTime = endTime - animation,
                        Target = target,
                    }
                    for handle2, attacks in pairs(self.ActiveAttacks) do
                        for endTime2, attack in pairs(attacks) do
                            if endTime - endTime2 > 15 then
                                self.ActiveAttacks[handle][endTime2] = nil
                            end
                        end
                    end
                    local endTime2 = self.HighestEndTime[handle]
                    if endTime2 ~= nil and endTime - endTime2 < animation - 0.1 then
                        self.ActiveAttacks[handle][endTime] = nil
                    end
                    self.HighestEndTime[handle] = endTime
                end
            end
        end
        
        -- RECALCULATE ATTACKS
        for handle, endTime in pairs(self.HighestEndTime) do
            if self.Handles[handle] == nil then
                self.HighestEndTime[handle] = nil
            end
        end
        for handle, attacks in pairs(self.ActiveAttacks) do
            if self.Handles[handle] == nil then
                for endTime, attack in pairs(attacks) do
                    self.ActiveAttacks[handle][endTime] = nil
                end
                self.ActiveAttacks[handle] = nil
            end
        end
        
        -- SET FARM MINIONS
        pos = myHero.pos
        speed = Attack:GetProjectileSpeed()
        windup = Attack:GetWindup()
        time = windup - Data:GetLatency() - self.ExtraFarmDelay:Value() * 0.001
        anim = Attack:GetAnimation()
        for i = 1, #self.EnemyMinionsInAttackRange do
            local target = self.EnemyMinionsInAttackRange[i]
            table.insert(self.FarmMinions, self:SetLastHitable(target, anim, time + target.distance / speed, Damage:GetAutoAttackDamage(myHero, target, self.StaticAutoAttackDamage)))
        end
        
        -- SPELLS
        for i = 1, #self.Spells do
            self.Spells[i]:Tick()
        end
        
        -- DRAW
        if self.MenuDrawings.Enabled:Value() and self.MenuDrawings.LastHittableMinions:Value() then
            for i = 1, #self.FarmMinions do
                local args = self.FarmMinions[i]
                local minion = args.Minion
                if Object:IsValid(minion, Obj_AI_Minion, true, true) then
                    if args.LastHitable then
                        Draw.Circle(minion.pos, math.max(65, minion.boundingRadius), 2, Color.LastHitable)
                    elseif args.AlmostLastHitable then
                        Draw.Circle(minion.pos, math.max(65, minion.boundingRadius), 2, Color.AlmostLastHitable)
                    end
                end
            end
        end
    end
    
    --ok
    function Health:GetPrediction
        (target, time)
        
        local timer, pos, team, handle, health, attackers
        timer = Game.Timer()
        pos = target.pos
        handle = target.handle
        if self.TargetsHealth[handle] == nil then
            self.TargetsHealth[handle] = target.health + Data:GetTotalShield(target)
        end
        health = self.TargetsHealth[handle]
        
        for attackerHandle, attacks in pairs(self.ActiveAttacks) do
            local attacker = self.Handles[attackerHandle]
            if attacker then
                local c = 0
                for endTime, attack in pairs(attacks) do
                    if attack.Target == handle then
                        
                        local speed, startT, flyT, endT, damage
                        speed = attack.Speed
                        startT = attack.StartTime
                        flyT = speed > 0 and Math:GetDistance(attacker.pos, pos) / speed or 0
                        endT = (startT + attack.WindUpTime + flyT) - timer
                        
                        if endT > 0 and endT < time then
                            c = c + 1
                            if self.AttackersDamage[attackerHandle] == nil then
                                self.AttackersDamage[attackerHandle] = {}
                            end
                            if self.AttackersDamage[attackerHandle][handle] == nil then
                                self.AttackersDamage[attackerHandle][handle] = Damage:GetAutoAttackDamage(attacker, target)
                            end
                            damage = self.AttackersDamage[attackerHandle][handle]
                            
                            health = health - damage
                        end
                    end
                end
            end
        end
        
        return health
    end
    
    --ok
    function Health:LocalGetPrediction
        (target, time)
        
        local timer, pos, team, handle, health, attackers, turretAttacked
        turretAttacked = false
        timer = Game.Timer()
        pos = target.pos
        handle = target.handle
        if self.TargetsHealth[handle] == nil then
            self.TargetsHealth[handle] = target.health + Data:GetTotalShield(target)
        end
        health = self.TargetsHealth[handle]
        
        local handles = {}
        
        for attackerHandle, attacks in pairs(self.ActiveAttacks) do
            local attacker = self.Handles[attackerHandle]
            if attacker then
                
                for endTime, attack in pairs(attacks) do
                    if attack.Target == handle then
                        
                        local speed, startT, flyT, endT, damage
                        speed = attack.Speed
                        startT = attack.StartTime
                        flyT = speed > 0 and Math:GetDistance(attacker.pos, pos) / speed or 0
                        endT = (startT + attack.WindUpTime + flyT) - timer
                        
                        -- laneClear
                        if endT < 0 and timer - attack.EndTime < 1.25 then
                            endT = attack.WindUpTime + flyT
                            endT = timer > attack.EndTime and endT or endT + (attack.EndTime - timer)
                            startT = timer > attack.EndTime and timer or attack.EndTime
                        end
                        
                        if endT > 0 and endT < time then
                            
                            handles[attackerHandle] = true
                            
                            -- damage
                            if self.AttackersDamage[attackerHandle] == nil then
                                self.AttackersDamage[attackerHandle] = {}
                            end
                            if self.AttackersDamage[attackerHandle][handle] == nil then
                                self.AttackersDamage[attackerHandle][handle] = Damage:GetAutoAttackDamage(attacker, target)
                            end
                            damage = self.AttackersDamage[attackerHandle][handle]
                            
                            -- laneClear
                            local c = 1
                            while (endT < time) do
                                if attackerHandle == self.AllyTurretHandle then
                                    turretAttacked = true
                                else
                                    health = health - damage
                                end
                                endT = (startT + attack.WindUpTime + flyT + c * attack.AnimationTime) - timer
                                c = c + 1
                                if c > 10 then
                                    print("ERROR LANECLEAR!")
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- laneClear
        for attackerHandle, obj in pairs(self.AllyMinionsHandles) do
            
            if handles[attackerHandle] == nil then
                local aaData = obj.attackData
                local isMoving = obj.pathing.hasMovePath
                
                if aaData == nil or aaData.target == nil or self.Handles[aaData.target] == nil or isMoving or self.ActiveAttacks[attackerHandle] == nil then
                    local distance = Math:GetDistance(obj.pos, pos)
                    local range = Data:GetAutoAttackRange(obj, target)
                    local extraRange = isMoving and 250 or 0
                    
                    if distance < range + extraRange then
                        local speed, flyT, endT, damage
                        
                        speed = aaData.projectileSpeed
                        distance = distance > range and range or distance
                        flyT = speed > 0 and distance / speed or 0
                        endT = aaData.windUpTime + flyT
                        
                        if endT < time then
                            if self.AttackersDamage[attackerHandle] == nil then
                                self.AttackersDamage[attackerHandle] = {}
                            end
                            if self.AttackersDamage[attackerHandle][handle] == nil then
                                self.AttackersDamage[attackerHandle][handle] = Damage:GetAutoAttackDamage(obj, target)
                            end
                            damage = self.AttackersDamage[attackerHandle][handle]
                            
                            local c = 1
                            while (endT < time) do
                                health = health - damage
                                endT = aaData.windUpTime + flyT + c * aaData.animationTime
                                c = c + 1
                                if c > 10 then
                                    print("ERROR LANECLEAR!")
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        
        return health, turretAttacked
    end
    
    --ok
    function Health:SetLastHitable
        (target, anim, time, damage)
        
        local timer, handle, currentHealth, health, lastHitable, almostLastHitable, almostalmost, unkillable
        
        timer = Game.Timer()
        handle = target.handle
        currentHealth = target.health + Data:GetTotalShield(target)
        self.TargetsHealth[handle] = currentHealth
        health = self:GetPrediction(target, time)
        
        lastHitable = false
        almostLastHitable = false
        almostalmost = false
        unkillable = false
        
        -- unkillable
        if health < 0 then
            unkillable = true
            for i = 1, #self.OnUnkillableC do
                self.OnUnkillableC[i](target)
            end
            return
            {
                LastHitable = lastHitable,
                Unkillable = unkillable,
                AlmostLastHitable = almostLastHitable,
                PredictedHP = health,
                Minion = target,
                AlmostAlmost = almostalmost,
                Time = time,
            }
        end
        
        -- lasthitable
        if health - damage < 0 then
            lastHitable = true
            self.IsLastHitable = true
            return
            {
                LastHitable = lastHitable,
                Unkillable = unkillable,
                AlmostLastHitable = almostLastHitable,
                PredictedHP = health,
                Minion = target,
                AlmostAlmost = almostalmost,
                Time = time,
            }
        end
        
        -- almost lasthitable
        local turretAttack, extraTime, almostHealth, almostAlmostHealth, turretAttacked
        turretAttack = self.AllyTurret ~= nil and self.AllyTurret.attackData or nil
        extraTime = (1.5 - anim) * 0.3
        extraTime = extraTime < 0 and 0 or extraTime
        almostHealth, turretAttacked = self:LocalGetPrediction(target, anim + time + extraTime)-- + 0.25
        if almostHealth < 0 then
            almostLastHitable = true
            self.ShouldWaitTime = GetTickCount()
        elseif almostHealth - damage < 0 then
            almostLastHitable = true
        elseif currentHealth ~= almostHealth then
            almostAlmostHealth, turretAttacked = self:LocalGetPrediction(target, 1.25 * anim + 1.25 * time + 0.5 + extraTime)
            if almostAlmostHealth - damage < 0 then
                almostalmost = true
            end
        end
        
        -- under turret, turret attackdata: 1.20048 0.16686 1200
        if turretAttacked or (turretAttack and turretAttack.target == handle) or (self.AllyTurret and (Data:IsInAutoAttackRange(self.AllyTurret, target) or Data:IsInAutoAttackRange2(self.AllyTurret, target))) then
            local nearTurret, isTurretTarget, maxHP, startTime, windUpTime, flyTime, turretDamage, turretHits
            
            nearTurret = true
            isTurretTarget = turretAttack.target == handle
            
            maxHP = target.maxHealth
            startTime = turretAttack.endTime - 1.20048
            windUpTime = 0.16686
            flyTime = Math:GetDistance(self.AllyTurret, target) / 1200
            turretDamage = Damage:GetAutoAttackDamage(self.AllyTurret, target)
            
            turretHits = 1
            while (maxHP > turretHits * turretDamage) do
                turretHits = turretHits + 1
                if turretHits > 10 then
                    print("ERROR TURRETHITS")
                    break
                end
            end
            turretHits = turretHits - 1
            
            return
            {
                LastHitable = lastHitable,
                Unkillable = unkillable,
                AlmostLastHitable = almostLastHitable,
                PredictedHP = health,
                Minion = target,
                AlmostAlmost = almostalmost,
                Time = time,
                -- turret
                NearTurret = nearTurret,
                IsTurretTarget = isTurretTarget,
                TurretHits = turretHits,
                TurretDamage = turretDamage,
                TurretFlyDelay = flyTime,
                TurretStart = startTime,
                TurretWindup = windUpTime,
            }
        end
        
        return
        {
            LastHitable = lastHitable,
            Unkillable = health < 0,
            AlmostLastHitable = almostLastHitable,
            PredictedHP = health,
            Minion = target,
            AlmostAlmost = almostalmost,
            Time = time,
        }
    end
    
    --ok
    function Health:ShouldWait
        ()
        -- why this delay ? because decreasing minion's health after attack is delayed, attack dissapear earlier + connection latency
        return GetTickCount() < self.ShouldWaitTime + 250
    end
    
    --ok
    function Health:GetJungleTarget
        ()
        
        if #self.JungleMinionsInAttackRange > 0 then
            table.sort(self.JungleMinionsInAttackRange, function(a, b) return a.maxHealth > b.maxHealth end);
            return self.JungleMinionsInAttackRange[1]
        end
        
        return #self.EnemyWardsInAttackRange > 0 and self.EnemyWardsInAttackRange[1] or nil
    end
    
    --ok
    function Health:GetLastHitTarget
        ()
        
        local min = 10000000
        local result = nil
        for i = 1, #self.FarmMinions do
            local minion = self.FarmMinions[i]
            if Object:IsValid(minion.Minion, Obj_AI_Minion, true, true) and minion.LastHitable and minion.PredictedHP < min and Data:IsInAutoAttackRange(myHero, minion.Minion) then
                min = minion.PredictedHP
                result = minion.Minion
                self.LastHitHandle = result.handle
            end
        end
        
        return result
    end
    
    --ok
    function Health:GetHarassTarget
        ()
        
        local LastHitPriority = Menu.Orbwalker.Farming.LastHitPriority:Value()
        local structure = #self.EnemyStructuresInAttackRange > 0 and self.EnemyStructuresInAttackRange[1] or nil
        
        if structure ~= nil then
            if not LastHitPriority then
                return structure
            end
            if self.IsLastHitable then
                return self:GetLastHitTarget()
            end
            if LastHitPriority and not self:ShouldWait() then
                return structure
            end
        else
            if not LastHitPriority then
                local hero = Target:GetComboTarget()
                if hero ~= nil then
                    return hero
                end
            end
            if self.IsLastHitable then
                return self:GetLastHitTarget()
            end
            if LastHitPriority and not self:ShouldWait() then
                local hero = Target:GetComboTarget()
                if hero ~= nil then
                    return hero
                end
            end
        end
    end
    
    function Health:GetLaneMinion
        ()
        
        local laneMinion = nil
        local num = 10000
        for i = 1, #self.FarmMinions do
            local minion = self.FarmMinions[i]
            if Data:IsInAutoAttackRange(myHero, minion.Minion) then
                if minion.PredictedHP < num and not minion.AlmostAlmost and not minion.AlmostLastHitable then--and (self.AllyTurret == nil or minion.CanUnderTurret) then
                    num = minion.PredictedHP
                    laneMinion = minion.Minion
                end
            end
        end
        
        return laneMinion
    end
    
    --ok
    function Health:GetLaneClearTarget
        ()
        
        local LastHitPriority = Menu.Orbwalker.Farming.LastHitPriority:Value()
        local LaneClearHeroes = Menu.Orbwalker.General.LaneClearHeroes:Value()
        local structure = #self.EnemyStructuresInAttackRange > 0 and self.EnemyStructuresInAttackRange[1] or nil
        local other = #self.EnemyWardsInAttackRange > 0 and self.EnemyWardsInAttackRange[1] or nil
        
        if structure ~= nil then
            if not LastHitPriority then
                return structure
            end
            if self.IsLastHitable then
                return self:GetLastHitTarget()
            end
            if other ~= nil then
                return other
            end
            if LastHitPriority and not self:ShouldWait() then
                return structure
            end
        else
            if not LastHitPriority and LaneClearHeroes then
                local hero = Target:GetComboTarget()
                if hero ~= nil then
                    return hero
                end
            end
            if self.IsLastHitable then
                return self:GetLastHitTarget()
            end
            if self:ShouldWait() then
                return nil
            end
            if LastHitPriority and LaneClearHeroes then
                local hero = Target:GetComboTarget()
                if hero ~= nil then
                    return hero
                end
            end
            
            -- lane minion
            local laneMinion = self:GetLaneMinion()
            if laneMinion ~= nil then
                self.LaneClearHandle = laneMinion.handle
                return laneMinion
            end
            
            -- ward
            if other ~= nil then
                return other
            end
        end
        return nil
    end
end

SDK.ObjectManager = Object
SDK.TargetSelector = Target
SDK.HealthPrediction = Health