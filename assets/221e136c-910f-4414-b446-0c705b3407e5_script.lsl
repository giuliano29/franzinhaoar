list ITEMS = ["Razor female"];

// button name, link, face, uuid{, link, face, uuid...}
list TEXTURES = [
    "Door Black",    1, 3, "15df98c3-4a95-44e7-aae7-adbbd93a5469",  // Texture 6 (static door)
                     1, 5, "2691469e-2fcd-4ebe-9265-41fb3e09f409",  // Texture 8 (static door)
                     1, 6, "684b8c89-3449-48c4-a9bb-58c5b0f67505",  // Texture 9 (static door)
                     5, 0, "3780a7cf-2ed2-4da2-ae3e-cd37da3f8032",  // Texture 13 (left door)
                     5, 1, "c1c387e0-6c3e-42a5-b393-735dbfe6ee84",  // Texture 14 (left door)
                     5, 2, "e2fc919b-9117-45b4-8f43-b7695d507cf5",  // Texture 15 (left door)
                     7, 0, "605d4a5c-0121-4196-8dee-7b357fe48a69",  // Texture 17 (right door)
                     7, 1, "7b429f86-fb2d-4222-956b-7af16a4a543e",  // Texture 18 (right door)
                     7, 2, "8b6df93c-3c1a-4e03-b4da-2e359119e2cd",  // Texture 19 (right door)
    "Door Silver",   1, 3, "209f3e40-3cf9-4d7f-9de4-81aae0a19c9c",
                     1, 5, "3922c72e-855a-4fa5-af0c-b9a48de39e15",
                     1, 6, "a013b150-bc31-4591-94a6-8617968b14fd",
                     5, 0, "c47c787c-3b85-4341-ab85-356847387eb9",
                     5, 1, "9c7863f0-f6eb-461e-b41b-475dc8d5c5b7",
                     5, 2, "2d2151b8-2772-4332-9bca-571fcc681869",
                     7, 0, "9dc86354-3058-4a32-b2d3-2bc5d8bb18c1",
                     7, 1, "dc548de7-0e76-400d-a2b5-f9115dc19466",
                     7, 2, "411ac27d-0547-4d01-9e99-3568e74e0123",
    "Door Bronze",   1, 3, "35317a48-7a99-43ce-9a59-91c2660da84d",
                     1, 5, "d4e1e6ec-6dad-4ac8-8bb7-b2ecfe9ff3e2",
                     1, 6, "c0284c1e-4dc4-43ec-8b89-2bc41b4fd58a",
                     5, 0, "35568f60-1c0c-4a8a-8d37-cc3f1c48f753",
                     5, 1, "cb8ff37e-0937-4e08-b8ff-41c4b9452475",
                     5, 2, "10d5c088-1f4f-466b-a7e1-0f6428dc1af9",
                     7, 0, "3e84aa5d-7859-47f2-9a70-1435e20de85d",
                     7, 1, "b3168b19-71b7-43a7-b99d-f39dbb695823",
                     7, 2, "94f10bbd-1a32-420f-a789-0a67730ffc07",
    "Faucet Black",  2, 0, "cba9d086-1eff-4d68-8366-9a091bebedec",  // Texture 1
    "Faucet Silver", 2, 0, "c84577cd-1771-41e2-a460-0aacb1a698ce",
    "Faucet Bronze", 2, 0, "8382edb5-2c4c-4570-a256-999819012e0a",
    "Wood 1",        1, 0, "137ff864-a138-44e4-80ac-1eec381fec31",  // Texture 3
    "Wood 2",        1, 0, "14d0ac75-fd5b-4eae-9a6c-f16a6389416e",
    "Wood 3",        1, 0, "ea24de1f-3a27-402e-8989-d0558322a010"
];

key active_sitter;
integer active_prim;
integer active_script_channel;
integer menu_channel;
integer menu_handle;
list menubtns = [];
string menucur;
integer waterlink = -1;
integer coldlink = -1;
integer hotlink = -1;
integer auto = TRUE;

integer isSitting() {
    return (llGetAgentSize(llGetLinkKey(llGetNumberOfPrims())) != ZERO_VECTOR);
}

