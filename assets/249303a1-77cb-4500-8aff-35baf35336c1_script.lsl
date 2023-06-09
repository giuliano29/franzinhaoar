integer running = FALSE;

default
{
    
    on_rez(integer p) {
        llResetScript();
    }
    changed(integer what) {
        if (what & CHANGED_REGION_RESTART) {
            llResetScript();
        }
    }
    
    state_entry()
    {
        llSensorRepeat("","",AGENT,50,PI,10);
    }
    
    sensor(integer n) {
        if (! running++) {
            llMessageLinked(LINK_SET,99,"People","");
            //llOwnerSay("Debug !Senson: There ARE People");
        }
    }
    no_sensor()
    {
        if (running)  {
            llMessageLinked(LINK_SET,99,"NoPeople","");
            //llOwnerSay("Debug !Sensor: No People");
            
        }
            
        running = FALSE;
    }
}
 