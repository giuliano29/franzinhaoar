integer channel;
integer listener = -1;
integer penis_channel;
integer curShow=6;
integer i;
integer partlink = 2;
integer cummed=0;
integer balldrip =0;
integer cockdrip =0;
float   cur_scale = 1.0;
float max_scale=1.7;
float min_scale=0.3;
float isShowing =1;

string pissTarget = "";// "4953119b-24f8-49d7-a325-9c85035dd286";

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


refresh()
{
        for (i=5; i < 8; i++)
            llSetLinkAlpha(i, 0.0, ALL_SIDES);
            
        llSetLinkAlpha(curShow, isShowing*1.0, ALL_SIDES);
        llSetLinkColor(3, <1,1,1>, ALL_SIDES);
        llSetLinkColor(4, <1,1,1>, ALL_SIDES);
        llSetLinkAlpha(3, isShowing*cockdrip*1.0, ALL_SIDES);
        llSetLinkAlpha(4, isShowing*cockdrip*1.0, ALL_SIDES);
}

default
{
    state_entry()
    {
       llParticleSystem([]);
       stopParticles();
      startListening();
    }
    
    on_rez(integer n)
    {
       startListening();
       refresh();
    }

    //dataserver(key query_id, string msg)
    listen(integer ch, string who, key id, string msg)
    {
        list tok = llParseString2List(msg, [" "], []);
        if (channel != channel) return;

        string cmd = llList2String(tok, 0);
        if(cmd == "rotate")
        {
            vector v = <0, -2.1*llList2Float(tok,2),  (PI/2)- (1.2*llList2Float(tok,1))> ;
            llSetLocalRot(llEuler2Rot(v));
        }
        else if (cmd == "piss")
        {
                            integer i;
               // llParticleSystem([]);
  
               llLoopSound("piss1",1.0);
            list pp =                     [
                   
                    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
                    PSYS_PART_START_SCALE,      <.04,.1, 0>,
                    PSYS_PART_START_ALPHA,      1.0,
                    PSYS_PART_START_COLOR,      <1.0,1.0,0.2>,
                    PSYS_SRC_ACCEL,             <0,0,-.9>,
                    PSYS_PART_MAX_AGE,          6.0,
                    PSYS_SRC_ANGLE_BEGIN,       -.1,
                    PSYS_SRC_ANGLE_END,         0.1,
                    PSYS_SRC_BURST_PART_COUNT,  2,
                    PSYS_SRC_BURST_RATE,        0.0, 
                    PSYS_SRC_BURST_SPEED_MIN,   0.5, 
                    PSYS_SRC_BURST_SPEED_MAX,   1.0];

                    if (pissTarget != "")
                    {
                         pp += [PSYS_PART_FLAGS,    
                          PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_EMISSIVE_MASK|PSYS_PART_TARGET_POS_MASK,
                          PSYS_SRC_TARGET_KEY, (key)pissTarget];
                    }
                    else
                         pp += [PSYS_PART_FLAGS,  PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_EMISSIVE_MASK];
                                        
                llLinkParticleSystem(partlink, pp);
        }
        else if (cmd == "pre")
        {
              list pp = [  // start of particle settings
           // Texture Parameters:
           PSYS_SRC_TEXTURE, "dr1", 
           PSYS_PART_START_SCALE, <.01,.01, FALSE>,  PSYS_PART_END_SCALE, <.05,1.0, FALSE>, 
           PSYS_PART_START_COLOR, <1,1,1>,      PSYS_PART_END_COLOR, <1,1,1>, 
           PSYS_PART_START_ALPHA, (float).9,       PSYS_PART_END_ALPHA, (float).5,     
         
           // Production Parameters:
           PSYS_SRC_BURST_PART_COUNT, (integer)2, 
           PSYS_SRC_BURST_RATE, (float) 4,  
           PSYS_PART_MAX_AGE, (float)3.0, 
           PSYS_SRC_MAX_AGE,(float) 0.0,  
        
           // Placement Parameters:
           PSYS_SRC_PATTERN, (integer)8, // 1=DROP, 2=EXPLODE, 4=ANGLE, 8=ANGLE_CONE,
           
           // Placement Parameters (for any non-DROP pattern):
           PSYS_SRC_BURST_SPEED_MIN, (float)0.0,   PSYS_SRC_BURST_SPEED_MAX, (float)0.0, 
           PSYS_SRC_BURST_RADIUS, .01,
        
           // Placement Parameters (only for ANGLE & CONE patterns):
           PSYS_SRC_ANGLE_BEGIN, (float) .25*PI,   PSYS_SRC_ANGLE_END, (float)0.0*PI,  
        // PSYS_SRC_OMEGA, <0,0,0>, 
        
           // After-Effect & Influence Parameters:
           PSYS_SRC_ACCEL, <0.0,0.0,-.3>,  
        // PSYS_SRC_TARGET_KEY,      llGetLinkKey(llGetLinkNum() + 1),       
              
           PSYS_PART_FLAGS, (integer)( 0         // Texture Options:     
                                | PSYS_PART_INTERP_COLOR_MASK   
                                | PSYS_PART_INTERP_SCALE_MASK   
                                | PSYS_PART_EMISSIVE_MASK   
                             // | PSYS_PART_FOLLOW_VELOCITY_MASK
                                                  // After-effect & Influence Options:
                              //  | PSYS_PART_WIND_MASK            
                              //  | PSYS_PART_BOUNCE_MASK          
                             // | PSYS_PART_FOLLOW_SRC_MASK     
                             // | PSYS_PART_TARGET_POS_MASK     
                             // | PSYS_PART_TARGET_LINEAR_MASK   
                            ) 
            //end of particle settings                     
        ];
         llLinkParticleSystem(partlink,pp);
         
        }
        
        else if (msg == "cum")
        {
                integer i;
                stopParticles();
                llLinkParticleSystem(partlink,
                    [
                    PSYS_PART_FLAGS,                            
                    PSYS_PART_FOLLOW_VELOCITY_MASK|
                    PSYS_PART_EMISSIVE_MASK,
                    PSYS_SRC_PATTERN,          
                    PSYS_SRC_PATTERN_ANGLE_CONE,
                    PSYS_PART_START_SCALE,      <.05,.1,0.1>,
                    PSYS_PART_START_ALPHA,      1.0,
                    PSYS_PART_START_COLOR,      <1.0,1.0,0.9>,
                    PSYS_SRC_ACCEL,             <0,0,-.5>,
                    PSYS_PART_MAX_AGE,          20.0,
                    PSYS_SRC_ANGLE_BEGIN,       0.0,
                    PSYS_SRC_ANGLE_END,         0.2,
                    PSYS_SRC_BURST_PART_COUNT,  36,
                    PSYS_SRC_BURST_RATE,        1.6, 
                    PSYS_SRC_BURST_SPEED_MIN,   0.5, 
                    PSYS_SRC_BURST_SPEED_MAX,   1.5]);
         
        }
        else if (cmd == "stop")
        {
            stopParticles();
        }
        else if (msg == "Drips")
        {
            cockdrip = !cockdrip;
            refresh();

        }
        else if (msg == "hide")
        {
            isShowing = !isShowing;
            refresh();
        }
        else if (cmd == "show")
        {
            curShow = llList2Integer(tok, 1);
            refresh();
        }
        else if (msg == "cummed")
        {
            cummed = !cummed;
            string c = "uncummed";
            if (cummed)
                c = "cummed1";
            llSetLinkTexture(5,c, ALL_SIDES);
            llSetLinkTexture(6,c, ALL_SIDES);
            llSetLinkTexture(7,c, ALL_SIDES);
        }
        else if (cmd == "setpisstarget")
        {
            pissTarget = llList2String(tok, 1);
        }
        else if (msg =="sizeup" || msg == "sizedown")
        {
            //check that the scale doesn't go beyond the bounds
            if (msg == "sizeup")
                cur_scale += 0.1;
            else
                cur_scale -= 0.1;
           scanLinkset();
            if (cur_scale > max_scale) { cur_scale = max_scale; }
            if (cur_scale < min_scale) { cur_scale = min_scale; }
 
            resizeObject(cur_scale);
        }
        else if (cmd == "setcolor")
        {
            vector col = 
                <llList2Float(tok, 1),   llList2Float(tok, 1),  llList2Float(tok, 3)>;

            llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, ALL_SIDES, col, 1.0]);
            llSetLinkPrimitiveParamsFast(6, [PRIM_COLOR, ALL_SIDES, col, 1.0]);
            llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, ALL_SIDES, col, 1.0]);
        }
    }

}