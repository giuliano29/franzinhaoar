// Channel for Listen 
integer AlphaChanel       = -50;
integer FeetNailsChannel  = 191801;
integer HandNailsChannel  = 181801;
integer LowerSkinChannel  = 171801;
integer UpperSkinChannel  = 171800;
integer NeckSkinChannel   = 171802;
integer FeetNormalChannel = 7654100;
integer FeetMiddleChannel = 7654200;
integer FeetHighChannel   = 7654300;
integer HandChannel       = -37641;
integer NeckSizeChannel   = 300999;
integer internalApi       = 8676589;

key shoesUUID;

showhideFeetAlpha(integer link, string cmd)
{
  if (cmd == "show")
  {
    llSetLinkAlpha(link, 1, ALL_SIDES);
  }
  else
  {
    llSetLinkAlpha(link, 0, ALL_SIDES);
  }
}

showhideHandFaces(integer link, string cmd)
{
  llSetLinkAlpha(link, 0.0, 0);
  llSetLinkAlpha(link, 0.0, 1);
  llSetLinkAlpha(link, 0.0, 2);
  llSetLinkAlpha(link, 0.0, 3);
  llSetLinkAlpha(link, 0.0, 4);
  
  if (cmd == "sf0")
  {
    llSetLinkAlpha(link, 1.0, 0);
  }
  else if (cmd == "sf4")
  {
    llSetLinkAlpha(link, 1.0, 1);
  }
  else if (cmd == "sf1")
  {
    llSetLinkAlpha(link, 1.0, 2);
  }
  else if (cmd == "sf2")
  {
    llSetLinkAlpha(link, 1.0, 3);
  }
  else if (cmd == "sf3")
  {
    llSetLinkAlpha(link, 1.0, 4);
  }
  else if ((cmd == "rhand" && link == 32) || (cmd == "lhand" && link == 33))
  {
    llSetLinkAlpha(link, 1.0, 2);
    llSetLinkAlpha(link, 1.0, 5);
  }
}

