show(){llSetAlpha(1.0, ALL_SIDES);} 
hide(){llSetAlpha(0, ALL_SIDES);} 

default
{
    state_entry()
    {
       // listen on your channel for any chat spoken by the object owner.
       //llListen(7654100,"",llGetOwner(),"");
        llListen(7654100,"",NULL_KEY,"");
    }
    
    listen(integer channel, string name, key id, string message) 
    { 
 // if(llStringLength(message)!=4)  wtf is this??
 // return;                   // no please continue
 // message = llToLower(message);    no need
 // llOwnerSay("Heard " + message);
 
 if (llGetOwnerKey(id) == llGetOwner()){
    
        if(message == "show"){ 
            show(); 
            } 

        else if(message == "hide"){ 
            hide(); 
            }
    }
}
} 