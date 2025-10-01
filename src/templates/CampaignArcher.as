package com.brockw.stickwar.campaign.controllers
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.*;
    import com.brockw.stickwar.engine.units.*;
   
    public class CampaignArcher extends CampaignController
    {
        // What should this class be about?
        // I'm thinking of making this into a fully fledged level
        // A scripted OvO level, with these units:
        // Miners, Swordwrath, Archidons, Speartons & Shadowrath(?)
        private var msg:InGameMessage;

        private var hasStarted:Boolean = false;
        
        public function CampaignArcher(param1:GameScreen)
        {
            super(param1);
        }

        public function start(param1:GameScreen) : void
        {
            util.
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
