package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class CampaignTutorial extends CampaignController
   {

      private var reinforced:bool;
      
      private var msg:InGameMessage; // Ingame Message.

      private var hasStarted:Boolean;
      
      public function CampaignTutorial(param1:GameScreen)
      {
         super(param1);
      }

      public function start(param1:GameScreen) : void
      {
         // Summons 3 swordwraths for your team.
         util.summonUnit("swordwrath", 3, param1.team); 
         msg = cs.startMsg("Starting Message Template.", ""); // Starting message
      }
      
      override public function update(param1:GameScreen) : void
      {
         if(!hasStarted)
         {
            start(param1);
            hasStarted = true;
         }
         cs.message(msg,8); // Message update. Essential for displaying any message.
         
         if(data.isTime(60)) // Once the ingame timer reaches 60s(1 min), do the following
         {
            // add what you want to happend when you reach 60 ingame time!
         }

         util.reinforcements(250, 1000, param1.team.enemyTeam,
         function():void{
               // Add whatever you want to happend once the enemy statue reaches 250 health
               msg = cs.startMsg("Reinforcements have arrived!");
            }
         )
      }
   }
}