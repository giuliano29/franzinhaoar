// MLPV2 Version 2.3j, by Learjeff Innis, based on
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)

integer MAX_BALLS   = 6;

integer ch;
integer swap;
integer BallCount;

string  pr1;
string  pr2;

integer Zoffset;

vector  RefPos;
rotation RefRot;

getRefPos() {   //reference position
    RefPos = llGetPos();
    RefRot = llGetRot();
    Zoffset = (integer)llGetObjectDesc();
    RefPos.z += (float) Zoffset / 100.0;
}

list Pdata;

getPosNew(string pdata) {
    Pdata = llParseString2List(pdata, [" "],[]);
}

setPos() {
    pr1 = (string)((vector)llList2String(Pdata, 0) * RefRot + RefPos);
    pr2 = (string)((vector)llList2String(Pdata, 2) * RefRot + RefPos);
    pr1 += (string)(llEuler2Rot((vector)llList2String(Pdata, 1) * DEG_TO_RAD) * RefRot);
    pr2 += (string)(llEuler2Rot((vector)llList2String(Pdata, 3) * DEG_TO_RAD) * RefRot);
    if (BallCount > 1) {
        llSay(ch+swap,pr1);     //msg to ball1/2
        llSay(ch+!swap,pr2);
    } else {
            llSay(ch,pr1);          //msg to ball1/2
    }

    integer ix;
    for (ix = 2; ix < BallCount; ++ix) {
        llSay(ch + ix, (string)((vector)llList2String(Pdata, 2*ix) * RefRot + RefPos)
            + (string)(llEuler2Rot((vector)llList2String(Pdata, 2*ix + 1) * DEG_TO_RAD) * RefRot));
    }
}

getChan() {
    ch = (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));          //fixed channel for prim
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
    state_entry() {
        getRefPos();
        getChan();
    }

    on_rez(integer arg) {
        getRefPos();
        getChan();
    }

    link_message(integer from, integer num, string cmd, key pkey) {
        if (cmd == "PRIMTOUCH"){
            return;
        }

        if (num == 1 && cmd == "STOP") {
            swap = 0;
            return;
        }

        if (num) return;

        if (cmd == "POSE") {
            list parms = csv2list((string)pkey);
            BallCount = (integer)llList2String(parms,1);
            return;
        } else if (cmd == "POSEPOS") {
                // p = (integer)((string)pkey
                getPosNew((string)pkey);
            setPos();
        } else if (cmd == "SWAP") {
                swap = (integer)((string)pkey) & 1;
            llSay(ch+swap,pr1);         //msg to ball1/2
            llSay(ch+!swap,pr2);
        } else if (cmd == "REPOS") {
                getRefPos();
            } else if (llGetSubString(cmd, 0, 0) == "Z") {
            if (llGetSubString(cmd, 1, 1) == "+") { cmd = llDeleteSubString(cmd, 1, 1); }
            integer change = (integer)llGetSubString(cmd, 1, -1);
            Zoffset += change;
            RefPos.z += (float)change/100.0;
            setPos();
            llOwnerSay("Height Adjustment: change by " + (string) change + "cm, new offset: " + (string)Zoffset + "cm");
            llSetObjectDesc((string)Zoffset);
        } else if (cmd == "GETREFPOS") {
                llMessageLinked(LinkScope_i,8,(string)RefPos,(string)RefRot);   //send reference position to pose
        }
    }
}
 