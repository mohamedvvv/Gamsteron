
local Menu, Color, Object, Target, Buff, Damage, Health, Math
local Data = SDK.Data

SDK.Init.Orbwalker = function()
    Menu = SDK.Menu
    Color = SDK.Color
    Object = SDK.ObjectManager
    Target = SDK.TargetSelector
    Buff = SDK.BuffManager
    Damage = SDK.Damage
    Health = SDK.HealthPrediction
    Math = SDK.Math
    Data = SDK.Data
end

local Cursor, Attack, Orbwalker

Cursor =
{
    Hold = nil,
    Step = 0,
    MoveTimer = 0,
    Flash = nil,
    WndChecked = false,
    EndTime = 0,
    Pos = nil,
    CastPos = nil,
    IsHero = false,
    Targets = {},
    TargetsBool = true,
    WParam = nil,
    Msg = nil,
}

do
    function Cursor:Init
        ()
        
        self.MenuDelay = Menu.Main.CursorDelay
        self.MenuOrbwalker = Menu.Orbwalker.General
        self.MenuDrawCursor = Menu.Main.Drawings.Cursor
        self.MenuRandomHumanizer = Menu.Orbwalker.RandomHumanizer
        
        _G.Control.Hold = function(key)
            if (self.Step == 0) then
                self:New(key, nil, false)
                Orbwalker.CanHoldPosition = false
                self.MoveTimer = 0
                return true
            end
            self.Hold = {Key = key, Tick = GetTickCount()}
            return true
        end
        
        _G.Control.Evade = function(pos)
            local cPos = nil
            if self.Step > 0 and self.CastPos ~= nil then
                cPos = self.Pos
            end
            self:New(MOUSEEVENTF_RIGHTDOWN, pos, false, cPos)
            return true
        end
        
        _G.Control.Flash = function(key, pos)
            if (self.Step == 0) then
                self:New(key, pos, false)
                return true
            end
            self.Flash = {Key = key, Pos = pos, Tick = GetTickCount()}
            return true
        end
        
        _G.Control.Attack = function(target)
            if (self.Step > 0) then
                return false
            end
            local key = self.MenuOrbwalker.AttackTargetKeyUse:Value() and self.MenuOrbwalker.AttackTKey:Key() or MOUSEEVENTF_RIGHTDOWN
            self:New(key, target, false)
            if (self.MenuOrbwalker.FastKiting:Value()) then
                self.MoveTimer = 0
            end
            return true
        end
        
        _G.Control.CastSpell = function(key, a, b, c)
            if (self.Step > 0) then
                return false
            end
            local pos = self:GetControlPos(a, b, c)
            self:New(key, pos, false)
            return true
        end
        
        _G.Control.Move = function(a, b, c)
            if (self.Step > 0 or GetTickCount() < self.MoveTimer) then
                return false
            end
            self:New(MOUSEEVENTF_RIGHTDOWN, self:GetControlPos(a, b, c), true)
            return true
        end
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Cursor:OnLoad
        ()
        
        table.insert(SDK.Tick, function()
            self.Targets = {}
            self.TargetsBool = true
        end)
        
        table.insert(SDK.FastTick, function()
            self:OnTick()
        end)
        
        table.insert(SDK.Draw, function()
            if self.MenuDrawCursor:Value() then
                Draw.Circle(mousePos, 150, 2, Color.Cursor)
            end
        end)
        
        table.insert(SDK.WndMsg, function(msg, wParam)
            self:WndMsg(msg, wParam)
        end)
    end
    
    function Cursor:New
        (key, castPos, isMove, cPos)
        
        self.Step = 1
        if key == MOUSEEVENTF_RIGHTDOWN then
            self.WParam = nil
            self.Msg = WM_RBUTTONUP
        else
            self.WParam = key
            self.Msg = nil
        end
        self.IsMove = isMove
        self.Pos = cPos or cursorPos
        self.WndChecked = false
        self.EndTime = GetTickCount() + 70 + self.MenuDelay:Value()
        self.IsHero = false
        self.CastPos = castPos
        if self.CastPos ~= nil then
            self:SetToCastPos()
            if self.CastPos.type and self.CastPos.type == Obj_AI_Hero then
                self.IsHero = true
            end
        end
        
        -- PRESS KEY
        if self.IsHero then
            Control.KeyDown(_G.HK_TCO)
        end
        
        if (self.Msg) then
            Control.mouse_event(MOUSEEVENTF_RIGHTDOWN)
            Control.mouse_event(MOUSEEVENTF_RIGHTUP)
            if self.IsMove then
                self.MoveTimer = GetTickCount() + self:GetHumanizer()
                Orbwalker.CanHoldPosition = true
            end
        else
            Control.KeyDown(self.WParam)
            Control.KeyUp(self.WParam)
        end
        
        if self.IsHero then
            Control.KeyUp(_G.HK_TCO)
        end
    end
    
    function Cursor:OnTick
        ()
        local step = self.Step
        
        if (step == 0) then
            if (self.Flash) then
                if GetTickCount() > self.Flash.Tick + 300 then
                    print('FLASH TIMEOUT !')
                else
                    self:New(self.Flash.Key, self.Flash.Pos, false)
                end
                self.Flash = nil
                return
            end
            
            if (self.Hold) then
                if GetTickCount() > self.Hold.Tick + 300 then
                    print('HOLD TIMEOUT !')
                else
                    self:New(self.Hold.Key, nil, false)
                    Orbwalker.CanHoldPosition = false
                    self.MoveTimer = 0
                end
                self.Hold = nil
                return
            end
        end
        
        if (step == 1) then
            self.Step = 2
            if self.CastPos == nil then
                self.Step = 0
            else
                self:SetToCastPos()
            end
            return
        end
        
        if (step == 2) then
            if (GetTickCount() > self.EndTime) then
                self.Step = 3
                self:SetToCursor()
            elseif self.CastPos ~= nil then
                self:SetToCastPos()
            end
            return
        end
        
        if (step == 3) then
            self:SetToCursor()
            return
        end
    end
    
    function Cursor:WndMsg
        (msg, wParam)
        
        if self.Step == 0 or self.WndChecked then
            return
        end
        
        if (self.Msg and msg == self.Msg) or (self.WParam and wParam == self.WParam) then
            self.EndTime = GetTickCount() + self.MenuDelay:Value()
            self.WndChecked = true
        end
    end
    
    function Cursor:IsCursorOnTarget
        (pos)
        
        pos = Vector(pos)
        if self.TargetsBool then
            for i = 1, Game.HeroCount() do
                local unit = Game.Hero(i)
                if unit and unit.valid and not unit.isAlly and unit.alive and unit.isTargetable and unit.visible and unit.distance < 2500 then
                    table.insert(self.Targets, {unit.pos, unit.boundingRadius + 180})
                end
            end
            for i = 1, Game.MinionCount() do
                local unit = Game.Minion(i)
                if unit and unit.valid and not unit.isAlly and unit.alive and unit.isTargetable and unit.visible and unit.distance < 2500 then
                    table.insert(self.Targets, {unit.pos, unit.boundingRadius + 120})
                end
            end
            for i = 1, Game.TurretCount() do
                local unit = Game.Turret(i)
                if unit and unit.valid and not unit.isAlly and unit.alive and unit.isTargetable and unit.visible and unit.distance < 2500 then
                    table.insert(self.Targets, {unit.pos, unit.boundingRadius + 120})
                end
            end
            self.TargetsBool = false
        end
        for i = 1, #self.Targets do
            local item = self.Targets[i]
            if pos:DistanceTo(item[1]) < item[2] then
                return true
            end
        end
        return false
    end
    
    function Cursor:GetHumanizer
        ()
        
        if self.MenuRandomHumanizer.Enabled:Value() then
            local min = self.MenuRandomHumanizer.Min:Value()
            local max = self.MenuRandomHumanizer.Max:Value()
            return max <= min and min or math.random(min, max)
        end
        return self.MenuOrbwalker.MovementDelay:Value()
    end
    
    function Cursor:SetToCastPos
        ()
        
        local pos = self.CastPos.pos
        if pos then
            pos = pos:To2D()
        else
            pos = (self.CastPos.z ~= nil) and self.CastPos:To2D() or self.CastPos
        end
        Control.SetCursorPos(pos.x, pos.y)
    end
    
    function Cursor:SetToCursor
        ()
        
        Control.SetCursorPos(self.Pos.x, self.Pos.y)
        local dx = cursorPos.x - self.Pos.x
        local dy = cursorPos.y - self.Pos.y
        if (dx * dx + dy * dy < 15000) then
            self.Step = 0
        end
    end
    
    function Cursor:GetControlPos
        (a, b, c)
        
        local pos
        if (a and b and c) then
            pos = Vector(a, b, c)
        elseif (a and b) then
            pos = {x = a, y = b}
        elseif (a) then
            pos = (a.pos ~= nil) and a or Vector(a)
        end
        return pos
    end
