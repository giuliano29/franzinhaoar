integer channel = 300301;
string message;
string texture1 = "a5d31268-f3f0-4f80-9080-364d0972c474";

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
        llSetLinkPrimitiveParamsFast(13, [PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 12, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 11, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 10, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 9, PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 8, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 7, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 5, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 5, PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 5, PRIM_TEXTURE, 7, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 5, PRIM_TEXTURE, 2, texture1, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 4, PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 3, PRIM_TEXTURE, 4, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 3, PRIM_TEXTURE, 5, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 3, PRIM_TEXTURE, 6, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 3, PRIM_TEXTURE, 7, message, <1,1,0>, <0,0,0>, 0]);
        }
}} 