// set=cold, hot, or anything else to stop
setWater(string set) {
    if (set == "auto") set = llList2String(["off", "hot"], isSitting());
    integer water = (set == "cold" || set == "hot");
    list cold = [];
    list hot = [];
    if (water) cold = [
        PSYS_PART_FLAGS,( 0 
            |PSYS_PART_INTERP_COLOR_MASK
            |PSYS_PART_INTERP_SCALE_MASK
            |PSYS_PART_FOLLOW_VELOCITY_MASK
            |PSYS_PART_EMISSIVE_MASK ), 
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE ,
        PSYS_PART_START_ALPHA,0.419608,
        PSYS_PART_END_ALPHA,0.470588,
        PSYS_PART_START_COLOR,<0.996078,1,0.972549> ,
        PSYS_PART_END_COLOR,<0.956863,1,0.976471> ,
        PSYS_PART_BLEND_FUNC_SOURCE,7,
        PSYS_PART_BLEND_FUNC_DEST,9,
        PSYS_PART_START_GLOW,0,
        PSYS_PART_END_GLOW,0,
        PSYS_PART_START_SCALE,<0.21875,0.53125,0>,
        PSYS_PART_END_SCALE,<0.1875,0.5,0>,
        PSYS_PART_MAX_AGE,1.58984,
        PSYS_SRC_MAX_AGE,0,
        PSYS_SRC_ACCEL,<0,0,-0.382812>,
        PSYS_SRC_BURST_PART_COUNT,2,
        PSYS_SRC_BURST_RADIUS,0.269531,
        PSYS_SRC_BURST_RATE,0.01,
        PSYS_SRC_BURST_SPEED_MIN,1.25,
        PSYS_SRC_BURST_SPEED_MAX,1.9375,
        PSYS_SRC_ANGLE_BEGIN,0.25,
        PSYS_SRC_ANGLE_END,0,
        PSYS_SRC_OMEGA,<0,0,0>,
        PSYS_SRC_TEXTURE, (key)"dda57b13-493f-490c-ab55-0df66b3a7ee9",
        PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"
    ];
    if (set == "hot") hot = [
        PSYS_PART_FLAGS,( 0 
            |PSYS_PART_INTERP_COLOR_MASK
            |PSYS_PART_INTERP_SCALE_MASK
            |PSYS_PART_FOLLOW_VELOCITY_MASK
            |PSYS_PART_EMISSIVE_MASK ), 
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE ,
        PSYS_PART_START_ALPHA,0.270588,
        PSYS_PART_END_ALPHA,0,
        PSYS_PART_START_COLOR,<1,1,1> ,
        PSYS_PART_END_COLOR,<0.8,0.8,0.85098> ,
        PSYS_PART_BLEND_FUNC_SOURCE,7,
        PSYS_PART_BLEND_FUNC_DEST,9,
        PSYS_PART_START_GLOW,0,
        PSYS_PART_END_GLOW,0,
        PSYS_PART_START_SCALE,<0.0625,0.0625,0>,
        PSYS_PART_END_SCALE,<1.1875,1.28125,0>,
        PSYS_PART_MAX_AGE,2.82812,
        PSYS_SRC_MAX_AGE,0,
        PSYS_SRC_ACCEL,<0,0,-0.601562>,
        PSYS_SRC_BURST_PART_COUNT,4,
        PSYS_SRC_BURST_RADIUS,0,
        PSYS_SRC_BURST_RATE,0.0898438,
        PSYS_SRC_BURST_SPEED_MIN,0,
        PSYS_SRC_BURST_SPEED_MAX,0.167969,
        PSYS_SRC_ANGLE_BEGIN,1.25,
        PSYS_SRC_ANGLE_END,2.25,
        PSYS_SRC_OMEGA,<0,0,0>,
        PSYS_SRC_TEXTURE, (key)"23ac3bf9-23f0-44f3-a0c1-8417bc75cccf",
        PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"
    ];
    llSetLinkAlpha(waterlink, (float)water, 0);
    llLinkParticleSystem(coldlink, cold);
    llLinkParticleSystem(hotlink, hot);
}

texture_menu() {
    menucur = "textures";
    dialog(llGetOwner(), "\nTexture changer\n\n", menubtns);
}

water_menu(key who) {
    menucur = "water";
    dialog(who, "\nControl water\n\n", ["Cold", "Hot", "Off", " ", " "]);
}

dialog(key id, string text, list btns) {
    llListenRemove(menu_handle);
    if (osIsUUID(active_sitter) && active_sitter != NULL_KEY) btns = "[BACK]" + btns;
    menu_channel = ((integer)llFrand(0x7FFFFF80) + 1) * -1;
    menu_handle = llListen(menu_channel, "", id, "");
    llDialog(id, text, llList2List(btns, -3, -1) + llList2List(btns, -6, -4) +
        llList2List(btns, -9, -7) + llList2List(btns, -12, -10), menu_channel);
    llSetTimerEvent(600.0);
}

default {
    state_entry() {
        integer c = llGetNumberOfPrims();
        string link;
        for (; c > 1/* && (waterlink < 0 || coldlink < 0 || hotlink < 0)*/; --c) {
            link = llGetLinkName(c);
            if (link == "water") waterlink = c;
            else if (link == "cold") coldlink = c;
            else if (link == "hot") hotlink = c;
        }
        if (waterlink > 0 && coldlink > 0 && hotlink > 0) {
            llSetLinkTextureAnim(waterlink, ANIM_ON | LOOP, 0, 5, 4, 0.0, 0.0, 10.0);
            setWater("auto");
        }
        integer i;
        integer l;
        c = llGetListLength(TEXTURES);
        for (i = 0; i < c; i += 3) {
            l = llList2Integer(TEXTURES, i);
            if (l == 0) {
                menubtns += llList2String(TEXTURES, i);
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
                    llMessageLinked(sender, 90101,
                        llList2String(data, 0) + "|[ADJUST]|" + (string)id, llList2Key(data, 2));
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
            else if (msg == "~Doors") llMessageLinked(LINK_ALL_OTHERS, 56, "touch", "door");
        }
        else if (num == 58 && waterlink > 0 && coldlink > 0 && hotlink > 0) {
                active_prim = sender;
                active_script_channel = (integer)msg;
                active_sitter = id;
                water_menu(id);
        }
    }
    changed(integer c) {
        if ((c & CHANGED_LINK) && auto == TRUE) setWater("auto");
    }
    listen(integer channel, string name, key id, string msg) {
        if (msg == "[BACK]") {
            if (menucur == "textures")
                llMessageLinked(LINK_SET, 90101,
                    (string)active_script_channel + "|[ADJUST]|" + (string)id, active_sitter);
            else
                llMessageLinked(LINK_SET, 90004, "", active_sitter);
        }
        else if (menucur == "textures") {
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
        else if (menucur == "water") {
            if (msg == "Cold") setWater("cold");
            else if (msg == "Hot") setWater("hot");
            else if (msg == "Off") setWater("off");
            water_menu(id);
        }
    }
}
 