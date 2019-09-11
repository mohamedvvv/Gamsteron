
local Object, Orbwalker, Item, Cursor, Health, Attack

SDK.Init.Utilities = function()
    Object = SDK.ObjectManager
    Orbwalker = SDK.Orbwalker
    Item = SDK.ItemManager
    Cursor = SDK.Cursor
    Health = SDK.HealthPrediction
    Attack = SDK.Attack
end

local Color, Action, Buff, Math, Damage, Data, Spell

Color =
{
    LightGreen =
    Draw.Color(255, 144, 238, 144),
    
    OrangeRed =
    Draw.Color(255, 255, 69, 0),
    
    Black =
    Draw.Color(255, 0, 0, 0),
    
    Red =
    Draw.Color(255, 255, 0, 0),
    
    Yellow =
    Draw.Color(255, 255, 255, 0),
    
    DarkRed =
    Draw.Color(255, 204, 0, 0),
    
    AlmostLastHitable =
    Draw.Color(255, 239, 159, 55),
    
    LastHitable =
    Draw.Color(255, 255, 255, 255),
    
    Range =
    Draw.Color(150, 49, 210, 0),
    
    EnemyRange =
    Draw.Color(150, 255, 0, 0),
    
    Cursor =
    Draw.Color(255, 0, 255, 0),
}

Action =
{
    Tasks =
    {
    },
}

do
    function Action:Init
        ()
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Action:OnLoad
        ()
        
        table.insert(SDK.FastTick, function()
            for i, task in pairs(self.Tasks) do
                if os.clock() >= task[2] then
                    if task[1]() or os.clock() >= task[3] then
                        table.remove(self.Tasks, i)
                    end
                end
            end
        end)
    end
    
    function Action:Add
        (task, startTime, endTime)
        
        startTime = startTime or 0
        endTime = endTime or 10000
        table.insert(self.Tasks, {task, os.clock() + startTime, os.clock() + startTime + endTime})
    end
end

Buff =
{
    CachedBuffs =
    {},
}

do
    function Buff:Init
        ()
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Buff:OnLoad
        ()
        
        table.insert(SDK.Tick, function()
            self.CachedBuffs = {}
        end)
    end
    
    function Buff:CreateBuffs
        (unit)
        
        local result = {}
        for i = 0, unit.buffCount do
            local buff = unit:GetBuff(i)
            if buff and buff.count > 0 then
                result[buff.name:lower()] =
                {
                    Type = buff.type,
                    StartTime = buff.startTime,
                    ExpireTime = buff.expireTime,
                    Duration = buff.duration,
                    Stacks = buff.stacks,
                    Count = buff.count,
                }
            end
        end
        return result
    end
    
    function Buff:GetBuffDuration
        (unit, name)
        
        name = name:lower()
        local id = unit.networkID
        if self.CachedBuffs[id] == nil then self.CachedBuffs[id] = self:CreateBuffs(unit) end
        if self.CachedBuffs[id][name] then
            return self.CachedBuffs[id][name].Duration
        end
        return 0
    end
    
    function Buff:GetBuff
        (unit, name)
        
        name = name:lower()
        local id = unit.networkID
        if self.CachedBuffs[id] == nil then self.CachedBuffs[id] = self:CreateBuffs(unit) end
        return self.CachedBuffs[id][name]
    end
    
    function Buff:HasBuffContainsName
        (unit, str)
        
        str = str:lower()
        local id = unit.networkID
        if self.CachedBuffs[id] == nil then self.CachedBuffs[id] = self:CreateBuffs(unit) end
        for name, buff in pairs(self.CachedBuffs[id]) do
            if name:find(str) then
                return true
            end
        end
        return false
    end
    
    function Buff:ContainsBuffs
        (unit, arr)
        
        local id = unit.networkID
        if self.CachedBuffs[id] == nil then self.CachedBuffs[id] = self:CreateBuffs(unit) end
        for i = 1, #arr do
            local name = arr[i]:lower()
            if self.CachedBuffs[id][name] then
                return true
            end
        end
        return false
    end
    
    function Buff:HasBuff
        (unit, name)
        
        name = name:lower()
        local id = unit.networkID
        if self.CachedBuffs[id] == nil then self.CachedBuffs[id] = self:CreateBuffs(unit) end
        if self.CachedBuffs[id][name] then
            return true
        end
        return false
    end
    
    function Buff:HasBuffTypes
        (unit, types)
        
        local id = unit.networkID
        if self.CachedBuffs[id] == nil then self.CachedBuffs[id] = self:CreateBuffs(unit) end
        for name, buff in pairs(self.CachedBuffs[id]) do
            if types[buff.Type] then
                return true
            end
        end
        return false
    end
    
    function Buff:GetBuffCount
        (unit, name)
        
        name = name:lower()
        local id = unit.networkID
        if self.CachedBuffs[id] == nil then self.CachedBuffs[id] = self:CreateBuffs(unit) end
        if self.CachedBuffs[id][name] then
            return self.CachedBuffs[id][name].Count
        end
        return 0
    end
end

Math =
{
}

