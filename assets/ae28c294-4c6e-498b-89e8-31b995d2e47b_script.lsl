default
{
    touch_start(integer n)
    {
        llRezObject("CircusHorse", llGetPos() + <-3, 0, -1>*llGetRot(), <0,0,0>, ZERO_ROTATION, 1);
    }
}

 