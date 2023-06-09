// MLPV2 Version 2.3, by Learjeff Innis, based on
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)
// 15-color balls by Lizz Silverstar

// 2.3: sequences
//      6 avs
//      Adjusting state

integer MAX_BALLS   = 6;

string  Version      = "MLPV2.3l IW 0.3.5";

integer b;
integer b0;
integer ballusers;
list    BallColors;
integer ch;
integer chat = 1;
integer group;
integer i;
integer menu;
integer menuusers;
integer redo = 1;
integer swap;
integer visible;
integer BallCount;
integer SaneMenuOrder;
integer ReloadOnRez;

integer Adjusting;
//string  LastPose;

integer BallsNeeded;

float alpha;
//string cmd;
string pose;
string Posemsg;     // for 'AGAIN'
key owner;
key user;
key user0;
list buttons;
list buttonindex;
list commands;
list menus;
list balls;
list users;

list SoundNames;
list Sounds;
list LMButtons;
list LMParms;
list MenuStack = [0];     // indices to previous menus, for "BACK" command

integer MenuPage;       // which page of current menu we're on, 0 for first

stop() {
    sendStand();     //msg to pos/pose
    llMessageLinked(LinkScope_i, 1, "STOP", (key)"");
    llSleep(0.2);
    killBalls();
    swap = 0;
    Adjusting = FALSE;
}


check_poses() {
    llOwnerSay("Checking configs");
    llMessageLinked(LinkScope_i,0,"POSEB", (key)"CHECK1"); llSleep(0.1);                       //msg to memory
    integer ix;
    string name;
    for (ix = 0; ix < llGetListLength(buttons); ++ix) {
        name = llList2String(buttons, ix);
        if (((integer)llList2String(commands, ix)) != 0) {
            llMessageLinked(LinkScope_i,0,"POSEB", (key)name); llSleep(0.1);                    //msg to memory
        }
    }
    llMessageLinked(LinkScope_i,0,"POSEB", (key)"CHECK2");                        //msg to memory
}

// Return a channel number that's based on the prim's key -- unique per object
integer channel() {
    return (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));
}


// setup for a pose based on menu characteristics
setup_pose() {
    if (BallsNeeded) {                  // if submenu includes balls:
        if (BallCount != BallsNeeded) {
            rezBalls();       // if not enough balls present: create balls
            llSleep(0.5);
        }
        integer ix;
        for (ix = 0; ix < BallsNeeded; ++ix) {
            llSay(ch + ix, llList2String(BallColors, ix)     // to ball: color, ballnum, adjusting
                + "|" + (string) ix
                + "|" + (string) Adjusting);
        }
        if (ballusers) setBalls("GROUP");           //if group access only
    }
}


unauth(string button, string who) {
    llDialog(user0, "\n" + button + " button allowed only for " + who, ["OK"], -1);
}

continMenu(string str) {
    llDialog(user0, "\n"+str+llKey2Name(user)+" is using the menu, continue?", ["Yes","Cancel"], ch - 1);
}

mainMenu() {
    MenuPage = 0;
    menu = 0;
    doMenu(FALSE);
}

//menu partly based on Menu Engine by Zonax Delorean (BSD License)
//llDialog(user, menuname, buttons(from index to nextindex-1), channel)
doMenu(integer inhibit_showing) {
    integer colors = (integer)llList2String(balls,menu);
    integer ix;
    integer mask = 0xf;
    integer shift = 0;
    BallsNeeded = 0;
    BallColors = [];
    for (ix = 0; ix < MAX_BALLS; ++ix) {
        integer bc = (colors & mask) >> ix*4;
        BallColors += (list)bc;
        if (bc) {
            BallsNeeded += 1;
        }
        mask = mask << 4;
    }

    if (inhibit_showing) {
        return;
    }

    b0 = (integer)llList2String(buttonindex, menu);         //position of first button for this (sub)menu
    b = (integer)llList2String(buttonindex, menu+1);        //position of first button for next (sub)menu

    b0 += MenuPage * 12;
    if (b - b0 > 12) {
        b = b0 + 12;
    }

    list menubuttons;
    list sortbuttons;
    menubuttons = llList2List(buttons, b0, b - 1);
    if (SaneMenuOrder) {
        sortbuttons =
            llList2List(menubuttons, -3, -1)
                + llList2List(menubuttons, -6, -4)
            + llList2List(menubuttons, -9, -7)
            + llList2List(menubuttons, -12, -10);
        menubuttons = sortbuttons;
    }
    llDialog(user, Version + "\n\n" + llList2String(menus,menu), menubuttons, ch - 1);
    llResetTime();
}