do
    function Math:PointOnSegment
        (p, p1, p2)
        
        local result =
        {
            IsOnSegment = false,
            PointSegment = nil,
            PointLine = nil,
            Point = 0,
        }
        local px, pz = p.x, (p.z or p.y)
        local ax, az = p1.x, (p1.z or p1.y)
        local bx, bz = p2.x, (p2.z or p2.y)
        local bxax = bx - ax
        local bzaz = bz - az
        local t = ((px - ax) * bxax + (pz - az) * bzaz) / (bxax * bxax + bzaz * bzaz)
        result.PointLine = {x = ax + t * bxax, y = az + t * bzaz}
        if t < 0 then
            result.IsOnSegment = false
            result.PointSegment = p1
            result.Point = 1
        elseif t > 1 then
            result.IsOnSegment = false
            result.PointSegment = p2
            result.Point = 2
        else
            result.IsOnSegment = true
            result.PointSegment = result.PointLine
        end
        return result
    end
    
    function Math:RadianToDegree
        (angle)
        
        return angle * (180.0 / math.pi)
    end
    
    function Math:Polar
        (v1)
        
        local x = v1.x
        local z = v1.z or v1.y
        if x == 0 then
            if z > 0 then
                return 90
            end
            return z < 0 and 270 or 0
        end
        local theta = self:RadianToDegree(math.atan(z / x))
        if x < 0 then
            theta = theta + 180
        end
        if theta < 0 then
            theta = theta + 360
        end
        return theta
    end
    
    function Math:AngleBetween
        (vec1, vec2)
        
        local theta = self:Polar(vec1) - self:Polar(vec2)
        if theta < 0 then
            theta = theta + 360
        end
        if theta > 180 then
            theta = 360 - theta
        end
        return theta
    end
    
    function Math:EqualVector
        (vec1, vec2)
        
        local diffX = vec1.x - vec2.x
        local diffZ = (vec1.z or vec1.y) - (vec2.z or vec2.y)
        if diffX >= -10 and diffX <= 10 and diffZ >= -10 and diffZ <= 10 then
            return true
        end
        return false
    end
    
    function Math:Quad
        (a, b, c)
        
        local sol = nil
        if (math.abs(a) < 1e-6) then
            if (math.abs(b) < 1e-6) then
                if (math.abs(c) < 1e-6) then
                    sol = {0, 0}
                end
            else
                sol = {-c / b, -c / b}
            end
        else
            local disc = b * b - 4 * a * c
            if (disc >= 0) then
                disc = math.sqrt(disc)
                local a = 2 * a
                sol = {(-b - disc) / a, (-b + disc) / a}
            end
        end
        return sol
    end
    
    function Math:Intercept
        (src, spos, epos, sspeed, tspeed)
        
        local dx = epos.x - spos.x
        local dz = epos.z - spos.z
        local magnitude = math.sqrt(dx * dx + dz * dz)
        local tx = spos.x - src.x
        local tz = spos.z - src.z
        local tvx = (dx / magnitude) * tspeed
        local tvz = (dz / magnitude) * tspeed
        
        local a = tvx * tvx + tvz * tvz - sspeed * sspeed
        local b = 2 * (tvx * tx + tvz * tz)
        local c = tx * tx + tz * tz
        
        local ts = self:Quad(a, b, c)
        
        local sol = nil
        if (ts) then
            local t0 = ts[1]
            local t1 = ts[2]
            local t = math.min(t0, t1)
            if (t < 0) then
                t = math.max(t0, t1)
            end
            if (t > 0) then
                sol = t
            end
        end
        
        return sol
    end
    
    function Math:IsInRange
        (v1, v2, range)
        
        v1 = v1.pos or v1
        v2 = v2.pos or v2
        local dx = v1.x - v2.x
        local dz = (v1.z or v1.y) - (v2.z or v2.y)
        if dx * dx + dz * dz <= range * range then
            return true
        end
        return false
    end
    
    function Math:GetDistanceSquared
        (v1, v2)
        
        v1 = v1.pos or v1
        v2 = v2.pos or v2
        local dx = v1.x - v2.x
        local dz = (v1.z or v1.y) - (v2.z or v2.y)
        return dx * dx + dz * dz
    end
    
    function Math:InsidePolygon
        (polygon, point)
        
        local result = false
        local j = #polygon
        point = point.pos or point
        local pointx = point.x
        local pointz = point.z or point.y
        for i = 1, #polygon do
            if (polygon[i].z < pointz and polygon[j].z >= pointz or polygon[j].z < pointz and polygon[i].z >= pointz) then
                if (polygon[i].x + (pointz - polygon[i].z) / (polygon[j].z - polygon[i].z) * (polygon[j].x - polygon[i].x) < pointx) then
                    result = not result
                end
            end
            j = i
        end
        return result
    end
    
    function Math:GetDistance
        (v1, v2)
        
        v1 = v1.pos or v1
        v2 = v2.pos or v2
        local dx = v1.x - v2.x
        local dz = (v1.z or v1.y) - (v2.z or v2.y)
        return math.sqrt(dx * dx + dz * dz)
    end
    
    function Math:EqualDirection
        (vec1, vec2)
        
        return self:AngleBetween(vec1, vec2) <= 5
    end
    
    function Math:Normalized
        (vec1, vec2)
        
        local vec = {x = vec1.x - vec2.x, y = 0, z = (vec1.z or vec1.y) - (vec2.z or vec2.y)}
        local length = math.sqrt(vec.x * vec.x + vec.z * vec.z)
        if length > 0 then
            local inv = 1.0 / length
            return Vector(vec.x * inv, 0, vec.z * inv)
        end
        return Vector(0, 0, 0)
    end
    
    function Math:Extended
        (vec, dir, range)
        
        local vecz = vec.z or vec.y
        local dirz = dir.z or dir.y
        return Vector(vec.x + dir.x * range, 0, vecz + dirz * range)
    end
    
    function Math:IsFacing
        (source, target, angle)
        
        angle = angle or 90
        target = target.pos or Vector(target)
        if self:AngleBetween(source.dir, target - source.pos) < angle then
            return true
        end
        return false
    end
    
    function Math:IsBothFacing
        (source, target, angle)
        
        if self:IsFacing(source, target, angle) and self:IsFacing(target, source, angle) then
            return true
        end
        return false
    end
    
    function Math:ProjectOn
        (p, p1, p2)
        
        local isOnSegment, pointSegment, pointLine
        local px, pz = p.x, (p.z or p.y)
        local ax, az = p1.x, (p1.z or p1.y)
        local bx, bz = p2.x, (p2.z or p2.y)
        local bxax = bx - ax
        local bzaz = bz - az
        local t = ((px - ax) * bxax + (pz - az) * bzaz) / (bxax * bxax + bzaz * bzaz)
        local pointLine = {x = ax + t * bxax, y = az + t * bzaz}
        if t < 0 then
            isOnSegment = false
            pointSegment = p1
        elseif t > 1 then
            isOnSegment = false
            pointSegment = p2
        else
            isOnSegment = true
            pointSegment = pointLine
        end
        return isOnSegment, pointSegment, pointLine
    end
end

Damage =
{
    BaseTurrets =
    {
        ["SRUAP_Turret_Order3"] = true,
        ["SRUAP_Turret_Order4"] = true,
        ["SRUAP_Turret_Chaos3"] = true,
        ["SRUAP_Turret_Chaos4"] = true,
    },
    
    TurretToMinionPercent =
    {
        ["SRU_ChaosMinionMelee"] = 0.43,
        ["SRU_ChaosMinionRanged"] = 0.68,
        ["SRU_ChaosMinionSiege"] = 0.14,
        ["SRU_ChaosMinionSuper"] = 0.05,
        ["SRU_OrderMinionMelee"] = 0.43,
        ["SRU_OrderMinionRanged"] = 0.68,
        ["SRU_OrderMinionSiege"] = 0.14,
        ["SRU_OrderMinionSuper"] = 0.05,
        ["HA_ChaosMinionMelee"] = 0.43,
        ["HA_ChaosMinionRanged"] = 0.68,
        ["HA_ChaosMinionSiege"] = 0.14,
        ["HA_ChaosMinionSuper"] = 0.05,
        ["HA_OrderMinionMelee"] = 0.43,
        ["HA_OrderMinionRanged"] = 0.68,
        ["HA_OrderMinionSiege"] = 0.14,
        ["HA_OrderMinionSuper"] = 0.05,
    },
    
    DAMAGE_TYPE_PHYSICAL = SDK.DAMAGE_TYPE_PHYSICAL,
    DAMAGE_TYPE_MAGICAL = SDK.DAMAGE_TYPE_MAGICAL,
    DAMAGE_TYPE_TRUE = SDK.DAMAGE_TYPE_TRUE,
}

