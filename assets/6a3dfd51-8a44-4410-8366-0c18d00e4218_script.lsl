integer version = 1;
integer gDicePrim0;
integer gDicePrim1;
integer main;
integer points_prim;
integer options_prim;
integer to_win;
integer border_prim;
integer glass_prim;
integer base_prim;
integer p1_chair;
integer p2_chair;
integer p3_chair;
integer p4_chair;
integer p5_chair;
integer p6_chair;
integer p7_chair;
integer p8_chair;
integer p1b;
integer p2b;
integer p3b;
integer p4b;
integer p5b;
integer p6b;
integer p7b;
integer p8b;

vector current_color = <1,1,1>;
vector black = <0,0,0>;
vector white = <1,1,1>;
vector yellow = <1,1,0>;
vector orange = <1,0.5,0>;
vector green = <0,1,0>;
vector blue = <0,0,1>;
vector red = <1,0,0>;

list colors = ["Black", "White", "Yellow", "Orange", "Green", "Blue", "Red"];

integer menu_channel;

key request = NULL_KEY;

reset_scripts()
{
    integer count = llGetInventoryNumber(INVENTORY_SCRIPT);
    while (count--)
    {
        string script = llGetInventoryName(INVENTORY_SCRIPT, count);
        if (script != llGetScriptName())
        {
            llResetOtherScript(script);
        }
    }
}

enumeratePrims()
{
    integer linkIndex = llGetNumberOfPrims();
    for (;linkIndex >= 1; --linkIndex)
    {
        string linkName = llGetLinkName(linkIndex);
        if (linkName == "D1") gDicePrim0 = linkIndex;
        else if (linkName == "D2") gDicePrim1 = linkIndex;
        else if (linkName == "center") main = linkIndex;  // xyzzytext-0-0
        else if (linkName == "options") options_prim = linkIndex;
        else if (linkName == "border") border_prim = linkIndex;
        else if (linkName == "glass") glass_prim = linkIndex;
        else if (linkName == "to_win") to_win = linkIndex;
        else if (linkName == "points") points_prim = linkIndex;

        else if (linkName == "s1") p1_chair = linkIndex;
        else if (linkName == "s2") p2_chair = linkIndex;
        else if (linkName == "s3") p3_chair = linkIndex;
        else if (linkName == "s4") p4_chair = linkIndex;
        else if (linkName == "s5") p5_chair = linkIndex;
        else if (linkName == "s6") p6_chair = linkIndex;
        else if (linkName == "s7") p7_chair = linkIndex;
        else if (linkName == "s8") p8_chair = linkIndex;
        else if (linkName == "s1b") p1b = linkIndex;
        else if (linkName == "s2b") p2b = linkIndex;
        else if (linkName == "s3b") p3b = linkIndex;
        else if (linkName == "s4b") p4b = linkIndex;
        else if (linkName == "s5b") p5b = linkIndex;
        else if (linkName == "s6b") p6b = linkIndex;
        else if (linkName == "s7b") p7b = linkIndex;
        else if (linkName == "s8b") p8b = linkIndex;
    }
}

set_color()
{
    llSetLinkColor(base_prim, current_color, ALL_SIDES);
    llSetLinkColor(border_prim, current_color, ALL_SIDES);
    llSetLinkColor(glass_prim, current_color, ALL_SIDES);
    // SEATS
    llSetLinkColor(p1_chair, current_color, 1);
    llSetLinkColor(p2_chair, current_color, 1);
    llSetLinkColor(p3_chair, current_color, 1);
    llSetLinkColor(p4_chair, current_color, 1);
    llSetLinkColor(p5_chair, current_color, 1);
    llSetLinkColor(p6_chair, current_color, 1);
    llSetLinkColor(p7_chair, current_color, 1);
    llSetLinkColor(p8_chair, current_color, 1);
    llSetLinkColor(p1b, current_color, ALL_SIDES);
    llSetLinkColor(p2b, current_color, ALL_SIDES);
    llSetLinkColor(p3b, current_color, ALL_SIDES);
    llSetLinkColor(p4b, current_color, ALL_SIDES);
    llSetLinkColor(p5b, current_color, ALL_SIDES);
    llSetLinkColor(p6b, current_color, ALL_SIDES);
    llSetLinkColor(p7b, current_color, ALL_SIDES);
    llSetLinkColor(p8b, current_color, ALL_SIDES);
}

default
{
    on_rez(integer x)
    {
        llResetScript();
    }

    state_entry()
    {
        enumeratePrims();
        menu_channel = llFloor(llFrand(99999)) * -1;
        llListen(menu_channel, "", llGetOwner(), "");
    }

    touch_start(integer x)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            integer face = llDetectedTouchFace(0);

            if (llDetectedLinkNumber(0) == options_prim)
            {
                if (face == 0)
                {
                    llDialog(llDetectedKey(0), "Please choose your option.", ["Reset"], menu_channel);
                }
            }
        }
    }

    listen(integer c, string n, key i, string m)
    {
        if (i != llGetOwner())
            return;

        // list colors = ["Black", "White", "Yellow", "Orange", "Green", "Blue", "Red"];
        if (c == menu_channel)
        {
            if (m == "Colors")
            {
                llDialog(i, "Please choose your color", colors, menu_channel);
            }
            else if (m == "Reset")
            {
                llWhisper(0, "Resetting.");
                reset_scripts();
            }
            else
            {
                if (m == "Black")
                    current_color = black;
                else if (m == "White")
                    current_color = white;
                else if (m == "Yellow")
                    current_color = yellow;
                else if (m == "Orange")
                    current_color = orange;
                else if (m == "Green")
                    current_color = green;
                else if (m == "Blue")
                    current_color = blue;
                else if (m == "Red")
                    current_color = red;

                set_color();
            }
        }
    }

    link_message(integer sender_num, integer num, string message, key id)
    {
        if (num == 4444)
        {
            reset_scripts();
        }
    }
}
