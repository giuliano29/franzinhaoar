default
{ 
    state_entry() {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    on_rez(integer start_param) {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llStopAnimation("AnkleLock");
            llStartAnimation("AnkleLock");
            llSetTimerEvent(3);
        }
    }
    timer() {
        llSetTimerEvent(0);
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
} 