default {
    on_rez(integer p) {
        llResetScript();
    }
    state_entry() {
        llLoopSound(llGetInventoryName(INVENTORY_SOUND, 0), 1.0);
    }
} 