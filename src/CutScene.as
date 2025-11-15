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

        public function update() : void
        {
            for(var _loc1_:String in messages)
            {
                var _loc2_:InGameMessage = messages[key].mc;
                var _loc3_:Object = messages[key];
                if(gameScreen.contains(_loc2_) && _loc2_.visible)
                {
                    // Check if there is no time set, and set the first frame the message is visible on screen.
                    if(_loc3_.time == -1) messages[key].time = _gameScreen.game.frame;
                    _loc2_.update();

                    // Check if it has lived longer than its lifespan.
                    if(_loc3_.time + _loc3_.lifetime < _gameScreen.game.frame) 
                    {
                        if(!_loc3_.remove) _loc2_.visible = false;
                        else
                        {
                            _gameScreen.removeChild(_loc2_);
                            delete messages[key];
                        }
                    }
                }
            }
        }

        // 07/10/2025 dyzqy: Added register function that adds your message inside the Object for usage.
        public function registerMessage(name:String, message:InGameMessage, lifespan:Number = -1, toRemove:Boolean = true) : void
        {
            if(messages[name]) Debug.instance.error("registerMessage(): Message with name '" + name + "' already exists.", "CutScene");
            if(message == null) Debug.instance.error("registerMessage(): No viable InGameMessage given.", "CutScene");
            
            messages[name] = {
                time: -1, 
                lifetime: lifespan != null ? int(lifespan * 30) : Number.MAX_VALUE,
                remove: toRemove, 
                mc: message
            };
        }
        
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
        public function enableUI() : void
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