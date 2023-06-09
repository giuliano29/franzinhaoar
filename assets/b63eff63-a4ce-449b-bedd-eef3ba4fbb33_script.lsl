
//MPLV2 Version 2.1, Lear Cale, from:
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)

integer MAX_AVS = 6;

integer a;
integer ch;
integer i;
integer swap;
string an1;
string an2;
string an3;
string an4;
string an5;
string an6;
string pose;

list    PRs;    // pos/rot pairs for Save

list anims;     // strided list of anims, indexed by pose*6
vector pos;
rotation rot;
integer BallCount;      // number of balls
integer UpdateCount;    // number of balls we've heard from, for save

string prStr(string str) {
    i = llSubStringIndex(str,">");
    vector p = ((vector)llGetSubString(str,0,i) - pos) / rot;
    vector r = llRot2Euler((rotation)llGetSubString(str,i+1,-1) / rot)*RAD_TO_DEG;
    return "<"+round(p.x, 3)+","+round(p.y, 3)+","+round(p.z, 3)+"> <"+round(r.x, 1)+","+round(r.y, 1)+","+round(r.z, 1)+">";
}

string round(float number, integer places) {
    float shifted;
    integer rounded;
    string s;
    shifted = number * llPow(10.0,(float)places);
    rounded = llRound(shifted);
    s = (string)((float)rounded / llPow(10.0,(float)places));
    s = llGetSubString(s,0,llSubStringIndex(s, ".")+places);
    return s;
}

check_anim(string aname) {
    if (aname == "") {
        return;
    }
    if (   aname != "PINK"
        && aname != "BLUE"
            && aname != "stand"
                && aname != "sit_ground") {

                    // ignore expression suffix of "*" or "::nnn"
                    if (llGetSubString(aname, -1, -1) == "*") {
                        aname = llGetSubString(aname, 0, -2);
                    } else {
                            integer ix = llSubStringIndex(aname, "::");
                        if (ix != -1) {
                            aname = llGetSubString(aname, 0, ix-1);
                        }
                    }

                    if (llGetInventoryType(aname) != INVENTORY_ANIMATION) {
                        llSay(0,"animation '"
                            + aname
                            + "' not in inventory (ok for build-in animations, otherwise check)");
                    }
                }
}

getChan() {
    ch = (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));  //fixed channel for prim
}

default_state_exit()
{
    llOwnerSay((string)a+" poses loaded ("+llGetScriptName()+": "+(string)llGetFreeMemory()+" bytes free)");
}

save_state_exit()
{
    llSetTimerEvent(0);
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
    link_message(integer from, integer num, string data, key id) {
        if (num != 9+a) return;

        if (data == "LOADED") { default_state_exit(); state on; }

        list ldata = llParseString2List(data,["  |  ","  | "," |  "," | "," |","| ","|"],[]);

        an1 = llList2String(ldata,1);
        an2 = llList2String(ldata,2);
        an3 = llList2String(ldata,3);
        an4 = llList2String(ldata,4);
        an5 = llList2String(ldata,5);
        an6 = llList2String(ldata,6);

        if (a>1) {
            check_anim(an1);
            check_anim(an2);
            check_anim(an3);
            check_anim(an4);
            check_anim(an5);
            check_anim(an6);
        } else if (a) { //pose1: set default
                if (an1 == "") an1 = "sit_ground";
            if (an2 == "") an2 = "sit_ground";
            if (an3 == "") an3 = "sit_ground";
            if (an4 == "") an4 = "sit_ground";
            if (an5 == "") an5 = "sit_ground";
            if (an6 == "") an6 = "sit_ground";
        } else {        //pose0: set stand
                if (an1 == "") an1 = "stand";
            if (an2 == "") an2 = "stand";
            if (an3 == "") an3 = "stand";
            if (an4 == "") an4 = "stand";
            if (an5 == "") an5 = "stand";
            if (an6 == "") an6 = "stand";
        }
        anims += [ an1, an2, an3, an4, an5, an6 ];
        ++a;
    }
    state_exit() {

    }
}


state on {
    state_entry() {
        getChan();
    }

    on_rez(integer arg) {
        getChan();
    }

    link_message(integer from, integer num, string cmd, key akey) {
        if (cmd == "PRIMTOUCH"){
            return;
        }
        if (num) return;
        if (cmd == "POSE") {
            list parms = csv2list((string)akey);
            BallCount = (integer)llList2String(parms,1);
            integer m = (integer)llList2String(parms,0) * 6;
            an1 = llList2String(anims, m);
            an2 = llList2String(anims, m+1);
            an3 = llList2String(anims, m+2);
            an4 = llList2String(anims, m+3);
            an5 = llList2String(anims, m+4);
            an6 = llList2String(anims, m+5);
        } else if (cmd == "SWAP") {
                swap = !swap;
        } else if (cmd == "SAVE") {
                pose = (string)akey;
            state save;
        } else return;
        llMessageLinked(LinkScope_i,ch+swap, an1,(key)""); llSleep(0.1);  //msg to poser 1/2
        llMessageLinked(LinkScope_i,ch+!swap,an2,(key)""); llSleep(0.1);
        llMessageLinked(LinkScope_i,ch+2, an3,(key)"");  llSleep(0.1); //msg to poser 3
        llMessageLinked(LinkScope_i,ch+3, an4,(key)"");  llSleep(0.1); //msg to poser 4
        llMessageLinked(LinkScope_i,ch+4, an5,(key)"");  llSleep(0.1); //msg to poser 4
        llMessageLinked(LinkScope_i,ch+5, an6,(key)"");  //msg to poser 4
    }
}

state save {
    state_entry() {
        llMessageLinked(LinkScope_i,0,"GETREFPOS","");    //msg to pos: ask ref position
        integer ix;
        PRs = [ "", "", "", "", "", "" ];

        for (ix = 0; ix < MAX_AVS; ++ix) {
            llListen(ch+16+ix,  "", NULL_KEY, "");
            llSay(ch+ix,"SAVE");       //msg to balls
        }
        llSetTimerEvent(3);
        UpdateCount = 0;
    }


    listen(integer channel, string name, key id, string pr) {
        channel -= (ch + 16);

        if (channel == 0) {
            channel = channel + swap;
        } else if (channel == 1) {
                channel = channel - swap;
        }

        PRs = llListReplaceList(PRs, (list)pr, channel, channel);

        if (++UpdateCount == BallCount) {
            pr = "";
            integer ix;
            for (ix = 0; ix < BallCount; ++ix) {
                pr += prStr(llList2String(PRs, ix)) + " ";
            }

            llOwnerSay("{"+pose+"} "+pr);
            llMessageLinked(LinkScope_i,1,pose,pr);       //write to memory
            save_state_exit();
            state on;
        }
    }
    link_message(integer from, integer num, string posstr, key rotkey) {
        if (posstr == "PRIMTOUCH"){
            return;
        }
        if (num != 8) return;
        pos = (vector)posstr;                   //revtrieve reference position from pos
        rot = (rotation)((string)rotkey);
    }
    timer() {
        save_state_exit();
        state on;
    }
    state_exit() {

    }
}
 