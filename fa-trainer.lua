do_often('run_loop()')

--[[
    Failure Management Trainer Script
    ---------------------------------
    This script manages random failure scenarios for X-Plane using FlyWithLua.
    It defines failure types, flight phases, scenario logic, and triggers failures based on flight datarefs.
--]]

print("Failure Management Trainer script running.")

-- Seed the random number generator for different results each run
math.randomseed(os.time())

-- =========================
-- Constants and Thresholds
-- =========================
TAXI_GROUND_SPEED_THRESHOLD = 0.5144 -- 30 knots
VERTICAL_SPEED_THRESHOLD = 0.508 -- 100 ft/min
LANDING_TAKEOFF_AGL_THRESHOLD = 15.24

-- =========================
-- Failure Index Table
-- =========================
failures = {
    -- ...existing code for failures table...
    sys_1_cpc_1 = 0,
    sys_1_cpc_1_r = 1,
    sys_1_cpc_2 = 2,
    sys_1_cpc_2_r = 3,
    sys_1_pack_1 = 4,
    sys_1_pack_2 = 5,
    sys_1_pack_1_main_ctl = 6,
    sys_1_pack_1_sec_ctl = 7,
    sys_1_pack_2_main_ctl = 8,
    sys_1_pack_2_sec_ctl = 9,
    sys_1_cabin_fan_1 = 10,
    sys_1_cabin_fan_2 = 11,
    sys_1_vent_ctl = 12,
    sys_1_vent_ctl_r = 13,
    sys_1_zone_ctl_ch_1 = 14,
    sys_1_zone_ctl_ch1_r = 15,
    sys_1_zone_ctl_ch_2 = 16,
    sys_1_zone_ctl_ch2_r = 17,
    sys_1_slow_decompr = 18,
    sys_1_explosive_decomp = 19,
    sys_2_fmgc_1 = 20,
    sys_2_fmgc_1_r = 21,
    sys_2_fmgc_2 = 22,
    sys_2_fmgc_2_r = 23,
    sys_2_fac_1 = 24,
    sys_2_fac_1_r = 25,
    sys_2_fac_2 = 26,
    sys_2_fac_2_r = 27,
    sys_2_mcdu_1 = 28,
    sys_2_mcdu_2 = 29,
    sys_2_fcu_1_fail = 30,
    sys_2_fcu_1_fail_r = 31,
    sys_2_fcu_2_fail = 32,
    sys_2_fcu_2_fail_r = 33,
    sys_2_yaw_damp_1_fail = 34,
    sys_2_yaw_damp_2_fail = 35,
    sys_2_rtl_1_fail = 36,
    sys_2_rtl_2_fail = 37,
    sys_2_rud_trim_1_fail = 38,
    sys_2_rud_trim_2_fail = 39,
    sys_2_w_s_tail = 40,
    sys_2_w_s_vert = 41,
    sys_2_w_s_comb = 42,
    sys_2_w_s_in_5nm = 43,
    sys_2_w_s_in_2nm = 44,
    sys_3_rmp_1 = 45,
    sys_3_rmp_2 = 46,
    sys_3_rmp_3 = 47,
    sys_3_vhf_1 = 48,
    sys_3_vhf_2 = 49,
    sys_3_atsu_fail = 50,
    sys_3_atsu_fail_r = 51,
    sys_3_cids_1_fail = 52,
    sys_3_cids_1_fail_r = 53,
    sys_3_cids_2_fail = 54,
    sys_3_cids_2_fail_r = 55,
    sys_4_ac_bus_1 = 56,
    sys_4_ac_bus_2 = 57,
    sys_4_ac_bus_ess = 58,
    sys_4_dc_bus_1 = 59,
    sys_4_dc_bus_2 = 60,
    sys_4_dc_bus_ess = 61,
    sys_4_bat_1 = 62,
    sys_4_bat_2 = 63,
    sys_4_tru_1 = 64,
    sys_4_tru_2 = 65,
    sys_4_tru_ess = 66,
    sys_4_l_eng_gen = 67,
    sys_4_l_eng_gen_r = 68,
    sys_4_r_eng_gen = 69,
    sys_4_r_eng_gen_r = 70,
    sys_4_apu_gen = 71,
    sys_4_apu_gen_r = 72,
    sys_5_sdcu_1_fail = 73,
    sys_5_sdcu_1_fail_r = 74,
    sys_5_sdcu_2_fail = 75,
    sys_5_sdcu_2_fail_r = 76,
    sys_5_fwd_cargo_fire = 77,
    sys_5_fwd_crg_fire_e = 78,
    sys_5_aft_cargo_fire = 79,
    sys_5_aft_crg_fire_e = 80,
    sys_6_l_ail_fail = 81,
    sys_6_l_ail_jam = 82,
    sys_6_r_ail_fail = 83,
    sys_6_r_ail_jam = 84,
    sys_6_l_elev_fail = 85,
    sys_6_l_elev_jam = 86,
    sys_6_r_elev_fail = 87,
    sys_6_r_elev_jam = 88,
    sys_6_ths_jam = 89,
    sys_6_elac_1_fail = 90,
    sys_6_elac_1_fail_r = 91,
    sys_6_elac_2_fail = 92,
    sys_6_elac_2_fail_r = 93,
    sys_6_sec_1_fail = 94,
    sys_6_sec_1_fail_r = 95,
    sys_6_sec_2_fail = 96,
    sys_6_sec_2_fail_r = 97,
    sys_6_sec_3_fail = 98,
    sys_6_sec_3_fail_r = 99,
    sys_6_fcdc_1_fail = 100,
    sys_6_fcdc_1_fail_r = 101,
    sys_6_fcdc_2_fail = 102,
    sys_6_fcdc_2_fail_r = 103,
    sys_7_sfcc_1s_fail = 104,
    sys_7_sfcc_1s_fail_r = 105,
    sys_7_sfcc_1f_fail = 106,
    sys_7_sfcc_1f_fail_r = 107,
    sys_7_sfcc_2s_fail = 108,
    sys_7_sfcc_2s_fail_r = 109,
    sys_7_sfcc_2f_fail = 110,
    sys_7_sfcc_2f_fail_r = 111,
    sys_7_slat_lk_at_0 = 112,
    sys_7_slat_lk_btwn_0_1 = 113,
    sys_7_slat_lk_btwn_1_2 = 114,
    sys_7_slat_lk_btwn_3_4 = 115,
    sys_7_flap_lk_btwn_0_1 = 116,
    sys_7_flap_lk_btwn_1_2 = 117,
    sys_7_flap_lk_btwn_2_3 = 118,
    sys_8_fqi_1_fault = 119,
    sys_8_fqi_1_fault_r = 120,
    sys_8_fqi_2_fault = 121,
    sys_8_fqi_2_fault_r = 122,
    sys_8_l_pmp_1_fail = 123,
    sys_8_l_pmp_2_fail = 124,
    sys_8_ctr_pmp_l_fail = 125,
    sys_8_ctr_pmp_r_fail = 126,
    sys_8_r_pmp_1_fail = 127,
    sys_8_r_pmp_2_fail = 128,
    sys_8_lhs_fuel_leak = 129,
    sys_8_rhs_fuel_leak = 130,
    sys_9_g_hyd_pump_fail = 131,
    sys_9_y_hyd_pump_fail = 132,
    sys_9_b_hyd_pump_fail = 133,
    sys_9_y_elec_pmp_fail = 134,
    sys_9_g_hyd_sys_leak = 135,
    sys_9_y_hyd_sys_leak = 136,
    sys_9_b_hyd_sys_leak = 137,
    sys_9_g_hyd_sys_ovht = 138,
    sys_9_y_hyd_sys_ovht = 139,
    sys_9_b_hyd_sys_ovht = 140,
    sys_10_whc_1_fail = 141,
    sys_10_whc_1_fail_r = 142,
    sys_10_whc_2_fail = 143,
    sys_10_whc_2_fail_r = 144,
    sys_10_phc_1_fail = 145,
    sys_10_phc_1_fail_r = 146,
    sys_10_phc_2_fail = 147,
    sys_10_phc_2_fail_r = 148,
    sys_10_phc_3_fail = 149,
    sys_10_phc_3_fail_r = 150,
    sys_11_l_pfd_fail = 151,
    sys_11_l_nd_fail = 152,
    sys_11_r_pfd_fail = 153,
    sys_11_r_nd_fail = 154,
    sys_11_upper_ecam_fail = 155,
    sys_11_lower_ecam_fail = 156,
    sys_11_fwc_1_fail = 157,
    sys_11_fwc_1_fail_r = 158,
    sys_11_fwc_2_fail = 159,
    sys_11_fwc_2_fail_r = 160,
    sys_11_sdac_1_fail = 161,
    sys_11_sdac_1_fail_r = 162,
    sys_11_sdac_2_fail = 163,
    sys_11_sdac_2_fail_r = 164,
    sys_11_dmc_1_fail = 165,
    sys_11_dmc_1_fail_r = 166,
    sys_11_dmc_2_fail = 167,
    sys_11_dmc_2_fail_r = 168,
    sys_11_dmc_3_fail = 169,
    sys_11_dmc_3_fail_r = 170,
    sys_12_lgciu_1_fail = 171,
    sys_12_lgciu_1_fail_r = 172,
    sys_12_lgciu_2_fail = 173,
    sys_12_lgciu_2_fail_r = 174,
    sys_12_bscu_1_fail = 175,
    sys_12_bscu_1_fail_r = 176,
    sys_12_bscu_2_fail = 177,
    sys_12_bscu_2_fail_r = 178,
    sys_12_tpms_fail = 179,
    sys_12_tpms_fail_r = 180,
    sys_12_btmu_fail = 181,
    sys_12_btmu_fail_r = 182,
    sys_12_nose_gear_jam = 183,
    sys_12_left_mlg_jam = 184,
    sys_12_right_mlg_jam = 185,
    sys_13_clog_plt_static = 186,
    sys_13_clog_coplt_static = 187,
    sys_13_clog_stby_static = 188,
    sys_13_clog_plt_pitot = 189,
    sys_13_clog_coplt_pitot = 190,
    sys_13_clog_stby_pitot = 191,
    sys_13_adr_1_fail = 192,
    sys_13_adr_2_fail = 193,
    sys_13_adr_3_fail = 194,
    sys_13_iru_1_fail = 195,
    sys_13_iru_2_fail = 196,
    sys_13_iru_3_fail = 197,
    sys_13_ra_1_fail = 198,
    sys_13_ra_1_fail_r = 199,
    sys_13_ra_2_fail = 200,
    sys_13_ra_2_fail_r = 201,
    sys_14_gpws_fail = 202,
    sys_14_gpws_fail_r = 203,
    sys_14_gpws_terr_fail = 204,
    sys_14_mmr_1_fail = 205,
    sys_14_mmr_1_fail_r = 206,
    sys_14_mmr_2_fail = 207,
    sys_14_mmr_2_fail_r = 208,
    sys_14_vor_1_fail = 209,
    sys_14_vor_1_fail_r = 210,
    sys_14_vor_2_fail = 211,
    sys_14_vor_2_fail_r = 212,
    sys_14_adf_1_fail = 213,
    sys_14_adf_1_fail_r = 214,
    sys_14_adf_2_fail = 215,
    sys_14_adf_2_fail_r = 216,
    sys_14_dme_1_fail = 217,
    sys_14_dme_1_fail_r = 218,
    sys_14_dme_2_fail = 219,
    sys_14_dme_2_fail_r = 220,
    sys_15_l_bleed_leak = 221,
    sys_15_r_bleed_leak = 222,
    sys_15_apu_bleed_leak = 223,
    sys_15_x_bleed_fault = 224,
    sys_15_apu_bleed_fault = 225,
    sys_15_bmc_1_fail = 226,
    sys_15_bmc_1_fail_r = 227,
    sys_15_bmc_2_fail = 228,
    sys_15_bmc_2_fail_r = 229,
    sys_16_apu_fail = 230,
    sys_16_apu_fire = 231,
    sys_17_fail_recvrbl = 232,
    sys_17_fail_no_damage = 233,
    sys_17_fail_w_damage = 234,
    sys_17_fire = 235,
    sys_17_hot_egt = 236,
    sys_17_rev_fail = 237,
    sys_17_rev_pressurized = 238,
    sys_17_rev_deployed = 239,
    sys_17_hot_start = 240,
    sys_17_start_fail = 241,
    sys_17_oil_press = 242,
    sys_17_eiu = 243,
    sys_17_eiu_r = 244,
    sys_17_fadec_a = 245,
    sys_17_fadec_b = 246,
    sys_18_fail_recvrbl = 247,
    sys_18_fail_no_damage = 248,
    sys_18_fail_w_damage = 249,
    sys_18_fire = 250,
    sys_18_hot_egt = 251,
    sys_18_rev_fail = 252,
    sys_18_rev_pressurized = 253,
    sys_18_rev_deployed = 254,
    sys_18_hot_start = 255,
    sys_18_start_fail = 256,
    sys_18_oil_press = 257,
    sys_18_eiu = 258,
    sys_18_eiu_r = 259,
    sys_18_fadec_a = 260,
    sys_18_fadec_b = 261
}

