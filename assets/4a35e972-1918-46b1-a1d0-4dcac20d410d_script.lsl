// button name, link, face, uuid{, link, face, uuid...}
list TEXTURES = [
    "Black",     1, 0, "1d5bb4ed-27b0-44e2-826f-dbd487aa9e25",   // Texture 2
    "Silver",    1, 0, "240fe410-37ec-4cfb-9aa4-5aec54069ea1",
    "Bronze",    1, 0, "e9b94639-d7ac-4dcc-905c-b53d19121202"
];

integer menu_channel;
integer menu_handle;
list menu = [];

texture_menu() {
    llListenRemove(menu_handle);
    menu_channel = ((integer)llFrand(0x7FFFFF80) + 1) * -1;
    menu_handle = llListen(menu_channel, "", llGetOwner(), "");
    llDialog(llGetOwner(), "Textures changer\n\n", llList2List(menu, -3, -1) +
        llList2List(menu, -6, -4) + llList2List(menu, -9, -7) + llList2List(menu, -12, -10), menu_channel);
    llSetTimerEvent(600.0);
}

default {
    state_entry() {
        // build texture menu
        integer i;
        integer c = llGetListLength(TEXTURES);
        integer l;
        for (i = 0; i < c; i += 3) {
            l = llList2Integer(TEXTURES, i);
            if (l == 0) {
                menu += llList2String(TEXTURES, i);
                ++i;
            }
        }
    }
    timer() {
        llSetTimerEvent(0.0);
        llListenRemove(menu_handle);
    }
    touch_start(integer n) {
        key id;
        while (~(--n)) {
            id = llDetectedKey(n);
            if (id != llGetOwner()) llRegionSayTo(id, 0, "Sorry, only the owner can change textures.");
            else texture_menu();
        }
    }
    listen(integer channel, string name, key id, string msg) {
        integer i = llListFindList(TEXTURES, [msg]) + 1;
        if (i) {
            integer link = 1;
            integer num = llGetListLength(TEXTURES);
            llOwnerSay("Applying " + msg);
            for (; i < num && link > 0; i+=3) {
                link = llList2Integer(TEXTURES, i);
                if (link > 0) llSetLinkTexture(link, llList2String(TEXTURES, i+2), llList2Integer(TEXTURES, i+1));
            }
        }
        texture_menu();
    }
}
 