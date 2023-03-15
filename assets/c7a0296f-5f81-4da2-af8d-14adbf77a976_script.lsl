// Athena mesh body courtesy of Gladiatrix Athena
// anklelock.bvh courtesy of Wizard And Steamwork team

// Constants ///////////////////////////////////////////////////////////////////////////////////

string PRODUCT    = "FBP1";    // Femme Body Protocol v1
list BODY_LINKS   = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
list BODY_FACES   = [8,8,8,8,2,2,8,8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8];
list BODY_SPECS   = ["N","R","L","F"];
list LAYER_LINKS  = [];
list FEETMAP      = ["F","M","H"];
float ANKLE_TIMER = 10.0;

vector VEC0       = ZERO_VECTOR;
vector VEC1       = <1.0, 1.0, 1.0>;

// State variables /////////////////////////////////////////////////////////////////////////////

integer bodyChan;   // channel we listen on, and send to
integer userChan;   // channel available from chat (for gestures for example)
integer neckshape;  // 0=24, 1=11, 2=7, 3=5, 4=0
integer neckfix;    // show neck blender TRUE/FALSE
integer nails;      // -1=hidden, 0=long, 1=short, 2=middle, 3=spike, 4=round
integer fnails;     // show feet nails TRUE/ALSE (stored in flat feet link 33)
string feetshape;   // F=flat, M=middle, H=high
integer nipples;    // 0=hidden, 1=soft, 2=hard, -1=hidden soft, -2=hidden hard
integer gloves;     // show layer on hands TRUE/FALSE (face 6)
integer socks;      // show layer on feet TRUE/FALSE (face 0)
integer anklelock;  // lock ankles with animation TRUE/FALSE (stored in high feet link 35)

integer nrule = 0;

// General functions ///////////////////////////////////////////////////////////////////////////

DBG(string msg) {
    llSay(DEBUG_CHANNEL, msg);
}

integer ownerChannel() {
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()));
}

listenUser(integer chan) {
    if (chan) {
        userChan = llListen(chan, "", llGetOwner(), "");
    }
    else {
        llListenRemove(userChan);
        userChan = 0;
    }
    llSetLinkPrimitiveParamsFast(40, [PRIM_DESC, (string)chan]);
}

sendMsg(string msg, string cmd, string params) {
    if (!osIsNpc(llGetKey())) {
        llSay(bodyChan, llDumpList2String([PRODUCT, msg, cmd, params], "|"));
    }
}

integer feet2link(string shape) {
    return 33 + llListFindList(FEETMAP, [shape]);
}

integer numberOfFaces(integer link) {
    return llList2Integer([0,
        8,8,8,8,2,2,8,8,8,8,
        8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
        5,3,3,3,3,3,1,1,1,1,5
        ], link - 1);
}

// returns -1 if not 0 or 1
integer bool(string val) {
    return llListFindList(["0","1"], val);
}

// Body state //////////////////////////////////////////////////////////////////////////////////

restoreState() {
    integer i;

    // user channel
    listenUser((integer)llList2String(llGetLinkPrimitiveParams(40, [PRIM_DESC]), 0));

    // neck shape (neck link is 30)
    neckshape = -1;
    neckfix = FALSE;
    for (i = 0; i < 5; ++i) {
        if (getAlpha(30, i)) { neckshape = i; }
    }
    if (!~neckshape) { // not defined, force to size 0 (4)
        setNeck(4, TRUE);
    }
    // neckfix is enabled if the same face than the neck is visible
    neckfix = getAlpha(40, neckshape);

    // nails shape
    nails = -1;
    for (i = 0; i < 5; ++i) {
        if (getAlpha(31, i)) { nails = i; }
    }
    gloves = getAlpha(31, 6);

    // feet (links 33=flat, 34=middle, 35=high)
    feetshape = "";
    for (i = 33; i < 36; ++i) {
        if (getAlpha(i, 2)) { // skin on face 2
            feetshape = llList2String(FEETMAP, i - 33);
        }
    }
    if (!feetshape) {
        feetshape = "F";
    }
    i = feet2link(feetshape);
    socks = getAlpha(i, 0);
    fnails = ("0" != llList2String(llGetLinkPrimitiveParams(33, [PRIM_DESC]), 0));
    setAnkleLock(("0" != llList2String(llGetLinkPrimitiveParams(35, [PRIM_DESC]), 0)));

    // nipples
    nipples = 0;
    if (getAlpha(36, 0)) { // 36=right soft
        nipples = 1;
    }
    else if (getAlpha(38, 0)) { // 38=right hard
        nipples = 2;
    }
}