end

Attack =
{
    TestDamage = false,
    
    TestCount = 0,
    TestStartTime = 0,
    
    SpecialWindup = Data.SpecialWindup[myHero.charName:lower()],
    
    HasLethalTempo = false,
    LethalTempoTimer = 0,
    
    AttackData =
    {
        windup = myHero.attackData.windUpTime,
        anim = myHero.attackData.animationTime,
        tickwindup = os.clock(),
        tickanim = os.clock(),
    },
    
    Reset = false,
    ServerStart = 0,
    CastEndTime = 1,
    LocalStart = 0,
    
    AttackWindup = 0,
    AttackAnimation = 0,
}

do
    function Attack:OnTick
        ()
        
        --[[
        local s = ''
        for k,v in pairs(myHero:GetSpellData(_E)) do
            s = s .. k .. ': ' .. tostring(v) .. '\n'
        end
        Draw.Text(s, myHero.pos:To2D())
    ]]
        
        if Buff:HasBuffContainsName(myHero, 'lethaltempoemp') then
            self.HasLethalTempo = true
            self.LethalTempoTimer = GetTickCount()
        elseif GetTickCount() > self.LethalTempoTimer + 1000 then
            self.HasLethalTempo = false
        end
        
        if self.AttackData.windup ~= myHero.attackData.windUpTime then
            self.AttackData.tickwindup = os.clock() + 1
            self.AttackData.windup = myHero.attackData.windUpTime
        end
        
        if self.AttackData.anim ~= myHero.attackData.animationTime then
            self.AttackData.tickanim = os.clock() + 1
            self.AttackData.anim = myHero.attackData.animationTime
        end
        
        if Data:CanResetAttack() and Orbwalker.Menu.General.AttackResetting:Value() then
            self.Reset = true
        end
        
        local spell = myHero.activeSpell
        if spell and spell.valid and spell.target > 0 and spell.castEndTime > self.CastEndTime and Data:IsAttack(spell.name) then
            -- spell.isAutoAttack then  and Game.Timer() < self.LocalStart + 0.2
            
            for i = 1, #Orbwalker.OnAttackCb do
                Orbwalker.OnAttackCb[i]()
            end
            
            self.CastEndTime = spell.castEndTime
            self.AttackWindup = spell.windup
            self.ServerStart = self.CastEndTime - self.AttackWindup
            self.AttackAnimation = spell.animation
            
            if self.TestDamage then
                if self.TestCount == 0 then
                    self.TestStartTime = Game.Timer()
                end
                self.TestCount = self.TestCount + 1
                if self.TestCount == 5 then
                    print('5 attacks in time: ' .. tostring(Game.Timer() - self.TestStartTime) .. '[sec]')
                    self.TestCount = 0
                    self.TestStartTime = 0
                end
            end
        end
    end
    
    function Attack:GetWindup
        ()
        
        if self.SpecialWindup then
            local windup = self.SpecialWindup()
            if windup then
                return windup
            end
        end
        
        if self.HasLethalTempo then
            return myHero.attackData.windUpTime
        end
        
        if os.clock() < self.AttackData.tickwindup and myHero.attackSpeed * (1 / myHero.attackData.animationTime / myHero.attackSpeed) <= 2.5 then
            return myHero.attackData.windUpTime
        end
        
        return self.AttackWindup
    end
    
    function Attack:GetAnimation
        ()
        
        if math.abs(myHero.attackData.animationTime - self.AttackAnimation) > 0.25 then
            return myHero.attackData.animationTime
        end
        
        if self.HasLethalTempo then
            --print(myHero.attackData.animationTime .. ' ' .. self.AttackAnimation)
            --print(myHero.attackSpeed * (1 / myHero.attackData.animationTime / myHero.attackSpeed))
            return myHero.attackData.animationTime
        end
        
        if os.clock() < self.AttackData.tickanim and myHero.attackSpeed * (1 / myHero.attackData.animationTime / myHero.attackSpeed) <= 2.5 then
            return myHero.attackData.animationTime
        end
        
        return self.AttackAnimation
    end
    
    function Attack:GetProjectileSpeed
        ()
        
        -- MELEE
        if Data.IsHeroMelee or (Data.IsHeroSpecialMelee and Data.IsHeroSpecialMelee()) then
            return math.huge
        end
        
        -- SPECIAL
        if Data.SpecialMissileSpeed then
            local speed = Data.SpecialMissileSpeed()
            if speed then
                return speed
            end
        end
        
        -- ATTACK DATA
        local speed = myHero.attackData.projectileSpeed
        if speed > 0 then
            return speed
        end
        
        -- MELEE
        return math.huge
    end
    
    function Attack:IsReady
        ()
        
        if self.CastEndTime > self.LocalStart then
            if self.Reset or Game.Timer() >= self.ServerStart + self:GetAnimation() - Data:GetLatency() - 0.01 then
                return true
            end
            return false
        end
        
        if Game.Timer() < self.LocalStart + 0.2 then
            return false
        end
        
        return true
    end
    
    function Attack:IsActive
        ()
        
        if self.CastEndTime > self.LocalStart then
            if Game.Timer() >= self.ServerStart + self:GetWindup() - Data:GetLatency() + 0.025 + Orbwalker.Menu.General.ExtraWindUpTime:Value() * 0.001 then
                return false
            end
            return true
        end
        
        if Game.Timer() < self.LocalStart + 0.2 then
            return true
        end
        
        return false
    end
    
    function Attack:IsBefore
        (multipier)
        
        return Game.Timer() > self.LocalStart + multipier * self:GetAnimation()
    end
