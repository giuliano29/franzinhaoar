key player_id = NULL_KEY;
integer seat;

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        llSitTarget(<0.000000, 0.3, 0.20>, <0.000000, 0.000000, -0.707107, -0.707107>);
        seat = 1000 + (integer)llGetSubString(llGetObjectName(), 1,2);
    }

    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key seated = llAvatarOnSitTarget();

            if (seated != NULL_KEY && player_id == NULL_KEY)
            {
                llMessageLinked(LINK_ROOT, 1000, (string)seat, seated);
                llRequestPermissions(seated, PERMISSION_TRIGGER_ANIMATION);
                player_id = seated;
            }
            else if (seated == NULL_KEY && player_id != NULL_KEY)
            {
                llMessageLinked(LINK_ROOT, seat, "", "");
                player_id = NULL_KEY;
            }
        }
    }

    run_time_permissions(integer perm)
    {
        string anim = llGetInventoryName(INVENTORY_ANIMATION, 0);
        if (anim != "")
        {
            llStopAnimation("sit");
            llStopAnimation("sit_generic");
            llStopAnimation("sit_female");
            llStartAnimation(anim);
        }
    }

    link_message(integer sender_num, integer num, string message, key id)
    {
        if (num == 5555)
        {
            key seated = llAvatarOnSitTarget();
            if (seated != NULL_KEY)
            {
                llUnSit(seated);
                player_id = NULL_KEY;
            }
        }
    }
}