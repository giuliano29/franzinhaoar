colora(integer i)
{
     while(i<36)
        {
          colora(i);  
          i++;
        }
    integer a=0;
   while(a<38)
        { 
        
          llSetLinkColor(i,<llFrand(1),llFrand(1),llFrand(1)>,a);
          a++;
        } 
}
primefacce()
{
    integer a;
    integer prims = llGetNumberOfPrims();
       for( a =1; a <=prims; ++a)
       llSay(0,"Prim Numero " + (string)a + "conta " +(string)llGetLinkNumberOfSides(a));
}

default
{
    state_entry()
    {
     //   primefacce();
        integer i=0; 
       
    }
}   