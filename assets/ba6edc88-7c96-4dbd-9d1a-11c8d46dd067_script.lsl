default
{
        state_entry()
        {
                llListen( -37641, "", NULL_KEY, "" );
        }
  
        listen( integer channel, string name, key id, string message )
        {if (llGetOwnerKey(id) == llGetOwner())
            
                if ( message == "sf0" )
                {
                        llSetAlpha(1.0, 0);
                        llSetAlpha(0.0, 1);
                        llSetAlpha(0.0, 2);
                        llSetAlpha(0.0, 3);
                        llSetAlpha(0.0, 4);
                        
                }
                else if ( message == "sf1" )
                {
                        llSetAlpha(0.0, 0);
                        llSetAlpha(1.0, 1);
                        llSetAlpha(0.0, 2);
                        llSetAlpha(0.0, 3);
                        llSetAlpha(0.0, 4);
                }
                else if ( message == "sf2" )
                {
                        llSetAlpha(0.0, 0);
                        llSetAlpha(0.0, 1);
                        llSetAlpha(1.0, 2);
                        llSetAlpha(0.0, 3);
                        llSetAlpha(0.0, 4);
                }
                else if ( message == "sf3" )
                {
                        llSetAlpha(0.0, 0);
                        llSetAlpha(0.0, 1);
                        llSetAlpha(0.0, 2);
                        llSetAlpha(1.0, 3);
                        llSetAlpha(0.0, 4);
                }
                else if ( message == "sf4" )
                {
                        llSetAlpha(0.0, 0);
                        llSetAlpha(0.0, 1);
                        llSetAlpha(0.0, 2);
                        llSetAlpha(0.0, 3);
                        llSetAlpha(1.0, 4);
                }
                else if ( message == "haf" )
                {
                        llSetAlpha(0.0, 0);
                        llSetAlpha(0.0, 1);
                        llSetAlpha(0.0, 2);
                        llSetAlpha(0.0, 3);
                        llSetAlpha(0.0, 4);
                }
}} 