//MLPV2 Version 2.3 - Learjeff Innis, from
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)
//To donate, go to my profile (Search - People - Miffy Fluffy) and use the "Pay..." button, thanks!
//You can also find the link to the latest version here.

integer MAX_AVS             = 6;
integer ResetOnOwnerChange  = FALSE;

// DESCRIPTION OF THE SCRIPTS
//
// ~run:
//  Default: sets other scripts to not running.
//  When the object is touched it will start all scrips.
//
// ~memory:
//  Here the positions are stored permanently. Information is still kept when the script is
//  not running or when everything is placed in inventory. The information will be lost only
//  when the ~memory script is reset.
//  A backup can be made on the .POSITIONS notecard, when the memory is empty, it will start
//  reading the .POSITIONS notecard automatically.
//
// ~menu:
//  1.loading: reads the .MENUITEMS notecard and builds the menu.
//    When it reads a "POSE": - the animations are stored in ~pose
//                            - their matching positions are looked up in ~memory and stored
//                              in ~pos.
//  2.ready:
//    When the object is touched: - shows the main menu
//                                - listens for menu selections.
//
//    When a submenu is selected: - shows the submenu
//                                - when balls are defined for this submenu it will rez
//                                  balls (if not already there) and set their colors.
//
//    When a pose is selected:  - ~pose will send the animations to ~pose1 and ~pose2,
//                                 they will set the animations to the avatars
//                              - ~pos wil send the matching positions to each ball.
//
//    When a position is saved: - ~pose will ask the balls for their position
//                              -  the positions are saved in ~memory ("permanent")
//                              -  the positions are updated in ~pos
//
//    When "STOP" is selected:  - will hide the balls
//                              - will stop the pose
//                              When "STOP" is selected again (or if no pose is started yet):
//                              - will remove the balls (derez/die)
//
// ~pos:
//  - loads the positions from ~memory and stores them (until shutdown/restart)
//  - sends positions for the selected pose to the balls
//
// ~pose:
//  - loads the animations from the .MENUITEMS notecard and stores them (until shutdown/restart)
//  - sends animations for the selected pose to ~pose1 and ~pose2
//  - when saving a position: will ask balls for their position and sends it to ~pos and ~memory
//    (~pos would be a more logical place to handle this, but ~pose has more free memory).
//
// ~poser, ~poser 1, ~poser 2, ~poser 3 (one for each ball):
//  - will ask permission to animate the avatar on ball
//  - will set the animations to avatar
//
// ~ball
//  - when balls are defined for a submenu (in .MENUITEMS), ~menu will rez copies of ~ball
//  - each will receive a unique communication channel from ~menu
//  - the color for each ball is set by ~menu
//  - the position of each ball is set by ~pos
//  - when an avatar selects to sit on a ball, the avatar info is sent to the appropriate; they
//    will ask permission and set the animation directly to the avatar (not via the ball)
//  - balls will commit suicide when they don't hear a "LIVE" message each minute (from ~menu).
//
// have fun!

//Note: if you make a revised version, please mention something like this:
//"MLP - alternative version by ... .... - Revision 1 (based on MLP V1.2 by Miffy Fluffy)

key     Owner;

list Scripts = [
    "~menucfg",
    "~pos",
    "~pose",
    "~poser",
    "~poser 1",
    "~poser 2",
    "~poser 3",
    "~poser 4",
    "~poser 5"
        ];

list OptionalScripts = [
    "~props",
    "~sequencer"
        ];

list PrimaryScripts = [
    "~memory",
    "~menu"
        ];
//setRunning(integer st) {
//    integer ix;
//    list    scripts = Scripts;
//    string  script;
//
//    for (ix = 0; ix < 100; ++ix) {
//        integer jx;
//
//        // try to stop any remaining scripts in the list
//        for (jx = llGetListLength(scripts) - 1; jx >= 0; --jx) {
//            script = llList2String(scripts, jx);
//            if (llGetInventoryType(script) == INVENTORY_SCRIPT) {
//                llSetScriptState(script, st);
//                scripts = llDeleteSubList(scripts, jx, jx);
//                --jx;
//            }
//        }
//
//        // got them all yet?
//        if (llGetListLength(scripts) == 0) {
//            // Yes -- handle key ones
//            llSetScriptState("~memory", st);
//            llSetScriptState("~menu", st);
//            if (st) {
//                llResetOtherScript("~memory");
//                llResetOtherScript("~menu");
//            }
//
//            // start/stop optional scripts if present
//            for (jx = llGetListLength(OptionalScripts) - 1; jx >= 0; --jx) {
//                script = llList2String(OptionalScripts, jx);
//                if (llGetInventoryType(script) == INVENTORY_SCRIPT) {
//                    llSetScriptState(script, st);
//                }
//            }
//            return;
//        }
//
//        llSleep(0.1);
//    }
//
//    llOwnerSay("missing scripts: " + llList2CSV(scripts));
//}

