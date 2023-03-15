integer channel = 191801;
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
        llSetLinkPrimitiveParamsFast(34, [PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,//Feet Flat
                     PRIM_LINK_TARGET,35, PRIM_TEXTURE, 1, message, <1,1,0>, <0,0,0>, 0,//Feet Mid
                     PRIM_LINK_TARGET,36, PRIM_TEXTURE, 0, message, <1,1,0>, <0,0,0>, 0]);//Feet High
        }
}} 