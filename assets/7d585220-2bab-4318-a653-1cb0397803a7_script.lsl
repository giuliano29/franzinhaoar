

float linear = 8; //Power used to go forward (1 to 30)
integer toggle;
float reverse_power = -5; //Power ued to go reverse (-1 to -30)
float turning_ratio = .2; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
string sit_message = "RIDE"; //Sit message
string not_owner_message = "You are not the owner of this vehicle ..."; //Not owner message

integer seated = 0;

float speedmult = 1.0;
string curstatus;
string anHorse;
string anMan;
string anPass;

string turningAnim;
string curTurningAnim;


psystem()
{
     llLinkParticleSystem(5, 
        [
            PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_BURST_RADIUS,.4,
            PSYS_SRC_ANGLE_BEGIN,PI/2,
            PSYS_SRC_ANGLE_END, PI/2,
            PSYS_PART_START_COLOR,<1.000000,.9000000,.7000000>,
            PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
            PSYS_PART_START_ALPHA, .2,
            PSYS_PART_END_ALPHA,0,
            PSYS_PART_START_GLOW,0,
            PSYS_PART_END_GLOW,0,
            PSYS_PART_START_SCALE,<1.50000,1.500000,0.000000>,
            PSYS_PART_END_SCALE,<4,5, 0.000000>,
            PSYS_SRC_TEXTURE,"smoke",
            PSYS_SRC_MAX_AGE,0,
            PSYS_PART_MAX_AGE,5,
            PSYS_SRC_BURST_RATE,0.05,
            PSYS_SRC_BURST_PART_COUNT,1,
            PSYS_SRC_ACCEL,<0.000000,0.000000, -1.00000>,
            PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
            PSYS_SRC_BURST_SPEED_MIN,.1,
            PSYS_SRC_BURST_SPEED_MAX,.3,
            PSYS_PART_FLAGS,
                0 
                | PSYS_PART_INTERP_COLOR_MASK
                | PSYS_PART_INTERP_SCALE_MASK
                | PSYS_PART_BOUNCE_MASK
        ]);
}


switchAnims(string status )
{
            key horse = llAvatarOnLinkSitTarget(2);
            key man = llAvatarOnLinkSitTarget(1);
            key pass = llAvatarOnLinkSitTarget(3);
            
            string oMan = anMan;
            string oPass = anPass;
            string oHorse = anHorse;

            anMan = "r_"+status;
            anHorse = "n_"+status;
            anPass = "p_"+status;
            
            if (status == "idle" && llFrand(1.)< 0.4)
                anHorse = "n_graze1";
            
            osAvatarStopAnimation(horse, "sit");
            osAvatarPlayAnimation(horse, anHorse);
            osAvatarPlayAnimation(man, anMan);
            
            osAvatarStopAnimation(man, oMan);
            osAvatarStopAnimation(horse, oHorse);
            
            if (pass != NULL_KEY)
            {
                osAvatarStopAnimation(pass, oPass);
                osAvatarPlayAnimation(pass, anPass);
            }
            
            llStopSound();
            if (status != "idle")
            {
                llLoopSound("s_"+status, 1.0);
                if (status == "gallop")
                    psystem();
            }
            else
            {
                llLinkParticleSystem(5, []);
            }
            
            if (llFrand(1.0) < 0.1) llTriggerSound("s_whinny"+(string) ((integer)(1+llFrand(3))), 1.0); 
}


    

init()
{
    
        llSetSitText(sit_message);
        // forward-back,left-right,updown
        llSitTarget(<0.2, 0.0, 1.2>, ZERO_ROTATION );
        
        //llSetCameraEyeOffset(<-10, -1.0, 3.0>);
        //llSetCameraAtOffset(<1.0, 0.0, 2.0>);
        
        //llPreloadSound("boat_start");
        //llPreloadSound("boat_run");
        
                
        llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
            llSetVehicleFlags(0);

        llSetVehicleType(VEHICLE_TYPE_CAR);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY );
        
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <.3, .3, .3> );
        
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1 );

        
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, .2);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.1);
        
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 1 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 5 );
        
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0.15);
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY,1. );
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, .1 );
        //llSetVehicleFloatParam( VEHICLE_BUOYANCY, 1 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, .5 );
        
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.9 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, .1 );
        
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, .9 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, .5 );
        
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0.5 );
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, .2 );
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, ZERO_ROTATION );
        
}

string curanim;

