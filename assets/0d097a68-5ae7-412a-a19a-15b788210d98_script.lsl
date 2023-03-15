// Camera Control HUD v2.0
//
// This script is Copyright (C) 2009 by Rob Knop aka Prospero Frobozz
//
// This script is free software, available under the GNU GPL version 2.
// You are free to use it, modify it, or distribute it.  If you distribute
// this script or any modified versions, they must also be under the GNU GPL.
// This means that the script itself must be mod/copy/transfer.  Objects that
// use the script, or other components of such objects, do not themselves need
// to be mod/copy/transfer, but the script, or any other scripts derived from
// it, must.

integer cameramode;
vector pos;
vector mypos;
rotation rot;
vector targ;

default
{
    attach(key id)
    {
        llResetScript();
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        cameramode = 0;
    }

    run_time_permissions(integer perm)
    {
        if (perm == PERMISSION_TRACK_CAMERA)
        {
            mypos = llGetPos();
            pos = llGetCameraPos();
            rot = llGetCameraRot();
            targ = pos + <1., 0., 0.>*rot;
            llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA);
        }
    
        if (perm != PERMISSION_CONTROL_CAMERA) return;
    
        llClearCameraParams();
        
        if (cameramode == 1)     // Absolute Freeze
        {
            llSetCameraParams([ CAMERA_POSITION, pos,
                                CAMERA_FOCUS, targ,
                                CAMERA_ACTIVE, 1,
                                CAMERA_FOCUS_LOCKED, 1,
                                CAMERA_POSITION_LOCKED, 1,
                                CAMERA_POSITION_LAG, 1.0,
                                CAMERA_FOCUS_LAG, 1.0 ]);
        }
        else if (cameramode == 2) // Absolute Camera Position
        {
            llSetCameraParams([ CAMERA_POSITION, pos,
                                CAMERA_ACTIVE, 1,
                                CAMERA_POSITION_LOCKED, 1,
                                CAMERA_POSITION_LAG, 0.2,
                                CAMERA_FOCUS_LAG, 0.2 ]);
        }
        else if (cameramode == 3) // Distance & Pitch
        {
            float dist = llVecDist(pos, mypos);
            float ang = llAsin((pos.z - mypos.z) / dist) * RAD_TO_DEG;
            llSetCameraParams([ CAMERA_ACTIVE, 1,
                                CAMERA_DISTANCE, dist,
                                CAMERA_PITCH, ang,
                                CAMERA_FOCUS_LAG, 0.1,
                                CAMERA_POSITION_LAG, 0.1
                                ]);
                                            
        }
        else
        {
        }
    }
    
    // ***********************************
    // Button configuration
    //
    //    +------------------+------------------+
    //    |   Freeze (1)     | Abs Position (2) |
    //    +------------------+------------------+
    //    | Rel Rotation (3) |   Release (0)    |
    //    +------------------+------------------+
    
    touch_start(integer num)
    {
        vector uv = llDetectedTouchUV(0);
        if (uv.x <= 0.5 && uv.y > 0.5) {
            cameramode = 1;
        }
        else if (uv.x > 0.5 && uv.y > 0.5) {
            cameramode = 2;
        }
        else if (uv.x <= 0.5 && uv.y <= 0.5) {
            cameramode = 3;
        }
        else {
            cameramode = 0;
        }

        llRequestPermissions(llGetOwner(), PERMISSION_TRACK_CAMERA);
    }
}
