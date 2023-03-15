float timeout = 60.0; // time out for menu 
integer pin = 19283;

integer chatChannel;
string  menuText = "Choose context of change.";
integer listenHandle;

float localRescale = 1;

default
{
    state_entry()
    {
        llSetRemoteScriptAccessPin(pin);   
    }
    
    changed (integer change)
    {
        if (change & CHANGED_OWNER)
        {
            localRescale = 1;
        }
    }

    link_message(integer source, integer num, string message, key id)
    {
        if (num == 124 && message == "DELETE")
        {
            llRemoveInventory(llGetScriptName());
            return;
        }
        
        if (num != 123 && num != 125)
        {
            return;
        }
        
        float scale = (float)message;
        vector tempVec = llGetScale();
        tempVec *= scale;
        llSetScale(tempVec);
        if (llGetLinkNumber() > 1)
        {
            vector tempje = llGetLocalPos();
            tempje *= scale;
            llSetPos(tempje);
        }
        
        if (num == 125)
        {
            float tempje = 1 / localRescale;
            llSetScale((llGetScale() * tempje));
            localRescale = 1;
        }
        
    }
    
    timer()
    {
        
        llSetTimerEvent(0);
        llListenRemove(listenHandle);
        listenHandle = FALSE;
    }
    
    touch_start(integer num)
    {
        if (llDetectedKey(0) != llGetOwner())
        {
            return;
        }
        
        if (!listenHandle)
        {
            chatChannel  = llRound(llFrand(10000000)) + 10;
            listenHandle = llListen(chatChannel, "", NULL_KEY, "");
            llSetTimerEvent(timeout);
        }
        
        llDialog(llGetOwner(), menuText, ["Resize"], chatChannel);
        
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id != llGetOwner())
        {
            return;
        }
        
        llSetTimerEvent(timeout); // Reset the timer.
        
        if (message == "Resize")
        {
            llMessageLinked(LINK_SET, 900, "MENU", NULL_KEY);
        }
        
        if (message == "This Prim")
        {
            llDialog(llGetOwner(), "Prim change menu", ["Scale +1%", "Scale -1%", "Revert"], chatChannel);
        }
        
        if (message == "Scale +1%")
        {
            localRescale *= 1.01;
            llSetScale((llGetScale() * 1.01));
            if (llGetLinkNumber() > 1)
            {
                vector tempje = llGetLocalPos();
                tempje *= 1.01;
                llSetPos(tempje);
            }
            llDialog(llGetOwner(), "Prim change menu", ["Scale +1%", "Scale -1%", "Revert"], chatChannel);
        }
        
        if (message == "Scale -1%")
        {
            localRescale *= 0.99;
            llSetScale((llGetScale() * 0.99));
            if (llGetLinkNumber() > 1)
            {
                vector tempje = llGetLocalPos();
                tempje *= 0.99;
                llSetPos(tempje);
            }
            llDialog(llGetOwner(), "Prim change menu", ["Scale +1%", "Scale -1%", "Revert"], chatChannel);
        }
        
        if (message == "Revert")
        {
            float tempje = 1 / localRescale;
            llSetScale((llGetScale() * tempje));
            localRescale = 1;
            llDialog(llGetOwner(), "Prim change menu", ["Scale +1%", "Scale -1%", "Revert"], chatChannel);
        }
            
    }
    
}