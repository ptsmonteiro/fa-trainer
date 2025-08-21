-- scenarios.lua
-- Scenario definitions for Failure Management Trainer

-- This file should be loaded with dofile or require from the main script.

scenarios = {
    {
        {
            phase = phases.takeoff,
            failure = pick_random({failures.sys_5_aft_cargo_fire, failures.sys_5_aft_crg_fire_e})
        },
        {
            phase = phases.climb,
            failure = pick_random({failures.sys_2_fmgc_1, failures.sys_2_fmgc_1_r})
        },
    },
}
