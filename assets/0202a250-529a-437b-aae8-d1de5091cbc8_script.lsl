//drop this script and your sound file into the object you wish to script. touch the object to start the sound. touch it again to stop it.

integer on = FALSE;
string soundname = "Waterfall2"; //put sound file name here

default
{
state_entry()
{
on = FALSE;
soundname = llGetInventoryName(INVENTORY_SOUND, 0);
}

touch_start(integer total_number)
{
if(llDetectedKey(0) != llGetOwner())
return;
if(soundname != "")
{
if(on)
llStopSound();
else
llLoopSound(soundname, 1);
on = !on;
}
}
} 