string dumpState() {
    return llDumpList2String([
        neckshape,
        neckfix,
        feetshape,
        nipples,
        nails,
        fnails,
        anklelock
    ], ",");
}

loadAlphas(string alphas) {
    list l = llParseStringKeepNulls(alphas, [","], []);
    vector col = getTint(2, 0); // get one link color for the whole skin
    integer i; integer c; integer f; integer v;
    string cells;
    list p;
    for (i = 0, c = 2; i < 28; ++i, ++c) {
        cells = llList2String(l, i);
        for (f = 0; f < llStringLength(cells); ++f) {
            if (~(v = bool(llGetSubString(cells, f, f)))) {
                p += [ PRIM_LINK_TARGET, c, PRIM_COLOR, f, col, (float)v];
            }
        }
    }
    llSetLinkPrimitiveParamsFast(1, p);
    // special links
    setNeck(neckshape, (integer)llList2String(l, i++));
    setHand(31, (integer)llList2String(l, i++));
    setHand(32, (integer)llList2String(l, i++));
    setFeet(feetshape, (integer)llList2String(l, i));
    twitchNipples(getAlpha(6, 0) && getAlpha(7, 0));
}

string dumpAlphas() {
    list cells = BODY_LINKS + BODY_SPECS;
    integer c = llGetListLength(cells);
    string cell; string val;
    integer i;  integer link; integer nfaces; integer f;
    list alphas;
    for (i = 0; i < c; ++i) {
        cell = llList2String(cells, i);
        if (cell == "N")      { val = (string)getAlpha(30, neckshape); }
        else if (cell == "R") { val = (string)getAlpha(31, 5); } // face 5=skin
        else if (cell == "L") { val = (string)getAlpha(32, 5); }
        else if (cell == "F") { val = (string)getAlpha(feet2link(feetshape), 2); } // face 2=skin
        else {
            val = "";
            nfaces = numberOfFaces((integer)cell);
            for (f = 0; f < nfaces; ++f) {
                val += (string)getAlpha((integer)cell, f);
            }
        }
        alphas += val;
    }
    return llDumpList2String(alphas, ",");
}

// Ankles locking //////////////////////////////////////////////////////////////////////////////

doAnkleLock() {
    llStopAnimation("anklelock");
    if (anklelock && (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)) {
        llStartAnimation("anklelock");
    }
}

setAnkleLock(integer active) {
    anklelock = (active == 1);
    llSetLinkPrimitiveParamsFast(35, [PRIM_DESC, (string)anklelock]);
    doAnkleLock();
}

// Parts visibility ////////////////////////////////////////////////////////////////////////////

integer getAlpha(integer link, integer face) {
    return (0.0 < llList2Float(llGetLinkPrimitiveParams(link, [PRIM_COLOR, face]), 1));
}

setAlphas(list cells, integer show) {
    if (~show) {
        show = (show != 0);

        string cell; string type;
        list p;
        vector col = getTint(2, 0); // get one link color for the whole skin
        integer c = llGetListLength(cells);
        integer nips = FALSE;
        while (--c > -1) {
            cell = llList2String(cells, c);
            if (~llListFindList(["6","7"], cell)) { nips = TRUE; }
            type = llGetSubString(cell, 0, 0);
            if (type == "N")      { setNeck(neckshape, show); }
            else if (type == "R") { setHand(31, show); }
            else if (type == "L") { setHand(32, show); }
            else if (type == "H") { setHand(31, show); setHand(32, show); }
            else if (type == "F") { setFeet(feetshape, show); }
            else if (type == "C") { p += [
                PRIM_LINK_TARGET, (integer)llGetSubString(cell, 1, -2),
                PRIM_COLOR, (integer)llGetSubString(cell, -1, -1), col, (float)show
            ];}
            else if ((integer)cell != 0) { p += [
                PRIM_LINK_TARGET, (integer)cell,
                PRIM_COLOR, ALL_SIDES, col, (float)show
            ];}
        }
        // check nipples
        if (p != []) {
            if (nips) { twitchNipples(show); }
            llSetLinkPrimitiveParams(1, p);
        }
    }
}

