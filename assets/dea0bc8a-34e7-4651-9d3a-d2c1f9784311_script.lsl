vector POSITION=<0.0, 0.0, 0.01>;
vector ROTATION = <0.0, 0.0, 0.0>;
string HOVERTEXT="";
string SIT_TEXT="";
string HOVER_RGB="255,255,255";
list rgb;
string animation;

list anims2stop;
float sleep = 0.5;



stop_anim(){
    integer list_pos = 0;
    integer list_length = llGetListLength(anims2stop);
    if(list_length > 0){
        while(list_pos < list_length){
            llStopAnimation(llList2String(anims2stop, list_pos));
            list_pos++;
        }
    }
}

set_text()
{
    if (llStringLength(HOVERTEXT)>0)
    {
        rgb=llCSV2List(HOVER_RGB);
        llSetText(HOVERTEXT,<llList2Float(rgb,0)*0.003921568627450980392156862745098,llList2Float(rgb,1)*0.003921568627450980392156862745098,llList2Float(rgb,2)*0.003921568627450980392156862745098>,1.0);

    }
    else
        llSetText("",<0,0,0>,0.0);
}

HideBall() // boogers
{
    llSetAlpha(0.0, ALL_SIDES);
    llSetText("",<0,0,0>,0.0);
}

ShowBall()
{
    llSetAlpha(1.0, ALL_SIDES);
    set_text();
}


default
{
    state_entry()
    {
        if (llStringLength(SIT_TEXT)>0)
            llSetSitText(SIT_TEXT);
        vector input = ROTATION * DEG_TO_RAD;
        rotation rot = llEuler2Rot(input);
        llSitTarget(POSITION, rot);
        set_text();
        animation=llGetInventoryName(INVENTORY_ANIMATION,0);
    }
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {

            if (llAvatarOnSitTarget() != NULL_KEY)
            {
                HideBall();
                llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);
                return;
            }
            else
            {
                if (llGetPermissionsKey() != NULL_KEY){ llStopAnimation(animation); }
                ShowBall();
                animation="";
                return;
            }
        }
    }
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            anims2stop = [];//Clears the list
            llStopAnimation("sit");
            llSleep(sleep);
            anims2stop = llGetAnimationList(llAvatarOnSitTarget());
            stop_anim();
            animation=llGetInventoryName(INVENTORY_ANIMATION,0);
            llStartAnimation(animation);
            
        }
    }


}


