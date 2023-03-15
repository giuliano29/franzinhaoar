////////////////////////////////////////////////////////////////////
// RenderWorks Advanced Texture Change HUD Scripts 1.0 /////////////
////////////////////////////////////////////////////////////////////
// OpenSource Script For SecondLife and OpenSimulator //////////////
// Licensed under Creative Commons Attribution 4.0 International ///
////////////////////////////////////////////////////////////////////
// This script by RenderWorks may be used in any manner, modified //
// and republished. Unless specified otherwise, our scripts are ////
// always open source. Objects made with these scripts may be sold /
// with no restrictions. ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////

         string config = ".config"; //Configuration notecard name.
string startingreading = "Started reading configuration notecard...."; //Started reading message.
string missingnotecard = "Missing inventory notecard: "; //Missing notecard message.
string finishedreading = "Finished reading configuration notecard!"; //Finished reading message.
string nomatchfound = "No match found for msg!"; //Finished reading message.

////////////////////////////////////////////////////////////////////

string  CHANNEL; // Channel for comms (Must be same as reciever).

string SR = "*"; // Seperator to use in the list, must be the same
                 // as the seperator to be used within the reviever
                 // script.

////////////////////////////////////////////////////////////////////

 list texturedetails;
list CONFIGlist;
 string TEXTURE;
 string LINK;
 string FACE;
 string OBJECTDESC;
////////////////////////////////////////////////////////////////////

integer line;
key readLine_id;

init()
{
     CHANNEL="-4001"; //Reset configuration values to default.
    
    if(llGetInventoryType(config) != INVENTORY_NOTECARD)// Make sure the file exists and is a notecard.
    {
        llOwnerSay(missingnotecard + config);// Notify owner of missing file.
        return; // Don't do anything else.
    }
    
    llOwnerSay(startingreading); //Notify owner we have started reading.
    
    line = 0;// Initialise to start reading from first line.
    
    readLine_id = llGetNotecardLine(config, line++); //Read the first line.
}

////////////////////////////////////////////////////////////////////

processConfiguration(string data)
{
    if(data == EOF) //If we are at the end of the file.
    {
        llOwnerSay(finishedreading); //Notify owner we have finished reading.
        
        state ready; //Go to the ready state where all further user actions will happen.
        
        return; //Do not do anything else.
    }
    
    if(data != "") //If line if not empty.
    {
        if(llSubStringIndex(data, "#") != 0) //If line does not begin with comment.
        {
   
           // Parse the string with the * seperator.
           texturedetails = llParseString2List(data,["*"],[""]);
           
           // Take the first parsed element and set it as the texture key.
           OBJECTDESC = llList2String(texturedetails, 0);

           // Take the second parsed element and set it as the texture key.
           TEXTURE = llList2String(texturedetails, 1);
           
           // Take the third parsed element and set it as the link number.
           LINK = llList2String(texturedetails, 2);
           
           // Take the fourth parsed element and set it as the face number.
           FACE = llList2String(texturedetails, 3);

       CONFIGlist = CONFIGlist + [ OBJECTDESC , TEXTURE , LINK , FACE ];
        }
    }
    
    readLine_id = llGetNotecardLine(config, line++);//Read the next line.
}

////////////////////////////////////////////////////////////////////

default
{
    state_entry()
    {
        init(); //Initialise the notecard reader when the script first starts.
    }

    changed(integer change)
    {
        if(change & CHANGED_INVENTORY){init();} //Initialise the notecard reader when the inventory changes.
    }

    dataserver(key request_id, string data)
    {
        if(request_id == readLine_id)
            processConfiguration(data);
    }
}

////////////////////////////////////////////////////////////////////

state ready
{
    
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY){llResetScript();} //Reset the script when the inventory changes.
    }
    
    state_entry() // Script has started.
   {
       // Begin listening on 'channel' for any messages.
       llListen((integer)CHANNEL,"",NULL_KEY,"");
   }
   
   listen(integer channel, string name, key id, string msg)
   {
       // If the message is from the owner of both objects.
       if (llGetOwner() == llGetOwnerKey(id))
       {
        integer c;
        integer length = llGetListLength(CONFIGlist);
        for( c=0 ; c < length ; c=c+4  ) {
            if (msg == llList2String(CONFIGlist, c) ) {
               llSetLinkTexture((integer) llList2String(CONFIGlist, c+2),
                                (key) llList2String(CONFIGlist, c+1),
                                (integer) llList2String(CONFIGlist, c+3));
            return ;
            }
        }
       // llOwnerSay(nomatchfound); //Notify owner 
    }
    return ;    
}
}