setNeck(integer shape, integer show) {
    if (show != -1 && llListFindList([0,1,2,3,4], [shape]) != -1) {
        llSetLinkAlpha(30, 0.0, ALL_SIDES);
        llSetLinkAlpha(40, 0.0, ALL_SIDES);
        if (show) {
            neckshape = shape;
            llSetLinkAlpha(30, 1.0, shape);
            if (neckfix) {
                llSetLinkAlpha(40, 1.0, shape);
            }
        }
    }
}

setHand(integer hand, integer show) {
    if (~show) {
        llSetLinkAlpha(hand, 0.0, ALL_SIDES);
        if (show) {
            llSetLinkAlpha(hand, 1.0, 5); // skin
            llSetLinkAlpha(hand, 1.0, nails);
            if (gloves) {
                llSetLinkAlpha(hand, 1.0, 6); // tattoo
            }
        }
    }
}

integer nextNails() {
    integer n = nails + 1;
    if (++n > 4) { n = 0; }
    return n;
}

setNails(integer shape) {
    if (~llListFindList([-1,0,1,2,3,4], shape)) {
        if (~nails) {
            llSetLinkAlpha(31, 0.0, nails);
            llSetLinkAlpha(32, 0.0, nails);
        }
        nails = shape;
        // check skin visibility
        if (shape > -1) {
            if (getAlpha(31, 5)) { llSetLinkAlpha(31, 1.0, nails); }
            if (getAlpha(32, 5)) { llSetLinkAlpha(32, 1.0, nails); }
        }
    }
}

setNipples(integer shape) {
    if (~llListFindList([0,1,2,-1,-2], shape)) {
        nipples = shape;
        llSetLinkAlpha(36, (float)(shape == 1), ALL_SIDES);
        llSetLinkAlpha(37, (float)(shape == 1), ALL_SIDES);
        llSetLinkAlpha(38, (float)(shape == 2), ALL_SIDES);
        llSetLinkAlpha(39, (float)(shape == 2), ALL_SIDES);
    }
}

integer nextNipples() {
    if (++nipples > 2) { nipples = 0; }
    return nipples;
}

twitchNipples(integer show) {
    if (~show) {
        show = (show != 0);
        // inverse the state value to show/hide, keeping the current soft/hard state
        if ((show == FALSE && nipples > -1) || (show == TRUE && nipples < 0)) {
            nipples = -nipples;
        }
        setNipples(nipples);
    }
}

string nextFeet() {
    integer i = llListFindList(FEETMAP, feetshape) + 1;
    if (i > 2) { i = 0; }
    return llList2String(FEETMAP, i);
}

setFeet(string shape, integer show) {
    if (~show) {
        llSetLinkAlpha(33, 0.0, ALL_SIDES);
        llSetLinkAlpha(34, 0.0, ALL_SIDES);
        llSetLinkAlpha(35, 0.0, ALL_SIDES);
        if (show) {
            integer link = feet2link(shape);
            if (~link) {
                feetshape = shape;
                llSetLinkAlpha(link, 1.0, 2); // skin
                if (fnails) { llSetLinkAlpha(link, 1.0, 1); } // nails
                if (socks) { llSetLinkAlpha(link, 1.0, 0); }
            }
        }
    }
}

// Textures ////////////////////////////////////////////////////////////////////////////////////

string getTexture(integer link, integer face) {
    return llList2String(llGetLinkPrimitiveParams(link, [PRIM_TEXTURE, face]), 0);
}

