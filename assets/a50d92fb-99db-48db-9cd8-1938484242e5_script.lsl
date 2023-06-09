// button name, link, face, uuid{, link, face, uuid...}
list TEXTURES = [
    "Seat Black",   1, 4, "17e447e7-d753-4ec2-8440-c97636e1de54", // Texture 8
                    3, 2, "6aec9c34-40af-4806-898d-2ceaf94ab526", // Texture 3
    "Seat White",   1, 4, "df393398-7d61-42a0-8fb6-a9bd3bab7ffd",
                    3, 2, "6e0c8215-27c2-4970-bda2-ffd8cbb208e7",
    "Seat Bronze",  1, 4, "d4cc4ab6-0dac-4234-9ebd-93edf75f9903",
                    3, 2, "050a4053-c596-40c9-af74-e0d9abcf9c55",
    "Metal Black",  1, 3, "f769d643-c214-425d-bb0b-bac0464c6def", // Texture 7
                    3, 1, "aa84be57-6bab-4856-8816-5e05e7e7a631", // Texture 2
    "Metal Silver", 1, 3, "0cca7f6d-60c0-446a-9ab3-41013bb1d924",
                    3, 1, "2b6fa233-d717-4179-afad-8f362ec03a89",
    "Metal Bronze", 1, 3, "9385230d-660f-4e78-87f6-b63dc3e8cfbf",
                    3, 1, "2aeb1a85-6c00-45b6-9d2f-9bdd2878ec0f"
];

key active_sitter;
integer active_prim;
integer active_script_channel;
integer menu_channel;
integer menu_handle;
list menu = [];
integer flaplink = -1;
string snd;

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
        for (; c > 1 && flaplink < 0; --c)
            if (llGetLinkName(c) == "flap") flaplink = c;
        snd = llGetInventoryName(INVENTORY_SOUND, 0);
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
    changed(integer c) {
        if (c & CHANGED_LINK) {
            if (llGetAgentSize(llGetLinkKey(llGetNumberOfPrims())) == ZERO_VECTOR) {
                if (~flaplink) llSetLinkPrimitiveParamsFast(flaplink, [PRIM_ROT_LOCAL, <0.0, 0.0, 0.0, 1.0>]);
                if (snd != "") llStopSound();
            }
            else {
                if (~flaplink) llSetLinkPrimitiveParamsFast(flaplink, [PRIM_ROT_LOCAL, <-0.707107,0.000000,0.000000,0.707107>]);
            }
        }
    }
    link_message(integer sender, integer num, string str, key id) {
        if (num == 90201) {
            llMessageLinked(LINK_SET, 90203, "", "");
        }
        else if (num == 90100) {
            list data = llParseString2List(str, ["|"], []);
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
        else if (num == 90045 && snd != "") {
            list data = llParseStringKeepNulls(str, ["|"], []);
            str = llList2String(data, 1);
            if (~llSubStringIndex(str, "Pee")) llLoopSound(snd, 1.0);
            else llStopSound();
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