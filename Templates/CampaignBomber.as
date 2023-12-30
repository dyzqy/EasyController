package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class CampaignBomber extends CampaignController
   {
        private var hasStarted:Boolean;
        
        public function CampaignBomber(param1:GameScreen)
        {
            super(param1);
        }

        public function start(param1:GameScreen) : void
        {
            util.registerUnit(["jugg","eclipsor"], param1.team);
            util.registerUnit(["earth","fire ele","charrog"], param1.team.enemyTeam);

            util.summonUnit("jugg", 5, param1.team);
            util.summonUnit(["meric","eclipsor"], 2, param1.team);
            util.summonUnit("Charrog", 2, param1.team.enemyTeam);
            util.summonUnit(["fire","earth"], 3, param1.team.enemyTeam);
        }
        
        override public function update(param1:GameScreen) : void
        {
            if(!hasStarted)
            {
                start(param1);
                hasStarted = true;
            }
        }
   }
}