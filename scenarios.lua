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
    {
        {
            phase = phases.takeoff,
            failure = pick_random({
                failures.sys_7_slat_lk_at_0,
                failures.sys_7_slat_lk_btwn_0_1,
                failures.sys_7_slat_lk_btwn_1_2,
                failures.sys_7_slat_lk_btwn_3_4,
                failures.sys_7_flap_lk_btwn_0_1,
                failures.sys_7_flap_lk_btwn_1_2,
                failures.sys_7_flap_lk_btwn_2_3
            })
        },
    },
    {
        {
            phase = phases.climb,
            failure = pick_random({
                failures.sys_2_fmgc_1, failures.sys_2_fmgc_1_r
            })
        },
        {
            phase = phases.climb,
            failure = pick_random({
                failures.sys_2_fmgc_2, failures.sys_2_fmgc_2_r
            })
        },
    },
    {
        {
            phase = phases.ground,
            failure = failures.sys_6_fcdc_2_fail
        },
        {
            phase = phases.climb,
            failure = failures.sys_4_dc_bus_ess
        },
    },

}
