

integer     DIR_STOP = 100;
integer     DIR_START = 101;
integer     DIR_NORM = 102;
integer     burnout = TRUE;
integer     screech = TRUE;
float Speed;
// Particle Script 0.3
// Created by Ama Omega
// 10-10-2003
// Modified by Jeri Zuma 4/05 for bling on and off commands

// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plan of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = FALSE;           // Particles effected by wind
integer followSource = TRUE;    // Particles follow the source
integer followVel = TRUE;       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_EXPLODE;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target = "self";

// Particle paramaters
float age = 1;                  // Life of each particle
float maxSpeed = 1;            // Max speed each particle is spit out at
float minSpeed = .05;            // Min speed each particle is spit out at
key texture = "smoke-01";                 // Texture used for particles, default used if blank
float startAlpha = .9;           // Start alpha (transparency) value
float endAlpha = 0;           // End alpha (transparency) value
vector startColor = <1,1,1>;    // Start color of particles <R,G,B>
vector endColor = <1,1,1>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <.05,0.4,.05>;     // Start size of particles 
vector endSize = <.03,1.2,.03>;       // End size of particles (if interpSize == TRUE)
vector push = <0,0,0>;          // Force pushed on particles

// System paramaters
float rate = .11;            // How fast (rate) to emit particles
float radius = .15;          // Radius to emit particles for BURST pattern
integer count = 3;        // How many particles to emit per BURST 
float outerAngle = 0.54;    // Outer angle for all ANGLE patterns
float innerAngle = 3.55;    // Inner angle for all ANGLE patterns
vector omega = <0,10,0>;    // Rotation of ANGLE patterns around the source
float life = 0;             // Life in seconds for the system to make particles

// Script variables
integer flags;

updateParticles()
{
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

 llParticleSystem([
     PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
     PSYS_SRC_BURST_PART_COUNT,  9999,
     PSYS_SRC_BURST_RATE,        0.0100000,
     PSYS_PART_MAX_AGE,          5.000000,
     PSYS_SRC_BURST_RADIUS,      0.100000,
     PSYS_SRC_ACCEL,             <0.00000, 2.00000, 0.00000>,
     PSYS_SRC_ANGLE_BEGIN,       0.000000,
     PSYS_SRC_ANGLE_END,         3.141593,
     PSYS_SRC_BURST_SPEED_MIN,   1.000000,
     PSYS_SRC_BURST_SPEED_MAX,   0.100000,
     PSYS_SRC_OMEGA,             <9.00000, 9.00000, 9.00000>,
     PSYS_PART_END_SCALE,        <2.00000, 2.00000, 2.00000>,
     PSYS_PART_START_SCALE,      <1.00000, 1.00000, 1.00000>,
     PSYS_PART_END_COLOR,        <1.00000, 1.00000, 1.00000>,
     PSYS_PART_START_COLOR,      <1.00000, 1.00000, 1.00000>,
     PSYS_PART_END_ALPHA,        0.030000,
     PSYS_PART_START_ALPHA,      0.300000,
     PSYS_SRC_TEXTURE,           texture,
     PSYS_PART_FLAGS,
         PSYS_PART_WIND_MASK |
         PSYS_PART_EMISSIVE_MASK |
         PSYS_PART_FOLLOW_VELOCITY_MASK |
         PSYS_PART_INTERP_COLOR_MASK |
         PSYS_PART_INTERP_SCALE_MASK
 ]);
}
integer LoopSound = 0;
default
{
    state_entry()
    {
        llParticleSystem([]);
        llListen(0, "", llGetOwner(), "" );
        
            llStopSound();
    }
    on_rez( integer start_param )
    {
        llResetScript();
    }
    //listen( integer channel, string name, key id, string message )
    //{
   //  
   //     if(message=="burnout"){
   //         burnout = TRUE;
//
   //     }
   //     if(message=="off")
   //     {   burnout = FALSE;
   //     
   //         llSetTimerEvent(0.0);
   //     }
   //     
   //     
   // }
    link_message(integer sender, integer num, string message, key id)
    {
        if(message=="burnoutoff")
        {   burnout = FALSE;
            llParticleSystem([]);
            if(LoopSound != 0)
            {
                llStopSound();
            }
            LoopSound = 0;
            llSetTimerEvent(0.0);
        }
        if(message=="stopburn")
        {   
            llParticleSystem([]);
            if(LoopSound != 0)
            {
                llStopSound();
            }
            LoopSound = 0;
            
            llSetTimerEvent(0.0);
        }
        if(message=="burnout"){
            burnout = TRUE;

        }
        if(message=="screechon"){
            screech = TRUE;

        }
        if(message=="screechoff"){
            screech = FALSE;

        }
        //if(num == DIR_STOP) llResetScript();
        else if(message=="letsburn" && burnout)
        {
          updateParticles();
            llSetTimerEvent(0.2);
            if(LoopSound != 1)
            {
                llLoopSound("screech1",1); 
            }
            LoopSound = 1; 
        }
        else if(message=="letsscreech" && screech && !burnout)
        {
          updateParticles();
            llSetTimerEvent(0.3);
            if(LoopSound != 1)
            {
                llLoopSound("screech1",1); 
            }
            LoopSound = 1; 
        }
        else if(message=="screech2" && screech && !burnout)
        {
          updateParticles();
            llSetTimerEvent(0.2);
            if(LoopSound != 1)
            {
                llLoopSound("screech1",1); 
            }
            LoopSound = 1;  
        }
        else if(message=="screech3" && screech && !burnout)
        {
          updateParticles();
            llSetTimerEvent(0.1);
            if(LoopSound != 1)
            {
                llLoopSound("screech1",1); 
            }
            LoopSound = 1;  
        }
        
    }
   
    timer()
    {
        Speed = llVecMag(llGetVel());
        if(Speed < 0.3) {
            
            llParticleSystem([]);
            
            if(LoopSound != 0)
            {
                llStopSound();
            }
            LoopSound = 0; 
        }
        if(screech && !burnout) {
            llSetTimerEvent(0.0);
            llParticleSystem([]);
            
            if(LoopSound != 0)
            {
                llStopSound();
            }
            LoopSound = 0; 
        }
    }
}