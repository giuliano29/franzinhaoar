// button name, link, face, uuid{, link, face, uuid...}
list TEXTURES = [
    "Black",     1, 0, "c868870d-c82d-45b6-a890-382b377f3d19",   // Texture 1
    "Silver",    1, 0, "bb04e445-2093-4238-b4f9-65e13c9b5a1a",
    "Bronze",    1, 0, "063cabb4-d5b4-4ebc-8289-de19ba0f928a"
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