// By Theda Twilight

string ANIM = "eyeblink";

default {
    state_entry() {
        llSetTimerEvent(0.0);
    }
    
    attach(key attached) {
        if (attached != NULL_KEY) {
            llRequestPermissions(attached, PERMISSION_TRIGGER_ANIMATION);
        } else {
            llSetTimerEvent(0.1);
        }
    }

    run_time_permissions(integer perms) {
        if(perms & (PERMISSION_TRIGGER_ANIMATION)) {
            llSetTimerEvent(0.1);
        }
    }

    timer() {
        llStartAnimation(ANIM);
    }

}
 
 