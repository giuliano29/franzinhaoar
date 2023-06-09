vector CLOSED = <0.466877,-1.158153,-0.033447>;
float MOVE = -0.85;

doMove() {
    vector pos = llGetLocalPos();
    float dir = llList2Float([1, -1], (integer)(llVecDist(CLOSED, pos) > 0.1));
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POS_LOCAL, pos + <MOVE * dir, 0, 0> * llGetLocalRot()]);
}

default {
    touch_start(integer n) {
        llMessageLinked(LINK_ALL_OTHERS, 56, "touch", "door");
        doMove();
    }
    link_message(integer sender, integer num, string str, key id) {
        if (num == 56 && (string)id == "door") doMove();
    }
}
 