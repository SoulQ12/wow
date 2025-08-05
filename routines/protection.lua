local Tinkr = ...
local Routine = Tinkr.Routine

-- An example solo/farming Protection Paladin routine.
-- Once automatically loaded, enable in-game with
-- /routine load protex

Routine:RegisterRoutine(function()
    -- don't spam in the GCD
    if gcd() > latency() then return end

    -- don't dismount us
    if mounted() then return end

    -- Zoom Zoom
    if not combat() and mounted() and not buff(CrusaderAura) then
        return cast(CrusaderAura)
    end

    -- Doom Doom
    if combat() and not buff(DevotionAura) then
        return cast(DevotionAura)
    end

    -- don't spam on nothing
    if not UnitExists(target) then return end

    -- don't spam on friendly or other
    if not UnitCanAttack(player, target) then return end

    -- don't start combat
    if not combat() then return end
    local hp = power(PowerType.HolyPower)

    -- you no cast!
    kickNameplate(HammerOfJustice, true)
    kickNameplate(Rebuke, true)
    kickNameplate(AvengersShield, true)

    if IsAltKeyDown() and castable(AshenHallow, target) then
        return cast(AshenHallow, target)
    end

    -- Survival
    if buff(ShiningLightProc) and castable(WordOfGlory) and health() <= 85 then
        return cast(WordOfGlory)
    end

    if health() <= 25 and castable(ArdentDefender) then
        return cast(ArdentDefender)
    end

    if solo() and health() <= 20 and castable(DivineShield) then
        return cast(DivineShield)
    end

    if solo() and hp < 3 and health() <= 70 and castable(WordOfGlory) then
        return cast(WordOfGlory)
    end

    if solo() and health() <= 45 and castable(WordOfGlory) then
        return cast(WordOfGlory)
    end

    if not solo() and health() <= 35 and castable(WordOfGlory) then
        return cast(WordOfGlory)
    end

    if hp == 3 and health() <= 75 and castable(ShieldOfTheRighteous) then
        cast(ShieldOfTheRighteous)
    end

    if hp == 4 and health() <= 85 and castable(ShieldOfTheRighteous) then
        cast(ShieldOfTheRighteous)
    end

    if hp == 5 and castable(ShieldOfTheRighteous) then
        cast(ShieldOfTheRighteous)
    end

    if not IsPlayerMoving() and not buff(Consecration) and castable(Consecration) then
        return cast(Consecration)
    end

    if castable(Judgment) and hp < 5 then
        return cast(Judgment)
    end

    if castable(HammerOfWrath)  and hp < 5 then
        return cast(HammerOfWrath)
    end

    if castable(AvengersShield) and hp < 5  then
        return cast(AvengersShield)
    end

    if castable(HammerOfTheRighteous) and hp < 5 then
        return cast(HammerOfTheRighteous)
    end

    if not IsPlayerMoving() and castable(Consecration) then
        return cast(Consecration)
    end
end, Routine.Classes.Paladin, 'protex')
