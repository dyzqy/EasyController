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

        private var frames:int = 0;

        private var counter:int = 0;

        private var overlay:MovieClip;


        private var unitsAvailable:Array;

        public function CutScene(gs:GameScreen)
        {
            _gameScreen = gs;
            unitsAvailable = [];
            super();
        }

        public function message(msg:InGameMessage, sec:int = 6, counter:Boolean = false) : void
        {
            if(Boolean(msg) && _gameScreen.contains(msg))
            {
                msg.update();
                if(frames++ > 30 * sec && (sec != 0 || sec == null))
                {
                    _gameScreen.removeChild(msg);
                }
            }
        }

        public function startMsg(msg1:String, msg2:String = "", y:* = 0, sound:String = "", comp:Boolean = false) : InGameMessage
        {
            var msg:InGameMessage = new InGameMessage("",_gameScreen.game);
            msg = new InGameMessage("",_gameScreen.game);
            msg.x = _gameScreen.game.stage.stageWidth / 2;
            msg.y = _gameScreen.game.stage.stageHeight / 4 - 75;
            msg.scaleX *= 1.3;
            msg.scaleY *= 1.3;
            _gameScreen.addChild(msg);
            msg.setMessage(msg1,msg2,y,sound,comp);
            frames = 0;
            return msg;
        }

        public function deleteMessage(msg:InGameMessage) : void
        {
            if(Boolean(msg) && _gameScreen.contains(msg))
            {
                _gameScreen.removeChild(msg);
            }
        }

        public function addlayer() : void
        {
            this.overlay = new MovieClip();
            this.overlay.graphics.beginFill(0,1);
            this.overlay.graphics.drawRect(0,0,850,750);
            _gameScreen.addChild(this.overlay);
            this.overlay.alpha = 0;
        }
        
        public function fadelayer(sec:int = 2, outcome:Boolean = true) : void
        {
            if(outcome) // Fading in
            {
                if (this.overlay.alpha < 1)
                {
                    this.overlay.alpha += (1 / (30 * sec));
                }
            }
            else
            {
                if (this.overlay.alpha > 0)
                {
                    this.overlay.alpha -= (1 / (30 * sec));
                }
            }
        }

        public function follow(un:Unit) : void
        {
            _gameScreen.game.targetScreenX = un.px - _gameScreen.game.map.screenWidth / 2;
        }

        public function infrontUnit(team:Team) : Unit
        {
            return team.forwardUnit;
        }

        public function removelayer() : void
        {
            _gameScreen.removeChild(this.overlay);
            counter = 0;
        }

        public function statelayer(outcome:Boolean = true) : Boolean
        {
            if(outcome)
            {
                return this.overlay.alpha >= 1;
            }
            else if(!outcome)
            {
                return this.overlay.alpha <= 0;
            }
        }

        public function cleanUp(ui:Boolean = true) : void
        {
            var team:Team = _gameScreen.game.team;
            var enemyTeam:Team = _gameScreen.game.team.enemyTeam;
            // var unit:Unit = null;

            team.gold = team.mana = 0;
            enemyTeam.gold = enemyTeam.mana = 0;
            team.cleanUpUnits();
            enemyTeam.cleanUpUnits();
            
            if(ui)
            {
                var hud:MovieClip = _gameScreen.userInterface.hud.hud;
                var i:int = 0;
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
        }

        public function postCleanUp(ui:Boolean = true) : void
        {
            var team:Team = _gameScreen.game.team;
            var enemyTeam:Team = _gameScreen.game.team.enemyTeam;
            // var unit:Unit = null;

            
            
            if(ui)
            {
                var hud:MovieClip = _gameScreen.userInterface.hud.hud;
                var i:int = 0;
                hud.economicDisplay.visible = true;
                hud.economicDisplay.alpha = 1;
                _gameScreen.userInterface.isGlobalsEnabled = true;
                if(hud.fastForward != null)
                {
                    hud.fastForward.visible = true;
                }

                while(i < unitsAvailable.length)
                {
                    _gameScreen.team.unitsAvailable[unitsAvailable[i]] = 1;
                    i++;
                }  
            }
        }

        public function summonWall(team:Team, x:int = 0, direction:int = 1, maxHealth:int = 400, health:int = -1) : void
        {
            var wall:Wall = null;
            var i:int = 0; 
            (wall = team.addWall(x)).setConstructionAmount(1);
            while(i < wall.wallParts.length)
            {
                var wallSpike:* = wall.wallParts[i];
                wallSpike.scaleX *= direction;
                i++;
            }
            wall.maxHealth = maxHealth;
            wall.health = (health != -1) ? health : maxHealth;
            wall.healthBar.totalHealth = maxHealth;
        }
    }
}