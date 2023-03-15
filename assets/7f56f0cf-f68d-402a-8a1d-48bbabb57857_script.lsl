default
{
    state_entry()
    {
        
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if(str == "SetMat")
        {
            llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_GLASS]);
        }
        else if (str == "ForwardSpin")
        {
            llSetTextureAnim(ANIM_ON | LOOP | SMOOTH,5,1,1,0,1,-2);
        }
        else if (str == "BackwardSpin")
        {
            llSetTextureAnim(ANIM_ON | LOOP | SMOOTH, 5,1,1,0,1,2);
        }
        else if (str == "NoSpin")
        {
            llSetTextureAnim(ANIM_ON | LOOP | SMOOTH,5,1,1,0,1,0);
        }                        
        
    }
}