say(string str) {
    if (menuusers) llWhisper(0,str);
    else llOwnerSay(str);
}

killBalls() {
    integer ix;
    for (ix = 0; ix < MAX_BALLS; ++ix) {
        llSay(ch + ix, "DIE");      //msg to balls
    }
    BallCount = 0;
    llSetTimerEvent(0.0);
}

setBalls(string cmd) {
    integer ix;
    for (ix = 0; ix < BallCount; ++ix) {
        llSay(ch + ix, cmd);      //msg to balls
    }
}


rezBalls() {
    integer current = BallCount;

    if (BallsNeeded == BallCount) return;

    if (BallCount == 0) {
        killBalls();  // for reinitialization, if old balls are around
    }

    while (BallCount > BallsNeeded) {
        --BallCount;
        llSay(ch + BallCount, "DIE");
    }

    while (BallCount < BallsNeeded) {
        llRezObject("~ball",llGetPos(),ZERO_VECTOR,ZERO_ROTATION,ch+BallCount);
        ++BallCount;
    }

    // Only do this if there were no balls
    if (! current) {
        llMessageLinked(LinkScope_i,0,"REPOS",(key)"");  //msg to pos
    }

    llSetTimerEvent(60.0);
}



sendStand() {
    llMessageLinked(LinkScope_i,0,"POSE","0,"+(string)BallCount); llSleep(0.1);        //msg to pos/pose
    llMessageLinked(LinkScope_i,0,"POSEB", "stand");
}

touched(integer same_group) {
    if (user0 == owner || (menuusers == 1 && same_group) || menuusers == 2) {   //0=owner 1=group 2=all
        if (user0 != user) {
            if (llGetTime() < 60.0 && user != (key)"") {
                continMenu("");
                return;
            }
            user = user0;
            group = same_group;
        }
        mainMenu();
    }
}

