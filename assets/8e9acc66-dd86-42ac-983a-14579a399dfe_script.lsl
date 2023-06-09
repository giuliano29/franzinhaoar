integer channel;
//vector color = <0,0,0>;
vector white  = <1,1,1>;
vector cream = <1.00000, 1.00000, 0.50196>;
vector orange = <1.00000, 0.50196, 0.00000>;
vector red = <1.00000, 0.00000, 0.00000>;
vector green = <0.25882, 0.40392, 0.00392>;
vector blue = <0.00000, 0.50196, 1.00000>;

// --- RoGe Allen Script-Service --- Lichtsteuerung
integer chan = 66715; // Kanal auf dem das Menue funktioniert 
integer zeit = 10; // Zeit nach der neu angeklickt werden muss (idle time)
float radius = 10.0; // Radius des Lichtes (mindestens 0.0 und maximal 20.0meter moeglich)
float falloff = 0.0; // Ausbreitung des Lichts zum Boden (0 = volle ausbreitung 1.0 = keine ausbreitung)
float staerke = 1.0; // staerke des lichtes (0.0 = aus ; 1.0 = volle staerke ; 0.5 = halbe staerke)
float glowstaerke = 0.1; // Staerke des Glow (0.1 = wenig Glow ; 1.0 = maximales Glow)
string kommando1 = "Light on"; // Button-Beschriftung (max. 24 Zeichen sonst Fehler)
string kommando2 = "Light off"; // Button-Beschriftung (max. 24 Zeichen sonst Fehler)
string kommando3 = "White"; // Button-Beschriftung (max. 24 Zeichen sonst Fehler)
string kommando4 = "Cream"; // Button-Beschriftung (max. 24 Zeichen sonst Fehler)
string kommando5 = "Orange"; // Button-Beschriftung (max. 24 Zeichen sonst Fehler)
string kommando6 = "Red"; // Button-Beschriftung (max. 24 Zeichen sonst Fehler)
string kommando7 = "Green";
string kommando8 = "Blue";
string kommando9 = "Color";
string kommando10 = "Back";
string dialognachricht = "menu"; // Nachricht (max 512 Zeichen)
//-------------------------------------------------------------------------------
// Ab hier bitte NIX mehr aendern, sonst gibt es boese Fehler!!!------------------
//-------------------------------------------------------------------------------
integer listener;
key wer = NULL_KEY;
vector farbe = <1,1,1>;
default
{
    state_entry()
    {
        
    }
    touch_start(integer total_number)
    {
        wer = llDetectedKey(0);
        listener = llListen(chan,"",NULL_KEY,"");
        llDialog(wer,dialognachricht,[kommando1,kommando2,kommando9],chan);
    }
    listen(integer channel,string name,key id,string mes)
    {
        list temper = llParseString2List(mes,["|"],[""]);
        if (llList2String(temper,0) == "Remote")
        {
            mes = llList2String(temper,1);
        }
        list params = [];
        if (mes == kommando1)
         {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, white, 1.0, 10.0, 0.00]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
        llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowstaerke]);

    }
        else if (mes == kommando2)
        {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE, <0,0,0>, 1.0, 0.0, 0.0]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
         llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0.0]);
        

    }
        
        else if (mes == kommando3)
        {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, white, 1.0, 10.0, 0.00]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
         llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowstaerke]);

    }
        else if (mes == kommando4)
        {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, cream, 1.0, 10.0, 0.00]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
         llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowstaerke]);

    }
        else if (mes == kommando5)
        {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, orange, 1.0, 10.0, 0.00]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
         llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowstaerke]);

    }
        else if (mes == kommando6)
        {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, red, 1.0, 10.0, 0.00]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
         llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowstaerke]);

    }
        else if (mes == kommando7)
        {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, green, 1.0, 10.0, 0.00]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
         llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowstaerke]);

    }
        else if (mes == kommando8)
        {
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, blue, 1.0, 10.0, 0.00]);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
         llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowstaerke]);

    }

        if (mes == kommando9)
        {
            if (mes == kommando9)
            {
                llDialog(wer,dialognachricht,[kommando3,kommando4,kommando5,kommando6,kommando7,kommando8],chan);
            }
        }
        else
        {
            if (llList2String(temper,0) != "Remote")
            {
                llListenRemove(listener);
                llRegionSay(chan,"Remote|"+mes);
                listener = llListen(chan,"",NULL_KEY,"");
            }
            temper = [];
            llSetPrimitiveParams(params);
            wer = NULL_KEY;
        }
    }
}
 