list genTextureRules(list links, integer face, string params) {
    list l = llParseStringKeepNulls(params, [","], []);
    string diffuse = llList2String(l, 0);
    string normal = llList2String(l, 1);
    string specular = llList2String(l, 2);

    list r;
    integer i; integer f; integer max; integer link;
    integer c = llGetListLength(links);

    if (diffuse != "") {
        for (i = 0; i < c; ++i) {
            r += [
                PRIM_LINK_TARGET, llList2Integer(links, i),
                PRIM_TEXTURE, face, diffuse, VEC1, VEC0, 0.0
            ];
        }
    }
    if (normal != "") {
        if (normal == "DEF") {
            if (~llListFindList(links, [2])) { // upper
                normal = "3ee3efcc-3256-4c79-bcb1-f40c1d240d97";
            }
            else if (~llListFindList(links, [12])) { // lower
                normal = "d8cf8728-9053-422b-bb60-7e738730cf9f";
            }
        }
//        DBG("rules for " + (string)c + " links");
        for (i = 0; i < c; ++i) {
            link = llList2Integer(links, i);
//            DBG("link #" + (string)link);
            r += [PRIM_LINK_TARGET, link];
            f = llList2Integer([face, 0], (face == ALL_SIDES));
            max = llList2Integer([face + 1, numberOfFaces(link)], (face == ALL_SIDES));
            for (f = 0; f < max; ++f) {
                r += [PRIM_NORMAL, f, normal, VEC1, VEC0, 0.0];
            }
//            DBG(llDumpList2String(r, ", "));
        }
    }
    if (specular != "") {
        string spec;
        vector col;
        integer gloss;
        integer env;
        list defs;

        f = llList2Integer([0, face], (face == ALL_SIDES));
        defs = llGetLinkPrimitiveParams(llList2Integer(links, 0), [PRIM_SPECULAR, f]);

        l = llParseStringKeepNulls(specular, [":"], []);
        spec  = llList2String(l, 0);
        col   = (vector)llList2String(l, 1);
        gloss = (integer)llList2String(l, 2);
        env   = (integer)llList2String(l, 3);
        if (spec == "")  { spec = llList2String(defs, 0); }
        if (col == VEC0) { col = llList2Vector(defs, 4); }
        if (gloss == 0)  { gloss = llList2Integer(defs, 5); }
        if (env == 0)    { env = llList2Integer(defs, 6); }
        if (spec == "DEF") {
            if (~llListFindList(links, [2])) { // upper
                spec = "ec46fdf6-02b4-4809-8ca3-d3ffe54d7c6f";
            }
            else if (~llListFindList(links, [12])) { // lower
                spec = "c3b5e1c6-2f74-4754-9d34-169e8979319b";
            }
        }
        for (i = 0; i < c; ++i) {
            link = llList2Integer(links, i);
            r += [PRIM_LINK_TARGET, link];
            f = llList2Integer([face, 0], (face == ALL_SIDES));
            max = llList2Integer([face + 1, numberOfFaces(link)], (face == ALL_SIDES));
            for (f = 0; f < max; ++f) {
                r += [PRIM_SPECULAR, f, spec, VEC1, VEC0, 0.0, col, gloss, env];
            }
        }
    }
    return r;
}

textureBody(string part, string params) {
    list p;
    integer i;
    if (part == "neck") {
        p = genTextureRules([40], ALL_SIDES, params);
    }
    else if (part == "upper") {
        p = genTextureRules(llList2List(BODY_LINKS, 0, 9) + [30], ALL_SIDES, params)
          + genTextureRules([31,32], 5, params);
    }
    else if (part == "lower") {
        p = genTextureRules(llList2List(BODY_LINKS, 10, -1), ALL_SIDES, params)
          + genTextureRules([33,34,35], 2, params);
    }
    // TODO: tattoo
    else if (part == "nipples") {
        p = genTextureRules([36,37,38,39], ALL_SIDES, params);
    }
    else if (part == "fnails") {
        p = genTextureRules([33,34,35], 1, params);
    }
    else {
        if (part == "rnails" || part == "hnails") {
            for (i = 0; i < 5; ++i) {
                p += genTextureRules([31], i, params);
            }
        }
        if (part == "lnails" || part == "hnails") {
            for (i = 0; i < 5; ++i) {
                p += genTextureRules([32], i, params);
            }
        }
    }
    if (p != []) {
        llSetLinkPrimitiveParamsFast(1, p);
    }
}

