//start_unprocessed_text
/*/|/  when the prim is touched, the script checks all other inventory items whether or not they're copiable
/|/  copiable items are added to a list, if the list is not empty when all items have been checked
/|/  the prim gives them to the touching avatar within a single folder
 
default
{
    touch_start(integer num_detected)
    {
        string thisScript = llGetScriptName();
        list inventoryItems;
        integer inventoryNumber = llGetInventoryNumber(INVENTORY_ALL);
 
        integer index;
        for ( ; index < inventoryNumber; ++index )
        {
            string itemName = llGetInventoryName(INVENTORY_ALL, index);
 
            if (itemName != thisScript)
            {
                if (llGetInventoryPermMask(itemName, MASK_OWNER) & PERM_COPY)
                {
                    inventoryItems += itemName;
                }
                else
                {
                    llSay(0, "Unable to copy the item named '" + itemName + "'.");
                }
            }
        }
 
        if (inventoryItems == [] )
        {
            llSay(0, "No copiable items found, sorry.");
        }
        else
        {
            llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventoryItems);    /|/ 3.0 seconds delay
        }
    }
}*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Releasex64 5.0.11.53634 - Jimmy Olsen
//last_compiled 02/22/2018 20:29:46
//mono







 
default
{
    touch_start(integer num_detected)
    {
        string thisScript = llGetScriptName();
        list inventoryItems;
        integer inventoryNumber = llGetInventoryNumber(INVENTORY_ALL);
 
        integer index;
        for ( ; index < inventoryNumber; ++index )
        {
            string itemName = llGetInventoryName(INVENTORY_ALL, index);
 
            if (itemName != thisScript)
            {
                if (llGetInventoryPermMask(itemName, MASK_OWNER) & PERM_COPY)
                {
                    inventoryItems += itemName;
                }
                else
                {
                    llSay(0, "Unable to copy the item named '" + itemName + "'.");
                }
            }
        }
 
        if (inventoryItems == [] )
        {
            llSay(0, "No copiable items found, sorry.");
        }
        else
        {
            llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventoryItems);    
        }
    }
}
 