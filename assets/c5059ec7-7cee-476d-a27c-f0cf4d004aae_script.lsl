default
{
state_entry()
{
llListen(-9999, "", "", ""); // Make the prim listen
}

listen( integer channel, string name, key id, string message )
{
if (channel==-9999) { // Match the same private channel

llSetAlpha((integer)message, ALL_SIDES); // Convert "message" into an integer and pass to the llSetAlpha() function as the transparency - 0 = invisible 1 = visible

}
}
} 