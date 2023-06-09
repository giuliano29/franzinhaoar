// sensor variables
float sensor_interval = 2.0;    // interval between scans in seconds
float sensor_range = 40.0;        // range in meters
// skinner
integer count;
integer ON;
list prims = [1,2,3]; //[1,2,3,4];
string tex; 
integer lnk = 1;

// cycler
float SECS_PER_SIDE = 0.5;
integer CYCLE_PING_PONG = FALSE;
integer increment = 1;
integer numSides;
integer lastSide;
integer cycling;

initialize ()
{
    integer i;
    string tex; 
    tex = "sheepskin";      
    for (i=0; i < llGetListLength(prims); i++)
    {
       integer lnk = llList2Integer(prims, i);
       llSetLinkPrimitiveParamsFast(lnk, [PRIM_TEXTURE, ALL_SIDES, tex, <1,1,1>, <0,0,0> , 0]);
       llSetLinkAlpha(lnk, 0.0, ALL_SIDES); //1=visible, 0=transp
    }
}

cycle()
{   
    integer nextSide = lastSide + increment;    
    if (CYCLE_PING_PONG)    
        {        
        if (nextSide == numSides)        
        {            
            nextSide = numSides - 2;    
            increment = -1;
        }        
        else        
        if (nextSide == -1)        
            {            
                nextSide = 1;            
                increment = 1;        
            }    
        }    
        else        
            llSetLinkAlpha(lnk, 0.0, ALL_SIDES);
            nextSide = nextSide % numSides;
            llSetLinkAlpha(lnk, 1.0, nextSide);    
            llSetLinkAlpha(lnk, 0.0, lastSide);    
            lastSide = nextSide;
        }
        
    
default
    {  
     on_rez(integer start_param) {
        llResetScript();
    }  
    
    state_entry()    
    { 
        //init
        initialize();
        integer lnk;
        lnk = 1;
        llSetLinkAlpha(1, 1.0, 4); //(prim, alpha 1=visible, 0=transp, face)   
        
        //active
        numSides = llGetNumberOfSides();        
        llSetLinkAlpha(lnk, 0.0, ALL_SIDES);        
        llSetLinkAlpha(lnk, 1.0, lastSide);    
        llSetTimerEvent(SECS_PER_SIDE); 
    }
         
    link_message(integer link, integer value, string str, key id) {
         if (str == "People") {
             //state running;
             llSetTimerEvent(SECS_PER_SIDE);
             cycle();
             llSensorRepeat("THIS_SENSOR_SHOULD_NEVER_RETURN_TRUE","",0,2.0,PI,2.0);
             } 
        else if (str == "NoPeople"){
            llSetTimerEvent(0.0);
            }
    }
           
 touch_start(integer total_number)    
    {//do nothing
    }        
    
 timer()    {        
    ++count;        
    if (count%7 == 0)        {            
        //every ten seconds
        llSetLinkAlpha(lnk, 0.0, ALL_SIDES); //1=visible, 0=transp
        lnk = lnk+1;
        if (lnk > 3) lnk = 1;
        llSetLinkAlpha(lnk, 1.0, 0); //(prim, alpha 1=visible, 0=transp, face) 
        }  
 
     cycle();    
    }
    
}  