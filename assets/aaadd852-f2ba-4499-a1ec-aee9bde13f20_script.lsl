iniziale()
{
    integer a;
     integer prim1s = llGetNumberOfPrims();
     for( a = 0; a <= prim1s; ++a)
       {
           if (a != 2 && a != 3 && a != 4 && a != 5 && a != 6 && a != 7 && a != 8  && a != 9 && a != 10 && a != 11 && a != 12 && a != 13)
{
     
       llSetLinkPrimitiveParamsFast(a, [   PRIM_COLOR,ALL_SIDES, <1.000, 1.000, 1.000>, 0]);
              }
        

}}

funzionericordacolore(integer num,integer face)
{
  list value=  llGetLinkPrimitiveParams(num, [PRIM_COLOR,face]);
  float alpha= llList2Float(value,1);
  vector colore= llList2Vector(value,0);
  if(alpha ==0.0)
  
  {   
  llSetLinkPrimitiveParamsFast(num, [  PRIM_COLOR,face, colore, 1]);
//  llSay(0,"trasparente");
    }
    else
    if(alpha ==1.0) 
  
  {   
  llSetLinkPrimitiveParamsFast(num, [  PRIM_COLOR,face, colore, 0]);
    }
     
}


applica(integer i,integer a)
{
      // llSay(0,(string)i+ "   "+(string)a);
     llSetLinkTexture(i-1, "3a367d1c-bef1-6d43-7595-e88c1e3aadb3",-1);
   
        llSetLinkColor(i, <0,0,0>, -1);
     
}
 integer select=0;
        integer select2=0;
        
numeroPrim()
{
 
      integer prim1s = llGetNumberOfPrims();
       
                      //  llSay(0,"Prims"+(string)prim1s);
                        integer facc1e=llGetLinkNumberOfSides(0);
                            integer a=0;
   while(a<prim1s)
        { 
          llSetLinkColor(a,<llFrand(1),llFrand(1),llFrand(1)>,1);
          a++;
        } 
                        
                      
                                 
                      
    
}
default
{
  state_entry()
  {
    //  numeroPrim();
      llListen(-50,"","","");
       iniziale();
    
    }  
    listen(integer channe,string name,key id,string message)
    {
        key ownerOfThisObject = llGetOwner();
        key ownerOfSpeaker = llGetOwnerKey(id);
        if (ownerOfSpeaker == ownerOfThisObject)
        {
        iniziale();
      //   llSay(0,message);
         string definizione=llGetSubString(message,0,0);
         
          if (message=="Reset")
        {
            
           // llSay(0,"Resettando");
            iniziale();
            llSetLinkPrimitiveParamsFast(13, [PRIM_COLOR,ALL_SIDES, <1.000, 1.000, 1.000>, 1]);
            llSetLinkPrimitiveParamsFast(12, [PRIM_COLOR,ALL_SIDES, <1.000, 1.000, 1.000>, 1]);
            llSetLinkPrimitiveParamsFast(11, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>,1]);
            llSetLinkPrimitiveParamsFast(10, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>,1]);
            llSetLinkPrimitiveParamsFast(9, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1]);
            llSetLinkPrimitiveParamsFast(8, [PRIM_COLOR, ALL_SIDES,<1.000, 1.000, 1.000>,1]);
            
            llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR,ALL_SIDES, <1.000, 1.000, 1.000>, 1]);
            llSetLinkPrimitiveParamsFast(6, [PRIM_COLOR,ALL_SIDES, <1.000, 1.000, 1.000>, 1]);
            llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>,1]);
            llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>,1]);
            llSetLinkPrimitiveParamsFast(3, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 1]);
            llSetLinkPrimitiveParamsFast(2, [PRIM_COLOR, ALL_SIDES,<1.000, 1.000, 1.000>,1]);
        } 
          
      
        if (definizione=="P")
        {
          string numeroprim=llGetSubString(message,1,-1);
          if ((integer)numeroprim >= 100)
          { 
         string ilprim=llGetSubString(message,1,2);
         string lafaccia=llGetSubString(message,3,3);
         funzionericordacolore((integer)ilprim,(integer)lafaccia);
        
           }
           else 
           if ((integer)numeroprim<100)
           {
                string ilprim=llGetSubString(message,1,1);
         string lafaccia=llGetSubString(message,2,2);
         funzionericordacolore((integer)ilprim,(integer)lafaccia);
           }
     
    }
       
}

    }   
    }
 