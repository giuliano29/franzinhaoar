float timeout = 60; // timeout for menu

integer chatChannel;
string  menuText = "Resize menu";

integer listenHandle;

float scaleChangesSinceRez = 1;
float scaleChangesSinceDefault = 1;

default
{

    state_entry()
    {
        listenHandle = FALSE;
    }
    
    on_rez(integer param)
    {
        scaleChangesSinceRez = 1;
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    
    run_time_permissions(integer perm)
    {
        integer i;
        // yeah yeah this is fake lol we get the perms we need anyway
        i++;    
    }
    
    changed (integer change)
    {
        if (change & CHANGED_OWNER)
        {
            scaleChangesSinceDefault = 1;
        }
    }
    
    link_message(integer source, integer num, string message, key id)
    {
        if (num == 900 && message == "MENU")
        {
        if (!listenHandle)
        {
            chatChannel  = llRound(llFrand(10000000)) + 10;
            listenHandle = llListen(chatChannel, "", NULL_KEY, "");
            llSetTimerEvent(timeout);
        }
        
        llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }
    }

    listen (integer channel, string name, key id, string message)
    {
        if (id != llGetOwner())
        {
            return;
        }
        llSetTimerEvent(timeout); // Reset the timer.
        
        if (message == "Scale +1%")
        {
            llMessageLinked(LINK_SET, 123, "1.01", NULL_KEY);
            scaleChangesSinceRez *= 1.01;
            scaleChangesSinceDefault *= 1.01;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }

        if (message == "Scale +5%")
        {
            llMessageLinked(LINK_SET, 123, "1.05", NULL_KEY);
            scaleChangesSinceRez *= 1.05;
            scaleChangesSinceDefault *= 1.05;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }

        if (message == "Scale +10%")
        {
            llMessageLinked(LINK_SET, 123, "1.10", NULL_KEY);
            scaleChangesSinceRez *= 1.10;
            scaleChangesSinceDefault *= 1.10;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }
        
        if (message == "Scale -1%")
        {
            llMessageLinked(LINK_SET, 123, "0.99", NULL_KEY);
            scaleChangesSinceRez *= .99;
            scaleChangesSinceDefault *= .99;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }
        
        if (message == "Scale -5%")
        {
            llMessageLinked(LINK_SET, 123, "0.95", NULL_KEY);
            scaleChangesSinceRez *= .95;
            scaleChangesSinceDefault *= .95;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }

        if (message == "Scale -10%")
        {
            llMessageLinked(LINK_SET, 123, "0.90", NULL_KEY);
            scaleChangesSinceRez *= .90;
            scaleChangesSinceDefault *= .90;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }

        if (message == "Restore")
        {
            llDialog(id, "Choose to revert to store default or to last rez default", ["Store", "Last Rez"], chatChannel);
        }
        
        if (message == "Store")
        {
            float tempje = 1 / scaleChangesSinceDefault;
            scaleChangesSinceRez *= tempje;
            llMessageLinked(LINK_SET, 125, (string)tempje, NULL_KEY);
            scaleChangesSinceDefault = 1;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }

        if (message == "Last Rez")
        {
            float tempje = 1 / scaleChangesSinceRez;
            scaleChangesSinceDefault *= tempje;
            llMessageLinked(LINK_SET, 125, (string)tempje, NULL_KEY);
            scaleChangesSinceRez = 1;
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }

        if (message == "Pose")
        {
            llDialog(id, "Start or stop pose mode. For easy viewing.", ["Start", "Stop"], chatChannel);
        }
        
        if (message == "Start")
        {
            llStartAnimation("turn_180");
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }
        
        if (message == "Stop")
        {
            llStopAnimation("turn_180");
            llDialog(llGetOwner(), menuText, ["Restore", "Pose", "Delete", "Scale -1%", "Scale -5%", "Scale -10%","Scale +1%", "Scale +5%", "Scale +10%"], chatChannel);
        }
        
        if (message == "Delete")
        {
            llMessageLinked(LINK_SET, 124, "DELETE", NULL_KEY);
            llRemoveInventory(llGetScriptName());
        }
        
        
    }
    
    
    timer()
    {
        
        llSetTimerEvent(0);
        llListenRemove(listenHandle);
        listenHandle = FALSE;
    }

    
    
}