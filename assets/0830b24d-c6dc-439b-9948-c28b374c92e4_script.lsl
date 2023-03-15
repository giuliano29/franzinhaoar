// Example Ribbon Particle Script
 
Particles()
{
    vector scale = llGetScale();
    float size = scale.z;
   
    llParticleSystem([
        PSYS_PART_FLAGS, 0
            | PSYS_PART_FOLLOW_VELOCITY_MASK
            | PSYS_PART_INTERP_COLOR_MASK
            | PSYS_PART_RIBBON_MASK,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
        PSYS_PART_START_GLOW, 0.15,
        PSYS_PART_END_GLOW, 0.05,
        PSYS_PART_START_COLOR, llGetColor(1),
        PSYS_PART_END_COLOR, llGetColor(3),
        PSYS_PART_START_ALPHA, 0.3,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_PART_START_SCALE, <0.15, 0.15, 0>,
        PSYS_SRC_TEXTURE,  llGetInventoryName(INVENTORY_TEXTURE, 0),
       
        PSYS_SRC_MAX_AGE, 0.0,
        PSYS_PART_MAX_AGE, 1.5,
        PSYS_SRC_BURST_RATE, 0.0,
        PSYS_SRC_BURST_PART_COUNT, 1
    ]);
}
 
default
{
    state_entry()
    {
        Particles();
    }
   
    changed(integer change)
    {
        if     (change & CHANGED_COLOR) Particles();
        else if(change & CHANGED_SCALE) Particles();
    }
}