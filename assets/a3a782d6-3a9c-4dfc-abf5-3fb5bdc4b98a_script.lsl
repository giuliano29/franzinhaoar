off(){llSetAlpha(0, ALL_SIDES);}
sh05(){llSetAlpha(1.0,0);}
sh04(){llSetAlpha(1.0,1);}
sh03(){llSetAlpha(1.0,2);}
sh02(){llSetAlpha(1.0,3);}
sh01(){llSetAlpha(1.0,4);}

default
{
    state_entry()
    {
        llListen(300999,"",NULL_KEY,"");
    }
    
    listen(integer channel, string name, key id, string message) 
    {if (llGetOwnerKey(id) == llGetOwner()) 

        if(message == "off") 
        { 
            off();
            return; 
        }         
        if(message == "show0") 
        { 
            off();
            sh01(); 
            return; 
        }
        if(message == "show5") 
        { 
            off();
            sh02(); 
            return; 
        }          
        if(message == "show7") 
        { 
            off();
            sh03(); 
            return; 
        }
        if(message == "show11") 
        { 
            off();
            sh04(); 
            return; 
        } 
        if(message == "show24") 
            off();
            sh05();
            return; 
    }
} 