package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.campaign.controllers.EasyController.*;
    import com.brockw.stickwar.GameScreen;

    public class Loader
    {
        public static const version:String = "1.3.0";

        public static const date:String = "28-06-2024";

        public static const developer:String = "dyzqy";

        public static const help:String = "AsePlayer, Clementchuah, s07, RinasSam"; // in alphabetical order, not in help amount.

        public static var instance:Loader;


        public var isBeta:Boolean = true;

        public var isDev:Boolean = false;

        public var isSW2:Boolean = false; 

        private var _gameScreen:GameScreen;

        public var stringMap:StringMap;

        public function Loader(gameScreen:GameScreen)
        {
            super();
            Loader.instance = this;
            this.stringMap = new StringMap();
            this._gameScreen = gameScreen;
        }
    }
}