// Tints ///////////////////////////////////////////////////////////////////////////////////////

vector getTint(integer link, integer face) {
    return llList2Vector(llGetLinkPrimitiveParams(link, [PRIM_COLOR, face]), 0);
}

setTintSkin(vector rgb) {
    integer i;
    for (i = 2; i < 31; ++i) {
        llSetLinkColor(i, rgb, ALL_SIDES);
    }
    llSetLinkColor(31, rgb, 5);
    llSetLinkColor(32, rgb, 5);
    for (i = 33; i < 36; ++i) {
        llSetLinkColor(i, rgb, 2);
    }
    llSetLinkColor(40, rgb, ALL_SIDES);
}

setTintLayer(vector rgb) {
}

setTintNails(integer which, vector rgb) {
    if (which == 33) { // feet
        llSetLinkColor(33, rgb, 1);
        llSetLinkColor(34, rgb, 1);
        llSetLinkColor(35, rgb, 1);
    }
    else {
        integer i;
        for (i = 0; i < 5; ++i) {
            llSetLinkColor(which, rgb, i);
        }
    }
}

setTintNipples(vector rgb) {
    llSetLinkColor(36, rgb, ALL_SIDES);
    llSetLinkColor(37, rgb, ALL_SIDES);
    llSetLinkColor(38, rgb, ALL_SIDES);
    llSetLinkColor(39, rgb, ALL_SIDES);
}


