
local _Visible, _PosData, _PathBank, _Waypoints, _Attacks, _Yasuo
do
    _Visible = {}
    _PosData = {}
    _PathBank = {}
    _Waypoints = {}
    _Attacks = {}
    
    SDK.ObjectManager:OnEnemyHeroLoad(function(args)
        if (args.charName:lower() == "yasuo" and args.isEnemy) then
            _Yasuo =
            {
                Wall = nil,
                Name = nil,
                Level = 0,
                CastTime = 0,
                StartPos = nil
            }
        end
    end)
    
    Callback.Add("Load", function()
        Callback.Add("Draw", function()
            local currentHeroes = {}
            local yasuoChecked = false
            
            for i = 1, Game.HeroCount() do
                local unit = Game.Hero(i)
                if IsValid(unit) and unit.isEnemy then
                    currentHeroes[unit.networkID] = true
                    
                    -- OnAttack
                    local id = unit.networkID
                    if (_Attacks[id] == nil) then
                        _Attacks[id] = {startTime = 0, animation = 0, windup = 0, castEndTime = 0, endTime = 0, isCloseToAttack = false}
                    end
                    if (unit.isEnemy and unit.attackSpeed > 1.5 and unit.range > 500) then
                        local spell = unit.activeSpell
                        if (spell and spell.valid) then
                            if (spell.castEndTime > _Attacks[id].castEndTime) then
                                local name = spell.name
                                if spell.isAutoAttack then
                                    _Attacks[id].startTime = spell.startTime
                                    _Attacks[id].animation = spell.animation
                                    _Attacks[id].windup = spell.windup
                                    _Attacks[id].castEndTime = spell.castEndTime
                                    _Attacks[id].endTime = spell.endTime
                                end
                            end
                        end
                        local isCloseToAttack = false
                        if (GetDistance(Get2D(unit.pos), Get2D(myHero.pos)) < 1500) then
                            if (Game.Timer() > _Attacks[id].startTime + (_Attacks[id].animation * 0.75) and Game.Timer() - _Attacks[id].startTime < _Attacks[id].animation * 1.5) then
                                local unitPos = Get2D(unit.pos)
                                for i, ally in pairs(GetAllyHeroes()) do
                                    if (GetDistance(Get2D(ally.pos), unitPos) < unit.range + unit.boundingRadius) then
                                        isCloseToAttack = true
                                        break
                                    end
                                end
                            end
                        end
                        _Attacks[id].isCloseToAttack = isCloseToAttack
                    end
                    
                    -- OnWaypoint
                    local unitPos = Get2D(unit.pos)
                    if (_PosData[id] == nil) then
                        _PosData[id] = {}
                        _PosData[id].Pos = unitPos
                    else
                        local n = Normalized(unitPos, _PosData[id].Pos)
                        if (n) then
                            _PosData[id].Pos = unitPos
                            _PosData[id].Dir = n
                        end
                    end
                    if (_Visible[id] == nil) then
                        _Visible[id] = {}
                        _Visible[id].visible = false
                    end
                    if (_Visible[id].visible == false) then
                        _Visible[id].visible = true
                        _Visible[id].visibleTick = GetTickCount()
                    end
                    if (_PathBank[id] == nil) then
                        _PathBank[id] = {}
                    end
                    if (_Waypoints[id] == nil) then
                        _Waypoints[id] = {}
                        _Waypoints[id].tick = 0
                        _Waypoints[id].stoptick = 0
                        _Waypoints[id].moving = false
                        _Waypoints[id].pos = {x = 0, z = 0}
                    end
                    local unitPath = unit.pathing
                    if (unitPath.hasMovePath) then
                        local endPos = Get2D(unitPath.endPos)
                        if (VectorsEqual(_Waypoints[id].pos, endPos) == false) then
                            _Waypoints[id].pos = endPos
                            _Waypoints[id].tick = GetTickCount()
                            _Waypoints[id].moving = true
                            table.insert(_PathBank[id], 1, {pos = endPos, tick = GetTickCount()})
                            if (#_PathBank[id] > 10) then
                                table.remove(_PathBank[id])
                            end
                        end
                    else
                        if (_Waypoints[id].moving) then
                            _Waypoints[id].stoptick = GetTickCount()
                            _Waypoints[id].moving = false
                        end
                    end
                    
                    -- _Yasuo
                    if (_Yasuo and not yasuoChecked and unit.charName == "_Yasuo") then
                        if (Game.Timer() > _Yasuo.CastTime + 2) then
                            local wallData = unit:GetSpellData(_W)
                            if (wallData.currentCd > 0 and wallData.cd - wallData.currentCd < 1.5) then
                                _Yasuo.Wall = nil
                                _Yasuo.Name = nil
                                _Yasuo.StartPos = nil
                                _Yasuo.Level = wallData.level
                                _Yasuo.CastTime = wallData.castTime
                                for i = 1, Game.ParticleCount() do
                                    local obj = Game.Particle(i)
                                    if (obj and obj.name and obj.pos) then
                                        local name = obj.name:lower()
                                        if (name:find("yasuo") and name:find("_w_") and name:find("windwall")) then
                                            if (name:find("activate")) then
                                                _Yasuo.StartPos = Get2D(obj.pos)
                                            else
                                                _Yasuo.Wall = obj
                                                _Yasuo.Name = obj.name
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if (_Yasuo.Wall ~= nil) then
                            if (_Yasuo.Name == nil or _Yasuo.Wall.name == nil or _Yasuo.Name ~= _Yasuo.Wall.name or _Yasuo.StartPos == nil) then
                                _Yasuo.Wall = nil
                            end
                        end
                        yasuoChecked = true
                    end
                end
            end
            
            for id, k in pairs(_PosData) do
                if (currentHeroes[id] == nil) then
                    if (_Visible[id].visible == true) then
                        _Visible[id].visible = false
                        _Visible[id].invisibleTick = GetTickCount()
                    end
                end
            end
        end)
    end)
end

-- MENU
local Menu, PredictionMaxRange, ExtraCollisionRadius
do
    Menu = MenuElement({name = "Prediction", id = "GPred", type = _G.MENU})
    Menu:MenuElement({id = "PredMaxRange", name = "Pred Max Range %", value = 100, min = 70, max = 100, step = 1, callback = function(value) PredictionMaxRange = value * 0.01 end})
    Menu:MenuElement({name = "Extra Collision Radius", id = "ExtraColRad", value = 15, min = 0, max = 50, step = 5, callback = function(value) ExtraCollisionRadius = value end})
    PredictionMaxRange = Menu.PredMaxRange:Value() * 0.01
    ExtraCollisionRadius = Menu.ExtraColRad:Value()
end

-- API
do
    _G.COLLISION_MINION = 0
    _G.COLLISION_ALLYHERO = 1
    _G.COLLISION_ENEMYHERO = 2
    _G.COLLISION_YASUOWALL = 3
    
    _G.HITCHANCE_IMPOSSIBLE = 0
    _G.HITCHANCE_COLLISION = 1
    _G.HITCHANCE_NORMAL = 2
    _G.HITCHANCE_HIGH = 3
    _G.HITCHANCE_IMMOBILE = 4
    
    _G.SPELLTYPE_LINE = 0
    _G.SPELLTYPE_CIRCLE = 1
    _G.SPELLTYPE_CONE = 2
end

-- IMMOBILE BUFF
local ImmobileBuffTypes, GetImmobileDuration
do
    
    --[[ Buff Types:
    INTERNAL = 0, AURA = 1, ENHANCER = 2, DEHANCER = 3, SPELLSHIELD = 4, STUN = 5, INVIS = 6, SILENCE = 7,
    TAUNT = 8, POLYMORPH = 9, SLOW = 10, SNARE = 11, DMG = 12, HEAL = 13, HASTE = 14, SPELLIMM = 15
    PHYSIMM = 16, INVULNERABLE = 17, SLEEP = 18, NEARSIGHT = 19, FRENZY = 20, FEAR = 21, CHARM = 22, POISON = 23
    SUPRESS = 24, BLIND = 25, COUNTER = 26, SHRED = 27, FLEE = 28, KNOCKUP = 29, KNOCKBACK = 30, DISARM = 31]]
    
    ImmobileBuffTypes =
    {
        [5] = true,
        [8] = true,
        [11] = true,
        --[18] = true broken shiit
        [21] = true,
        [22] = true,
        [24] = true,
        [29] = true,
    }
    
    GetImmobileDuration = function
        (unit)
        
        local SpellStartTime = 0
        local AttackStartTime = 0
        local ImmobileDuration = 0
        local KnockDuration = 0
        local path = unit.pathing
        if ((not path) or path.hasMovePath) then
            return ImmobileDuration, SpellStartTime, AttackStartTime, KnockDuration
        end
        for i = 0, unit.buffCount do
            local buff = unit:GetBuff(i)
            if (buff) then
                local count = buff.count
                local duration = buff.duration
                local btype = buff.type
                if (count and duration and btype and count > 0 and duration > 0) then
                    if (duration > ImmobileDuration and ImmobileBuffTypes[btype]) then
                        ImmobileDuration = duration
                    elseif (btype == 30) then
                        KnockDuration = duration
                    end
                end
            end
        end
        local spell = unit.activeSpell
        if (spell and spell.valid) then
            if spell.isAutoAttack then
                AttackStartTime = spell.startTime
            elseif (spell.windup > 0.2) then
                SpellStartTime = spell.startTime
            end
        end
        return ImmobileDuration, SpellStartTime, AttackStartTime, KnockDuration
    end
end

-- UTILITIES
local IsValid, Get2D, Get3D, GetDistance, IsInRange, VectorsEqual, Normalized, Extended,
Perpendicular, Intersection, ClosestPointOnLineSegment, quad, intercept, Polar, AngleBetween,
GetPathLenght, CutPath, GetPath, GetEnemyHeroes, GetAllyHeroes
do
    IsValid = function
        (unit)
        
        if (unit and unit.valid and unit.isTargetable and unit.alive and unit.visible and unit.networkID and unit.pathing and unit.health > 0) then
            return true
        end
        return false
    end
    
    Get2D = function
        (p1)
        
        if (p1.pos) then
            p1 = p1.pos
        end
        local result = {x = 0, z = 0}
        if (p1.x) then
            result.x = p1.x
        end
        if (p1.z) then
            result.z = p1.z
        elseif (p1.y) then
            result.z = p1.y
        end
        return result
    end
    
    Get3D = function
        (p1)
        
        if (p1.pos) then
            p1 = p1.pos
        end
        return Vector(p1.x, 0, p1.z)
    end
    
    GetDistance = function
        (p1, p2)
        
        local dx = p2.x - p1.x
        local dz = p2.z - p1.z
        return math.sqrt(dx * dx + dz * dz)
    end
    
    IsInRange = function
        (p1, p2, range)
        
        local dx = p1.x - p2.x
        local dz = p1.z - p2.z
        if (dx * dx + dz * dz <= range * range) then
            return true
        end
        return false
    end
    
    VectorsEqual = function
        (p1, p2)
        
        if (GetDistance(p1, p2) < 5) then
            return true
        end
        return false
    end
    
    Normalized = function
        (p1, p2)
        
        local dx = p1.x - p2.x
        local dz = p1.z - p2.z
        local length = math.sqrt(dx * dx + dz * dz)
        local sol = nil
        if (length > 0) then
            local inv = 1.0 / length
            sol = {x = (dx * inv), z = (dz * inv)}
        end
        return sol
    end
    
    Extended = function
        (vec, dir, range)
        
        if (dir == nil) then
            return vec
        end
        return {x = vec.x + dir.x * range, z = vec.z + dir.z * range}
    end
    
    Perpendicular = function
        (dir)
        
        if (dir == nil) then
            return nil
        end
        return {x = -dir.z, z = dir.x}
    end
    
    Intersection = function
        (s1, e1, s2, e2)
        
        local IntersectionResult = {Intersects = false, Point = {x = 0, z = 0}}
        local deltaACz = s1.z - s2.z
        local deltaDCx = e2.x - s2.x
        local deltaACx = s1.x - s2.x
        local deltaDCz = e2.z - s2.z
        local deltaBAx = e1.x - s1.x
        local deltaBAz = e1.z - s1.z
        local denominator = deltaBAx * deltaDCz - deltaBAz * deltaDCx
        local numerator = deltaACz * deltaDCx - deltaACx * deltaDCz
        if (denominator == 0) then
            if (numerator == 0) then
                if s1.x >= s2.x and s1.x <= e2.x then
                    return {Intersects = true, Point = s1}
                end
                if s2.x >= s1.x and s2.x <= e1.x then
                    return {Intersects = true, Point = s2}
                end
                return IntersectionResult
            end
            return IntersectionResult
        end
        local r = numerator / denominator
        if (r < 0 or r > 1) then
            return IntersectionResult
        end
        local s = (deltaACz * deltaBAx - deltaACx * deltaBAz) / denominator
        if (s < 0 or s > 1) then
            return IntersectionResult
        end
        local point = {x = s1.x + r * deltaBAx, z = s1.z + r * deltaBAz}
        return {Intersects = true, Point = point}
    end
    
    ClosestPointOnLineSegment = function
        (p, p1, p2)
        
        local px = p.x
        local pz = p.z
        local ax = p1.x
        local az = p1.z
        local bx = p2.x
        local bz = p2.z
        local bxax = bx - ax
        local bzaz = bz - az
        local t = ((px - ax) * bxax + (pz - az) * bzaz) / (bxax * bxax + bzaz * bzaz)
        if (t < 0) then
            return p1, false
        end
        if (t > 1) then
            return p2, false
        end
        return {x = ax + t * bxax, z = az + t * bzaz}, true
    end
    
    quad = function
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
    
    intercept = function
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
        
        local ts = quad(a, b, c)
        
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
    
    Polar = function
        (p1)
        
        local x = p1.x
        local z = p1.z
        if (x == 0) then
            if (z > 0) then
                return 90
            end
            if (z < 0) then
                return 270
            end
            return 0
        end
        local theta = math.atan(z / x) * (180.0 / math.pi) --RadianToDegree
        if (x < 0) then
            theta = theta + 180
        end
        if (theta < 0) then
            theta = theta + 360
        end
        return theta
    end
    
    AngleBetween = function
        (p1, p2)
        
        if (p1 == nil or p2 == nil) then
            return nil
        end
        local theta = Polar(p1) - Polar(p2)
        if (theta < 0) then
            theta = theta + 360
        end
        if (theta > 180) then
            theta = 360 - theta
        end
        return theta
    end
    
    GetPathLenght = function
        (path)
        
        local result = 0
        for i = 1, #path - 1 do
            result = result + GetDistance(path[i], path[i + 1])
        end
        return result
    end
    
    CutPath = function
        (path, distance)
        
        if (distance <= 0) then
            return path
        end
        local result = {}
        for i = 1, #path - 1 do
            local dist = GetDistance(path[i], path[i + 1])
            if (dist > distance) then
                table.insert(result, Extended(path[i], Normalized(path[i + 1], path[i]), distance))
                for j = i + 1, #path do
                    table.insert(result, path[j])
                end
                break
            end
            distance = distance - dist
        end
        if (#result > 0) then
            return result
        end
        return {path[#path]}
    end
    
    GetPath = function
        (unit, unitPath)
        
        local result = {}
        table.insert(result, Get2D(unit.pos))
        if (unitPath.isDashing) then
            table.insert(result, Get2D(unitPath.endPos))
        else
            for i = unitPath.pathIndex, unitPath.pathCount do
                table.insert(result, Get2D(unit:GetPath(i)))
            end
        end
        return result
    end
    
    GetEnemyHeroes = function
        ()
        
        local _EnemyHeroes = {}
        for i = 1, Game.HeroCount() do
            local hero = Game.Hero(i)
            if IsValid(hero) and hero.isEnemy then
                table.insert(_EnemyHeroes, hero)
            end
        end
        return _EnemyHeroes
    end
    
    GetAllyHeroes = function
        ()
        
        local _AllyHeroes = {}
        for i = 1, Game.HeroCount() do
            local hero = Game.Hero(i)
            if IsValid(hero) and hero.isAlly then
                table.insert(_AllyHeroes, hero)
            end
        end
        return _AllyHeroes
    end
end

-- PREDICTED POSITION
local function GetDashingPrediction(from, speed, radius, delay, movespeed, dashSpeed, dashPath)
    from = Get2D(from)
    local predPos, castPos, timeToHit
    local delayPath = CutPath(dashPath, dashSpeed * delay)
    if (#delayPath == 1) then
        local startPos = dashPath[1]
        local endPos = dashPath[2]
        local dashTime = GetDistance(startPos, endPos) / dashSpeed
        local reactionTime = delay - dashTime
        if (speed == math.huge) then
            if (movespeed * reactionTime < radius - 25) then
                predPos = endPos
                timeToHit = delay
            end
        else
            local projTime = GetDistance(from, endPos) / speed
            reactionTime = reactionTime + projTime
            if (reactionTime * movespeed < radius - 25) then
                predPos = endPos
                timeToHit = delay + projTime
            end
        end
    else
        local startPos = delayPath[1]
        if (speed == math.huge) then
            predPos = startPos
            timeToHit = delay
        else
            local endPos = delayPath[2]
            local dashTime = GetDistance(startPos, endPos) / dashSpeed
            local t = intercept(from, startPos, endPos, speed, dashSpeed)
            if (t and t <= dashTime) then
                predPos = Extended(startPos, Normalized(endPos, startPos), t * dashSpeed)
                timeToHit = delay + t
            else
                local projTime = GetDistance(from, endPos) / speed
                local reactionTime = projTime - dashTime
                if (movespeed * reactionTime < radius - 25) then
                    predPos = endPos
                    timeToHit = delay + projTime
                end
            end
        end
    end
    castPos = predPos
    return predPos, castPos, timeToHit
end

local function findAngle(p0, p1, p2)
    local b = math.pow(p1.x - p0.x, 2) + math.pow(p1.z - p0.z, 2)
    local a = math.pow(p1.x - p2.x, 2) + math.pow(p1.z - p2.z, 2)
    local c = math.pow(p2.x - p0.x, 2) + math.pow(p2.z - p0.z, 2)
    local angle = math.acos((a + b - c) / math.sqrt(4 * a * b)) * (180 / math.pi)
    if (angle > 90) then
        angle = 180 - angle
    end
    return angle
end

local function GetPredictedPosition(from, speed, movespeed, p)
    local pos, timetohit
    
    local tT = 0
    for i = 1, #p - 1 do
        local a = p[i]
        local b = p[i + 1]
        local tB = G.GetDistance(a, b) / movespeed
        local direction = G.Normalized(b, a)
        a = G.Extended(a, direction, -(movespeed * tT))
        local t = G.intercept(from, a, b, speed, movespeed)
        if (t and t >= tT and t <= tT + tB) then
            return G.Extended(a, direction, t * movespeed), t
        end
        tT = tT + tB
    end
    
    return nil, -1
end

local function GetPredictedPosition(from, delay, speed, radius, movespeed, stype, path)
    from = Get2D(from)
    local predpos, castpos, timetohit
    -- spell with only delay
    if (speed == math.huge) then
        timetohit = delay
        predpos = CutPath(path, movespeed * timetohit)[1]
        castpos = CutPath(path, movespeed * timetohit - radius * 0.9)[1]
    else
        -- spell with speed and delay
        local cancalc = true
        local timeelapsed = 0
        local source = from
        local delaypath = CutPath(path, movespeed * delay)
        for i = 1, #delaypath - 1 do
            local sP = delaypath[i]
            local eP = delaypath[i + 1]
            local it = intercept(source, sP, eP, speed, movespeed)
            if (it == nil or it <= 0) then
                cancalc = false
                break
            end
            local movetime = GetDistance(sP, eP) / movespeed
            if (movetime >= it) then
                predpos = Extended(sP, Normalized(eP, sP), it * movespeed)
                radius = math.min(radius, radius * GetDistance(from, predpos) / 750)
                radius = radius * 0.0111 * findAngle(predpos, path[1], from)
                castpos = CutPath(delaypath, movespeed * (timeelapsed + it) - radius)[1]
                cancalc = false
                break
            end
            -- last path
            if (i == #delaypath - 1) then
                predpos = eP
                castpos = predpos
                --castpos = CutPath(delaypath, movespeed * (timeelapsed + movetime + (it - movetime) - radiusdelay))[1]
                cancalc = false
                break
            end
            timeelapsed = timeelapsed + movetime
            source = Extended(source, Normalized(eP, source), speed * movetime)
        end
        if (cancalc and predpos == nil and #delaypath == 1) then
            predpos = path[#path]
            castpos = predpos
        end
        if (predpos ~= nil) then
            timetohit = delay + (GetDistance(from, predpos) / speed)
        end
    end
    -- return
    return predpos, castpos, timetohit
end

local function GetPathBank(bank, unitPos, time)
    local result = {}
    local currentTime = GetTickCount()
    for i = 1, #bank do
        local p = bank[i]
        local n = Normalized(unitPos, p.pos)
        if (n ~= nil and currentTime < p.tick + time) then
            table.insert(result, {i, n})
        end
    end
    return result
end

-- COLLISION
local function IsYasuoWall()
    if (_Yasuo or _Yasuo.Wall == nil) then
        return false
    end
    if (_Yasuo.Name == nil or _Yasuo.Wall.name == nil or _Yasuo.Name ~= _Yasuo.Wall.name or _Yasuo.StartPos == nil) then
        _Yasuo.Wall = nil
        return false
    end
    return true
end

function GetCollision(source, castPos, predPos, speed, delay, radius, collisionTypes, skipID)
    source = Get2D(source)
    castPos = Get2D(castPos)
    predPos = Get2D(predPos)
    local x = 0
    if (VectorsEqual(castPos, predPos) == false) then
        local pointLine, isOnSegment = ClosestPointOnLineSegment(predPos, source, castPos)
        local d1 = GetDistance(source, pointLine)
        local d2 = GetDistance(source, castPos)
        if (d1 > d2) then
            x = d1 - d2
        end
    end
    source = Extended(source, Normalized(source, castPos), 75)
    castPos = Extended(castPos, Normalized(castPos, source), 200 + x)
    
    local isWall, collisionObjects, collisionCount = false, {}, 0
    
    local objects = {}
    local checkYasuoWall = false
    for i, colType in pairs(collisionTypes) do
        if (colType == 0) then
            for k = 1, Game.MinionCount() do
                local unit = Game.Minion(k)
                if (IsValid(unit) and unit.isEnemy and GetDistance(source, Get2D(unit.pos)) < 2000) then
                    table.insert(objects, unit)
                end
            end
        elseif (colType == 1) then
            for k, unit in pairs(GetAllyHeroes()) do
                if (unit.networkID ~= skipID and GetDistance(source, Get2D(unit.pos)) < 2000) then
                    table.insert(objects, unit)
                end
            end
        elseif (colType == 2) then
            for k, unit in pairs(GetEnemyHeroes()) do
                if (unit.networkID ~= skipID and GetDistance(source, Get2D(unit.pos)) < 2000) then
                    table.insert(objects, unit)
                end
            end
        elseif (colType == 3) then
            checkYasuoWall = true
        end
    end
    
    for i, object in pairs(objects) do
        
        local isCol = false
        local path = object.pathing
        local objectPos = Get2D(object.pos)
        local pointLine, isOnSegment = ClosestPointOnLineSegment(objectPos, source, castPos)
        if (isOnSegment and IsInRange(objectPos, pointLine, radius + ExtraCollisionRadius + object.boundingRadius)) then
            isCol = true
            
        elseif (path and path.hasMovePath) then
            objectPos = Get2D(object:GetPrediction(speed, delay))
            pointLine, isOnSegment = ClosestPointOnLineSegment(objectPos, source, castPos)
            if isOnSegment and IsInRange(objectPos, pointLine, radius + ExtraCollisionRadius + object.boundingRadius) then
                isCol = true
            end
        end
        
        if (isCol) then
            table.insert(collisionObjects, object)
            collisionCount = collisionCount + 1
        end
    end
    
    if (checkYasuoWall and IsYasuoWall()) then
        local Pos = Get2D(_Yasuo.Wall.pos)
        local ExtraWidth = 50 + ExtraCollisionRadius * 2
        local Width = ExtraWidth + 300 + 50 * _Yasuo.Level
        local Direction = Perpendicular(Normalized(Pos, _Yasuo.StartPos))
        local StartPos = Extended(Pos, Direction, Width / 2)
        local EndPos = Extended(StartPos, Direction, -Width)
        local IntersectionResult = Intersection(StartPos, EndPos, castPos, source)
        if (IntersectionResult.Intersects) then
            local t = Game.Timer() + delay + (GetDistance(IntersectionResult.Point, source) / speed)
            if t < _Yasuo.CastTime + 4 then
                isWall = true
                collisionCount = collisionCount + 1
            end
        end
    end
    return isWall, collisionObjects, collisionCount
end

local function GetPrediction(unit, source, speed, radius, delay, stype)
    local predPos, castPos, timeToHit, SubRange
    local hitChance = 0
    OnWaypoint(unit)
    local id = unit.networkID
    local unitPath = unit.pathing
    if (unitPath.hasMovePath) then
        if (GetTickCount() > _Visible[id].visibleTick + 250) then
            if (unitPath.isDashing) then
                predPos, castPos, timeToHit = GetDashingPrediction(source, speed, radius, delay, unit.ms, unitPath.dashSpeed, GetPath(unit, unitPath))
                if (predPos ~= nil) then
                    hitChance = 4
                end
            elseif (not _Attacks[id].isCloseToAttack) then
                local currentPath = GetPath(unit, unitPath)
                predPos, castPos, timeToHit = GetPredictedPosition(source, delay, speed, radius, unit.ms, stype, currentPath)
                if (predPos ~= nil) then
                    SubRange = true
                    local randomDirectionSpam = false
                    unitPos = Get2D(unit.pos)
                    local nn = Normalized(unitPos, _PosData[id].Pos)
                    if (nn) then
                        _PosData[id].Pos = unitPos
                        _PosData[id].Dir = nn
                    end
                    local bank = GetPathBank(_PathBank[id], unitPos, 400)
                    for i, p1 in pairs(bank) do
                        for j, p2 in pairs(bank) do
                            if (p1[1] ~= p2[1] and AngleBetween(p1[2], p2[2]) > 20) then
                                randomDirectionSpam = true
                                break
                            end
                        end
                    end
                    local badDirection = false
                    if (_PosData[id].Dir == nil) then
                        badDirection = true
                        --print("nil 1")
                    else
                        local n2 = Normalized(predPos, unitPos)
                        if (n2 == nil) then
                            badDirection = true
                            --print("nil 2")
                        else
                            local angle = AngleBetween(n2, _PosData[id].Dir)
                            if angle > 85 then
                                badDirection = true
                                --print(angle .. " lol")
                            end
                        end
                    end
                    if (randomDirectionSpam == false and badDirection == false) then
                        local diff = GetTickCount() - _Waypoints[id].tick
                        local op = math.min(1, radius / unit.ms / timeToHit)
                        local dist = GetDistance(castPos, Get2D(unit.pos))
                        local pathLenght = GetPathLenght(currentPath)
                        if (pathLenght > 100) then
                            local isLowHc = false
                            local isHighHc = false
                            if (stype == 0) then
                                local n1 = Normalized(Get2D(source.pos), castPos)
                                local n2 = Normalized(unitPos, castPos)
                                if (n1 and n2) then
                                    local angle = AngleBetween(n1, n2)
                                    if (angle < 15 or angle > 180 - 15) then
                                        isHighHc = true
                                    elseif (angle > 75 and angle < 180 - 75) then
                                        isLowHc = true
                                    end
                                end
                            end
                            local distToSource = GetDistance(castPos, Get2D(source.pos))
                            if (pathLenght < (unit.ms * delay) - radius) then-- or isLowHc) then
                                hitChance = 2
                                --print("normal")
                            elseif (false and #bank > 0 and op > 0.6) then
                                hitChance = 3
                                --print("high: op")
                            elseif (false and isHighHc and distToSource < 400) then
                                hitChance = 3
                                --print("high 1 angle < 15")
                            elseif (#bank > 2) then
                                hitChance = 3
                                --print("high: bank > 2")
                            elseif (diff < 100) then
                                hitChance = 3
                                --print("high: < 100")
                            elseif (diff > 750 and pathLenght > 500) then
                                hitChance = 3
                                --print("high: > 750")
                            else
                                hitChance = 2
                                --print("normal2")
                            end
                        end
                    end
                end
            end
        end
    elseif (unit.visible and GetTickCount() > _Visible[id].visibleTick + 400) then
        local duration, SpellStartTime, AttackStartTime, knockduration = GetImmobileDuration(unit)
        if (duration > 0) then
            local predTime = delay
            if (speed ~= math.huge) then
                predTime = predTime + (GetDistance(Get2D(source.pos), Get2D(unit.pos)) / speed)
            end
            local reactiontime = predTime - duration
            if (duration >= predTime or reactiontime * unit.ms < radius - 25) then
                predPos = Get2D(unit.pos)
                castPos = predPos
                timeToHit = delay + (GetDistance(predPos, Get2D(source.pos)) / speed)
                hitChance = 4
            end
        elseif (knockduration == 0) then
            local stopTimer = GetTickCount() - _Waypoints[id].stoptick
            predPos = Get2D(unit.pos)
            castPos = predPos
            timeToHit = delay + (GetDistance(predPos, Get2D(source.pos)) / speed)
            if (AttackStartTime > 0 and Game.Timer() - AttackStartTime < 0.05) then
                hitChance = 2
                hitChance = 3
            elseif (SpellStartTime > 0 and Game.Timer() - SpellStartTime < 0.05) then
                hitChance = 2
                hitChance = 3
            elseif (stopTimer > 1500) then
                hitChance = 3
            elseif (stopTimer > 1000) then
                hitChance = 2
            end
        end
    end
    return predPos, castPos, timeToHit, hitChance, SubRange
end

function GetGamsteronPrediction(unit, args, source)
    -- not valid
    if (IsValid(unit) == false) then
        return {Hitchance = 0}
    end
    -- pre pred unit data
    local prePosTo = Get2D(unit.posTo)
    local preVisible = unit.visible
    local prePath = unit.pathing
    if (prePath == nil or prePath.endPos == nil) then
        return {Hitchance = 0}
    end
    local preMovePath = prePath.hasMovePath
    local preIsdashing = prePath.isDashing
    local prePathCount = prePath.pathCount
    -- input
    local inputCollision = false
    if (args.Collision ~= nil) then
        inputCollision = args.Collision
    end
    local inputMaxCollision = 0
    if (args.MaxCollision ~= nil) then
        inputMaxCollision = args.MaxCollision
    end
    local inputCollisionTypes = {0, 3}
    if (args.CollisionTypes ~= nil) then
        inputCollisionTypes = args.CollisionTypes
    end
    local latency = _G.LATENCY > 1 and _G.LATENCY * 0.001 or _G.LATENCY
    local inputDelay = 0.06 + latency
    if (args.Delay ~= nil) then
        inputDelay = inputDelay + args.Delay
    end
    local inputRadius = 1
    if (args.Radius ~= nil) then
        inputRadius = args.Radius
    end
    local inputRange = math.huge
    if (args.Range ~= nil) then
        inputRange = args.Range
    end
    local inputSpeed = math.huge
    if (args.Speed ~= nil) then
        inputSpeed = args.Speed
    end
    local inputType = 0
    if (args.Type ~= nil) then
        inputType = args.Type
    end
    local inputRealRadius = inputRadius
    if (args.UseBoundingRadius or inputType == 0) then
        inputRealRadius = inputRadius + unit.boundingRadius
    end
    -- output
    local predPos, castPos, timeToHit, hitChance, SubRange = GetPrediction(unit, source, inputSpeed, inputRealRadius, inputDelay, inputType)
    if (hitChance == 0) then
        return {Hitchance = 0}
    end
    -- check distance
    if inputRange ~= math.huge then
        if (SubRange) then
            inputRange = inputRange * PredictionMaxRange
        end
        local mepos = Get2D(myHero.pos)
        local hepos = Get2D(unit.pos)
        if (hitChance >= 3 and IsInRange(mepos, hepos, inputRange + inputRealRadius) == false) then
            hitChance = 2
        end
        if (IsInRange(castPos, mepos, inputRange) == false) then
            return {Hitchance = 0}
        end
        local x = 0
        if (inputType == 1) then
            x = inputRadius
        end
        if (IsInRange(predPos, mepos, inputRange + x) == false) then
            return {Hitchance = 0}
        end
    end
    -- collision
    local colObjects = {}
    if (inputCollision) then
        local isWall, collisionObjects, collisionCount = GetCollision(source, castPos, predPos, inputSpeed, inputDelay, inputRadius, inputCollisionTypes, unit.networkID)
        if (isWall or collisionCount > inputMaxCollision) then
            hitChance = 1
            colObjects = collisionObjects
        end
    end
    -- post pred unit data
    local postPosTo = Get2D(unit.posTo)
    local postVisible = unit.visible
    local postPath = unit.pathing
    if (postPath == nil) then
        return {Hitchance = 0}
    end
    local postMovePath = postPath.hasMovePath
    local postIsdashing = postPath.isDashing
    local postPathCount = postPath.pathCount
    -- check pre post data
    if (VectorsEqual(prePosTo, postPosTo) == false or preVisible ~= postVisible or preMovePath ~= postMovePath or preIsdashing ~= postIsdashing or prePathCount ~= postPathCount) then
        return {Hitchance = 0}
    end
    -- linear castpos
    local castPos3D = Get3D(castPos)
    if (inputType == 0 and castPos3D:ToScreen().onScreen == false) then
        local mepos = Get2D(myHero.pos)
        castPos = Extended(mepos, Normalized(castPos, mepos), 600)
    end
    local pcast = Vector(castPos.x, unit.pos.y, castPos.z) --Get3D(castPos)
    local ppred = Vector(predPos.x, unit.pos.y, predPos.z) --Get3D(predPos)
    return {Hitchance = hitChance, CastPosition = pcast, UnitPosition = ppred, CollisionObjects = colObjects}
end