default
{
  state_entry()
  {
    llSetTimerEvent(0);
    llListen(AlphaChanel,"","","");
    llListen(FeetNailsChannel,"","","");
    llListen(HandNailsChannel,"","","");
    llListen(LowerSkinChannel,"","","");
    llListen(UpperSkinChannel,"","","");
    llListen(NeckSkinChannel,"","","");
    llListen(FeetNormalChannel,"","","");
    llListen(FeetMiddleChannel,"","","");
    llListen(FeetHighChannel,"","","");
    llListen(HandChannel,"","","");
    llListen(NeckSizeChannel,"","","");
    llListen(internalApi,"","","");
    llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR,ALL_SIDES, <1.000, 1.000, 1.000>, 0]);
    llSetLinkPrimitiveParamsFast(31, [PRIM_COLOR,ALL_SIDES, <1.000, 1.000, 1.000>, 0]);
  }

  attach(key attached) 
  {
    if (attached != NULL_KEY) 
    {
      llRequestPermissions(attached, PERMISSION_TRIGGER_ANIMATION);
    } 
    else 
    {
      llSetTimerEvent(0);
    }
  }
  
  run_time_permissions(integer perms) 
  {
    if(perms & PERMISSION_TRIGGER_ANIMATION) 
    {
      llStartAnimation("AnkleLock");
      llSetTimerEvent(1);
    }
  }

  timer() 
  {
    llStopAnimation("AnkleLock");
    llStartAnimation("AnkleLock");
    
//    if (shoesUUID != NULL_KEY && llListFindList(llGetAttachedList(llGetOwner()), [shoesUUID]) == -1)
//    {
//      showhideFeetAlpha(34 , "show");
//      showhideFeetAlpha(35 , "hide");
//      showhideFeetAlpha(36 , "hide");
//      shoesUUID = NULL_KEY;
//      llSetTimerEvent(0);
//    } // jenni mod
  }
  
  listen(integer channel,string name,key id,string message)
  {
    if (llGetOwnerKey(id) == llGetOwner())
    {
      if (channel == AlphaChanel)
      {
        if (message=="Reset")
        {
          llSetLinkPrimitiveParamsFast( 2, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET,  3,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET,  4,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET,  5,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET,  6,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET,  7,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET,  8,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET,  9,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 10,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 11,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 12,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 13,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 14,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 15,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 16,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 17,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 18,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 19,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 20,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 21,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 22,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 23,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 24,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 25,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 26,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 27,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 28,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 29,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 30,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1,
                     PRIM_LINK_TARGET, 31,  PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1]);                        
        } 
          
        if (llGetSubString(message,0,0) == "P")
        {
          integer link;
          integer face;
        
          if ((integer)llGetSubString(message,1,-1) >= 100)
          { 
            link = (integer)llGetSubString(message,1,2);
            face = (integer)llGetSubString(message,3,3);
          }
          else
          {
            link = (integer)llGetSubString(message,1,1);
            face = (integer)llGetSubString(message,2,2);
          }
        
          list value = llGetLinkPrimitiveParams(link, [PRIM_COLOR,face]);
          float alpha = llList2Float(value, 1);
          vector color = llList2Vector(value,0);
  
          if(alpha == 0)
          {   
            llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, color, 1]);
          }
          else 
          {   
            llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, color, 0]);
          } 
        }
      }
      else if (channel == FeetNailsChannel)
      {
        llSetLinkPrimitiveParamsFast(34, [PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,   //Feet Flat
                   PRIM_LINK_TARGET, 35,  PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,   //Feet Mid
                   PRIM_LINK_TARGET, 36,  PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0]); //Feet High
      }
      else if (channel == HandNailsChannel)
      {
        llSetLinkPrimitiveParamsFast(32, [PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,   //Left Hand
                   PRIM_LINK_TARGET, 32,  PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,   //Left Hand
                   PRIM_LINK_TARGET, 32,  PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0,   //Left Hand
                   PRIM_LINK_TARGET, 32,  PRIM_TEXTURE, 3, message, <1,1,0>, <0,0,0>, 0,   //Left Hand
                   PRIM_LINK_TARGET, 32,  PRIM_TEXTURE, 4, message, <1,1,0>, <0,0,0>, 0,   //Left Hand
                   PRIM_LINK_TARGET, 33,  PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,   //Right Hand
                   PRIM_LINK_TARGET, 33,  PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,   //Right Hand
                   PRIM_LINK_TARGET, 33,  PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0,   //Right Hand
                   PRIM_LINK_TARGET, 33,  PRIM_TEXTURE, 3, message, <1,1,0>, <0,0,0>, 0,   //Right Hand
                   PRIM_LINK_TARGET, 33,  PRIM_TEXTURE, 4, message, <1,1,0>, <0,0,0>, 0]); //Right Hand      
      }
      else if (channel == LowerSkinChannel)
      {
        llSetLinkPrimitiveParamsFast(13, [PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 14,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 15,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 16,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 17,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 18,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 19,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 20,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 21,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 22,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 23,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 24,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 25,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 26,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 27,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 28,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 29,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 30,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 34,  PRIM_TEXTURE, 2        , message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 35,  PRIM_TEXTURE, 2        , message, <1,1,0>, <0,0,0>, 0, 
                   PRIM_LINK_TARGET, 36,  PRIM_TEXTURE, 1        , message, <1,1,0>, <0,0,0>, 0]);      
      }
      else if (channel == UpperSkinChannel)
      {
        llSetLinkPrimitiveParamsFast( 2, [PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET,  3,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET,  4,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET,  5,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET,  6,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET,  7,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET,  8,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET,  9,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 10,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 11,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 12,  PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 32,  PRIM_TEXTURE, 5        , message, <1,1,0>, <0,0,0>, 0,
                   PRIM_LINK_TARGET, 33,  PRIM_TEXTURE, 5        , message, <1,1,0>, <0,0,0>, 0]);      
      }
      else if (channel == NeckSkinChannel)
      {
        llSetLinkTexture(31, message, ALL_SIDES);
      }
      else if (channel == FeetNormalChannel)
      {
        showhideFeetAlpha(34 , message);
      }
      else if (channel == FeetMiddleChannel)
      {
        showhideFeetAlpha(35 , message);
      }
      else if (channel == FeetHighChannel)
      {
        showhideFeetAlpha(36 , message);
      }
      else if (channel == HandChannel)
      {
        showhideHandFaces(32 , message);
        showhideHandFaces(33 , message);
      }
      else if (channel == NeckSizeChannel)
      {
        llSetLinkAlpha(31, 0, ALL_SIDES);
        
        if(message == "show0") 
        { 
          llSetLinkAlpha(31, 1, 4);
        }
        if(message == "show5") 
        { 
          llSetLinkAlpha(31, 1, 3); 
        }          
        if(message == "show7") 
        { 
          llSetLinkAlpha(31, 1, 2); 
        }
        if(message == "show11") 
        { 
          llSetLinkAlpha(31, 1, 1);
        }
        if(message == "show24") 
        {
          llSetLinkAlpha(31, 1, 0); 
        }      
      }
      else if (channel == internalApi)
      {
//        if (llListFindList(llGetAttachedList(llGetOwner()), [id]) == -1)
//        {
//          return;
//        }  // jenni mod
        
        shoesUUID = id;
        llSetTimerEvent(1);
        
        list data = llParseString2List(message, ["|"], []);
        
        string cmd = llList2String(data, 0);
        string val = llList2String(data, 1);
        
        if (cmd == "selectFeet")
        {
          showhideFeetAlpha(34 , "hide");
          showhideFeetAlpha(35 , "hide");
          showhideFeetAlpha(36 , "hide");
          
          if (val == "high")
          {
            showhideFeetAlpha(36 , "show");
          }
          else if (val == "middle")
          {
            showhideFeetAlpha(35 , "show");
          }
          else
          {
            showhideFeetAlpha(34 , "show");
          }
        }
      }
    }
  }
} 