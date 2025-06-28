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
         // util.summonUnit() can be used to summon a unit, but it is much more powerful than that
         // You can specify the team the swordwrath spawns in, the amount of swordwrath to spawn
         // While also being able to give them a special function/command.

         // This usage of summonUnit is the most basic. It summons one swordwrath in your team.
         util.summonUnit("swordwrath"); 

         // And you can expand on that, by choosing the amount of units that should spawn
         // In this case, 2 archidons will be summoned in your team. This really lowers the 
         // amount of code that has to be written each time you want to summon normal units in bulk.
         util.summonUnit("archidon", 2);

         // But what if you want to summon a unit for the enemy instead of the player?
         // Well that's simple! you can expand even more in the function
         // This summons 1 spearton in the enemy team! 
         util.summonUnit("spearton", 1, param1.team.enemyTeam);
      }
      
      override public function update(param1:GameScreen) : void
      {
         if(!hasStarted)
         {
            start(param1);
            hasStarted = true;
         }
         
         // data.isTime() is used to check the current time ingame(The red timer at the bottom of the screen).
         // Once the ingame timer reaches 30 seconds, it will run what is inside the if statement
         if(data.isTime(30))
         {
            // add what you want to happend when you reach 60 ingame time!
            
         }
      }
   }
}