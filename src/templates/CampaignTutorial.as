package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class CampaignTutorial extends CampaignController
   {
      private var hasStarted:Boolean;
      
      public function CampaignTutorial(param1:GameScreen)
      {
         super(param1);
      }

      public function start(param1:GameScreen) : void
      {
         // Summons 3 swordwraths for your team.
         util.summonUnit("swordwrath", 3, param1.team, function(unit:Unit):void{
            unit.px = 1500;
         }); 
      }
      
      override public function update(param1:GameScreen) : void
      {
         if(!hasStarted)
         {
            start(param1);
            hasStarted = true;
         }
         
         if(data.isTime(60)) // Once the ingame timer reaches 60s(1 min), do the following
         {
            // add what you want to happend when you reach 60 ingame time!
         }
      }
   }
}