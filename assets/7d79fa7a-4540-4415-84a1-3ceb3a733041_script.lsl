
float   Timeout     = 399600.0;
key     Owner;

integer LinkScope_i = LINK_THIS;
default
{
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number != -99 || (string)id != "#STATUS" ) { return; }
        if (message == "" || message == llGetScriptName()) { llMessageLinked(LinkScope_i, -98, llGetScriptName(), (key)"#ACTIVE"); }
        else if (message == "#START") { state default_start; }
        else { return; }
    }
}

state default_start
{
    state_entry() {
        Owner = llGetOwner();
    }

    link_message(integer sender, integer num, string str, key id) {
        if (str == "PRIMTOUCH") {
            return;
        }

        if (num == 0 && str == "POSEB") {
            llSetTimerEvent(Timeout);
            return;
        }

        if (num == 1 && str == "STOP") {
            llSetTimerEvent(0.0);
            return;
        }
    }

    timer() {
        llMessageLinked(LinkScope_i, -12002, "STOP", (key)"");
        llSetTimerEvent(0.0);
    }

    changed(integer change) {
        if ((change & CHANGED_OWNER) && llGetOwner() != Owner) {
            Owner = llGetOwner();
            llSetScriptState(llGetScriptName(), FALSE);
        }
    }
}