setBalls(string cmd) {
    integer ch = channel();
    integer ix;

    for (ix = 0; ix < MAX_AVS; ++ix) {
        llSay(ch + ix, cmd);      //msg to balls
    }
}

integer channel() {
    return (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));
}

debug(string message)
{
    llOwnerSay(llGetScriptName() + ": " + message);
}

integer is_empty(string message)
{
    if (llStringTrim(message, STRING_TRIM) == "") { return TRUE; }
    return FALSE;
}

display_text(string message)
{
    llSetText(message, <1.0,1.0,1.0>, 1.0);
}

list scripts_missing(list Scripts_l)
{
    list ScriptsMissing_l = [];
    integer ScriptCount_i = llGetListLength(Scripts_l);
    integer i;
    for (i=0;i<ScriptCount_i;++i)
    {
        string ScriptName_sg = llList2String(Scripts_l, i);
        if (!is_empty(ScriptName_sg) && llGetInventoryType(ScriptName_sg) != INVENTORY_SCRIPT)
        {
            ScriptsMissing_l += ScriptName_sg;
        }
    }
    return ScriptsMissing_l;
}

scripts_reset(list ScriptResetting_l)
{
    integer ScriptCount_i = llGetListLength(ScriptResetting_l);
    integer i;
    for (i=0;i<ScriptCount_i;++i)
    {
        string ScriptName_sg = llList2String(ScriptResetting_l, i);
        if (!is_empty(ScriptName_sg) && llGetInventoryType(ScriptName_sg) == INVENTORY_SCRIPT)
        {
            if (ScriptName_sg != llGetScriptName())
            {
                llResetOtherScript(ScriptName_sg);
            }
        }
    }
}
list parse_string_2_list(string message, list separators, list spacers)
{
    list Input_l = llParseString2List(message, separators, spacers); message = "";
    list Output_l = [];
    integer Count_i = llGetListLength(Input_l);
    integer i;
    for (i=0;i<Count_i;++i) { Output_l += llList2String(Input_l, i); }
    return Output_l;
}


list ScriptsActivated_l;
list ScriptsPending_l;

integer ThrottleRetries_i;
float ThrottleDelay_i;

integer TestingChainOfEvents_bg = FALSE;
integer LinkScope_i = LINK_THIS;
integer StartingUp = FALSE;
integer RespondReset_b = FALSE;
default
{
    state_entry()
    {
        StartingUp = TRUE;
        RespondReset_b = TRUE;
        setBalls("DIE");
        Owner = llGetOwner();
        display_text("");
        ScriptsPending_l = PrimaryScripts + Scripts;
        scripts_reset(ScriptsPending_l);
        state script_exists_check;
    }
}

state script_exists_check
{
    state_entry()
    {
        display_text("Please wait...");
        if (!llGetListLength(ScriptsPending_l)) { state running; }
        if (llGetListLength(scripts_missing(ScriptsPending_l)) > 0)
        {
            ThrottleRetries_i = 5;
            ThrottleDelay_i = 5.0;
            llSetTimerEvent(0.0); llSetTimerEvent(0.1);
            return;
        }
        state script_responding_check;
    }
    timer()
    {
        if (ThrottleRetries_i)
        {
            llSetTimerEvent(0.0); llSetTimerEvent(ThrottleDelay_i);
            --ThrottleRetries_i;
            display_text("Locating scripts......\nRetries left: " + (string)ThrottleRetries_i);
            if (llGetListLength(scripts_missing(ScriptsPending_l)) == 0)
            {
                llSetTimerEvent(0.0);
                state script_responding_check;
            }
        }
        else
        {
            llSetTimerEvent(0.0);
            state script_exists_abort;
        }
    }
    changed(integer change)
    {
        if (change & (CHANGED_INVENTORY | CHANGED_ALLOWED_DROP)) { state script_exists_reset; }
    }

}

