list COLORS = [
    "White", <1.0, 1.0, 1.0>,
    "Red",   <1.0, 0.0, 0.0>,
    "Green", <0.0, 1.0, 0.0>,
    "Blue",  <0.0, 0.0, 1.0>,
    "Yellow", <1.0, 1.0, 0.0>,
    "Pink",   <1.0, 0.0, 1.0>,
    "Cyan",   <0.0, 1.0, 1.0>,
    "Purple", <0.5, 0.0, 1.0>
];

integer menu_channel;
integer menu_handle;
vector color = <1.0, 1.0, 1.0>;
integer holding = FALSE;

integer get_light() {
    return llList2Integer(llGetPrimitiveParams([PRIM_FULLBRIGHT, 0]), 0);
}

set_light(integer on) {
    llSetLinkPrimitiveParamsFast(LINK_THIS, [
        PRIM_FULLBRIGHT, 0, on,
        PRIM_GLOW, 0, (float)on,
        PRIM_COLOR, 0, llList2Vector([<1,1,1>, color], on), 1.0,
        PRIM_POINT_LIGHT, on, color, 1.0, 10.0, 0.75
    ]);
}

light_menu(key who) {
    list menu = llList2ListStrided(COLORS, 0, -1, 2);
    llListenRemove(menu_handle);
    menu_channel = ((integer)llFrand(0x7FFFFF80) + 1) * -1;
    menu_handle = llListen(menu_channel, "", "", "");
    llDialog(who, "Light color changer\n\n", llList2List(menu, -3, -1) +
        llList2List(menu, -6, -4) + llList2List(menu, -9, -7) + llList2List(menu, -12, -10), menu_channel);
    llSetTimerEvent(600.0);
}

default {
    state_entry() {
        set_light(FALSE);
    }
    touch_start(integer n) {
        llResetTime();
    }
    touch_end(integer n) {
        if (llGetTime() > 1.0) light_menu(llDetectedKey(0));
        else set_light(1 - get_light());
    }
    timer() {
        llSetTimerEvent(0.0);
        llListenRemove(menu_handle);
    }
    listen(integer channel, string name, key id, string msg) {
        integer i = llListFindList(COLORS, [msg]) + 1;
        if (i) {
            color = llList2Vector(COLORS, i);
            set_light(TRUE);
        }
        light_menu(id);
    }
}
 