package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.InGameMessage;
    import flash.display.MovieClip;

    public class Extra
    {
        private var _gameScreen:GameScreen;
        private var frames:int = 0;
        private var counter:int = 0;
        private var overlay:MovieClip;

        public function Extra(gs:GameScreen)
        {
            _gameScreen = gs;
            super();
        }

        public function message(msg:InGameMessage, sec:int = 6) : void
        {
            if(Boolean(msg) && _gameScreen.contains(msg))
            {
                msg.update();
                if(frames++ > 30 * sec)
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
            //break;
            return msg;
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
    }
}