////////////////////////////////////////////////////////////////////////////////////////////////
default {
    changed(integer what) {
        if (CHANGED_OWNER & what) {
            llResetScript();
        }
    }
    attach(key agent) {
        if (agent) {
            llResetScript();
        }
        else if (llGetAttached() == 0) {
            // inform we detached
            sendMsg("bye", "", "");
            llSetTimerEvent(0.0);
        }
    }
    state_entry() {
        llSetTimerEvent(0.0);
        restoreState();
        // simulate attach
        if (llGetAttached()) {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        }
    }
    run_time_permissions(integer perms) {
        if (perms & PERMISSION_TRIGGER_ANIMATION) {
            doAnkleLock();
            llSetTimerEvent(ANKLE_TIMER);
            // start listening to commands
            if (!osIsNpc(llGetKey())) {
                bodyChan = ownerChannel();
                llListen(bodyChan, "", "", "");
                // send a "hello" on our channel to inform an attached hud
                sendMsg("hello", "", "");
            }
        }
    }
    timer() {
        doAnkleLock();
    }
    listen(integer channel, string name, key id, string msg) {
        list l = llParseStringKeepNulls(msg, ["|"], []);
        if (llList2String(l, 0) != PRODUCT || llGetOwnerKey(id) != llGetOwner() || osIsNpc(llGetKey())) {
            return; // don't treat anything
        }
        msg = llList2String(l, 1);
        string cmd = llList2String(l, 2);
        string val = llList2String(l, 3);
        integer ival = (integer)val;

        if (msg == "ping") {
            // send the actual state of the body
            val = "";
            if (cmd == "settings") {
                val = dumpState() + ":" + dumpAlphas();
            }
            sendMsg("pong", cmd, val);
        }
        else if (msg == "chan") {
            listenUser(ival);
        }
        else if (msg == "alpha") {
            if (cmd == "P") {
                loadAlphas(val);
            }
            else if (cmd == "A") {
                setAlphas(BODY_LINKS + BODY_SPECS, bool(val));
            }
            else {
                if (~llSubStringIndex(cmd, ",")) { l = llParseString2List(cmd, [","], []); }
                else                             { l = [cmd]; }
                setAlphas(l, ival);
            }
        }
        else if (msg == "shape") {
            if (cmd == "neck")         { setNeck(ival, getAlpha(30, neckshape)); }
            else if (cmd == "neckfix") { neckfix = bool(val); setNeck(neckshape, getAlpha(30, neckshape)); }
            else if (cmd == "feet")    { if (val == "n") { val = nextFeet(); } setFeet(val, getAlpha(feet2link(feetshape), 2)); }
            else if (cmd == "nipples") { if (val == "n") { ival = nextNipples(); } setNipples(ival); }
            else if (cmd == "nails")   { if (val == "n") { ival = nextNails(); } setNails(ival); }
            else if (cmd == "fnails")  { fnails = bool(val); setFeet(feetshape, getAlpha(feet2link(feetshape), 2)); }
            else if (cmd == "ankle")   { setAnkleLock(bool(val)); }
        }
        else if (msg == "texture")     { textureBody(cmd, val); }
        else if (msg == "tint") {
            vector col = (vector)val;
            if (cmd == "skin")         { setTintSkin(col); }
            else if (cmd == "nipples") { setTintNipples(col); }
            else if (cmd == "rnails")  { setTintNails(31, col); }
            else if (cmd == "lnails")  { setTintNails(32, col); }
            else if (cmd == "hnails")  { setTintNails(31, col); setTintNails(32, col); }
            else if (cmd == "fnails")  { setTintNails(33, col); }
            else if (cmd == "layer")  { setTintLayer(col); }
        }
        else if (msg == "get") {
            if (cmd == "alpha")        { sendMsg(cmd, "P", dumpAlphas()); }
            else if (cmd == "state")   { sendMsg(cmd, "settings", dumpState()); }
            else if (cmd == "neck")    { sendMsg("shape", cmd, (string)neckshape); }
            else if (cmd == "neckfix") { sendMsg("shape", cmd, (string)neckfix); }
            else if (cmd == "feet")    { sendMsg("shape", cmd, feetshape); }
            else if (cmd == "nipples") { sendMsg("shape", cmd, (string)nipples); }
            else if (cmd == "nails")   { sendMsg("shape", cmd, (string)nails); }
            else if (cmd == "fnails")  { sendMsg("shape", cmd, (string)fnails); }
            else if (cmd == "ankle")   { sendMsg("shape", cmd, (string)anklelock); }
            else if (cmd == "texture") {
                if (val == "neck")         { sendMsg(cmd, val, getTexture(40, 0)); }
                else if (val == "upper")   { sendMsg(cmd, val, getTexture(2, 0)); }
                else if (val == "lower")   { sendMsg(cmd, val, getTexture(12, 0)); }
                else if (val == "nipples") { sendMsg(cmd, val, getTexture(36, 0)); }
                else if (val == "rnails")  { sendMsg(cmd, val, getTexture(31, 0)); }
                else if (val == "lnails")  { sendMsg(cmd, val, getTexture(32, 0)); }
                else if (val == "fnails")  { sendMsg(cmd, val, getTexture(33, 1)); }
                else if (val == "lupper")  { sendMsg(cmd, val, ""); }
                else if (val == "llower")  { sendMsg(cmd, val, ""); }
                else if (val == "gloves") { sendMsg(cmd, val, ""); }
                else if (val == "socks")  { sendMsg(cmd, val, ""); }
            }
            else if (cmd == "tint") {
                if (val == "skin")         { sendMsg(cmd, val, (string)getTint(2, 0)); }
                else if (val == "nipples") { sendMsg(cmd, val, (string)getTint(36, 0)); }
                else if (val == "rnails")  { sendMsg(cmd, val, (string)getTint(31, 0)); }
                else if (val == "lnails")  { sendMsg(cmd, val, (string)getTint(32, 0)); }
                else if (val == "fnails")  { sendMsg(cmd, val, (string)getTint(33, 1)); }
                else if (val == "layer")  { sendMsg(cmd, val, (string)VEC1); }
            }
        }
    }
}
 