do
    function Damage:Init()
        self.HeroStaticDamage =
        {
            ["Caitlyn"] = function(args)
                if Buff:HasBuff(args.From, "caitlynheadshot") then
                    if args.TargetIsMinion then
                        args.RawPhysical = args.RawPhysical + args.From.totalDamage * 1.5
                    else
                        --TODO
                    end
                end
            end,
            ["Corki"] = function(args)
                args.RawTotal = args.RawTotal * 0.5
                args.RawMagical = args.RawTotal
            end,
            ["Diana"] = function(args)
                if Buff:GetBuffCount(args.From, "dianapassivemarker") == 2 then
                    local level = args.From.levelData.lvl
                    args.RawMagical = args.RawMagical + math.max(15 + 5 * level, -10 + 10 * level, -60 + 15 * level, -125 + 20 * level, -200 + 25 * level) + 0.8 * args.From.ap
                end
            end,
            ["Draven"] = function(args)
                if Buff:HasBuff(args.From, "DravenSpinningAttack") then
                    local level = args.From:GetSpellData(_Q).level
                    args.RawPhysical = args.RawPhysical + 25 + 5 * level + (0.55 + 0.1 * level) * args.From.bonusDamage
                end
            end,
            ["Graves"] = function(args)
                local t = {70, 71, 72, 74, 75, 76, 78, 80, 81, 83, 85, 87, 89, 91, 95, 96, 97, 100}
                args.RawTotal = args.RawTotal * t[math.max(math.min(args.From.levelData.lvl, 18), 1)] * 0.01
            end,
            ["Jinx"] = function(args)
                if Buff:HasBuff(args.From, "JinxQ") then
                    args.RawPhysical = args.RawPhysical + args.From.totalDamage * 0.1
                end
            end,
            ["Kalista"] = function(args)
                args.RawPhysical = args.RawPhysical - args.From.totalDamage * 0.1
            end,
            ["Kayle"] = function(args)
                local level = args.From:GetSpellData(_E).level
                if level > 0 then
                    if Buff:HasBuff(args.From, "JudicatorRighteousFury") then
                        args.RawMagical = args.RawMagical + 10 + 10 * level + 0.3 * args.From.ap
                    else
                        args.RawMagical = args.RawMagical + 5 + 5 * level + 0.15 * args.From.ap
                    end
                end
            end,
            ["Nasus"] = function(args)
                if Buff:HasBuff(args.From, "NasusQ") then
                    args.RawPhysical = args.RawPhysical + math.max(Buff:GetBuffCount(args.From, "NasusQStacks"), 0) + 10 + 20 * args.From:GetSpellData(_Q).level
                end
            end,
            ["Thresh"] = function(args)
                local level = args.From:GetSpellData(_E).level
                if level > 0 then
                    local damage = math.max(Buff:GetBuffCount(args.From, "threshpassivesouls"), 0) + (0.5 + 0.3 * level) * args.From.totalDamage
                    if Buff:HasBuff(args.From, "threshqpassive4") then
                        damage = damage * 1
                    elseif Buff:HasBuff(args.From, "threshqpassive3") then
                        damage = damage * 0.5
                    elseif Buff:HasBuff(args.From, "threshqpassive2") then
                        damage = damage * 1 / 3
                    else
                        damage = damage * 0.25
                    end
                    args.RawMagical = args.RawMagical + damage
                end
            end,
            ["TwistedFate"] = function(args)
                if Buff:HasBuff(args.From, "cardmasterstackparticle") then
                    args.RawMagical = args.RawMagical + 30 + 25 * args.From:GetSpellData(_E).level + 0.5 * args.From.ap
                end
                if Buff:HasBuff(args.From, "BlueCardPreAttack") then
                    args.DamageType = self.DAMAGE_TYPE_MAGICAL
                    args.RawMagical = args.RawMagical + 20 + 20 * args.From:GetSpellData(_W).level + 0.5 * args.From.ap
                elseif Buff:HasBuff(args.From, "RedCardPreAttack") then
                    args.DamageType = self.DAMAGE_TYPE_MAGICAL
                    args.RawMagical = args.RawMagical + 15 + 15 * args.From:GetSpellData(_W).level + 0.5 * args.From.ap
                elseif Buff:HasBuff(args.From, "GoldCardPreAttack") then
                    args.DamageType = self.DAMAGE_TYPE_MAGICAL
                    args.RawMagical = args.RawMagical + 7.5 + 7.5 * args.From:GetSpellData(_W).level + 0.5 * args.From.ap
                end
            end,
            ["Varus"] = function(args)
                local level = args.From:GetSpellData(_W).level
                if level > 0 then
                    args.RawMagical = args.RawMagical + 6 + 4 * level + 0.25 * args.From.ap
                end
            end,
            ["Viktor"] = function(args)
                if Buff:HasBuff(args.From, "ViktorPowerTransferReturn") then
                    args.DamageType = self.DAMAGE_TYPE_MAGICAL
                    args.RawMagical = args.RawMagical + 20 * args.From:GetSpellData(_Q).level + 0.5 * args.From.ap
                end
            end,
            ["Vayne"] = function(args)
                if Buff:HasBuff(args.From, "vaynetumblebonus") then
                    args.RawPhysical = args.RawPhysical + (0.25 + 0.05 * args.From:GetSpellData(_Q).level) * args.From.totalDamage
                end
            end,
        }
        
        self.ItemStaticDamage =
        {
            [1043] = function(args)
                args.RawPhysical = args.RawPhysical + 15
            end,
            [2015] = function(args)
                if Buff:GetBuffCount(args.From, "itemstatikshankcharge") == 100 then
                    args.RawMagical = args.RawMagical + 40
                end
            end,
            [3057] = function(args)
                if Buff:HasBuff(args.From, "sheen") then
                    args.RawPhysical = args.RawPhysical + 1 * args.From.baseDamage
                end
            end,
            [3078] = function(args)
                if Buff:HasBuff(args.From, "sheen") then
                    args.RawPhysical = args.RawPhysical + 2 * args.From.baseDamage
                end
            end,
            [3085] = function(args)
                args.RawPhysical = args.RawPhysical + 15
            end,
            [3087] = function(args)
                if Buff:GetBuffCount(args.From, "itemstatikshankcharge") == 100 then
                    local t = {50, 50, 50, 50, 50, 56, 61, 67, 72, 77, 83, 88, 94, 99, 104, 110, 115, 120}
                    args.RawMagical = args.RawMagical + (1 + (args.TargetIsMinion and 1.2 or 0)) * t[math.max(math.min(args.From.levelData.lvl, 18), 1)]
                end
            end,
            [3091] = function(args)
                args.RawMagical = args.RawMagical + 40
            end,
            [3094] = function(args)
                if Buff:GetBuffCount(args.From, "itemstatikshankcharge") == 100 then
                    local t = {50, 50, 50, 50, 50, 58, 66, 75, 83, 92, 100, 109, 117, 126, 134, 143, 151, 160}
                    args.RawMagical = args.RawMagical + t[math.max(math.min(args.From.levelData.lvl, 18), 1)]
                end
            end,
            [3100] = function(args)
                if Buff:HasBuff(args.From, "lichbane") then
                    args.RawMagical = args.RawMagical + 0.75 * args.From.baseDamage + 0.5 * args.From.ap
                end
            end,
            [3115] = function(args)
                args.RawMagical = args.RawMagical + 15 + 0.15 * args.From.ap
            end,
            [3124] = function(args)
                args.CalculatedMagical = args.CalculatedMagical + 15
            end
        }
        
        self.HeroPassiveDamage =
        {
            ["Jhin"] = function(args)
                if Buff:HasBuff(args.From, "jhinpassiveattackbuff") then
                    args.CriticalStrike = true
                    args.RawPhysical = args.RawPhysical + math.min(0.25, 0.1 + 0.05 * math.ceil(args.From.levelData.lvl / 5)) * (args.Target.maxHealth - args.Target.health)
                end
            end,
            ["Lux"] = function(args)
                if Buff:HasBuff(args.Target, "LuxIlluminatingFraulein") then
                    args.RawMagical = 20 + args.From.levelData.lvl * 10 + args.From.ap * 0.2
                end
            end,
            ["Orianna"] = function(args)
                local level = math.ceil(args.From.levelData.lvl / 3)
                args.RawMagical = args.RawMagical + 2 + 8 * level + 0.15 * args.From.ap
                if args.Target.handle == args.From.attackData.target then
                    args.RawMagical = args.RawMagical + math.max(Buff:GetBuffCount(args.From, "orianapowerdaggerdisplay"), 0) * (0.4 + 1.6 * level + 0.03 * args.From.ap)
                end
            end,
            ["Quinn"] = function(args)
                if Buff:HasBuff(args.Target, "QuinnW") then
                    local level = args.From.levelData.lvl
                    args.RawPhysical = args.RawPhysical + 10 + level * 5 + (0.14 + 0.02 * level) * args.From.totalDamage
                end
            end,
            ["Vayne"] = function(args)
                if Buff:GetBuffCount(args.Target, "VayneSilveredDebuff") == 2 then
                    local level = args.From:GetSpellData(_W).level
                    args.CalculatedTrue = args.CalculatedTrue + math.max((0.045 + 0.015 * level) * args.Target.maxHealth, 20 + 20 * level)
                end
            end,
            ["Zed"] = function(args)
                if 100 * args.Target.health / args.Target.maxHealth <= 50 and not Buff:HasBuff(args.From, "zedpassivecd") then
                    args.RawMagical = args.RawMagical + args.Target.maxHealth * (4 + 2 * math.ceil(args.From.levelData.lvl / 6)) * 0.01
                end
            end
        }
    end
    
    function Damage:IsBaseTurret
        (name)
        
        if self.BaseTurrets[name] then
            return true
        end
        return false
    end
    
    function Damage:SetHeroStaticDamage
        (args)
        
        local s = self.HeroStaticDamage[args.From.charName]
        if s then s(args) end
    end
    
    function Damage:SetItemStaticDamage
        (id, args)
        
        local s = self.ItemStaticDamage[id]
        if s then s(args) end
    end
    
    function Damage:SetHeroPassiveDamage
        (args)
        
        local s = self.HeroPassiveDamage[args.From.charName]
        if s then s(args) end
    end
    
    function Damage:CalculateDamage
        (from, target, damageType, rawDamage, isAbility, isAutoAttackOrTargetted)
        
        if from == nil or target == nil then
            return 0
        end
        if isAbility == nil then
            isAbility = true
        end
        if isAutoAttackOrTargetted == nil then
            isAutoAttackOrTargetted = false
        end
        local fromIsMinion = from.type == Obj_AI_Minion
        local targetIsMinion = target.type == Obj_AI_Minion
        local baseResistance = 0
        local bonusResistance = 0
        local penetrationFlat = 0
        local penetrationPercent = 0
        local bonusPenetrationPercent = 0
        if damageType == self.DAMAGE_TYPE_PHYSICAL then
            baseResistance = math.max(target.armor - target.bonusArmor, 0)
            bonusResistance = target.bonusArmor
            penetrationFlat = from.armorPen
            penetrationPercent = from.armorPenPercent
            bonusPenetrationPercent = from.bonusArmorPenPercent
            -- Minions return wrong percent values.
            if fromIsMinion then
                penetrationFlat = 0
                penetrationPercent = 0
                bonusPenetrationPercent = 0
            elseif from.type == Obj_AI_Turret then
                penetrationPercent = self:IsBaseTurret(from.charName) and 0.75 or 0.3
                penetrationFlat = 0
                bonusPenetrationPercent = 0
            end
        elseif damageType == self.DAMAGE_TYPE_MAGICAL then
            baseResistance = math.max(target.magicResist - target.bonusMagicResist, 0)
            bonusResistance = target.bonusMagicResist
            penetrationFlat = from.magicPen
            penetrationPercent = from.magicPenPercent
            bonusPenetrationPercent = 0
        elseif damageType == self.DAMAGE_TYPE_TRUE then
            return rawDamage
        end
        local resistance = baseResistance + bonusResistance
        if resistance > 0 then
            if penetrationPercent > 0 then
                baseResistance = baseResistance * penetrationPercent
                bonusResistance = bonusResistance * penetrationPercent
            end
            if bonusPenetrationPercent > 0 then
                bonusResistance = bonusResistance * bonusPenetrationPercent
            end
            resistance = baseResistance + bonusResistance
            resistance = resistance - penetrationFlat
        end
        local percentMod = 1
        -- Penetration cant reduce resistance below 0.
        if resistance >= 0 then
            percentMod = percentMod * (100 / (100 + resistance))
        else
            percentMod = percentMod * (2 - 100 / (100 - resistance))
        end
        local flatPassive = 0
        local percentPassive = 1
        if fromIsMinion and targetIsMinion then
            percentPassive = percentPassive * (1 + from.bonusDamagePercent)
        end
        local flatReceived = 0
        if not isAbility and targetIsMinion then
            flatReceived = flatReceived - target.flatDamageReduction
        end
        return math.max(percentPassive * percentMod * (rawDamage + flatPassive) + flatReceived, 0)
    end
    
    function Damage:GetStaticAutoAttackDamage
        (from, targetIsMinion)
        
        local args = {
            From = from,
            RawTotal = from.totalDamage,
            RawPhysical = 0,
            RawMagical = 0,
            CalculatedTrue = 0,
            CalculatedPhysical = 0,
            CalculatedMagical = 0,
            DamageType = self.DAMAGE_TYPE_PHYSICAL,
            TargetIsMinion = targetIsMinion
        }
        self:SetHeroStaticDamage(args)
        local HashSet = {}
        for i = 1, #Item.ItemSlots do
            local slot = Item.ItemSlots[i]
            local item = args.From:GetItemData(slot)
            if item ~= nil and item.itemID > 0 then
                if HashSet[item.itemID] == nil then
                    self:SetItemStaticDamage(item.itemID, args)
                    HashSet[item.itemID] = true
                end
            end
        end
        return args
    end
    
    function Damage:GetHeroAutoAttackDamage
        (from, target, static)
        
        local args = {
            From = from,
            Target = target,
            RawTotal = static.RawTotal,
            RawPhysical = static.RawPhysical,
            RawMagical = static.RawMagical,
            CalculatedTrue = static.CalculatedTrue,
            CalculatedPhysical = static.CalculatedPhysical,
            CalculatedMagical = static.CalculatedMagical,
            DamageType = static.DamageType,
            TargetIsMinion = target.type == Obj_AI_Minion,
            CriticalStrike = false,
        }
        if args.TargetIsMinion and args.Target.maxHealth <= 6 then
            return 1
        end
        self:SetHeroPassiveDamage(args)
        if args.DamageType == self.DAMAGE_TYPE_PHYSICAL then
            args.RawPhysical = args.RawPhysical + args.RawTotal
        elseif args.DamageType == self.DAMAGE_TYPE_MAGICAL then
            args.RawMagical = args.RawMagical + args.RawTotal
        elseif args.DamageType == self.DAMAGE_TYPE_TRUE then
            args.CalculatedTrue = args.CalculatedTrue + args.RawTotal
        end
        if args.RawPhysical > 0 then
            args.CalculatedPhysical = args.CalculatedPhysical + self:CalculateDamage(from, target, self.DAMAGE_TYPE_PHYSICAL, args.RawPhysical, false, args.DamageType == self.DAMAGE_TYPE_PHYSICAL)
        end
        if args.RawMagical > 0 then
            args.CalculatedMagical = args.CalculatedMagical + self:CalculateDamage(from, target, self.DAMAGE_TYPE_MAGICAL, args.RawMagical, false, args.DamageType == self.DAMAGE_TYPE_MAGICAL)
        end
        local percentMod = 1
        if args.From.critChance - 1 == 0 or args.CriticalStrike then
            percentMod = percentMod * self:GetCriticalStrikePercent(args.From)
        end
        return percentMod * args.CalculatedPhysical + args.CalculatedMagical + args.CalculatedTrue
    end
    
    function Damage:GetAutoAttackDamage
        (from, target, respectPassives)
        
        if respectPassives == nil then
            respectPassives = true
        end
        if from == nil or target == nil then
            return 0
        end
        local targetIsMinion = target.type == Obj_AI_Minion
        if respectPassives and from.type == Obj_AI_Hero then
            return self:GetHeroAutoAttackDamage(from, target, self:GetStaticAutoAttackDamage(from, targetIsMinion))
        end
        if targetIsMinion then
            if target.maxHealth <= 6 then
                return 1
            end
            if from.type == Obj_AI_Turret and not self:IsBaseTurret(from.charName) then
                local percentMod = self.TurretToMinionPercent[target.charName]
                if percentMod ~= nil then
                    return target.maxHealth * percentMod
                end
            end
        end
        return self:CalculateDamage(from, target, self.DAMAGE_TYPE_PHYSICAL, from.totalDamage, false, true)
    end
    
    function Damage:GetCriticalStrikePercent
        (from)
        
        local baseCriticalDamage = 2
        local percentMod = 1
        local fixedMod = 0
        if from.charName == "Jhin" then
            percentMod = 0.75
        elseif from.charName == "XinZhao" then
            baseCriticalDamage = baseCriticalDamage - (0.875 - 0.125 * from:GetSpellData(_W).level)
        elseif from.charName == "Yasuo" then
            percentMod = 0.9
        end
        return baseCriticalDamage * percentMod
    end
