integer channel = 300302;
string message;

default
    {
    state_entry()
    {
    llListen( channel, "", NULL_KEY, "" );
    }
    listen( integer channel, string name, key id, string message )
    {
string touchid = (string)llGetObjectDetails(id, [OBJECT_OWNER]);
string ownerid = llGetOwner();

    if(ownerid == touchid)
        {
        llSetLinkPrimitiveParamsFast(3, [PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 3, PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 4, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0]);
        }
}} 