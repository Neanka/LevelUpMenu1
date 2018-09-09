package
{
   import Shared.AS3.BSUIComponent;
   
   public class PerkGrid extends BSUIComponent
   {
 
	   public function PerkGrid()
      {
		 trace(this, "constructor");
         super();
	  }
	  
	  public function InvalidateGrid() : *
	  {
		  trace(this, "InvalidateGrid");
	  }
	  
      public function onTexturesRegistered() : *
      {
		  trace(this, "texturesregistered");
      }

   }
}
