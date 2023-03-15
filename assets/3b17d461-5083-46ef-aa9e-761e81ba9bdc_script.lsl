//Color changing script by SoLur Industries

//If you have purchased this script from myself, or SoLur Industries, you are free to modify it and use it in products.
//This script is not meant to be given away or used without permission or purchase, however.
//Please leave this above message in all copies of this script!
//Thank you!
//-Sol Columbia


list grayscale =["black",<0,0,0>,"white",<1,1,1>,"gray",<0.5,0.5,0.5>,"silver",<0.75,0.75,0.75>,"darkgray",<0.4,0.4,0.4>,
    "lightgrey",<0.83,0.83,0.83>];
list reds = ["red",<1,0,0>,"darkred",<0.55,0,0>,"crimson",<0.86,0.08,0.24>,"indianred",<0.8,0.36,0.36>,
    "orangered",<1,0.27,0>];
list pinks = ["hotpink",<1,0.41,0.71>,"pink", <1,0.75,0.8>,"lightpink",<1,0.71,0.76>,"deeppink",<1,0.08,0.58>,
    "fuchsia",<1,0,1>,"orchid",<0.85,0.44,0.84>,"plum",<0.87,0.63,0.87>];
list violets = ["violet",<0.8,0.51,0.8>,"indigo",<0.29,0,0.51>,"lavender",<0.7,0.7,1>,"magenta",<1,0,1>,
    "purple",<0.5,0,0.5>,"darkmagenta",<0.55,0,0.55>,"darkviolet",<0.58,0,0.83>,"blueviolet",<0.54,0.17,0.89>];
list dk_blues = ["darkblue",<0,0,0.55>,"blue",<0,0,1>,"deepskyblue",<0,0.75,1>,"mediumblue",<0,0,0.8>,
    "midnightblue",<0.1,0.1,0.44>,"royalblue",<0.25,0.41,0.88>,"slateblue",<0.42,0.35,0.8>,"steelblue",<0.27,0.51,0.71>];
list lt_blues = ["teal",<0,0.5,0.5>,"turquoise",<0.25,0.88,0.82>,"darkcyan",<0,0.55,0.55>, "lightblue", <0.68,0.85,0.9>,
    "aquamarine",<0.5,1,0.83>,"azure",<0.8,1,1>,"cyan",<0,1,0.9>,"skyblue",<0.53,0.81,0.92>];
list yellows = ["yellow",<1,1,0>,"gold",<1,0.84,0>,"lightyellow",<1,1,0.88>,"goldenrod",<0.85,0.65,0.13>,
    "yellowgreen",<0.6,0.8,0.2>];
list dk_greens = ["darkgreen",<0,0.39,0>,"green",<0,0.5,0>,"forestgreen",<0.13,0.55,0.13>,"lawngreen",<0.49,0.99,0>,
    "springgreen",<0,1,0.5>];
list lt_greens = ["lightgreen",<0.56,0.93,0.56>,"chartreuse",<0.5,1,0>,"greenyellow",<0.68,1,0.18>,"honeydew",<0.94,1,0.94>,
    "limegreen",<0.2,0.8,0.2>,"mintcream",<0.96,1,0.98>,"seagreen",<0.18,0.55,0.34>];
list oranges = ["orange",<1,0.65,0>,"darkorange",<1,0.55,0>,"coral",<1,0.5,0.31>,"navajowhite",<1,0.87,0.68>,
    "salmon",<0.98,0.5,0.45>,"seashell",<1,0.96,0.93>,"brown",<.24,.17,.15>];

//Typically you wouldn't change anything below here, but if you're feelin it, who's gonna stop you?!
//---------------------------------------------------------

integer channel; 
integer listen_handle;
key owner;
list sub_menu;
list main_menu = ["grayscale", "reds", "pinks", "violets", "dk_blues", "lt_blues", "yellows", "dk_greens", "lt_greens", "oranges"];


init() {
    llListenRemove(listen_handle);
    owner = llGetOwner();
    channel = llFloor(llFrand(2000000));  //random channel so multiple scripts don't interfere with each other
    listen_handle = llListen(channel, "", owner, "");
}


default
{
    on_rez(integer s) { init(); }
    state_entry() { init(); }
        
    listen(integer channel, string name, key id, string message) {
                        
        if (llListFindList(main_menu, [message]) != -1) {
            if (message == "grayscale") sub_menu = grayscale; 
            else if (message == "reds") sub_menu = reds;
            else if (message == "pinks") sub_menu = pinks;
            else if (message == "violets") sub_menu = violets;
            else if (message == "dk_blues") sub_menu = dk_blues;
            else if (message == "lt_blues") sub_menu = lt_blues;
            else if (message == "yellows") sub_menu = yellows;
            else if (message == "dk_greens") sub_menu = dk_greens;
            else if (message == "lt_greens") sub_menu = lt_greens;
            else if (message == "oranges") sub_menu = oranges;
            
            llDialog(owner, "\n\nSelect a color", llList2ListStrided(sub_menu, 0, -1, 2), channel);
            return;  
        } 
        
        integer index = llListFindList(sub_menu, [message]);
        if (index != -1) {
            vector color_vector = llList2Vector(sub_menu, index+1);
            if (llGetLinkNumber() == 1) llSetLinkColor(LINK_SET, color_vector, ALL_SIDES);  //If it's root prim, do whole set
            else llSetColor(color_vector, ALL_SIDES);  //otherwise, just do that prim
        }
        
    }   
    
    touch_start(integer s) {
        if (llDetectedKey(0) == owner) {    
            llDialog(owner, "\n\nSelect a color group", main_menu, channel);
        }
    }
}