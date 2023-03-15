integer channel = 171800;
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
        llSetLinkPrimitiveParamsFast(2, [PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 3, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 4, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 5, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 6, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 7, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 8, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 9, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 10, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 11, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 12, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 32, PRIM_TEXTURE, 5, message, <1,1,0>, <0,0,0>, 0, //Hand Skin
                     PRIM_LINK_TARGET, 33, PRIM_TEXTURE, 5, message, <1,1,0>, <0,0,0>, 0]); //Hand Skin
        }
}}