default
{
    
    on_rez(integer n)
    {
        llResetScript();   
    }
    
    state_entry()
    {
        init();
    }
    
    changed(integer change)
    {
        
        
        if ((change & CHANGED_LINK) == CHANGED_LINK)
        {
            key agent = llAvatarOnLinkSitTarget(1);
            if (agent != NULL_KEY)
            {                


                    llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA| PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                    llSetLinkAlpha(4, 0.0, ALL_SIDES);
                    init();
                    llSleep(0.3);
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llSleep(0.5);
                   
                    seated = 1;

            }
            else
            {
                
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSleep(.2);
                llReleaseControls();
                llTargetOmega(<0,0,0>,PI,0);
                llSetLinkAlpha(2,1.0, ALL_SIDES);
                llSetRot(ZERO_ROTATION);
                //llSleep(3);
                //llDie();
                llClearCameraParams();
                seated = 0;
                //llStopAnimation("horse_sit");
                key horse = llAvatarOnLinkSitTarget(2);
                key man = llAvatarOnLinkSitTarget(1);
                key pass  = llAvatarOnLinkSitTarget(3);
                if (man != NULL_KEY) osAvatarStopAnimation(man, anMan);
                if (pass != NULL_KEY) osAvatarStopAnimation(pass, anPass);
                
            }

        }
        
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | 
                            CONTROL_LEFT| CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT , TRUE, FALSE);
        }
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llStopAnimation("sit");
            //llStartAnimation("man-stop");
            switchAnims("idle");
        }
        if (perm & PERMISSION_CONTROL_CAMERA)
        {
            llSetCameraParams([
               CAMERA_ACTIVE, 1,                     // 0=INACTIVE  1=ACTIVE
               CAMERA_BEHINDNESS_ANGLE, 15.0,         // (0 to 180) DEGREES
               CAMERA_BEHINDNESS_LAG, .6,           // (0 to 3) SECONDS
               CAMERA_DISTANCE, 5.0,                 // ( 0.5 to 10) METERS
               CAMERA_PITCH, 20.0,                    // (-45 to 80) DEGREES
               CAMERA_POSITION_LOCKED, FALSE,        // (TRUE or FALSE)
               CAMERA_POSITION_LAG, 0.05,             // (0 to 3) SECONDS
               CAMERA_POSITION_THRESHOLD, 30.0,       // (0 to 4) METERS
               CAMERA_FOCUS_LOCKED, FALSE,           // (TRUE or FALSE)
               CAMERA_FOCUS_LAG, 0.01 ,               // (0 to 3) SECONDS
               CAMERA_FOCUS_THRESHOLD, 0.01,          // (0 to 4) METERS
               CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0>   // <-10,-10,-10> to <10,10,10> METERS
              ]);
        }
        
    }
    
    control(key id, integer level, integer edge)
    {
        integer reverse=1;
        vector angular_motor;
 
        
        //get current speed
        vector vel = llGetVel();
        float speed = llVecMag(vel);
        //car controls

        string status = "idle";
        float jumpspeed=0;
        linear =0;
        
        if(level & edge &  CONTROL_UP)
        {
            if (speedmult < 3.) speedmult += 1.;
        }
        
        
        if(level & edge &  CONTROL_DOWN)
        {
            if (speedmult > 1.) speedmult -= 1.;
        }
        

        

        
        if(level & CONTROL_FWD)
        {

            linear = 6.;
            
            if (speedmult > 2.)
            {
                status = "gallop";
                linear = 20.;
            }
            else if (speedmult > 1.)   
            {
                linear = 12.;
                status = "trot";
            }
            else 
                status = "walk";


            if ( level & CONTROL_BACK )
            {
                linear = 20.;
                angular_motor.y += .5;
                status = "jump";
            }
            else jumpspeed=-2;
        }
        
        else if(level & CONTROL_BACK)
        {
            linear = -5.;
            reverse = -1;
            status = "walk";
        }
        

        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <linear, 0, 0>);


        turningAnim = "";

        if(level & (CONTROL_ROT_RIGHT))
        {
            angular_motor.z -=  7+ speed/turning_ratio * reverse;
            //angular_motor.x += 2; 
            turningAnim = "n_right_turn";
        }
        
        if(level & (CONTROL_ROT_LEFT))
        {
            angular_motor.z +=  7 + speed/turning_ratio * reverse;
            //angular_motor.x -= 2;
            turningAnim = "n_left_turn";
        }

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
        
        
        if (curstatus != status)
        {
            curstatus = status;       
            switchAnims(status);
        }
        
        if (curTurningAnim != turningAnim)
        {
            key horse = llAvatarOnLinkSitTarget(2);
            osNpcStopAnimation(horse, curTurningAnim);
            curTurningAnim = turningAnim;
            if (curTurningAnim != "")
                osNpcPlayAnimation(horse, curTurningAnim);
        }

    } //end control   
    

} //end default 