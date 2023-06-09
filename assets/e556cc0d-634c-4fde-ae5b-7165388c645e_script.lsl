
integer CHANNEL = -3092;
key me;

setTextures(string texture) {
    llSetLinkTexture(5, texture, ALL_SIDES);
    llSetLinkTexture(4, texture, ALL_SIDES);
    llSetLinkTexture(3, texture, ALL_SIDES);
    llSetLinkTexture(2, texture, ALL_SIDES);
}

setColors(vector color) {
    llSetLinkColor(5, color, ALL_SIDES);
    llSetLinkColor(4, color, ALL_SIDES);
    llSetLinkColor(3, color, ALL_SIDES);
    llSetLinkColor(2, color, ALL_SIDES);
}

setAlphas(float soft, float hard) {
    llSetLinkAlpha(5, soft, ALL_SIDES);
    llSetLinkAlpha(4, soft, ALL_SIDES);
    llSetLinkAlpha(3, hard, ALL_SIDES);
    llSetLinkAlpha(2, hard, ALL_SIDES);
}

default {
    changed(integer what) {
        if (CHANGED_OWNER & what) {
            llResetScript();
        }
    }
    state_entry() {
        me = llGetOwner();
        llListen(CHANNEL, "", "", "");
    }
    touch_start(integer n) {
        key id = llDetectedKey(0);
        if (id == me || llGetOwnerKey(id) == me) {
            llDialog(me, " ", ["Soft", "Hard", "Hide"], CHANNEL);
        }
    }
    listen(integer chan, string name, key id, string msg) {
        if (id == me) { 
            if ("Soft" == msg) { setAlphas(1.0, 0.0); }
            else if ("Hard" == msg) { setAlphas(0.0, 1.0); }
            else if ("Hide" == msg) { setAlphas(0.0, 0.0); }
        }
        else if (llGetOwnerKey(id) == me) { 
            list p = llParseString2List(msg, [":"], []);
            msg = llList2String(p, 0);
            if (msg == "state") {
                msg = llList2String(p, 1);
                if ("hide" == msg) { setAlphas(0.0, 0.0); }
                else if ("soft" == msg) { setAlphas(1.0, 0.0); }
                else if ("hard" == msg) { setAlphas(0.0, 1.0); }
            }
            else if (msg == "tex") { setTextures(llList2String(p, 1)); }
            else if (msg == "color") { setColors((vector)llList2String(p, 1)); }
        }
    }
}

 