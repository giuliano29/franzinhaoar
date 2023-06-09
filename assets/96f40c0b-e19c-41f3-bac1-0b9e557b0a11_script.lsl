string Name = "horse";
key uNPC;
integer channel = 320320;



flash(vector v)
{
     llSetLinkPrimitiveParams(6, [PRIM_COLOR, ALL_SIDES , v, 1.0]);
     llSleep(.3);
     llSetLinkPrimitiveParams(6, [PRIM_COLOR, ALL_SIDES , v, 0.0]);    
}

psystem_ok()
{

     llLinkParticleSystem(1, 
        [
            PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_BURST_RADIUS,.1,
            PSYS_SRC_ANGLE_BEGIN,PI,
            PSYS_SRC_ANGLE_END,PI+0.1,
            PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
            PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
            PSYS_PART_START_ALPHA, 1,
            PSYS_PART_END_ALPHA, 0.,
            PSYS_PART_START_GLOW,0,
            PSYS_PART_END_GLOW,0,
            
            PSYS_PART_START_SCALE,<1.0000,1.00000,0.000000>,
            PSYS_PART_END_SCALE,<2,2, 0.000000>,
            PSYS_SRC_TEXTURE,"OK",
            PSYS_SRC_MAX_AGE, 2.,
            PSYS_PART_MAX_AGE, 2.,
            PSYS_SRC_BURST_RATE, 2. ,
            PSYS_SRC_BURST_PART_COUNT, 1,
            PSYS_SRC_ACCEL,<0.000000,0.000000, 0.0000>,
            PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
            PSYS_SRC_BURST_SPEED_MIN,0.1,
            PSYS_SRC_BURST_SPEED_MAX,0.1,
            PSYS_PART_FLAGS,
                0 
                | PSYS_PART_EMISSIVE_MASK
                | PSYS_PART_INTERP_COLOR_MASK
                | PSYS_PART_INTERP_SCALE_MASK
                | PSYS_PART_TARGET_POS_MASK
                //| PSYS_PART_BOUNCE_MASK
                //| PSYS_PART_FOLLOW_SRC_MASK
                | PSYS_PART_FOLLOW_VELOCITY_MASK
        ]);
        
        //llLinkParticleSystem(1, []);
}

default
{
    
    on_rez(integer n)
    {
        llResetScript();
    }
    
    state_entry()
    {

        string n = llStringTrim(llGetObjectDesc(), STRING_TRIM);
        if (n != "") Name = n;
        llSetTimerEvent(300);
        llListen(channel, "", "", "");
        llSetText("", <1,1,1>, 1.0);
    }
    
    changed(integer c)
    {
         if (c&CHANGED_LINK)
         {
            if (llAvatarOnLinkSitTarget(1) != NULL_KEY)
            {
                key horse = llAvatarOnLinkSitTarget(2);
                if (horse == NULL_KEY)
                {
                    //llSay(0, "Rezzing the horse NPC...");
                    uNPC = osNpcCreate(" ", "", llGetPos()+<0,0,2>, "appearance",  0);
                    llSleep(3);
                    osNpcSit(uNPC, llGetLinkKey(2), OS_NPC_SIT_NOW);
                    llSleep(.5);
                    osNpcPlayAnimation(uNPC, "n_idle");
                   
                }
                //llRegionSay(320320, "JOIN "+llGetKey()+ " " +  (string)llAvatarOnLinkSitTarget(1));
                llSetTimerEvent(0);
            }
            else
            {
                
                llSetText("", <1,1,1>, 1.0);
                llSetTimerEvent(200);
            }
        }
    }
   
    
    timer()
    {
        if (llAvatarOnLinkSitTarget(1) == NULL_KEY)
        {
                key u2 = llAvatarOnLinkSitTarget(2);
                if (u2 != NULL_KEY)
                {
                    llSay(0, "Removing NPC...");
                    osNpcStand(u2);
                    llSleep(1.);
                    osNpcRemove(u2);
                    llSleep(2);                
                }
                llDie();
        }
        
    }
    
    listen(integer ch,string nm,  key id, string m)
    {
        if (llGetSubString(m, 0, 3) == "ERR ")
        {
            llSetText(llGetSubString(m, 3, -1), <1, 0,0>, 1.0);
            llTriggerSound("doing", 1.0);
            flash(<1,0,0>);
        }
        else if (llGetSubString(m, 0, 3) == "TXT ")
        {
            llSetText(llGetSubString(m, 3, -1), <0, 1, 0>, 1.0);
        }
        else if (llGetSubString(m, 0, 3) == "SUC ")
        {
            
            llTriggerSound("ding", 1.0);
            llSetText(llGetSubString(m, 3, -1), <0, 1, 0>, 1.0);
                flash(<0,1,0>);
        }
        else if (llGetSubString(m, 0, 3) == "LAP ")
        {
            llTriggerSound("lap", 1.0);
            llSetText(llGetSubString(m, 3, -1), <0, 1, 0>, 1.0);
                flash(<0,1,0>);
            //lParticleSystem
        }
        else if (llGetSubString(m, 0, 3) == "SND ")
        {
            llTriggerSound((key)llGetSubString(m, 3, -1), 1.0);
        }
        else if (m == "REPORT")
        {
            if (llAvatarOnLinkSitTarget(1) != NULL_KEY)
            {
                llRegionSay(320320, "JOIN "+llGetKey()+ " " +  (string)llAvatarOnLinkSitTarget(1));
                flash(<0,1,0>);
            }
        }
    }
}
 