end

Data = require("Gamsteron_Arrays")

do
    function Data:Init
        ()
        self.IsChanneling = self.ChannelingBuffs[self.HeroName]
        self.CanDisableMove = self.AllowMovement[self.HeroName]
        self.CanDisableAttack = self.DisableAttackBuffs[self.HeroName]
        self.SpecialMissileSpeed = self.SpecialMissileSpeeds[self.HeroName]
        self.IsHeroMelee = self.HeroMelees[self.HeroName]
        self.IsHeroSpecialMelee = self.HeroSpecialMelees[self.HeroName]
        self.ExtraAttackRange = self.ExtraAttackRanges[self.HeroName]
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Data:OnLoad()
        self.AttackReset = self.AttackResets[self.HeroName]
        if self.AttackReset then
            self.AttackResetSuccess = false
            self.AttackResetSlot = self.AttackReset.Slot
            self.AttackResetBuff = self.AttackReset.Buff
            self.AttackResetOnCast = self.AttackReset.OnCast
            self.AttackResetCanCancel = self.AttackReset.CanCancel
            self.AttackResetTimer = 0
            self.AttackResetTimeout = 0
            local AttackResetKey = self.AttackReset.Key
            local AttackResetActiveSpell = self.AttackReset.ActiveCheck
            local AttackResetIsReady = self.AttackReset.ReadyCheck
            local AttackResetName = self.AttackReset.Name
            local AttackResetSpellName = self.AttackReset.SpellName
            local X, T = 0, 0
            if not self.AttackResetCanCancel then--and not Object.IsRiven then
                table.insert(SDK.WndMsg, function(msg, wParam)
                    if not self.AttackResetSuccess and not Control.IsKeyDown(HK_LUS) and not Game.IsChatOpen() and wParam == AttackResetKey then
                        local checkNum = Object.IsRiven and 400 or 600
                        if GetTickCount() <= self.AttackResetTimer + checkNum then
                            return
                        end
                        if AttackResetIsReady and Game.CanUseSpell(self.AttackResetSlot) ~= 0 then
                            return
                        end
                        local spellData = myHero:GetSpellData(self.AttackResetSlot)
                        if (Object.IsRiven or spellData.mana <= myHero.mana) and spellData.currentCd == 0 and (not AttackResetName or spellData.name == AttackResetName) then
                            if AttackResetActiveSpell then
                                self.AttackResetTimer = GetTickCount()
                                local startTime = GetTickCount() + 400
                                Action:Add(function()
                                    local s = myHero.activeSpell
                                    if s and s.valid and s.name == AttackResetSpellName then
                                        self.AttackResetTimer = GetTickCount()
                                        self.AttackResetSuccess = true
                                        --print("Attack Reset ActiveSpell")
                                        --print(startTime - GetTickCount())
                                        return true
                                    end
                                    if GetTickCount() < startTime then
                                        return false
                                    end
                                    return true
                                end)
                                return
                            end
                            
                            self.AttackResetTimer = GetTickCount()
                            
                            if Object.IsKindred then
                                Orbwalker:SetMovement(false)
                                local setTime = GetTickCount() + 550
                                -- SET ATTACK
                                Action:Add(function()
                                    if GetTickCount() < setTime then
                                        return false
                                    end
                                    --print("Move True Kindred")
                                    Orbwalker:SetMovement(true)
                                    return true
                                end)
                                return
                            end
                            
                            self.AttackResetSuccess = true
                            --print("Attack Reset")
                            
                            -- RIVEN
                            if Object.IsRiven then
                                X = X + 1
                                if X == 1 then
                                    T = GetTickCount()
                                end
                                if X == 3 then
                                    --print(GetTickCount() - T)
                                end
                                local isThree = Buff:HasBuff(myHero, 'riventricleavesoundtwo')
                                if isThree then
                                    X = 0
                                end
                                local riven_start = GetTickCount() + 450 + (isThree and 100 or 0) - LATENCY
                                Action:Add(function()
                                    if GetTickCount() < riven_start then
                                        if Cursor.Step == 0 then
                                            Cursor.MoveTimer = 0
                                            Control.Move()
                                        end
                                        return false
                                    end
                                    Orbwalker:SetAttack(true)
                                    Attack.Reset = true
                                    return true
                                end)
                                Orbwalker:SetAttack(false)
                                return
                            end
                        end
                    end
                end)
            end
        end
    end
    
    function Data:IdEquals
        (a, b)
        if a == nil or b == nil then
            return false
        end
        return a.networkID == b.networkID
    end
    
    function Data:GetAutoAttackRange
        (from, target)
        local result = from.range
        local fromType = from.type
        if fromType == Obj_AI_Minion then
            local fromName = from.charName
            result = self.MinionRange[fromName] ~= nil and self.MinionRange[fromName] or 0
        elseif fromType == Obj_AI_Turret then
            result = 775
        end
        if target then
            local targetType = target.type
            if targetType == Obj_AI_Barracks then
                result = result + 270
            elseif targetType == Obj_AI_Nexus then
                result = result + 380
            else
                result = result + from.boundingRadius + target.boundingRadius
                if targetType == Obj_AI_Hero and self.ExtraAttackRange then
                    result = result + self.ExtraAttackRange(target)
                end
            end
        else
            result = result + from.boundingRadius + 35
        end
        return result
    end
    
    function Data:IsInAutoAttackRange
        (from, target, extrarange)
        local range = extrarange or 0
        return Math:IsInRange(from.pos, target.pos, self:GetAutoAttackRange(from, target) + range)
    end
    
    function Data:IsInAutoAttackRange2
        (from, target, extrarange)
        local range = self:GetAutoAttackRange(from, target) + (extrarange or 0)
        if Math:IsInRange(from.pos, target.pos, range) and Math:IsInRange(from.pos, target.posTo, range) then
            return true
        end
        return false
    end
    
    function Data:CanResetAttack
        ()
        if self.AttackReset == nil then
            return false
        end
        
        if self.AttackResetCanCancel then
            if self.AttackResetOnCast then
                if self.AttackResetBuff == nil or Buff:HasBuff(myHero, self.AttackResetBuff) then
                    local spellData = myHero:GetSpellData(self.AttackResetSlot)
                    local startTime = spellData.castTime - spellData.cd
                    if not self.AttackResetSuccess and Game.Timer() - startTime < 0.2 and GetTickCount() > self.AttackResetTimer + 1000 then
                        --print('Reset Cast, Buff')
                        self.AttackResetSuccess = true
                        self.AttackResetTimeout = GetTickCount()
                        self.AttackResetTimer = GetTickCount()
                        return true
                    end
                    if self.AttackResetSuccess and GetTickCount() > self.AttackResetTimeout + 200 then
                        --print('Reset Timeout')
                        self.AttackResetSuccess = false
                    end
                    return false
                end
            elseif Buff:ContainsBuffs(myHero, self.AttackResetBuff) then
                if not self.AttackResetSuccess then
                    self.AttackResetSuccess = true
                    --print('Reset Buff')
                    return true
                end
                return false
            end
            if self.AttackResetSuccess then
                --print('Remove Reset')
                self.AttackResetSuccess = false
            end
            return false
        end
        
        if self.AttackResetSuccess then
            self.AttackResetSuccess = false
            --print("AA RESET STOP !")
            return true
        end
        
        return false
    end
    
    function Data:IsAttack
        (name)
        if self.IsAttackSpell[name] then
            return true
        end
        if self.IsNotAttack[name] then
            return false
        end
        return name:lower():find('attack')
    end
    
    function Data:GetLatency
        ()
        return LATENCY * 0.001
    end
    
    function Data:HeroCanMove
        ()
        if self.IsChanneling and self.IsChanneling() then
            if self.CanDisableMove == nil or (not self.CanDisableMove()) then
                return false
            end
        end
        return true
    end
    
    function Data:HeroCanAttack
        ()
        if self.IsChanneling and self.IsChanneling() then
            return false
        end
        if self.CanDisableAttack and self.CanDisableAttack() then
            return false
        end
        if Buff:HasBuffTypes(myHero, {[25] = true, [31] = true}) then
            return false
        end
        return true
    end
    
    function Data:IsMelee
        ()
        if self.IsHeroMelee or (self.IsHeroSpecialMelee and self.IsHeroSpecialMelee()) then
            return true
        end
        return false
    end
    
    function Data:GetHeroPriority
        (name)
        local p = self.HeroPriorities[name:lower()]
        return p and p or 5
    end
    
    function Data:GetHeroData
        (obj)
        if obj == nil then
            return {}
        end
        local id = obj.networkID
        if id == nil or id <= 0 then
            return {}
        end
        local name = obj.charName
        if name == nil or self.HeroNames[name:lower()] == nil then
            return {}
        end
        local Team = obj.team
        local IsEnemy = obj.isEnemy
        local IsAlly = obj.isAlly
        if Team == nil or Team < 100 or Team > 200 or IsEnemy == nil or IsAlly == nil or IsEnemy == IsAlly then
            return {}
        end
        return
        {
            valid = true,
            isEnemy = IsEnemy,
            isAlly = IsAlly,
            networkID = id,
            charName = name,
            team = Team,
            unit = obj,
        }
    end
    
    function Data:Join
        (t1, t2)
        
        local t = {}
        
        for i = 1, #t1 do
            table.insert(t, t1[i])
        end
        
        for i = 1, #t2 do
            table.insert(t, t2[i])
        end
        
        return t
    end
    
    function Data:IsUnit
        (unit)
        local type = unit.type
        if type == Obj_AI_Hero or type == Obj_AI_Minion or type == Obj_AI_Turret then
            return true
        end
        return false
    end
    
    function Data:GetTotalShield
        (obj)
        
        local shieldAd, shieldAp
        shieldAd = obj.shieldAD
        shieldAp = obj.shieldAP
        
        return (shieldAd and shieldAd or 0) + (shieldAp and shieldAp or 0)
    end
    
    function Data:TotalShieldHealth
        (target)
        
        local result = target.health + target.shieldAD + target.shieldAP
        --[[if target.charName == "Blitzcrank" then
            if not self:HasBuff(target, "manabarriercooldown") and not self:HasBuff(target, "manabarrier") then
                result = result + target.mana * 0.5
            end
        end--]]
        return result
    end
    
    function Data:GetBuildingBBox
        (unit)
        local type = unit.type
        if type == Obj_AI_Barracks then
            return 270
        end
        if type == Obj_AI_Nexus then
            return 380
        end
        return 0
    end
    
    function Data:IsAlly
        (unit)
        local team = unit.team
        if team == self.AllyTeam then
            return true
        end
        return false
    end
    
    function Data:IsEnemy
        (unit)
        local team = unit.team
        if team == self.EnemyTeam then
            return true
        end
        return false
    end
    
    function Data:IsJungle
        (unit)
        local team = unit.team
        if team == self.JungleTeam then
            return true
        end
        return false
    end
    
    function Data:IsOtherMinion
        (unit)
        if unit.maxHealth <= 6 then
            return true
        end
        return false
    end
    
    function Data:IsLaneMinion
        (unit)
        if not self:IsOtherMinion(unit) and not self:IsJungle(unit) then
            return true
        end
        return false
    end
    
    function Data:Stop
        ()
        
        return Game.IsChatOpen() or (ExtLibEvade and ExtLibEvade.Evading) or (JustEvade and (not JustEvade.Evading or JustEvade.Evading())) or (not Game.IsOnTop())
    end
