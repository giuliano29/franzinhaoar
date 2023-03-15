integer prim_num;
string prim_name;
vector color;
integer CMD_CH;
key kQuery;
integer iLine = 0;
integer data;

default
{ //start of default state

on_rez(integer start_param) { // on rezz state starts here

        // every time we're rezzed, reset the script
        // this ensures that if we're transferred to a new owner, we're listening to them and not still to the previous one
        llResetScript();       
                            // following brace ends on rezz state
                            }

changed(integer change) { // something changed
        if (change & CHANGED_INVENTORY) { // and it was a link change
                           llResetScript();

                                          // following brace ends check for link change
                                          }
                        //following brace ends changed state
                         }           

listen(integer ch, string name, key id, string msg)
    { // start of listen state 
    
      // check here to see if string is a vector - if so then do it
      string myTrimmedText = llDumpList2String(llParseString2List(msg, [" "], []), " ");
  //    llOwnerSay(myTrimmedText);
      integer index = llSubStringIndex(myTrimmedText,"<");
   

if(index == -1)  
{
// no vector found in string - so treat it as a number     
// llOwnerSay ((string)msg);

// shoes are links 1 and 6
// here we check to see which link buton has been hit

if (msg == "3"){
llSetLinkTexture(1, "placid_blue_2", ALL_SIDES);
llSetLinkTexture(6, "placid_blue_1", ALL_SIDES);
               }

if (msg == "4"){
llSetLinkTexture(1, "hemlock_2", ALL_SIDES);
llSetLinkTexture(6, "hemlock_1", ALL_SIDES);
                }

if (msg == "5"){
llSetLinkTexture(1, "violet_tulip_2", ALL_SIDES);
llSetLinkTexture(6, "violet_tulip_1", ALL_SIDES);
              }
              
if (msg == "6"){
llSetLinkTexture(1, "paloma_2", ALL_SIDES);
llSetLinkTexture(6, "paloma_1", ALL_SIDES);
              }
                          
if (msg == "7"){
llSetLinkTexture(1, "sand_2", ALL_SIDES);
llSetLinkTexture(6, "sand_1", ALL_SIDES);
              }
                           
if (msg == "8"){
llSetLinkTexture(1, "freesia_2", ALL_SIDES);
llSetLinkTexture(6, "freesia_1", ALL_SIDES);
              }                                          
if (msg == "9"){
llSetLinkTexture(1, "cayenne_2", ALL_SIDES);
llSetLinkTexture(6, "cayenne_1", ALL_SIDES);
              }
              
if (msg == "10"){
llSetLinkTexture(1, "celosia_2", ALL_SIDES);
llSetLinkTexture(6, "celosia_1", ALL_SIDES);
              }  
              
if (msg == "11"){
llSetLinkTexture(1, "dazzling_blue_2", ALL_SIDES);
llSetLinkTexture(6, "dazzling_blue_1", ALL_SIDES);
              }
              
if (msg == "12"){
llSetLinkTexture(1, "radiant_orchid_2", ALL_SIDES);
llSetLinkTexture(6, "radiant_orchid_1", ALL_SIDES);
              }                    

if (msg == "13"){
llSetLinkTexture(1, "black_2", ALL_SIDES);
llSetLinkTexture(6, "black_1", ALL_SIDES);
              }                    

if (msg == "14"){
llSetLinkTexture(1, "cream_2", ALL_SIDES);
llSetLinkTexture(6, "cream_1", ALL_SIDES);
              }                    

if (msg == "15"){
llSetLinkTexture(1, "lt_cream_2", ALL_SIDES);
llSetLinkTexture(6, "lt_cream_1", ALL_SIDES);
              }                    

if (msg == "16"){
llSetLinkTexture(1, "gray_2", ALL_SIDES);
llSetLinkTexture(6, "gray_1", ALL_SIDES);
              }                    

if (msg == "17"){
llSetLinkTexture(1, "brown_2", ALL_SIDES);
llSetLinkTexture(6, "brown_1", ALL_SIDES);
              }                    

if (msg == "18"){
llSetLinkTexture(1, "green_2", ALL_SIDES);
llSetLinkTexture(6, "green_1", ALL_SIDES);
              }                    

if (msg == "19"){
llSetLinkTexture(1, "hot_pink_2", ALL_SIDES);
llSetLinkTexture(6, "hot_pink_1", ALL_SIDES);
              }                    

if (msg == "20"){
llSetLinkTexture(1, "red_shoe 2", ALL_SIDES);
llSetLinkTexture(6, "red shoe 1", ALL_SIDES);
              }  

if (msg == "21"){
llSetLinkTexture(1, "chocolate_2", ALL_SIDES);
llSetLinkTexture(6, "chocolate_1", ALL_SIDES);
              }                    

if (msg == "22"){
llSetLinkTexture(1, "navy_2", ALL_SIDES);
llSetLinkTexture(6, "navy_1", ALL_SIDES);
              }  
              
// End of shoe texture checks - start of toenail texture checks 
// toenail textures on hud prims 35 thru 62

if (msg == "35"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "black", ALL_SIDES);
              }
              
if (msg == "36"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "bronze", ALL_SIDES);
              }   
              
if (msg == "37"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "dark_red", ALL_SIDES);
              }       
              
