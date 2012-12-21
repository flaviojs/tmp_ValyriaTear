------------------------------------------------------------------------------[[
-- Filename: layna_forest_crystal_appearance_anim.lua
--
-- Description: Display an image of the stone sign text, in the actual
-- scripture seen by the characters for 5 seconds with fade in/out.
------------------------------------------------------------------------------]]

local ns = {}
setmetatable(ns, {__index = _G})
layna_forest_crystal_appearance_anim = ns;
setfenv(1, ns);

local crystal_shadow_id = 0;
local lightning1_id = 0;
local lightning2_id = 0;
local lightning3_id = 0;
local vortex_id = 0;

local display_time = 0;

local lightning_time = 0;
local lightning1_triggered = false;
local lightning2_triggered = false;
local lightning3_triggered = false;
local lightning4_triggered = false;
local lightning5_triggered = false;
local lightning6_triggered = false;
local lightning7_triggered = false;
local lightning8_triggered = false;
local lightning9_triggered = false;

local tremor_triggered = false;

function Initialize(map_instance)
    Map = map_instance;

    Script = Map:GetScriptSupervisor();
    Effects = Map:GetEffectSupervisor();

    crystal_shadow_id = Script:AddImage("dat/maps/layna_forest/crystal_appearance/crystal_shadow.png", 20.0, 31.0);

    lightning1_id = Script:AddImage("dat/maps/layna_forest/crystal_appearance/blue_lightning1.png", 248.0, 400.0);
    lightning2_id = Script:AddImage("dat/maps/layna_forest/crystal_appearance/blue_lightning2.png", 118.0, 400.0);
    lightning3_id = Script:AddImage("dat/maps/layna_forest/crystal_appearance/blue_lightning3.png", 171.0, 400.0);

    vortex_id = Script:AddImage("dat/maps/layna_forest/crystal_appearance/vortex.png", 386.0, 207.0);

    display_time = 0;
end

function Update()
    -- Only show the image if requested by the events
    if (GlobalManager:DoesEventExist("story", "layna_forest_crystal_appearance") == false) then
        return;
    end

    if (GlobalManager:GetEventValue("story", "layna_forest_crystal_appearance") == 0) then
        return;
    end

    local time_expired = SystemManager:GetUpdateTime();

    -- Handle the timer
    display_time = display_time + time_expired;
    lightning_time = lightning_time + time_expired;

    -- Start the timer
    if (display_time > 15000) then
        display_time = 0;
        -- Disable the event at the end of it
        GlobalManager:SetEventValue("story", "layna_forest_crystal_appearance", 0);
    end

    if (tremor_triggered == false and display_time >= 2000) then
        -- Trigger a tremor
        VideoManager:ShakeScreen(0.6, 13000, hoa_video.GameVideo.VIDEO_FALLOFF_GRADUAL);
        AudioManager:PlaySound("snd/rumble.wav");

        -- Fade out the "music"
        AudioManager:FadeOutAllMusic(2000);

        -- trigger also the particle effect
        Map:GetParticleManager():AddParticleEffect("dat/effects/particles/crystal_appearance.lua", 512.0, 282.0);

        tremor_triggered = true;
    end

end

-- Draw the lightning effects
function _DrawLightnings()
    -- trigger the lightnings
    if (lightning_time >= 2000 and lightning_time <= 2300) then
        Script:DrawImage(lightning1_id, 470, 282.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning1_triggered == false) then
            lightning1_triggered = true;
            AudioManager:PlaySound("snd/lightning.wav");
        end
    end

    if (lightning_time >= 3000 and lightning_time <= 3300) then
        Script:DrawImage(lightning2_id, 550, 282.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning2_triggered == false) then
            lightning2_triggered = true;
            AudioManager:PlaySound("snd/thunder.wav");
        end
    end

    if (lightning_time >= 3500 and lightning_time <= 3800) then
        Script:DrawImage(lightning3_id, 500, 280.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning3_triggered == false) then
            lightning3_triggered = true;
            AudioManager:PlaySound("snd/lightning.wav");
        end
    end

    if (lightning_time >= 4000 and lightning_time <= 4300) then
        Script:DrawImage(lightning2_id, 490, 278.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning4_triggered == false) then
            lightning4_triggered = true;
            AudioManager:PlaySound("snd/thunder.wav");
        end
    end

    if (lightning_time >= 4200 and lightning_time <= 4500) then
        Script:DrawImage(lightning1_id, 570, 284.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning5_triggered == false) then
            lightning5_triggered = true;
            AudioManager:PlaySound("snd/lightning.wav");
        end
    end

    if (lightning_time >= 4400 and lightning_time <= 4700) then
        Script:DrawImage(lightning3_id, 400, 280.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning6_triggered == false) then
            lightning6_triggered = true;
            AudioManager:PlaySound("snd/lightning.wav");
        end
    end

    if (lightning_time >= 4800 and lightning_time <= 5200) then
        Script:DrawImage(lightning2_id, 520, 278.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning7_triggered == false) then
            lightning7_triggered = true;
            AudioManager:PlaySound("snd/thunder.wav");
        end
    end

    if (lightning_time >= 5000 and lightning_time <= 5300) then
        Script:DrawImage(lightning1_id, 480, 280.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning8_triggered == false) then
            lightning8_triggered = true;
            AudioManager:PlaySound("snd/lightning.wav");
        end
    end

    if (lightning_time >= 5200 and lightning_time <= 5400) then
        Script:DrawImage(lightning2_id, 530, 284.0, hoa_video.Color(1.0, 1.0, 1.0, 1.0));
        if (lightning9_triggered == false) then
            lightning9_triggered = true;
            AudioManager:PlaySound("snd/thunder.wav");
        end
    elseif (lightning_time > 5400) then
        -- loop the last lightnings until the effect is gone
        lightning_time = 4000;
        lightning4_triggered = false;
        lightning5_triggered = false;
        lightning6_triggered = false;
        lightning7_triggered = false;
        lightning8_triggered = false;
        lightning9_triggered = false;
    end
