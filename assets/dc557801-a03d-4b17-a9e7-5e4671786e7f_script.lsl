integer channel = 171801;
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
        llSetLinkPrimitiveParamsFast(13, [PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 14, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 15, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 16, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 17, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 18, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 19, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 20, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 21, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 22, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 23, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 24, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 25, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 26, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 27, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 28, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 29, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 30, PRIM_TEXTURE, ALL_SIDES, message, <1,1,0>, <0,0,0>, 0,
                     PRIM_LINK_TARGET, 34, PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0, //Feet Flat
                     PRIM_LINK_TARGET, 35, PRIM_TEXTURE, 2, message, <1,1,0>, <0,0,0>, 0, //Feet Mid
                     PRIM_LINK_TARGET, 36, PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0]); //Feet High
        }
}}