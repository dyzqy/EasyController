package com.brockw.stickwar.campaign.controllers
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.*;
    import com.brockw.stickwar.engine.units.*;
   
    public class CampaignArcher extends CampaignController
    {

        private var msg:InGameMessage;

        private var hasStarted:Boolean = false;
        
        public function CampaignArcher(param1:GameScreen)
        {
            super(param1);
        }

        public function start(param1:GameScreen) : void
        {
            msg = cs.startMsg("The enemy archidons have teamed up with the shadowrath to create new traps, beware where you put your feet!");
            for(var i:int = 0; i < 5; i++)
            {
                pp.landmine(param1.team.statue.px + 750 + data.random(0, 0), param1.game.map.height / 5 * i, param1.team.enemyTeam, 0.15);
            }
        }
        
        override public function update(param1:GameScreen) : void
        {
            if(!hasStarted)
            {
                start(param1);
                hasStarted = true;
            }
            cs.message(msg, 8);
            pp.updateProjectiles();
        }
    }
}
