default
{
        state_entry()
        {
                llListen( -37641, "", NULL_KEY, "" );
        }
  
        listen( integer channel, string name, key id, string message )
        {if (llGetOwnerKey(id) == llGetOwner())
            
                if ( message == "ns1" )
                {
                 llSetLinkPrimitiveParamsFast(13,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(12,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(11,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(10,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(9,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 1]);
                }
                else if ( message == "ns2" )
                {
                 llSetLinkPrimitiveParamsFast(13,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(12,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(11,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(10,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 1]);
                 llSetLinkPrimitiveParamsFast(9,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                }
                else if ( message == "ns3" )
                {
                 llSetLinkPrimitiveParamsFast(13,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(12,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(11,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 1]);
                 llSetLinkPrimitiveParamsFast(10,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(9,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                }
                else if ( message == "ns4" )
                {
                 llSetLinkPrimitiveParamsFast(13,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(12,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 1]);
                 llSetLinkPrimitiveParamsFast(11,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(10,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(9,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                }
                else if ( message == "ns5" )
                {
                 llSetLinkPrimitiveParamsFast(13,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 1]);
                 llSetLinkPrimitiveParamsFast(12,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(11,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(10,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(9,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                }
                else if ( message == "hneck" )
                {
                 llSetLinkPrimitiveParamsFast(13,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(12,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(11,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(10,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(9,[PRIM_COLOR, ALL_SIDES,<1,1,1>, 0]);
                }
                else if ( message == "sle" )
                {
                 llSetLinkPrimitiveParamsFast(5,[PRIM_COLOR, 0,<1,1,1>, 1]);
                 llSetLinkPrimitiveParamsFast(3,[PRIM_COLOR, 2,<1,1,1>, 0]);
                }
                else if ( message == "hle" )
                {
                 llSetLinkPrimitiveParamsFast(5,[PRIM_COLOR, 0,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(3,[PRIM_COLOR, 2,<1,1,1>, 1]);
                }
                else if ( message == "sre" )
                {
                 llSetLinkPrimitiveParamsFast(5,[PRIM_COLOR, 1,<1,1,1>, 1]);
                 llSetLinkPrimitiveParamsFast(3,[PRIM_COLOR, 3,<1,1,1>, 0]);
                }
                else if ( message == "hre" )
                {
                 llSetLinkPrimitiveParamsFast(5,[PRIM_COLOR, 1,<1,1,1>, 0]);
                 llSetLinkPrimitiveParamsFast(3,[PRIM_COLOR, 3,<1,1,1>, 1]);
                }
}} 