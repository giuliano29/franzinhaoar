list ITEMS = ["Toothbrush", "Shaving machine", "Hair dryer", "Hair brush", "Eyeshadow"];

// button name, link, face, uuid{, link, face, uuid...}
list TEXTURES = [
    "Top Black",     1, 5, "797de48a-50a3-4980-9f68-c9278d7c6336", // Texture 7
    "Top Silver",    1, 5, "5ed482ae-2308-46e2-8e27-ec3788c555e8",
    "Top Bronze",    1, 5, "5f8e4908-07fa-4530-80bb-c19dac220c81",
    "Faucet Black",  5, 0, "5f8687f7-7699-411f-949e-67256dbb9fcc", // Texture 10
    "Faucet Silver", 5, 0, "6af1f88b-799c-49e1-81ac-c6aa6cf33531",
    "Faucet Bronze", 5, 0, "23d4f7f8-a425-4163-8bb7-d553bda84862",
    "Wood 1",        1, 1, "3c0150a2-b420-49cd-8946-ff75d96a5887", // Texture 1
    "Wood 2",        1, 1, "45a53f0c-1abd-4cc0-825b-4236169b85d9",
    "Wood 3",        1, 1, "2fc6bbab-5725-473d-985a-c7accdebbcc7"
];

key active_sitter;
integer active_prim;
integer active_script_channel;
integer menu_channel;
integer menu_handle;
list menu = [];
integer waterlink = -1;

texture_menu() {
    list btns = menu;
    if (osIsUUID(active_sitter) && active_sitter != NULL_KEY) btns = "[BACK]" + btns;
    llListenRemove(menu_handle);
    menu_channel = ((integer)llFrand(0x7FFFFF80) + 1) * -1;
    menu_handle = llListen(menu_channel, "", llGetOwner(), "");
    llDialog(llGetOwner(), "Textures changer\n\n", llList2List(btns, -3, -1) +
        llList2List(btns, -6, -4) + llList2List(btns, -9, -7) + llList2List(btns, -12, -10), menu_channel);
    llSetTimerEvent(600.0);
}

default {
    state_entry() {
        integer c = llGetNumberOfPrims();
        for (; c > 1 && waterlink < 0; --c) if (llGetLinkName(c) == "water") waterlink = c;
        if (~waterlink) {
            llSetLinkAlpha(waterlink, 0.0, 0);
            llSetLinkTextureAnim(waterlink, ANIM_ON|SMOOTH|LOOP, 0, 2, 1, 0.0, 0.0, 0.7);
        }
        integer i;
        integer l;
        c = llGetListLength(TEXTURES);
        for (i = 0; i < c; i += 3) {
            l = llList2Integer(TEXTURES, i);
            if (l == 0) {
                menu += llList2String(TEXTURES, i);
                ++i;
            }
        }
        // register [TEXTURE] button
        llMessageLinked(LINK_SET, 90203, "", "");
    }
    timer() {
        llSetTimerEvent(0.0);
        llListenRemove(menu_handle);
    }
    link_message(integer sender, integer num, string msg, key id) {
        if (num == 90201) {
            llMessageLinked(LINK_SET, 90203, "", "");
        }
        else if (num == 90100) {
            list data = llParseString2List(msg, ["|"], []);
            if (llList2String(data, 1) == "[TEXTURE]") {
                if (id != llGetOwner()) {
                    llRegionSayTo(id, 0, "Sorry, only the owner can change textures.");
                    llMessageLinked(sender, 90101, llList2String(data, 0) + "|[ADJUST]|" + (string)id, llList2Key(data, 2));
                }
                else {
                    active_prim = sender;
                    active_script_channel = llList2Integer(data, 0);
                    active_sitter = llList2Key(data, 2);
                    texture_menu();
                }
            }
        }
        else if (num == 90033) {
            llListenRemove(menu_handle);
        }
        else if (num == 90005) {
            if (msg == "Items") llGiveInventoryList(id, llGetObjectName() + " items", ITEMS);
            else if (msg == "~Water" && waterlink > -1) llSetLinkAlpha(waterlink,
                1.0-llList2Float(llGetLinkPrimitiveParams(waterlink, [PRIM_COLOR, 0]), 1), 0);
        }
    }
    listen(integer channel, string name, key id, string msg) {
        if (msg == "[BACK]") {
            llMessageLinked(LINK_SET, 90101, (string)active_script_channel + "|[ADJUST]|" + (string)id, active_sitter);
        }
        else {
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
}
 