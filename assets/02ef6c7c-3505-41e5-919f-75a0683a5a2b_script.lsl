integer ch2=191801;

default
{
   state_entry()
   {
       llListen(ch2,"",NULL_KEY,"");       
   }

   listen(integer channel, string name, key id, string msg)
     {
       if (llGetOwner() == llGetOwnerKey(id))
        { 

            llSetTexture(llGetSubString(msg,0,-1),1);           
        }
     }
} 