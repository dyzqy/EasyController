package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.InGameMessage;
    import com.brockw.stickwar.engine.Team.Team;
    import com.brockw.stickwar.engine.units.*;
    import flash.display.MovieClip;

    public class CutScene
    {
        private var _gameScreen:GameScreen;

        private var unitsAvailable:Array = [];

        public function CutScene(gs:GameScreen)
        {
            _gameScreen = gs;
            super();
        }

        public function follow(un:*) : void
        {
            if(un is Unit)
            {
                _gameScreen.game.targetScreenX = un.px - _gameScreen.game.map.screenWidth / 2;
            }
            else if(un is int || un is Number)
            {
                _gameScreen.game.targetScreenX = int(un) - _gameScreen.game.map.screenWidth / 2;
            }
        }

        // Disables functionality for all hud elements that influence the game. 
        public function disableUI() : void
        {
            var hud:MovieClip = _gameScreen.userInterface.hud.hud;
            hud.economicDisplay.visible = false;
            hud.economicDisplay.alpha = 0;
            _gameScreen.userInterface.isGlobalsEnabled = false;

            if(hud.fastForward != null)
            {
                hud.fastForward.visible = false;
            }

            for (var i:int in _gameScreen.team.unitsAvailable)
            {
                unitsAvailable.push(i);
                delete _gameScreen.team.unitsAvailable[i];
            }
        }

        // Enables functionality for all hud elements that influence the game. 
        public function enableUI(ui:Boolean = true) : void
        {
            var hud:MovieClip = _gameScreen.userInterface.hud.hud;
            
            hud.economicDisplay.visible = true;
            hud.economicDisplay.alpha = 1;
            _gameScreen.userInterface.isGlobalsEnabled = true;
            if(hud.fastForward != null)
            {
                hud.fastForward.visible = true;
            }

            for(var i:int = 0; i < unitsAvailable.length; i++)
            {
                _gameScreen.team.unitsAvailable[unitsAvailable[i]] = 1;
                i++;
            }  
            unitsAvailable = [];
        }
    }
}