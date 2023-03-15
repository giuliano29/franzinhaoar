integer penis_channel=0;
integer listener = -1;
integer curShow=6;
integer i;
integer partlink = 2;
integer cummed=0;
integer balldrip =0;
integer asson=0;
integer cockdrip =0;
float   cur_scale = 1.0;
float max_scale=1.7;
float min_scale=0.3;
integer isShowing=1;

list link_scales = [];
list link_positions = [];

showLink(integer l)
{
    llSetLinkAlpha(LINK_ALL_CHILDREN, 0.0, ALL_SIDES);
    llSetLinkAlpha(l, 1.0, 1);
    curShow = l;
}

stopParticles()
{
    for (i=0; i < 16; i++)
        llLinkParticleSystem(i,[]);
        llParticleSystem([]);
 llStopSound();
}


scanLinkset()
{
    integer link_qty = llGetNumberOfPrims();
    integer link_idx;
    integer link_ofs = (link_qty != 1); // add 1 if more than one prim (as linksets start numbering with 1)
    list params;
    
    for (link_idx = 0; link_idx < link_qty; ++link_idx)
    {
        params = llGetLinkPrimitiveParams(link_idx + link_ofs, [PRIM_POS_LOCAL, PRIM_SIZE]);
 
        link_positions += llList2Vector(params, 0);
        link_scales    += llList2Vector(params, 1);
    }
    
    
    max_scale = 1.5;
    min_scale = 0.5;
}
 
resizeObject(float scale)
{
    integer link_qty = llGetNumberOfPrims();
    integer link_idx;
    integer link_ofs = (link_qty != 1);
 
    // scale the root
    llSetLinkPrimitiveParamsFast(link_ofs, [PRIM_SIZE, scale * llList2Vector(link_scales, 0)]);
    // scale all but the root
    for (link_idx = 1; link_idx < link_qty; link_idx++)
    {
        llSetLinkPrimitiveParamsFast(link_idx + link_ofs,
            [PRIM_SIZE,      scale * llList2Vector(link_scales, link_idx),
         PRIM_POS_LOCAL, scale * llList2Vector(link_positions, link_idx)]);
    
      //llOwnerSay("scale=" + (string)scale+" Would be " + (string)(scale * llList2Vector(link_scales, link_idx)) + " pos = " + (string)(scale * llList2Vector(link_positions, link_idx)) );
    }
}


startListening()
{
   if (listener != -1)
        llListenRemove(listener);
   penis_channel = -1 - (integer)("0x" + llGetSubString( (string) llGetOwner(), -6, -1) )-3994 ;
   listener = llListen(penis_channel, "","","");
}

