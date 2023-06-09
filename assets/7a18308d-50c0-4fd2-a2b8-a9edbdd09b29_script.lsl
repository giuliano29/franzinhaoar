// button name, link, face, uuid{, link, face, uuid...}
list TEXTURES = [
    "Frame Black",  1, 0, "7dda52de-729f-453f-9147-306fb63c2451",   // Texture 2
                    1, 2, "18920616-25f5-4fc6-abb0-cee76ae3b23f",   // Texture 4
                    1, 3, "afb1bc0a-b590-4c15-8b23-a95d5bee2bc1",   // Texture 5
    "Frame Silver", 1, 0, "76153369-2f41-4d30-901b-3f52c24527e0",
                    1, 2, "5ec66e47-9bf7-425b-8535-888d25efaadc",
                    1, 3, "9c720f63-d03f-4e4a-aa32-48e737f9a913",
    "Frame Bronze", 1, 0, "bb50e849-5e27-41e3-ac27-5ecc0d818818",
                    1, 2, "e8cbf5af-ec33-4dfd-8ade-4a48bd4771e1",
                    1, 3, "53939386-350c-4eb5-a341-dd95cbb723fa",
    "Mirror 1",     1, 1, "e68f5613-1158-4880-aad1-d05415d8a65a",   // Texture 3
    "Mirror 2",     1, 1, "329e87ea-42cc-46d0-b536-264552b16c8c",
    "Mirror 3",     1, 1, "5d887f43-dcec-44fa-bdfc-67ddfbb325ab"
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