//(c)Eggy Lippmann 2004 - Licensed to SL players under the GPL
key hide="00000000-0000-2222-3333-100000001007";
key show="5748decc-f629-461c-9a36-a35a221fe21f";
default
{
    state_entry()
    {
        llListen(20,"","","");//SET lISTEN CHANNEL 0 IS OPEN CHAT
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }
    
    listen(integer c, string n, key k, string m)
    {
        if(m=="show") llSetTexture(show,ALL_SIDES);
        else if (m=="hide") llSetTexture(hide,ALL_SIDES);
    }
}
 