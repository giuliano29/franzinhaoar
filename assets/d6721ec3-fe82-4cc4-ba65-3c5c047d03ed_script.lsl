integer channel;
integer penis_channel;
integer listener=-1;
string anim;

list Wanks = ["Wank1", "Wank2", "Werk3", "Wank4", "Wank5", "Wank6"];

list buttons = [
"main",
"main",
"rotate 0 0",
"stop",
"pre",
"cum",
"piss", //6
"hide",
"show 7", 
"show 6", 
"show 5", 
"sizedown",
"sizeup",
"more",
"null",
"null"
];



StartAnim(string anim)
{
    integer i;
    for (i=0; i < llGetListLength(Wanks); i++)
        llStopAnimation(llList2String(Wanks, i));

        if (anim != "")
            llStartAnimation(anim);
}


startListening()
{
   if (listener != -1)  llListenRemove(listener);
   channel = -1 - (integer)("0x" + llGetSubString( (string) llGetOwner(), -6, -1) )-3993 ;
   penis_channel = -1 - (integer)("0x" + llGetSubString( (string) llGetOwner(), -6, -1) )-3994 ;
   //listener = llListen(channel, "","","");
}


default
{
    state_entry()
    {
        startListening();
    }
    
    on_rez(integer n)
    {
        startListening();
    }
    
    touch_start(integer n)
    {
     
        string cmd;
        integer lnk = llDetectedLinkNumber(0);
      // llOwnerSay("l="+(string)lnk);

        if (lnk>1)
        {
            cmd = llList2String(buttons, lnk);
            if (cmd == "more")
            {
                if (listener == -1)
                    listener = llListen(channel, "", "","");
                
                llDialog(llGetOwner(), "Extras", ["Drips", "Ass Drip","Cancel", "Fart", "Cumfart", "Wank5", "Wank4", "Wank1", "Wank2", "Wank3"],  channel);
                llSetTimerEvent(60);
                return;
            }
        }
        else
        {
            vector pos = llDetectedTouchST(0);
            cmd =  "rotate "+(string)(pos.x-0.5) + " " + (string)(pos.y-0.5);
        }

        if (cmd == "stop")
                StartAnim("");    //Special - stop anims

        llSay(penis_channel, cmd);
    }
    
    listen(integer ch, string w, key id, string msg)
    {
        if (ch != channel) return;
        if (msg == "Wank1" || msg == "Wank2" ||msg == "Wank3" ||msg == "Wank4" ||msg == "Wank5" ||msg == "Wank6")
        {
            integer perm = llGetPermissions();
            if (! (perm & PERMISSION_TRIGGER_ANIMATION)) // remember to use bitwise operators!
            {
                llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION); // request permissions from the owner.
                anim = msg;
            }                
            else 
            {
                anim = msg;
                StartAnim(msg);
            }
        }
        else if (msg == "Cancel")
            return;
        else
        {
            llSay(penis_channel, msg);
        }

    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
             StartAnim(anim);
        }
    }

    timer() 
    {
        if (listener>0)
        {
            llListenRemove(listener);
            listener = -1;
        }
        llSetTimerEvent(0);
    }
 
    changed(integer change)
    {
        if (change & CHANGED_OWNER) //note that it's & and not &&... it's bitwise!
        {
            llResetScript();
        }
    }
    
}