-- =========================
-- Flight Phases
-- =========================
phases = {
    ground = 0,
    takeoff = 1,
    climb = 2,
    cruise = 3,
    descent = 4,
    approach = 5,
    landing = 6,
}

-- =========================
-- Utility Functions
-- =========================
function pick_random(elements)
    return elements[math.random(#elements)]
end

-- =========================
-- Scenario Logic
-- =========================
cruise_time = 0

function get_phase()
    -- on the ground?
    if get("sim/flightmodel/forces/faxil_gear") > 0 then
        if get("sim/flightmodel/position/groundspeed") > TAXI_GROUND_SPEED_THRESHOLD then
            if get("sim/flightmodel/forces/faxil_gear") > 0 then
                current_phase = phases.takeoff
            else
                current_phase = phases.landing
            end
        else
            current_phase = phases.ground
        end
    else
        -- lower than 50ft / 16m
        if get("sim/flightmodel/position/y_agl") < LANDING_TAKEOFF_AGL_THRESHOLD then
            if get("sim/flightmodel/position/vh_ind") > 0 then
                current_phase = phases.takeoff
            else
                current_phase = phases.landing
            end
        -- higher than 50ft / 16m
        else
            if get("sim/flightmodel/position/vh_ind") > VERTICAL_SPEED_THRESHOLD then
                current_phase = phases.climb
            elseif get("sim/flightmodel/position/vh_ind") < VERTICAL_SPEED_THRESHOLD then
                current_phase = phases.descent
            else
                current_phase = phases.cruise
                if cruise_time == 0 then
                    cruise_time = get("sim/time/total_flight_time_sec")
                end
            end
        end
    end
    print("phase " .. current_phase)
    return current_phase
end


-- =========================
-- Load Scenarios from External File
-- =========================
dofile(SCRIPT_DIRECTORY .. "scenarios.lua")

function enhance_scenario(scenario)
    for i = 1, #scenario do
        -- Add triggered key
        scenario[i].triggered = false
        -- create a trigger for each step of the scenario
        local comparison = pick_random({-1,1})
        if (scenario[i].phase) == phases.ground then
            scenario[i].trigger = {
                comparison = comparison,
                dataref = "sim/flightmodel/position/groundspeed",
                threshold = math.random(5, TAXI_GROUND_SPEED_THRESHOLD),
            }
        elseif (scenario[i].phase) == phases.takeoff then
            scenario[i].trigger = {
                comparison = comparison,
                dataref = "sim/flightmodel/position/y_agl",
                threshold = math.random(1, LANDING_TAKEOFF_AGL_THRESHOLD),
            }
        elseif (scenario[i].phase) == phases.climb then
            scenario[i].trigger = {
                comparison = 1,
                dataref = "sim/flightmodel/position/y_agl",
                threshold = math.random(1, 7300), -- 24000ft
            }
        elseif (scenario[i].phase) == phases.cruise then
            scenario[i].trigger = {
                comparison = 1,
                dataref = "sim/time/total_flight_time_sec",
                threshold = math.random(1, 600) + cruise_time,
            }
        elseif (scenario[i].phase) == phases.descent then
            scenario[i].trigger = {
                comparison = -1,
                dataref = "sim/flightmodel/position/y_agl",
                threshold = math.random(1, 3000), -- 10000ft
            }
        elseif (scenario[i].phase) == phases.approach then
            scenario[i].trigger = {
                comparison = -1,
                dataref = "sim/flightmodel/position/y_agl",
                threshold = math.random(1, 1500), -- 5000ft
            }
        elseif (scenario[i].phase) == phases.landing then
            scenario[i].trigger = {
                comparison = -1,
                dataref = "sim/flightmodel/position/y_agl",
                threshold = math.random(1, LANDING_TAKEOFF_AGL_THRESHOLD),
            }
        end
    end
end

function print_scenario(scenario)
    print("Scenario:")
    for i, step in ipairs(scenario) do
        -- Find phase name from phases table
        local phase_name = nil
        for name, value in pairs(phases) do
            if value == step.phase then
                phase_name = name
                break
            end
        end
        if not phase_name then phase_name = tostring(step.phase) end
        print(string.format("Step %d: phase = %s, failure = %d", i, phase_name, step.failure))
        if step.trigger then
            print(string.format("Trigger: comparison = %d, dataref = %s, threshold = %d", step.trigger.comparison, step.trigger.dataref, step.trigger.threshold))
        end
    end
end

-- =========================
-- Failure Triggering
-- =========================
function trigger_failure(failure_index)
    -- FlyWithLua uses X-Plane's dataref functions: dataref() and array access with set() and get()
    -- Define datarefs if not already defined
    if not numberOfFaults then
        numberOfFaults = dataref_table("toliss_airbus/faultinjection/numberOfFaults_rw")
        faultIndex = dataref_table("toliss_airbus/faultinjection/fault_index_rw")
        faultSetClear = dataref_table("toliss_airbus/faultinjection/fault_set_clear")
    end

    -- Increase the number of faults
    numberOfFaults[0] = numberOfFaults[0] + 1
    local idx = numberOfFaults[0] - 1
    faultIndex[idx] = failure_index
    faultSetClear[idx] = 1
    print("Triggered failure " .. tostring(failure_index))
end

-- =========================
-- Dataref Listing Utility
-- =========================
function list_datarefs()
    -- FlyWithLua: use dataref_table for writable arrays, dataref for single values
    local failure_name = dataref("toliss_airbus/faultinjection/index_check_name", "string")
    local failure_system = dataref("toliss_airbus/faultinjection/index_check_system", "number")
    local failure_index = dataref("toliss_airbus/faultinjection/index_check_rw", "number")

    local file = io.open(SCRIPT_DIRECTORY .. "failure_log.txt", "w")

    for i = 0, 261 do
        -- Set the index to check
        toliss_airbus_faultinjection_index_check_rw = i
        -- Give X-Plane a frame to update the datarefs (FlyWithLua is single-threaded, so this is a best effort)
        -- In practice, you may need to run this in a coroutine or with delays for large tables, but for now:
        -- Read the updated values
        local name = toliss_airbus_faultinjection_index_check_name or ""
        local system = toliss_airbus_faultinjection_index_check_system or 0

        -- Normalize failure_name to lowercase and replace non-alphanumeric characters with underscores
        local normalized_name = string.lower(name)
        normalized_name = string.gsub(normalized_name, "%W", "_")
        normalized_name = string.gsub(normalized_name, "_+", "_")
        normalized_name = string.gsub(normalized_name, "_$", "")
        local output = string.format("sys_%d_%s = %d,\n", system, normalized_name, i)
        print(output)
        file:write(output)
    end
    file:close()
end

-- =========================
-- Scenario Initialization
-- =========================
scenario = pick_random(scenarios)
print_scenario(scenario)
enhance_scenario(scenario)
print_scenario(scenario)

-- =========================
-- Main Loop
-- =========================
function run_loop()
    print("running on the loop..")
    local phase = get_phase()
    print("Current phase: " .. phase)
    for i = 1, #scenario do
        local step = scenario[i]
        print("Checking step " .. i .. ": phase = " .. step.phase .. ", failure = " .. step.failure)
        if step.triggered then
            print("Step " .. i .. " has already been triggered.")
            goto continue
        end
        if step.phase ~= phase then 
            print("Step " .. i .. " is not in the current phase: " .. step.phase .. ", skipping.")
            goto continue
        end

        local trigger = step.trigger
        local dataref_value = get(trigger.dataref)
        if (trigger.comparison == 1 and dataref_value >= trigger.threshold) or
        (trigger.comparison == -1 and dataref_value <= trigger.threshold) then
            print("Triggering failure for step " .. i .. ": " .. step.failure)
            trigger_failure(step.failure)
            step.triggered = true
        else
            print("Trigger condition not met for step " .. i .. ": " .. trigger.dataref .. " = " .. dataref_value .. ", threshold = " .. trigger.threshold)
        end
        ::continue::
    end
end

do_often('run_loop()')
