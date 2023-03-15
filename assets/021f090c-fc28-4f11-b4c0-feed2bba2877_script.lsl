integer channel = 181801;
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
        llSetLinkPrimitiveParamsFast(32, [PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,//Left Hand
                     PRIM_LINK_TARGET,32, PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,//Left Hand
                     PRIM_LINK_TARGET,32, PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0,//Left Hand
                     PRIM_LINK_TARGET,32, PRIM_TEXTURE, 3, message, <1,1,0>, <0,0,0>, 0,//Left Hand
                     PRIM_LINK_TARGET,32, PRIM_TEXTURE, 4, message, <1,1,0>, <0,0,0>, 0,//Left Hand
                     PRIM_LINK_TARGET,33, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,//Right Hand
                     PRIM_LINK_TARGET,33, PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,//Right Hand
                     PRIM_LINK_TARGET,33, PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0,//Right Hand
                     PRIM_LINK_TARGET,33, PRIM_TEXTURE, 3, message, <1,1,0>, <0,0,0>, 0,//Right Hand
                     PRIM_LINK_TARGET,33, PRIM_TEXTURE, 4, message, <1,1,0>, <0,0,0>, 0]);//Right Hand
        }
}}