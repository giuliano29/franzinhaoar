// HUD Script for HUGSaLOT Valkyrie's freebie cock
// version 6/28/09

// Too customize your own HUD buttons, simply make an object (prim) and give it the name of the command you want to use
// (see list of valid commands below). Attach the object TO the base prim that contains this HUD script.
// That is: Select the object you want as a button FIRST (go into edit mode on it first), next SHIFT-Click too select
// the base of the HUD (that contains this script), and then click Tools → Link, and that's it!
// You do not need to add any scripts into your button objects for them to function.

key     Owner;

list Buttons = [
// Commands list:
    
      "HARD"    // Sets penis erect in default (set) 0 angle
    , "SOFT"    // Sets penis in soft (flacid) mode, also stops particle and animations
    , "TILT"    // Displays menu for tilt angles
    
    , "spray"   // Starts cum particles
    , "stream"  // Starts a coninuious stream of cum. Use STOP to end
    , "whack"   // Starts animation in penis  (AO should be disabled, or it may not play)

    , "leak"    // Starts precum leaking particles. Use STOP to end.
    , "pee"     // Starts peeing particle effect.  Use STOP to end.
    , "stop"    // Stops all particle effects.

    , "SHINY"   // turn shiny on/off, on erect & flaccid prims
    , "DETACH"
    , "MORE..." // Displays message about the SET command before you comit to it
    ];

list Morebuttons = [
      "SHOW"
    , "HIDE"
    , " "

    , "MINI"
    , "MAXI"
    , "  "

    , "*SET*"
    , "RESIZE"
    , "BACK"
    ];

// Remember you can use ANY positive (angles up) or negative (angles down) value for creating your angle buttons.
// You're not limited to only the preset values listed below. 
list TiltButtons = [
      "0"       // Sets default horizontal angle posistion
    , "up"
    , "down"
    
    , "+10"     // Sets angle +10 from defualt 0 (zero)
    , "+20"     // Sets angle +20 from defualt 0 (zero)
    , "+30"     // Sets angle +30 from defualt 0 (zero)
        
    , "-10"     // Sets angle -10 from defualt 0 (zero)
    , "-20"     // Sets angle -20 from defualt 0 (zero)
    , "-30"     // Sets angle -30 from defualt 0 (zero)

    , "-40"
    , "+40"
    , "BACK"    // Goes back to main menu (useless as a HUD button)
    ];

integer MenuChan;           // channel for responses from menu
integer ControlChan;        // channel for sending commands to cock

menu(key id, list buttons) {
    
    // sort the buttons so they appear in same order as above.
    buttons =
          llList2List(buttons, -3, -1)
        + llList2List(buttons, -6, -4)
        + llList2List(buttons, -9, -7)
        + llList2List(buttons, -12, -10);

    // post the menu
    llDialog(id, "choose", buttons, MenuChan);
}

set_menu(key id) {
    llDialog(id, "Set default cock position?\n\n"
        + "Click the SET button below if your cock is where you want it "
        + "to be by default (angle 0).  Your cock will return here whenever "
        + "you change between hard and soft."
        + "\n\nClick 'ignore' if you don't want to do that.",
        ["SET"], MenuChan);
}

integer menucommand(key id, string msg) {
    // handle menu response
    if (msg == "MENU") {
        menu(id, Buttons);
        return TRUE;
    }
    if (msg == "TILT") {
        llWhisper(ControlChan, "HARD");
        menu(id, TiltButtons);
        return TRUE;
    }
    if (msg == "BACK") {
        menu(id, Buttons);
        return TRUE;
    }
    if (msg == "*SET*") {
        set_menu(id);
        return TRUE;
    }
    if (msg == "MORE...") {
        menu(id, Morebuttons);
        return TRUE;
    }
    if (msg == "MINI") {
        llSetRot(llEuler2Rot(<0., 0., PI/2.>));
        return TRUE;
    }
    if (msg == "MAXI") {
        llSetRot(llEuler2Rot(<0., 0., 0.>));
        return TRUE;
    }
    if (msg == "DETACH") {
        if (! (llGetPermissions() & PERMISSION_ATTACH)) {
            llOwnerSay("No permission to detach");
            return TRUE;
        }
        llWhisper(ControlChan, msg);
        llDetachFromAvatar();
        // llDie();
        return TRUE;
    }
    
    return FALSE;
}
    

default
{
    state_entry() {
        // select a random negative channel for menu
        // DEBUG_CHANNEL  just happens to be the biggest integer
        MenuChan = -1 - (integer)llFrand(-DEBUG_CHANNEL);
        
        // Pick a channel to use with the cock that it will choose too, but won't
        // interfere with other users or objects.  These two lines of code have to
        // match scripts in the cock.
        ControlChan = (integer)("0x"+llGetSubString((string)llGetOwner(),-4,-1));
        // avoid zero, debug-channel, and low positive channels
        if (ControlChan >= 0 && ControlChan < 100 || ControlChan == DEBUG_CHANNEL) ControlChan -= 200;
        
        // listen for menu responses.  On ControlChan, we'll only chat, not listen.
        llListen(MenuChan, "", llGetOwner(), "");
        llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
        Owner = llGetOwner();
    }
    
    run_time_permissions(integer perm) {
    }

    touch_start(integer total_number) {
        integer prim = llDetectedLinkNumber(0);
        if (prim == llGetLinkNumber()) {
            // user clicked this prim: send menu
            menu(llDetectedKey(0), Buttons);
            return;
        }
        
        // Root prim wasn't clicked, so use the prim's name as the command
        string msg = llGetLinkName(prim);
        
        // put up tilt menu if it's the TILT button
        if (msg == "TILT") {
            llWhisper(ControlChan, "HARD");
            menu(llDetectedKey(0), TiltButtons);
            return;
        }
        
        if (menucommand(llDetectedKey(0), msg)) {
            return;
        }
        
        // Find out if it's a number; if so, it's a tilt angle
        integer angle = (integer)msg;
        if (angle != 0 || msg == "0") {
            // it's a tilt button, so make it hard first
            llWhisper(ControlChan, "HARD");
        }
        
        // Pass message to cock
        llWhisper(ControlChan, msg);
    }
    
    listen(integer chan, string name, key id, string msg) {
        // llOwnerSay(msg);
        
        if (menucommand(id, msg)) {
            return;
        }
        
        // relay command to cock
        llWhisper(ControlChan, msg);
        if (msg == "RESIZE") {
            return;
        }
        
        // put appropriate menu back up
        if (llListFindList(Buttons, (list)msg) != -1) {
            menu(id, Buttons);
        } else if (llListFindList(Morebuttons, (list)msg) != -1) {
            menu(id, Morebuttons);
        } else if (llListFindList(TiltButtons, (list)msg) != -1) {
            menu(id, TiltButtons);
        }
    }

    // reset script if owner changed
    changed(integer change) {
        if (Owner != llGetOwner()) {
            llResetScript();
        }
    }
}