end

function DrawPostEffects()
    -- Only show the image if requested by the events
    if (GlobalManager:DoesEventExist("story", "layna_forest_crystal_appearance") == false) then
        return;
    end

    if (GlobalManager:GetEventValue("story", "layna_forest_crystal_appearance") == 0) then
        return;
    end

    _DrawLightnings();

    -- Apply a dark overlay first.
    local overlay_alpha = 0.8;
    if (display_time >= 0 and display_time <= 2500) then
		overlay_alpha = 0.8 * (display_time / 2500);
        Map:GetEffectSupervisor():EnableLightingOverlay(hoa_video.Color(0.0, 0.0, 0.0, overlay_alpha));
    elseif (display_time > 2500 and display_time <= 6500) then
        overlay_alpha = 0.8;
        Map:GetEffectSupervisor():EnableLightingOverlay(hoa_video.Color(0.0, 0.0, 0.0, overlay_alpha));
    elseif (display_time > 6500 and display_time <= 8000) then
        overlay_alpha = 0.8 - (display_time - 6500) / (8000 - 6500);
        Map:GetEffectSupervisor():EnableLightingOverlay(hoa_video.Color(0.0, 0.0, 0.0, overlay_alpha));
    elseif (overlay_alpha > 0.0 and display_time > 8000) then
        overlay_alpha = 0.0;
        Map:GetEffectSupervisor():DisableLightingOverlay();
    end

    -- Then show the vortex
    -- TODO: Show the vortex particle effect.
    local vortex_alpha = 0.0;
    local crystal_alpha = 0.0;
    if (display_time >= 4000 and display_time <= 5000) then
		vortex_alpha = 0.2 * (display_time - 4000) / (5000 - 4000);
        crystal_alpha = (display_time - 4000) / (5000 - 4000);
        Script:DrawImage(vortex_id, 532, 384.0, hoa_video.Color(1.0, 1.0, 1.0, vortex_alpha));
        Script:DrawImage(crystal_shadow_id, 512, 280.0, hoa_video.Color(1.0, 1.0, 1.0, crystal_alpha));
    elseif (display_time > 5000 and display_time <= 6500) then
        vortex_alpha = 0.2;
        crystal_alpha = 1.0;
        Script:DrawImage(vortex_id, 532, 384.0, hoa_video.Color(1.0, 1.0, 1.0, vortex_alpha));
        Script:DrawImage(crystal_shadow_id, 512, 280.0, hoa_video.Color(1.0, 1.0, 1.0, crystal_alpha));
    elseif (display_time > 6500 and display_time <= 10600) then
        vortex_alpha = 0.2 - 0.2 * (display_time - 6500) / (10600 - 6500);
        crystal_alpha = 1.0 - (display_time - 6500) / (10600 - 6500);
        Script:DrawImage(vortex_id, 532, 384.0, hoa_video.Color(1.0, 1.0, 1.0, vortex_alpha));
        Script:DrawImage(crystal_shadow_id, 512, 280.0, hoa_video.Color(1.0, 1.0, 1.0, crystal_alpha));
    elseif (vortex_alpha > 0.0 and display_time > 10600) then
        vortex_alpha = 0.0;
        crystal_alpha = 0.0;
    end


    -- Then apply a white flash
    local flash_alpha = 0.0;
    if (display_time >= 8000 and display_time <= 8500) then
		flash_alpha = 1.0 * (display_time - 8000) / (8500 - 8000);
        Map:GetEffectSupervisor():EnableLightingOverlay(hoa_video.Color(1.0, 1.0, 1.0, flash_alpha));
    elseif (display_time > 8500 and display_time <= 11000) then
        flash_alpha = 1.0;
        Map:GetEffectSupervisor():EnableLightingOverlay(hoa_video.Color(1.0, 1.0, 1.0, flash_alpha));
    elseif (display_time > 11000 and display_time <= 15000) then
        flash_alpha = 1.0 - (display_time - 11000) / (15000 - 11000);
        Map:GetEffectSupervisor():EnableLightingOverlay(hoa_video.Color(1.0, 1.0, 1.0, flash_alpha));
    elseif (flash_alpha > -1.0 and display_time > 15000) then
        flash_alpha = -1.0;
        Map:GetEffectSupervisor():DisableLightingOverlay();
        Map:GetParticleManager():StopAll(false);
    end

end