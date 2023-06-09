// :CATEGORY:Door
// :NAME:Door
// :AUTHOR:Ezhar Fairlight
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:250
// :NUM:341
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Door.lsl
// :CODE:

// improved door script by Ezhar Fairlight
// features: automatic closing, workaround for rotating out of position,
// doesn't mess up when moved, adjustable direction (inwards/outwards)
// updated for SL 1.1 damped rotations, small bugfix

// ********** USER SETTINGS HERE **********
float       TIMER_CLOSE = 5.0;      // automatically close the door after this many seconds,
                                    // set to 0 to disable

integer     DIRECTION   = -1;       // direction door opens in. Either 1 (outwards) or -1 (inwards);
// ********** END OF USER SETTINGS **********



integer     DOOR_OPEN   = 1;
integer     DOOR_CLOSE  = 2;

vector      mypos;      // door position (objects move a tiny amount
                        // away from their position each time they are rotated,
                        // thus we need to workaround this by resetting
                        // the position after rotating)
                        
door(integer what) {
    rotation    rot;
    rotation    delta;
    
    llSetTimerEvent(0); // kill any running timers
    
    if ( what == DOOR_OPEN ) {
        llTriggerSound("Door open", 0.8);
       
        rot = llGetRot();
        delta = llEuler2Rot(<0, 0, -DIRECTION * PI_BY_TWO>);
        rot = delta * rot;                  // rotate by -45 degree
        llSetRot(rot);
        
    } else if ( what == DOOR_CLOSE) {
        rot = llGetRot();
        delta = llEuler2Rot(<0, 0, DIRECTION * PI_BY_TWO>);    // rotate by 45 degree
        rot = delta * rot;
        llSetRot(rot);

        llTriggerSound("Door close", 0.8);
    }
}
        

default {   // is closed
    on_rez(integer start_param) { // reset, so we store the new position
        llResetScript();
    }
    
    state_entry() {
        mypos = llGetPos();     // remember where we're supposed to be
    }
    
    touch_start(integer total_number) {
        door(DOOR_OPEN);
        
        state is_open;
    }
    
    moving_end() {  // done moving me around, store new position
        mypos = llGetPos();
    }
}

state is_open {
    state_entry() {
        llSetTimerEvent(TIMER_CLOSE);
    }
    
    touch_start(integer num) {
        door(DOOR_CLOSE);
        
        llSetPos(mypos);        // workaround for tiny movements during rotation
        
        state default;
    }
    
    timer() { // it's time to close the door
        door(DOOR_CLOSE);
        
        llSetPos(mypos);        // workaround for tiny movements during rotation
        
        state default;
    }
    
    moving_start() { // close door when door is being moved
        door(DOOR_CLOSE);
        
        state default;
    }
}
// END //
 