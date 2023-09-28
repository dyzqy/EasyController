package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.EnslavedGiant;
   
   public class CampaignTutorial extends CampaignController
   {
       
      
      private var eGiant:EnslavedGiant; // Variable of "Enslaved Giant" unit.
      
      private var msg:InGameMessage; // Ingame Message.
      
      private var start:Boolean = false;
      
      public function CampaignTutorial(param1:GameScreen)
      {
         super(param1);
      }
      
      override public function update(param1:GameScreen) : void
      {
         cs.message(msg,8); // Message update. Essential for displaying any message.
         if(!start)
         {
            debug.SimulateConsole(12,false); // Create debugging console
            // Summons 10 swordwraths, 3 speartons for your team & 10 speartons for enemy.
            util.SummonUnit("sword",10,param1.team); 
            util.SummonUnit("spear",3,param1.team);
            util.SummonUnit("spear",10,param1.team.enemyTeam);
            this.eGiant = util.SummonVarUnit("egiant",param1.team); // Summons a unit using a variable for later use
            debug.Log("Starting units summoned.");
            msg = cs.startMsg("Starting Message Template.", "Template"); // Starting message
            start = true;
         }
         
         if(data.isTime(60)) // Once it has passed 1 minute ever since the game started, do the following.
         {
            util.SummonUnit("meric",5,param1.team);
            util.SummonUnit("spear",5,param1.team);
            util.SummonUnit("spear",5,param1.team.enemyTeam);
            util.SummonUnit("magikill",3,param1.team.enemyTeam);
            debug.Log("Summoned reinforcements.");
         }

         util.loop(5,function():void // every 5 seconds, summon a spearton on players' side
         {
            util.SummonUnit("spear",1,param1.team);
            debug.Log("Loop has been run.");
         });

         util.king(this.eGiant); // If the EnslavedGiant dies, your statue gets destroyed. Just like mMedusa in the Chaos Empire mod by AsePlayer.
      }
   }
}
