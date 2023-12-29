package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class CampaignTutorial extends CampaignController
   {

      private var eGiant:EnslavedGiant; // Variable of "Enslaved Giant" unit.
      
      private var msg:InGameMessage; // Ingame Message.

      private var hasStarted:Boolean;
      
      public function CampaignTutorial(param1:GameScreen)
      {
         super(param1);
      }

      public function start(param1:GameScreen) : void
      {
         debug.SimulateConsole(12,false); // Create debugging console
         // Summons 10 swordwraths, 3 speartons for your team & 10 speartons for enemy.
         util.summonUnit("sword", 3, param1.team); 
         util.summonUnit("spear", 5, param1.team);
         util.summonUnit("spear", 10, param1.team.enemyTeam);
         this.eGiant = util.summonUnit("egiant", 1, param1.team, Unit); // Summons a unit using a variable for later use
         debug.Log("Starting units summoned.");
         msg = cs.startMsg("Starting Message Template.", "Template"); // Starting message
      }
      
      override public function update(param1:GameScreen) : void
      {
         if(!hasStarted)
         {
            start(param1);
            hasStarted = true;
         }
         cs.message(msg,8); // Message update. Essential for displaying any message.
         
         if(data.isTime(60)) // Once it has passed 1 minute ever since the game started, do the following.
         {
            util.summonUnit(["spear","meric"], 3, param1.team); // Spawns a group of units, 3 of spears and 3 of merics
            util.summonUnit("spear", 5, param1.team.enemyTeam);
            util.summonUnit("magikill", 3, param1.team.enemyTeam);
            debug.Log("Summoned reinforcements.");
         }
      }
   }
}