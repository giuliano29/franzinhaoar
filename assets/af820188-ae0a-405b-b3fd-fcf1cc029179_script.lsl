
      
integer ch=100701;          //Same unique 5 digit number as controller.

integer side = ALL_SIDES;   //Side to apply the texture to.
                            // ALL_SIDES = All sides of the object.
                            // Numbers 1-8 = Face number of the object.

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////






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
}