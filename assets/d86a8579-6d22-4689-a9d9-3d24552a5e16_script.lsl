show(){llSetAlpha(1.0, ALL_SIDES);} 
hide(){llSetAlpha(0, ALL_SIDES);} 

default
{
    state_entry()
    {llListen(7654300,"",NULL_KEY,"");}
    
    listen(integer channel, string name, key id, string message) 
    {if (llGetOwnerKey(id) == llGetOwner())
        {if(message == "show")
            {show();} 

        else if(message == "hide")
            {hide();}
        }
}} 