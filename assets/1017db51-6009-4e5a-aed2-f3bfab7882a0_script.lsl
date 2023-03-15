//  be happy
 
default
{
    attach(key attached)
    {
        if (attached)
            llResetScript();
    //  else
    //      has been detached
    }
 
    state_entry()
    {
        key owner = llGetOwner();
 
        llRequestPermissions(owner, PERMISSION_TRIGGER_ANIMATION);
    }
 
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
            llSetTimerEvent(35.0);
    }
 
    timer()
    {
        llStartAnimation("010-v8-ANIMATION GLOBALE 001");
    }
} 