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

        // 06/10/2025 dyzqy: Added global state.
        public var state:int = 0;
        // 06/10/2025 dyzqy: Added new messages object for the new update function.
        public var messages:Object = {};

        public function CutScene(gs:GameScreen)
        {
            _gameScreen = gs;
        }

        // public function update() : void
        // {
        //     for (var key:String in messages)
        //     {
        //         messages[key].update();
        //     }
        // }

        // public function registerMessage(message:InGameMessage, name:String = "message") : void
        // {
        //     messages[name] = message;
        // }
        
        /* 13/08/2025 dyzqy: Added error message when you input an invalid parameter type. */
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
            else
            {
                Debug.instance.error("Invalid parameter for 'follow()'. The parameter must be either a Unit or a Number.", "CutScene");
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
                /* 13/08/2023 dyzqy: Fixed oversight, incrementing "i" twice. */
            }  
            unitsAvailable = [];
        }
    }
}