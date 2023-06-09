default
{
    state_entry()
    {
        llParticleSystem([
            PSYS_PART_FLAGS,( 0 
                |PSYS_PART_INTERP_COLOR_MASK
                |PSYS_PART_INTERP_SCALE_MASK
                |PSYS_PART_FOLLOW_VELOCITY_MASK
                |PSYS_PART_EMISSIVE_MASK ), 
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE ,
            PSYS_PART_START_ALPHA,0.152941,
            PSYS_PART_END_ALPHA,0,
            PSYS_PART_START_COLOR,<1,1,1> ,
            PSYS_PART_END_COLOR,<1,1,1> ,
            PSYS_PART_START_SCALE,<0.875,1.1875,0>,
            PSYS_PART_END_SCALE,<2.5,2.5,0>,
            PSYS_PART_MAX_AGE,3,
            PSYS_SRC_MAX_AGE,0,
            PSYS_SRC_ACCEL,<0,0,-3.30469>,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_BURST_RADIUS,0,
            PSYS_SRC_BURST_RATE,0.0390625,
            PSYS_SRC_BURST_SPEED_MIN,0.148438,
            PSYS_SRC_BURST_SPEED_MAX,0.464844,
            PSYS_SRC_ANGLE_BEGIN,0,
            PSYS_SRC_ANGLE_END,0.28125,
            PSYS_SRC_OMEGA,<0,0,0>,
            PSYS_SRC_TEXTURE, (key)"43927f6f-c844-4164-a1c9-bba699760196",
            PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"
         ]);
    }
}
 