if (msg == "38"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "light_plum", ALL_SIDES);
              }                            
              
if (msg == "39"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "nude", ALL_SIDES);
              }   
              
if (msg == "40"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "purple", ALL_SIDES);
              }  
               
if (msg == "41"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "rose", ALL_SIDES);
              }    
              
if (msg == "42"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "sky", ALL_SIDES);
              }                          
                                    
if (msg == "43"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_acid_green", ALL_SIDES);
              }                                               
                                                          
if (msg == "44"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_acid_lemon", ALL_SIDES);
              }                                                                       
if (msg == "45"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_black", ALL_SIDES);
              }                                                                                 
if (msg == "46"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_blue_camo", ALL_SIDES);
              }                                                                                     
if (msg == "47"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_bronze_red", ALL_SIDES);
              }                          
             
if (msg == "48"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_brt_red", ALL_SIDES);
              }                         
                        
if (msg == "49"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_corn", ALL_SIDES);
              }             
                        
if (msg == "50"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_dark_red", ALL_SIDES);
              }                          
             
if (msg == "51"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_earth", ALL_SIDES);
              }                          
                        
if (msg == "52"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_giraffe", ALL_SIDES);
              }               
                        
if (msg == "53"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_lavender", ALL_SIDES);
              }
                                   
if (msg == "54"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_leopard", ALL_SIDES);
              }                                                             
if (msg == "55"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_light_plum", ALL_SIDES);
              }
 
if (msg == "56"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_nude", ALL_SIDES);
              }  
   
if (msg == "57"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_purple", ALL_SIDES);
              }    
     
if (msg == "58"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_rose", ALL_SIDES);
              }      
       
if (msg == "59"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_sky", ALL_SIDES);
              }        
         
if (msg == "60"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "wht_tp_zebra", ALL_SIDES);
              }          
           
if (msg == "61"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "zz_acid_lemon", ALL_SIDES);
              }            
             
if (msg == "62"){
integer count; 
for (count =7; count <=16; count++)
llSetLinkTexture(count, "zz_acid_green", ALL_SIDES);
              }
                             
 // ******* end of toenail textures ******                                                                                             
                                     
if (msg == "33"){
    
// Are ankles solid - if so set to clear - otherwise set to solid  
list params  = llGetLinkPrimitiveParams(5,[PRIM_COLOR,0]);
string isAlpha = llList2String(params, 1);
vector isColour = llList2Vector(params, 0);

if (isAlpha == "1.000000")
    {
llSetLinkPrimitiveParams(4,[PRIM_COLOR, ALL_SIDES, isColour, 0.0]);
llSetLinkPrimitiveParams(5,[PRIM_COLOR, ALL_SIDES, isColour, 0.0]);
     }
 else 
 {
llSetLinkPrimitiveParams(4,[PRIM_COLOR, ALL_SIDES, isColour, 1.0]);
llSetLinkPrimitiveParams(5,[PRIM_COLOR, ALL_SIDES, isColour, 1.0]);
  }               
                
// next brace ends msg 33               
                 }


if (msg == "34"){
    
// Are shoes solid - if so set to clear - otherwise set to solid  
list params  = llGetLinkPrimitiveParams(1,[PRIM_COLOR,0]);
string isAlpha = llList2String(params, 1);
vector isColour = llList2Vector(params, 0);

if (isAlpha == "1.000000")
    {
llSetLinkPrimitiveParams(1,[PRIM_COLOR, ALL_SIDES, isColour, 0.0]);
llSetLinkPrimitiveParams(6,[PRIM_COLOR, ALL_SIDES, isColour, 0.0]);
     }
 else 
 {
llSetLinkPrimitiveParams(1,[PRIM_COLOR, ALL_SIDES, isColour, 1.0]);
llSetLinkPrimitiveParams(6,[PRIM_COLOR, ALL_SIDES, isColour, 1.0]);
  }               
                
// next brace ends msg 34               
                 }

// following brace ends index check for -1
}                    

    else 

{     
//its a vector - so treat it as such
 // llOwnerSay ((string)index);
       // llSetColor((vector)msg,0);
       llSetLinkColor(2, (vector)msg,0);
       llSetLinkColor(3, (vector)msg,0);
       llSetLinkColor(4, (vector)msg,0);
       llSetLinkColor(5, (vector)msg,0);
                   } 
 
                
    //following brace ends listen state
   }

    state_entry()
    { // state entry begin
       llOwnerSay ("Foot script has been reset");
        llOwnerSay("Reading Chanel number from notecard...");
        kQuery = llGetNotecardLine("config", iLine);
    // following brace = end of state entry
    }


dataserver(key query_id, string data) {
 
        if (query_id == kQuery) {
            // this is a line of our notecard
         if (data == EOF) {    
 
 llOwnerSay("No more lines in notecard, read " + (string)iLine + " lines.");
 
                          } 
            
            else {
                
                CMD_CH  = (integer) data; 
               
 llOwnerSay ("Colour Changer Channel set to "+data);
   
            llListen(CMD_CH, "", "", "");
 
                         }
                                }
                                      }

// following brace = default state end
} 