default
{
    state_entry()
    {
       llParticleSystem([]);
      // listener = llListen(channel, "","","");
      stopParticles();
      startListening();
    }
    on_rez(integer n)
    {
        startListening();
    }
    
    

    //dataserver(key query_id, string msg)
    listen(integer ch, string who, key id, string msg)
    {
        list tok = llParseString2List(msg, [" "], []);

        string cmd = llList2String(tok, 0);
       // llOwnerSay(llList2CSV(tok));
       if (cmd == "hide")
       {
            isShowing = !isShowing;
            llSetLinkAlpha(5, isShowing*1.0, ALL_SIDES);
       }
       else if (cmd == "Fart")
       {
            string s = "fart"+(integer)(1+ llFrand(4));
        
            llPlaySound(s,1.0);
            llLinkParticleSystem(2, [PSYS_PART_MAX_AGE, 30,
            PSYS_PART_FLAGS, 267,
            PSYS_PART_START_COLOR, <0.6, 0.5, 0.29>,
            PSYS_PART_END_COLOR, <.60000, .40000, .20000>,
            PSYS_PART_START_SCALE, <0.3, 0.3, 0.4>,
            PSYS_PART_END_SCALE, <4.20000, 4.20000, 0400000>,
            PSYS_SRC_PATTERN, 2,
            PSYS_SRC_BURST_RATE,0.2,
            PSYS_SRC_ACCEL,<0.00000, 0.00000, 0.010000>,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_BURST_RADIUS,0.000000,
            PSYS_SRC_BURST_SPEED_MIN,0.01000,
            PSYS_SRC_BURST_SPEED_MAX,0.30000,
            PSYS_SRC_INNERANGLE,0.000000,
            PSYS_SRC_OUTERANGLE,1.000000,

            PSYS_SRC_MAX_AGE, 2,
            PSYS_PART_START_ALPHA,0.6,
            PSYS_PART_END_ALPHA,0.1,
            PSYS_SRC_TEXTURE, "smoke",
            PSYS_SRC_TARGET_KEY,(key)"" ]);
            llSetTimerEvent(10);
            
        }
        else if (cmd == "Cumfart")
        {
            
             //string s = "fart"+(integer)(1+ llFrand(4));
            llPlaySound("cfart",1.0);
            
            list pp =  [
            PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_BURST_RADIUS,0.0,
            PSYS_SRC_ANGLE_BEGIN,-1,
            PSYS_SRC_ANGLE_END,1,
            PSYS_SRC_TARGET_KEY,llGetKey(),
            PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
            PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
            PSYS_PART_START_ALPHA,0.6,
            PSYS_PART_END_ALPHA,1,
            PSYS_PART_START_GLOW,0,
            PSYS_PART_END_GLOW,0,
            PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
            PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
            PSYS_PART_START_SCALE,<0.06,0.100000,0.000000>,
            PSYS_PART_END_SCALE,<0.100000,2.000000,0.000000>,
            PSYS_SRC_TEXTURE,"dr4",
            PSYS_SRC_MAX_AGE,1,
            PSYS_PART_MAX_AGE,3.1,
            PSYS_SRC_BURST_RATE,7,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_ACCEL,<0.000000,0.000000,-0.600000>,
            PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
            PSYS_SRC_BURST_SPEED_MIN,-0.1,
            PSYS_SRC_BURST_SPEED_MAX,-0.0,
            PSYS_PART_FLAGS,
                0 |
                PSYS_PART_EMISSIVE_MASK |
                PSYS_PART_INTERP_SCALE_MASK
        ];
        
            llLinkParticleSystem(2,pp);
            llSetTimerEvent(10);
            
        }
        else if (msg == "Ass Drip")
        {
            asson=!asson;
            if (asson)
            {            
                list pp =  [
                PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
                PSYS_SRC_BURST_RADIUS,0.0,
                PSYS_SRC_ANGLE_BEGIN,-1,
                PSYS_SRC_ANGLE_END,1,
                PSYS_SRC_TARGET_KEY,llGetKey(),
                PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_START_ALPHA,0.6,
                PSYS_PART_END_ALPHA,1,
                PSYS_PART_START_GLOW,0,
                PSYS_PART_END_GLOW,0,
                PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
                PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
                PSYS_PART_START_SCALE,<0.06,0.100000,0.000000>,
                PSYS_PART_END_SCALE,<0.100000,1.7,0.000000>,
                PSYS_SRC_TEXTURE,"dr4",
                PSYS_SRC_MAX_AGE,0,
                PSYS_PART_MAX_AGE,3.1,
                PSYS_SRC_BURST_RATE,5,
                PSYS_SRC_BURST_PART_COUNT,2,
                PSYS_SRC_ACCEL,<0.000000,0.000000,-0.600000>,
                PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
                PSYS_SRC_BURST_SPEED_MIN,-0.1,
                PSYS_SRC_BURST_SPEED_MAX,-0.0,
                PSYS_PART_FLAGS,
                    0 |
                    PSYS_PART_EMISSIVE_MASK |
                    PSYS_PART_INTERP_SCALE_MASK
                ];
            
                llLinkParticleSystem(2,pp);
                
            }
            else
               llLinkParticleSystem(2,[]);
               
           
            llSetLinkAlpha(3,  asson*1.0, ALL_SIDES);
            llSetLinkAlpha(4,  asson*1.0, ALL_SIDES);
            llSetLinkColor(3,  <1,1,1>, ALL_SIDES);
            llSetLinkColor(4,  <1,1,1>, ALL_SIDES);
        }
    }
    
    
    
    timer()
    {
        integer i;
        for (i=2; i < 13; i++) 
            llLinkParticleSystem(i,[]);
        llSetTimerEvent(0);
    }
}