end

Spell =
{
}

do
    function Spell:Init
        ()
        
        self.QTimer = 0
        self.WTimer = 0
        self.ETimer = 0
        self.RTimer = 0
        self.QkTimer = 0
        self.WkTimer = 0
        self.EkTimer = 0
        self.RkTimer = 0
        
        self.GameCanUseSpell = _G.Game.CanUseSpell
        _G.Game.CanUseSpell = function(spell)
            if self:IsReady(spell) then
                return 0
            end
            return 1
        end;
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Spell:OnLoad
        ()
        
        table.insert(SDK.WndMsg, function(msg, wParam)
            local timer = Game.Timer()
            
            if wParam == HK_Q then
                if timer > self.QkTimer + 0.33 and self.GameCanUseSpell(_Q) == 0 then
                    self.QkTimer = timer
                end
                return
            end
            
            if wParam == HK_W then
                if timer > self.WkTimer + 0.33 and self.GameCanUseSpell(_W) == 0 then
                    self.WkTimer = timer
                end
                return
            end
            
            if wParam == HK_E then
                if timer > self.EkTimer + 0.33 and self.GameCanUseSpell(_E) == 0 then
                    self.EkTimer = timer
                end
                return
            end
            
            if wParam == HK_R then
                if timer > self.RkTimer + 0.33 and self.GameCanUseSpell(_R) == 0 then
                    self.RkTimer = timer
                end
                return
            end
        end)
    end
    
    function Spell:IsReady
        (spell, delays)
        
        if Cursor.Step > 0 then
            return false
        end
        
        if delays ~= nil then
            local timer = Game.Timer()
            if timer < self.QTimer + delays.q or timer < self.QkTimer + delays.q then
                return false
            end
            if timer < self.WTimer + delays.w or timer < self.WkTimer + delays.w then
                return false
            end
            if timer < self.ETimer + delays.e or timer < self.EkTimer + delays.e then
                return false
            end
            if timer < self.RTimer + delays.r or timer < self.RkTimer + delays.r then
                return false
            end
        end
        
        if self.GameCanUseSpell(spell) ~= 0 then
            return false
        end
        
        return true
    end
    
    function Spell:GetLastSpellTimers
        ()
        
        return self.QTimer, self.QkTimer, self.WTimer, self.WkTimer, self.ETimer, self.EkTimer, self.RTimer, self.RkTimer
    end
    
    function Spell:CheckSpellDelays
        (delays)
        
        local timer = Game.Timer()
        if timer < self.QTimer + delays.q or timer < self.QkTimer + delays.q then
            return false
        end
        if timer < self.WTimer + delays.w or timer < self.WkTimer + delays.w then
            return false
        end
        if timer < self.ETimer + delays.e or timer < self.EkTimer + delays.e then
            return false
        end
        if timer < self.RTimer + delays.r or timer < self.RkTimer + delays.r then
            return false
        end
        return true
    end
    
    function Spell:CheckSpellDelays2
        (delays)
        
        local timer = Game.Timer()
        if timer < self.QTimer + delays[_Q] or timer < self.QkTimer + delays[_Q] then
            return false
        end
        if timer < self.WTimer + delays[_W] or timer < self.WkTimer + delays[_W] then
            return false
        end
        if timer < self.ETimer + delays[_E] or timer < self.EkTimer + delays[_E] then
            return false
        end
        if timer < self.RTimer + delays[_R] or timer < self.RkTimer + delays[_R] then
            return false
        end
        return true
    end
    
    function Spell:SpellClear
        (spell, spelldata, isReady, canLastHit, canLaneClear, getDrawMenu, getDamage)
        
        local c =
        {
            HK = 0,
            Radius = spelldata.Radius,
            Delay = spelldata.Delay,
            Speed = spelldata.Speed,
            Range = spelldata.Range,
            ShouldWaitTime = 0,
            IsLastHitable = false,
            LastHitHandle = 0,
            LaneClearHandle = 0,
            FarmMinions = {},
        }
        
        if spell == _Q then
            c.HK = HK_Q
        elseif spell == _W then
            c.HK = HK_W
        elseif spell == _E then
            c.HK = HK_E
        elseif spell == _R then
            c.HK = HK_R
        else
            print('SDK.Spell.SpellClear: error, spell must be _Q, _W, _E or _R')
            return
        end
        
        function c:GetLastHitTargets
            ()
            
            local result = {}
            
            for i, minion in pairs(self.FarmMinions) do
                if minion.LastHitable then
                    local unit = minion.Minion
                    if unit.handle ~= Health.LastHitHandle then
                        table.insert(result, unit)
                    end
                end
            end
            
            return result
        end
        
        function c:GetLaneClearTargets
            ()
            
            local result = {}
            
            for i, minion in pairs(self.FarmMinions) do
                local unit = minion.Minion
                if unit.handle ~= Health.LaneClearHandle then
                    table.insert(result, unit)
                end
            end
            
            return result
        end
        
        function c:ShouldWait
            ()
            
            return Game.Timer() <= self.ShouldWaitTime + 1
        end
        
        function c:SetLastHitable
            (target, time, damage)
            
            local hpPred = Health:GetPrediction(target, time)
            
            local lastHitable = false
            local almostLastHitable = false
            
            if hpPred - damage < 0 then
                lastHitable = true
                self.IsLastHitable = true
            elseif Health:GetPrediction(target, myHero:GetSpellData(spell).cd + (time * 3)) - damage < 0 then
                almostLastHitable = true
                self.ShouldWaitTime = Game.Timer()
            end
            
            return {LastHitable = lastHitable, Unkillable = hpPred < 0, Time = time, AlmostLastHitable = almostLastHitable, PredictedHP = hpPred, Minion = target}
        end
        
        function c:Reset()
            for i = 1, #self.FarmMinions do
                table.remove(self.FarmMinions, i)
            end
            self.IsLastHitable = false
            self.LastHitHandle = 0
            self.LaneClearHandle = 0
        end
        
        function c:Tick
            ()
            
            if Orbwalker:IsAutoAttacking() or not isReady() then
                return
            end
            
            local isLastHit = canLastHit() and (Orbwalker.Modes[Orbwalker.ORBWALKER_MODE_LASTHIT] or Orbwalker.Modes[Orbwalker.ORBWALKER_MODE_LANECLEAR])
            local isLaneClear = canLaneClear() and Orbwalker.Modes[Orbwalker.ORBWALKER_MODE_LANECLEAR]
            
            if not isLastHit and not isLaneClear then
                return
            end
            
            if Cursor.Step ~= 0 then
                return
            end
            
            if myHero:GetSpellData(spell).level == 0 then
                return
            end
            
            if myHero.mana < myHero:GetSpellData(spell).mana then
                return
            end
            
            if Game.CanUseSpell(spell) ~= 0 and myHero:GetSpellData(spell).currentCd > 0.5 then
                return
            end
            
            local targets = Object:GetEnemyMinions(self.Range - 35, false, true, true)
            for i = 1, #targets do
                local target = targets[i]
                table.insert(self.FarmMinions, self:SetLastHitable(target, self.Delay + target.distance / self.Speed + Data:GetLatency(), getDamage()))
            end
            
            if self.IsLastHitable and (isLastHit or isLaneClear) then
                local targets = self:GetLastHitTargets()
                for i = 1, #targets do
                    local unit = targets[i]
                    if unit.alive and unit:GetCollision(self.Radius + 35, self.Speed, self.Delay) == 1 then
                        if Control.CastSpell(self.HK, unit:GetPrediction(self.Speed, self.Delay)) then
                            self.LastHitHandle = unit.handle
                            Orbwalker:SetAttack(false)
                            Action:Add(function()
                                Orbwalker:SetAttack(true)
                            end, self.Delay + (unit.distance / self.Speed) + 0.05, 0)
                            break
                        end
                    end
                end
            end
            
            if isLaneClear and self.LastHitHandle == 0 and not self:ShouldWait() then
                local targets = self:GetLaneClearTargets()
                for i = 1, #targets do
                    local unit = targets[i]
                    if unit.alive and unit:GetCollision(self.Radius + 35, self.Speed, self.Delay) == 1 then
                        if Control.CastSpell(self.HK, unit:GetPrediction(self.Speed, self.Delay)) then
                            self.LaneClearHandle = unit.handle
                        end
                    end
                end
            end
            
            local lhmenu, lcmenu = getDrawMenu()
            if lhmenu.enabled:Value() or lcmenu.enabled:Value() then
                local targets = self.FarmMinions
                for i = 1, #targets do
                    local minion = targets[i]
                    if minion.LastHitable and lhmenu.enabled:Value() then
                        Draw.Circle(minion.Minion.pos, lhmenu.radius:Value(), lhmenu.width:Value(), lhmenu.color:Value())
                    elseif minion.AlmostLastHitable and lcmenu.enabled:Value() then
                        Draw.Circle(minion.Minion.pos, lcmenu.radius:Value(), lcmenu.width:Value(), lcmenu.color:Value())
                    end
                end
            end
        end
        
        Health:AddSpell(c)
    end
end

SDK.Color = Color
SDK.Action = Action
SDK.BuffManager = Buff
SDK.Math = Math
SDK.Damage = Damage
SDK.Data = Data
SDK.Spell = Spell