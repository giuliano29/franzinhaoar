default {
    state_entry() {
        llSetLinkTextureAnim(2, ANIM_ON|LOOP|SMOOTH|PING_PONG|ROTATE, ALL_SIDES, 1, 1, 0.0, PI/8, .010);
        llSetLinkTextureAnim(3, ANIM_ON|LOOP|SMOOTH|PING_PONG|ROTATE, ALL_SIDES, 1, 1, PI/2, PI/8, .010);
    }
} 