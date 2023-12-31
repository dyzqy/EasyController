package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.Team.*;
   
   public class CampaignBomber extends CampaignController
   {
        private var hasStarted:Boolean;

        private var msg:InGameMessage;
        
        public function CampaignBomber(param1:GameScreen)
        {
            super(param1);
        }

        public function start(param1:GameScreen) : void
        {
            util.registerUnit(["jugg","eclipsor"], param1.team); // registers Juggerknights & Eclipsors to team, allowing them to be spawned in the Order Empire.
            util.registerUnit(["earth","fire ele","charrog"], param1.team.enemyTeam); // registers Charrog, Fire & Earth elementals for enemy.

            util.summonUnit("jugg", 5, param1.team); // Spawns units
            util.summonUnit(["meric","eclipsor"], 2, param1.team);
            util.summonUnit("Charrog", 2, param1.team.enemyTeam);
            util.summonUnit(["fire","earth"], 3, param1.team.enemyTeam);
            param1.team.gold = 4000; // gives 4000 gold to player
        }
        
        override public function update(param1:GameScreen) : void
        {
            if(!hasStarted)
            {
                start(param1);
                hasStarted = true;
            }
            cs.message(msg, 5);
            util.reinforcements(300, 3000, param1.team.enemyTeam,
            function():void{
                util.summonUnit(["charrog", "earth"], 5, param1.team.enemyTeam);
                msg = cs.startMsg("Reinforcements have arrived!");
            }, true); // Sets reinforcement condition, when reaching 300 health, it sets health to 3000 & runs function.
        }
   }
}