state script_exists_reset
{
    state_entry()
    {
        state script_exists_check;
    }
}

state script_exists_abort
{
    state_entry()
    {
        display_text("Touch to reset\nScripts Missing:\n" + llList2CSV(scripts_missing(ScriptsPending_l)));
    }
    touch_start(integer total_number)
    {
        state resetscript;
    }
}

state script_responding_check
{
    state_entry()
    {
        display_text("Please wait......");
        if (!llGetListLength(ScriptsPending_l)) { state running; }
        ScriptsActivated_l = [];
        ThrottleRetries_i = 5;
        ThrottleDelay_i = 5.0;
        llSetTimerEvent(0.0); llSetTimerEvent(ThrottleDelay_i);
        llMessageLinked(LinkScope_i, -99, "", (key)"#STATUS");
    }
    link_message(integer sender_number, integer number, string message, key id)
    {
        // expecting -98, scriptname, #Active
        if (number != -98 || (string)id != "#ACTIVE") { return; }
        if (llListFindList(ScriptsActivated_l, [message]) != -1) { return; }
        llSetTimerEvent(0.0);
        ScriptsActivated_l += message;
        if (llGetListLength(ScriptsActivated_l) != llGetListLength(ScriptsPending_l))
        {
            ThrottleRetries_i = 5;
            llSetTimerEvent(0.0); llSetTimerEvent(ThrottleDelay_i);
        }
        else
        {
            state running;
        }
    }
    timer()
    {
        --ThrottleRetries_i;
        if (ThrottleRetries_i > 0)
        {
            display_text("Script(s) not responding....\nRetries left: " + (string)ThrottleRetries_i);
            llSetTimerEvent(0.0); llSetTimerEvent(ThrottleDelay_i);
            llMessageLinked(LinkScope_i, -99, "", (key)"#STATUS");
        }
        else
        {
            llSetTimerEvent(0.0);
            state script_responding_abort;
        }
    }
}

state script_responding_abort
{
    state_entry()
    {
        list ScriptsNotResponding_l = [];
        integer ScriptCount_i = llGetListLength(ScriptsPending_l);
        integer i;
        for (i=0;i<ScriptCount_i;++i)
        {
            string ScriptName_sg = llList2String(ScriptsPending_l, i);
            if (!is_empty(ScriptName_sg) && llListFindList(ScriptsActivated_l, [ScriptName_sg]) == -1)
            {
                ScriptsNotResponding_l += ScriptName_sg;
            }
        }
        if (RespondReset_b)
        {
            RespondReset_b = FALSE;
            scripts_reset(ScriptsNotResponding_l);
            ScriptsPending_l = ScriptsNotResponding_l;
            state script_exists_check;
            return;
        }
        display_text("Touch to reset\nScripts not responding:\n" + llList2CSV(ScriptsNotResponding_l));
    }
    touch_start(integer total_number)
    {
        state resetscript;
    }
}


state running
{
    state_entry()
    {
        display_text("");
        if (StartingUp)
        {
            StartingUp = FALSE;
            llOwnerSay("OFF (touch to switch on)");
            return;
        }
        state run;
    }
    touch_start(integer i) {
        state run;
    }

    // Waits for another script to send a link message.
    link_message(integer sender_num, integer num, string str, key id) {
        if (str == "PRIMTOUCH" && id == llGetOwner()) {
            state run;
        }
    }

    changed(integer change) {
        if (change & CHANGED_OWNER && Owner != llGetOwner()) {
            state resetscript;
        }
    }

}


state run {
    state_entry() {
        //setRunning(TRUE);
        llMessageLinked(LinkScope_i, -99, "#START", (key)"#STATUS");
    }
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number != -100 || (string)id != "#RESET" ) { return; }
        list ScriptResetting_l = parse_string_2_list(message, ["|"], []);
        if (llListFindList(ScriptResetting_l, [llGetScriptName()]) != -1) { llResetScript(); return; }
        scripts_reset(ScriptResetting_l);
        ScriptsPending_l = ScriptResetting_l;
        state script_exists_check;
    }
    changed(integer change) {
        if (ResetOnOwnerChange
            && (change & CHANGED_OWNER)
                && Owner != llGetOwner()) {
                    state resetscript;
                }
    }
}

state resetscript
{
    state_entry()
    {
        llResetScript();
    }
}

 