// return TRUE if caller should do menu
integer handle_cmd(string button, integer sequenced) {
    b = llListFindList(buttons, (list) button);                     //find position of cmd
    string cmd = llList2String(commands,b);                         //get command

    if (cmd == "TOMENU") {
        integer newmenu = llListFindList(menus,[ button ]);         //find submenu
        if (newmenu == -1) return FALSE;
        if (sequenced) {
            integer oldmenu = menu;
            menu = newmenu;
            doMenu(TRUE);
            setup_pose();
            menu = oldmenu;
            return FALSE;
        }
        i = (integer)llList2String(users, newmenu);
        if (user == owner || (i == 1 && group) || i == 2) {         //0=owner 1=group 2=all
            MenuStack = (list)menu + MenuStack;
            MenuPage = 0;
            menu = newmenu;
            doMenu(sequenced);
            return FALSE;
        }
        if (i == 1) unauth(button, "group");
        else unauth(button, "owner");
        return FALSE;
    } else if (cmd == "BACK") {
            if (MenuPage) {
                --MenuPage;
                doMenu(sequenced);
                return FALSE;
            }
        menu = (integer)llList2String(MenuStack,0);
        MenuStack = llList2List(MenuStack,1,-1);
        doMenu(sequenced);
        return FALSE;
    } else if (cmd == "MORE") {
            ++MenuPage;
        doMenu(sequenced);
        return FALSE;
    } else if (cmd == "CHECK") {
            check_poses();
    } else if ((integer)cmd > 0) {                                  //POSE
            if (Adjusting && button != pose) {
                llMessageLinked(LinkScope_i,0,"SAVE",pose);               //msg to pos/pose
                llSleep(5.0);
            }
        setup_pose();
        Posemsg = cmd + "," + (string) BallCount;
        llMessageLinked(LinkScope_i,0,"POSE", Posemsg); llSleep(0.1);               //msg to pose
        llMessageLinked(LinkScope_i,0,"POSEB", (key)button);          //msg to memory
        if (chat) say(button);
        pose = button;
    } else if (cmd == "SWAP") {
            swap += 1;
        llMessageLinked(LinkScope_i,0,"SWAP",(key)((string)swap));              //msg to pos/pose
    } else if (cmd == "STAND") {
            sendStand();     //msg to pos/pose
        if (chat) say(button);
        pose = "stand";
    } else if (cmd == "STOP") {
            if (chat) say(button);
        stop();
        return FALSE;
    } else if (cmd == "ADJUST") {
            Adjusting = ! Adjusting;
        setBalls("ADJUST|" + (string)Adjusting);
    } else if (cmd == "HIDE") {
            setBalls("0");
    } else if (cmd == "SHOW") {
            setBalls("SHOW");
    } else if (cmd == "DUMP") {
            llMessageLinked(LinkScope_i,1,"DUMP",(key)"");
    } else if (cmd == "INVISIBLE") {
            visible = !visible;
        llSetAlpha((float)visible*alpha, ALL_SIDES);
    } else if (cmd == "REDO") {
            redo = !redo;
        if (redo) say(button+" ON"); else say(button+" OFF");
    } else if (cmd == "CHAT") {
            chat = !chat;
        if (chat) say(button+" ON"); else say(button+" OFF");
    } else if (cmd == "BALLUSERS") {
            ballusers = !ballusers;
        if (ballusers) {
            llOwnerSay(button+" GROUP");
            setBalls("GROUP");
        } else {
                llOwnerSay(button+" ALL");
            setBalls("ALL");
        }
    } else if (cmd == "MENUUSERS") {
            if (user == owner) {
                if (!menuusers) {
                    menuusers = 1;
                    llOwnerSay(button+" GROUP");
                } else if (menuusers == 1) {
                        menuusers = 2;
                    llOwnerSay(button+" ALL");
                } else if (menuusers == 2) {
                        menuusers = 0;
                    llOwnerSay(button+" OWNER");
                }
            } else unauth(button, "owner");
    } else if (cmd == "RESET" || cmd == "RELOAD" || cmd == "RESTART") {
            stop();
        if (chat) say(button);

        if (cmd == "RESET") {
            llMessageLinked(LinkScope_i, -100, llDumpList2String([llGetScriptName()] + ScriptsInit_l, "|"), (key)"#RESET");
            return FALSE;
        } else {
                if (cmd == "RESTART") {
                    llMessageLinked(LinkScope_i, -100, llDumpList2String(["~memory", "~props", llGetScriptName(), "~sequencer"] + ScriptsInit_l, "|"), (key)"#RESET");
                    return FALSE;
                }
            else
            { // reload
                //llResetOtherScript("~memory");
                llMessageLinked(LinkScope_i, -100, "~memory|~props", (key)"#RESET");
            }
        }
    } else if (cmd == "OFF") {
            sendStand();     //msg to pos/pose
        stop();
        if (user == owner) {
            llOwnerSay(button);
            //llResetOtherScript("~run");
            llMessageLinked(LinkScope_i, -100, "~run", (key)"#RESET");
            return FALSE;
        }
        unauth(button, "owner");
        return FALSE;
    } else if (llGetSubString(cmd, 0, 0) == "Z" || (cmd == "SAVE")) {    //SAVE or Z-adjust
            llMessageLinked(LinkScope_i,0,cmd,pose);                           //msg to pos/pose
        doMenu(sequenced);
        return FALSE;
    } else if (cmd == "LINKMSG") {
            // menu button to send LM to a non-MLPV2 script
            integer ix = llListFindList(LMButtons, [button]);
        if (ix != -1) {
            list lmparms = csv2list(llList2String(LMParms, ix));
            llMessageLinked(
                (integer)llList2String(lmparms, 1),     // destination link#
                (integer)llList2String(lmparms, 2),     // 'num' arg
                llList2String(lmparms, 3),      // 'str' arg
                user0);                         // key arg
            if ((integer)llList2String(lmparms,0)) {    // inhibit remenu?
                return FALSE;                         //   yes, bug out
            }
        }
    } else if (cmd == "SOUND") {
            integer ix = llListFindList(SoundNames, (list)button);
        if (ix >= 0) {
            llPlaySound(llList2String(Sounds, ix), 1.0);
        }
    }
    return TRUE;
}

default_state_exit()
{ // workaround for http://inworldz.com/mantis/view.php?id=224
    llOwnerSay("("+llGetScriptName()+": "+(string)llGetFreeMemory()+" bytes free)");
    llWhisper(0, Version + ": READY");
}


list csv2list(string message)
{ // workaround for http://opensimulator.org/mantis/view.php?id=3595
    list Input_l = llCSV2List(message); message = "";
    list Output_l = [];
    integer Count_i = llGetListLength(Input_l);
    integer i;
    for (i=0;i<Count_i;++i) { Output_l += llList2String(Input_l, i); }
    return Output_l;
}

