// sensor variables
float sensor_interval = 2.0;    // interval between scans in seconds
float sensor_range = 40.0;        // range in meters
//other variables   
float SECS_PER_SIDE = 3;
integer CYCLE_PING_PONG = TRUE;
integer increment = 1;
integer numSides;
integer lastSide;
integer cycling;
integer colsound = 0;

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
            nextSide = nextSide % numSides;
            llSetAlpha(1.0, nextSide);    
            llSetAlpha(0.0, lastSide);    
            lastSide = nextSide;
        }
        
default
    {    
     on_rez(integer start_param) {
        llResetScript();
    }
    state_entry()    
        {        
        numSides = llGetNumberOfSides();        
        if (numSides < 2)        
            {            
            string scriptName = llGetScriptName();            
            //llSay(DEBUG_CHANNEL, scriptName + " disabled. Only works in multi-sided elements.");
            //llSetScriptState(scriptName, FALSE);        
            }        
            llSetAlpha(0.0, ALL_SIDES);        
            llSetAlpha(1.0, lastSide); 
         llSetTimerEvent(sensor_interval); //Repeats the sensor.
        }
        link_message(integer link, integer value, string str, key id) {
        if (str == "People") {
            //content here
            //state running;
            llSetTimerEvent(SECS_PER_SIDE);
            cycle();
            llSensorRepeat("THIS_SENSOR_SHOULD_NEVER_RETURN_TRUE","",0,2.0,PI,2.0);
        } else if (str == "NoPeople"){
            llSetTimerEvent(0.0);
        }
// end of Default          
    }               
           
touch_start(integer total_number)    
    {//do nothing
    }        
timer()    
    {  cycle();    }
} 