end

Orbwalker =
{
    CanHoldPosition = true,
    
    PostAttackTimer = 0,
    
    IsNone = true,
    ORBWALKER_MODE_NONE = SDK.ORBWALKER_MODE_NONE,
    ORBWALKER_MODE_COMBO = SDK.ORBWALKER_MODE_COMBO,
    ORBWALKER_MODE_HARASS = SDK.ORBWALKER_MODE_HARASS,
    ORBWALKER_MODE_LANECLEAR = SDK.ORBWALKER_MODE_LANECLEAR,
    ORBWALKER_MODE_JUNGLECLEAR = SDK.ORBWALKER_MODE_JUNGLECLEAR,
    ORBWALKER_MODE_LASTHIT = SDK.ORBWALKER_MODE_LASTHIT,
    ORBWALKER_MODE_FLEE = SDK.ORBWALKER_MODE_FLEE,
    
    OnPreAttackCb = {},
    OnPostAttackCb = {},
    OnPostAttackTickCb = {},
    OnAttackCb = {},
    OnMoveCb = {},
}

do
    function Orbwalker:Init
        ()
        
        self.Menu = Menu.Orbwalker
        self.MenuDrawings = Menu.Main.Drawings
        self.HoldPositionButton = Menu.Orbwalker.Keys.HoldKey
        
        self.MenuKeys =
        {
            [self.ORBWALKER_MODE_COMBO] = {},
            [self.ORBWALKER_MODE_HARASS] = {},
            [self.ORBWALKER_MODE_LANECLEAR] = {},
            [self.ORBWALKER_MODE_JUNGLECLEAR] = {},
            [self.ORBWALKER_MODE_LASTHIT] = {},
            [self.ORBWALKER_MODE_FLEE] = {},
        }
        
        self.Modes =
        {
            [self.ORBWALKER_MODE_COMBO] = false,
            [self.ORBWALKER_MODE_HARASS] = false,
            [self.ORBWALKER_MODE_LANECLEAR] = false,
            [self.ORBWALKER_MODE_JUNGLECLEAR] = false,
            [self.ORBWALKER_MODE_LASTHIT] = false,
            [self.ORBWALKER_MODE_FLEE] = false,
        }
        
        self:RegisterMenuKey(self.ORBWALKER_MODE_COMBO, self.Menu.Keys.Combo)
        self:RegisterMenuKey(self.ORBWALKER_MODE_HARASS, self.Menu.Keys.Harass)
        self:RegisterMenuKey(self.ORBWALKER_MODE_LASTHIT, self.Menu.Keys.LastHit)
        self:RegisterMenuKey(self.ORBWALKER_MODE_LANECLEAR, self.Menu.Keys.LaneClear)
        self:RegisterMenuKey(self.ORBWALKER_MODE_JUNGLECLEAR, self.Menu.Keys.Jungle)
        self:RegisterMenuKey(self.ORBWALKER_MODE_FLEE, self.Menu.Keys.Flee)
        
        self.ForceMovement = nil
        self.ForceTarget = nil
        
        self.PostAttackBool = false
        self.AttackEnabled = true
        self.MovementEnabled = true
        self.CanAttackC = function() return true end
        self.CanMoveC = function() return true end
        
        table.insert(SDK.Load, function()
            self:OnLoad()
        end)
    end
    
    function Orbwalker:OnLoad
        ()
        
        table.insert(SDK.Draw, function()
            
            if self.MenuDrawings.Range:Value() then
                Draw.Circle(myHero.pos, Data:GetAutoAttackRange(myHero), 2, Color.Range)
            end
            
            if self.MenuDrawings.HoldRadius:Value() then
                Draw.Circle(myHero.pos, self.Menu.General.HoldRadius:Value(), 1, Color.LightGreen)
            end
            
            if self.MenuDrawings.EnemyRange:Value() then
                local t = Object:GetEnemyHeroes(false, false, true, false, false)
                for i = 1, #t do
                    local enemy = t[i]
                    local range = Data:GetAutoAttackRange(enemy, myHero)
                    Draw.Circle(enemy.pos, range, 2, Math:IsInRange(enemy, myHero, range) and Color.EnemyRange or Color.Range)
                end
            end
        end)
        
        table.insert(SDK.FastTick, function()
            Attack:OnTick()
            
            self.IsNone = self:HasMode(self.ORBWALKER_MODE_NONE)
            self.Modes = self:GetModes()
            
            if Cursor.Step > 0 then
                return
            end
            
            if Data:Stop() then
                return
            end
            
            Health:OnTick()
            
            if self.IsNone then
                return
            end
            
            self:Orbwalk()
        end)
    end
    
    function Orbwalker:RegisterMenuKey
        (mode, key)
        --
        table.insert(self.MenuKeys[mode], key)
    end
    
    function Orbwalker:GetModes
        ()
        return {
            [self.ORBWALKER_MODE_COMBO] = self:HasMode(self.ORBWALKER_MODE_COMBO),
            [self.ORBWALKER_MODE_HARASS] = self:HasMode(self.ORBWALKER_MODE_HARASS),
            [self.ORBWALKER_MODE_LANECLEAR] = self:HasMode(self.ORBWALKER_MODE_LANECLEAR),
            [self.ORBWALKER_MODE_JUNGLECLEAR] = self:HasMode(self.ORBWALKER_MODE_JUNGLECLEAR),
            [self.ORBWALKER_MODE_LASTHIT] = self:HasMode(self.ORBWALKER_MODE_LASTHIT),
            [self.ORBWALKER_MODE_FLEE] = self:HasMode(self.ORBWALKER_MODE_FLEE),
        }
    end
    
    function Orbwalker:HasMode
        (mode)
        if mode == self.ORBWALKER_MODE_NONE then
            for _, value in pairs(self:GetModes()) do
                if value then
                    return false
                end
            end
            return true
        end
        for i = 1, #self.MenuKeys[mode] do
            local key = self.MenuKeys[mode][i]
            if key:Value() then
                return true
            end
        end
        return false
    end
    
    function Orbwalker:OnPreAttack
        (func)
        table.insert(self.OnPreAttackCb, func)
    end
    
    function Orbwalker:OnPostAttack
        (func)
        table.insert(self.OnPostAttackCb, func)
    end
    
    function Orbwalker:OnPostAttackTick
        (func)
        table.insert(self.OnPostAttackTickCb, func)
    end
    
    function Orbwalker:OnAttack
        (func)
        table.insert(self.OnAttackCb, func)
    end
    
    function Orbwalker:OnPreMovement
        (func)
        table.insert(self.OnMoveCb, func)
    end
    
    function Orbwalker:CanAttackEvent
        (func)
        self.CanAttackC = func
    end
    
    function Orbwalker:CanMoveEvent
        (func)
        self.CanMoveC = func
    end
    
    function Orbwalker:__OnAutoAttackReset
        ()
        Attack.Reset = true
    end
    
    function Orbwalker:SetMovement
        (boolean)
        self.MovementEnabled = boolean
    end
    
    function Orbwalker:SetAttack
        (boolean)
        self.AttackEnabled = boolean
    end
    
    function Orbwalker:IsEnabled
        ()
        return true
    end
    
    function Orbwalker:IsAutoAttacking
        (unit)
        
        if unit == nil or unit.isMe then
            return Attack:IsActive()
        end
        
        return Game.Timer() < unit.attackData.endTime - unit.attackData.windDownTime
    end
    
    function Orbwalker:CanMove
        (unit)
        
        if unit == nil or unit.isMe then
            if not self.CanMoveC() then
                return false
            end
            if (JustEvade and (not JustEvade.Evading or JustEvade.Evading())) or (ExtLibEvade and ExtLibEvade.Evading) then
                return false
            end
            if myHero.charName == 'Kalista' then
                return true
            end
            if not Data:HeroCanMove() then
                return false
            end
            return not Attack:IsActive()
        end
        
        local attackData = unit.attackData
        return Game.Timer() > attackData.endTime - attackData.windDownTime
    end
    
    function Orbwalker:CanAttack
        (unit)
        
        if unit == nil or unit.isMe then
            if not self.CanAttackC() then
                return false
            end
            if (JustEvade and (not JustEvade.Evading or JustEvade.Evading())) or (ExtLibEvade and ExtLibEvade.Evading) then
                return false
            end
            if not Data:HeroCanAttack() then
                return false
            end
            return Attack:IsReady()
        end
        
        local attackData = unit.attackData
        return Game.Timer() > attackData.endTime
    end
    
    function Orbwalker:GetTarget
        ()
        
        if Object:IsValid(self.ForceTarget, Obj_AI_Hero, true, true, true) then
            return self.ForceTarget
        end
        
        if self.Modes[self.ORBWALKER_MODE_COMBO] then
            return Target:GetComboTarget()
        end
        
        if self.Modes[self.ORBWALKER_MODE_LASTHIT] then
            return Health:GetLastHitTarget()
        end
        
        if self.Modes[self.ORBWALKER_MODE_JUNGLECLEAR] then
            local jungle = Health:GetJungleTarget()
            if jungle ~= nil then
                return jungle
            end
        end
        
        if self.Modes[self.ORBWALKER_MODE_LANECLEAR] then
            return Health:GetLaneClearTarget()
        end
        
        if self.Modes[self.ORBWALKER_MODE_HARASS] then
            return Health:GetHarassTarget()
        end
        
        return nil
    end
    
    function Orbwalker:MeleeLogic
        ()
        local process, position, aarange, aatarget, aatarget150, mePos, hepos, distance, direction
        
        process = true
        position = nil
        aarange = myHero.range + myHero.boundingRadius - 35
        
        aatarget = Target:GetTarget(Object:GetEnemyHeroes(aarange, true, true, true, true), Damage.DAMAGE_TYPE_PHYSICAL)
        
        if aatarget == nil then
            return process, position
        end
        
        aatarget150 = Target:GetTarget(Object:GetEnemyHeroes(aarange + 150, true, true, true, true), Damage.DAMAGE_TYPE_PHYSICAL)
        
        if aatarget150 ~= nil then
            aatarget = aatarget150
        end
        
        distance = aatarget.distance
        if (distance < aatarget.boundingRadius + 30) then
            if self.CanHoldPosition then
                Control.Hold(self.HoldPositionButton:Key())
            end
            return false, nil
        end
        
        mePos = myHero.pos
        hepos = aatarget.pos
        direction = (hepos - mePos):Normalized()
        position = hepos + direction * 200
        
        local i = 0
        while (Cursor:IsCursorOnTarget(position)) do
            i = i + 50
            position = hepos + direction * i
        end
        
        return process, position
    end
    
    function Orbwalker:OnUnkillableMinion
        (cb)
        table.insert(Health.OnUnkillableMinionCallbacks, cb);
    end
    
    function Orbwalker:Attack
        (unit)
        
        if self.AttackEnabled and unit ~= nil and unit.pos ~= nil and unit.pos:ToScreen().onScreen and self:CanAttack() then
            local args = {Target = unit, Process = true}
            
            for i = 1, #self.OnPreAttackCb do
                self.OnPreAttackCb[i](args)
            end
            
            if args.Process then
                if args.Target and Control.Attack(args.Target) then
                    Attack.Reset = false
                    Attack.LocalStart = Game.Timer()
                    self.PostAttackBool = true
                end
                return true
            end
        end
        
        return false
    end
    
    function Orbwalker:Move
        ()
        
        if self.MovementEnabled and self:CanMove() then
            if self.PostAttackBool then
                for i = 1, #self.OnPostAttackCb do
                    self.OnPostAttackCb[i]()
                end
                self.PostAttackTimer = Game.Timer()
                self.PostAttackBool = false
            end
            
            if Game.Timer() < self.PostAttackTimer + 0.15 then
                for i = 1, #self.OnPostAttackTickCb do
                    self.OnPostAttackTickCb[i]()
                end
            end
            
            local mePos = myHero.pos
            if Math:IsInRange(mePos, _G.mousePos, self.Menu.General.HoldRadius:Value()) then
                if self.CanHoldPosition then
                    Control.Hold(self.HoldPositionButton:Key())
                end
                return
            end
            
            if GetTickCount() > Cursor.MoveTimer then
                local args = {Target = nil, Process = true}
                
                for i = 1, #self.OnMoveCb do
                    self.OnMoveCb[i](args)
                end
                
                if not args.Process then
                    return
                end
                
                if self.ForceMovement ~= nil then
                    Control.Move(self.ForceMovement)
                    return
                end
                
                if args.Target == nil then
                    if self.Menu.General.StickToTarget:Value() and Data:IsMelee() and myHero.range < 450 then
                        local process, meleepos = self:MeleeLogic()
                        if not process then
                            return
                        end
                        Control.Move(meleepos)
                        return
                    end
                else
                    if args.Target.x then
                        args.Target = Vector(args.Target)
                    elseif args.Target.pos then
                        args.Target = args.Target.pos
                    end
                    Control.Move(args.Target)
                    return
                end
                
                local pos = Math:IsInRange(mePos, mousePos, 100) and mePos:Extend(mousePos, 100) or nil
                
                if self.Menu.General.SkipTargets:Value() then
                    local i = 0
                    local mPos = pos or mousePos
                    local dir = (mPos - mePos):Normalized()
                    
                    while (Cursor:IsCursorOnTarget(mPos)) do
                        i = i + 50
                        mPos = mPos + dir * i
                        pos = mPos
                    end
                end
                
                Control.Move(pos)
                
            end
        end
    end
    
    function Orbwalker:Orbwalk
        ()
        
        if not self:Attack(self:GetTarget()) then
            self:Move()
        end
    end
end

SDK.Cursor = Cursor
SDK.Attack = Attack
SDK.Orbwalker = Orbwalker
