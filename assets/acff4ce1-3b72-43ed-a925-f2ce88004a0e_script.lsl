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
            llSetTimerEvent(8.0);
    }
 
    timer()
    {
        llStartAnimation("Cligne-mina-003-Petite pause oeil clot 36");
    }
} 