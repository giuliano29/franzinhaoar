integer ch=100701;
integer side = ALL_SIDES;

default
{
    state_entry()
    {
        llListen(ch,"",NULL_KEY,"");
    }

    listen(integer ch, string name, key id, string msg)
    {   
       if (llGetOwner() == llGetOwnerKey(id))
       { 
           llSetTexture(llGetSubString(msg,0,-1),side);
       }
    }
} 