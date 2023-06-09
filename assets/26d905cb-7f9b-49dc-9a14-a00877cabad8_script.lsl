string product = "BBHappyHeels";

integer Channel;
integer Handle;

integer Key2Chan(key ID)
{
  return 0x80000000 | (integer)("0x"+(string)ID);
}

default
{
  state_entry()
  {
    Channel = Key2Chan(llGetOwner());
    Handle = llListen(Channel, "", "", "");
  }
  
  listen(integer channel, string name, key id, string message)
  {
    if (llGetOwnerKey(id) == llGetOwner())
    {
      list data = llParseString2List(message, ["|"], []);
      
      if (llList2String(data, 0) == product)
      {
        llSetTexture(llList2String(data, 1), (integer)llList2String(data, 2));
      }
    }
  }
  
  changed(integer change)
  {
    if (change & CHANGED_OWNER)
    {
      llResetScript();
    }
  }
}  