list parse_string_keep_nulls(string message, list separators, list spacers)
{
    list Input_l = llParseStringKeepNulls(message, separators, spacers); message = "";
    list Output_l = [];
    integer Count_i = llGetListLength(Input_l);
    integer i;
    for (i=0;i<Count_i;++i) { Output_l += llList2String(Input_l, i); }
    return Output_l;
}

list ScriptsInit_l = ["~menucfg", "~pos", "~pose", "~poser", "~poser 1", "~poser 2", "~poser 3", "~poser 4", "~poser 5"];

integer LinkScope_i = LINK_THIS;
default
{
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number != -99 || (string)id != "#STATUS" ) { return; }
        if (message == "" || message == llGetScriptName()) { llMessageLinked(LinkScope_i, -98, llGetScriptName(), (key)"#ACTIVE"); }
        else if (message == "#START") { state default_start; }
        else { return; }
    }
}

state default_start {
    state_entry() {
        ch = channel();
        killBalls();
        //llSleep(2.0);       // give ~run a chance to shut us down
        //        llResetOtherScript("~menucfg");
        //        llResetOtherScript("~pos");
        //        llResetOtherScript("~pose");
        //        llResetOtherScript("~poser");
        //        llResetOtherScript("~poser 1");
        //        llResetOtherScript("~poser 2");
        //        llResetOtherScript("~poser 3");
        //        llResetOtherScript("~poser 4");
        //        llResetOtherScript("~poser 5");

        alpha = llGetAlpha(0);                                          //store object transparancy (alpha)
        if (alpha < 0.1) alpha = 0.5; else visible = 1;                 //if invisible store a visible alpha
    }

    link_message(integer from, integer num, string str, key id) {
        if (from != llGetLinkNumber()) { return; }
        if (num >= 0) { return;}

        // LMs from ~memory, passing configuration
        if (num == -1) {
            buttons = csv2list(str);
        } else if (num == -2) {
                commands = csv2list(str);
        } else if (num == -3) {
                menus = csv2list(str);
        } else if (num == -4) {
                buttonindex = csv2list(str);
        } else if (num == -5) {
                balls = csv2list(str);
        } else if (num == -6) {
                users = csv2list(str);
        } else if (num == -7) {
                LMButtons = csv2list(str);
        } else if (num == -8) {
                LMParms = parse_string_keep_nulls(str, ["|"], []);
        } else if (num == -9) {
                SoundNames = csv2list(str);
        } else if (num == -10) {
                Sounds = csv2list(str);
        } else if (num == -20) {
                list args = csv2list(str);
            redo            = (integer)llList2String(args,0);
            chat            = (integer)llList2String(args,1);
            ballusers       = (integer)llList2String(args,2);
            menuusers       = (integer)llList2String(args,3);
            SaneMenuOrder   = (integer)llList2String(args,4);
            ReloadOnRez     = (integer)llList2String(args,5);
            default_state_exit();
            state on;
        }
    }
}

state re_on {
    state_entry() {
        state on;
    }
}

state on {
    state_entry() {
        ch = channel();
        owner = llGetOwner();
        llListen(ch - 1, "", NULL_KEY, "");                      //listen for pressed buttons
        // llWhisper(0, "Channel: " + (string)ch);
    }

    on_rez(integer arg) {
        if (ReloadOnRez) {
            llMessageLinked(LinkScope_i, -100, llDumpList2String([llGetScriptName()] + ScriptsInit_l, "|"), (key)"#RESET");
            return;
        }
        BallCount = 0;
        llSetTimerEvent(0.0);
        state re_on;
    }

    touch_start(integer tcount) {
        user0 = llDetectedKey(0);
        touched(llDetectedGroup(0));
    }

    listen(integer channel, string name, key id, string button) {
        if (id != user) {
            if (button == "Yes") {
                user = id;
                group = llSameGroup(user0);
                mainMenu();
            } else if (button != "Cancel") {
                    continMenu("Selection cancelled because ");
            }
            return;
        }
        if (handle_cmd(button, FALSE) && redo) doMenu(FALSE);
    }


    link_message(integer from, integer num, string str, key id) {

        if (str == "PRIMTOUCH") {
            user0 = id;
            touched(num);
            return;
        }
        if (num == 0 && str == "AGAIN") {
            llMessageLinked(LinkScope_i,0,"POSE", Posemsg); llSleep(0.1);          //msg to pose
            llMessageLinked(LinkScope_i,0,"POSEB", (key)pose);        //msg to memory
            return;
        }
        if (num == -12002) {
            handle_cmd(str, TRUE);
            return;
        }
    }

    timer() {
        setBalls("LIVE");           //msg to balls: stay alive
    }
}
 