integer flag = 0;
integer level=0;
string anim ; 
string drink;
integer foodValue;
list showLinks;
key drinkTexture;
vector drinkColor;
integer channel = 87924828;

setColor(string nm, vector color, float alpha, key texture)
{
    integer lnk;
    for (lnk=2; lnk <= llGetNumberOfPrims(); lnk++)
    {
        if (llGetLinkName(lnk) == nm)
        {
            llSetLinkPrimitiveParamsFast(lnk, [PRIM_COLOR, ALL_SIDES, color,  alpha]);
            if (texture != "") llSetLinkTexture(lnk, texture, ALL_SIDES);
        }
    }
}


refresh()
{
    llSetLinkAlpha(LINK_ALL_CHILDREN, 0.,ALL_SIDES);
    integer i;
    for (i=0; i < llGetListLength(showLinks); i++)
    {
        if (level>0 && llList2String(showLinks,i) == "drink")
        {
            setColor(llList2String(showLinks,i), drinkColor, 1.0, (key)drinkTexture);
        }
        else
            setColor(llList2String(showLinks,i), <1,1,1>, 1.0, "");
    }
}

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION); //asks the owner's permission
        llListen(channel, "", "","");

    }
 
    run_time_permissions(integer parm)
    {
        if(parm & PERMISSION_TRIGGER_ANIMATION) //triggers animation
        {
            llStartAnimation("hold_R_handgun"); //animation to play
            refresh();
        }
    }
 
 
    on_rez(integer st)
    {
        llResetScript();
    }
 
    attach(key id)
    {
        if(id == NULL_KEY)
        {
            // we've been detached
            if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)
            {
                llStopAnimation("hold_R_handgun"); // stop if we have permission
                llStopAnimation("drunk2"); // stop if we have permission
                llStopAnimation("sipping"); // stop if we have permission
            }
        }
    }
 
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        {
            if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)
                llStopAnimation("hold_R_handgun"); // stop if we have permission
            llResetScript(); // re-initialize with new owner
        }
    }
 
    timer()
    {
        string  nanim = "sipping";;
        refresh(); 
        
        if (level > 100)
        {            
            level = 90;
            llStopAnimation("faint");
            llStartAnimation("faint");
            llOwnerSay("You have fainted! Stop eating so much!");
        }
        else if (level>0)    level -= 5;

        //llStartAnimation("sipping");
        //llSleep(2);
        //llStopAnimation("sipping"); 

        llStopAnimation("hold_r_handgun"); 
        llStartAnimation("hold_r_handgun");
        llSetTimerEvent(60);
    }
    
    //dataserver(key k, string m)
    listen(integer c, string w, key id, string m)
    {
            list tk = llParseStringKeepNulls(m, ["|"] , []);
            string cmd = llList2Key(tk,0);
            if (cmd  == "REFILL" ) 
            {
                drink = llList2String(tk, 2);
                foodValue = llList2Integer(tk, 4);
                //drunkSips  =  llList2Integer(tk, 4);
                
                drinkTexture = llList2Key(tk, 6);
                drinkColor = llList2Key(tk, 7);
                showLinks = "drink";
                //llOwnerSay("txt  "+(string) drinkTexture);
                level += foodValue;
                llSetTimerEvent(1);
            }
            else if (cmd == "SHOW")
            {
                showLinks += llParseString2List(llList2String(tk, 2), [","], []);
                refresh();
            }
    }
}
 