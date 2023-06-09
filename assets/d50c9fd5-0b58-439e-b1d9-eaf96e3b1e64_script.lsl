list ITEMS = ["Brush", "Red Wine F", "Red Wine M"];

// button name, link, face, uuid{, link, face, uuid...}
list TEXTURES = [
    "Tub Black",     1, 4, "b3299b94-3de7-4530-8864-122008e77422",   // Texture 7
    "Tub Silver",    1, 4, "368fa12b-1746-432b-a8f0-52c971f2871c",
    "Tub Bronze",    1, 4, "88c72ed8-73aa-41ac-8cbc-225811e57fef",
    "Metal Black",   1, 1, "c5d30c7f-d062-4ec2-921d-ad9d162e94c2",   // Texture 4
                     1, 3, "9481e822-5ac3-4685-8545-3ba45ed4650c",   // Texture 6
    "Metal Silver",  1, 1, "bd8af2b3-d70b-46b7-8bbe-9425cdf38b0e",
                     1, 3, "08006f84-2604-4912-afc9-616f224f6c30",
    "Metal Bronze",  1, 1, "d701b464-80aa-45b6-bcf3-89e30e76f96f",
                     1, 3, "6a9a8553-227b-494f-8994-8a7bcc87bfcf",
    "Faucet Black",  3, 0, "d4033b21-4bcb-4fda-b692-4858576ae709",
    "Faucet Silver", 3, 0, "a7b08d99-4313-40ce-b3e7-cd3a8c6a1de2",
    "Faucet Bronze", 3, 0, "d0ad19ec-7c72-4e36-b07f-fef711a0b5b4"
];

key active_sitter;
integer active_prim;
integer active_script_channel;
integer menu_channel;
integer menu_handle;
list menu = [];

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