package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.controllers.EasyController.*;
    import flash.system.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class Loader
    {
        public static const version:String = "EC_1.1.0"; 

        public static const date:String = "29-12-2023"; // Happy BD to Stick War 2 Custom Mods!

        public static const developer:String = "dyzqy";

        public static const help:String = "AsePlayer, s07, RinasSam"; // in alphabetical order, not in help amount.


        public var versionCheck:Boolean = false;

        public var oldVersion:Boolean = false;

        public var isBeta:Boolean = true;

        private var description:TextField;

        private var title:TextField;

        private var _gameScreen:GameScreen;

        public var stringMap:StringMap;

        public function Loader(gameScreen:GameScreen)
        {
            super();
            this.stringMap = new StringMap();
            this._gameScreen = gameScreen;
            if(versionCheck && !isBeta)
            {
                verifyVersion(version);
            }
        }

        public function verifyVersion(currentVersion:String)
        {
            Security.allowDomain("raw.githubusercontent.com");
            Security.allowInsecureDomain("raw.githubusercontent.com");
            var request:URLRequest = new URLRequest("https://raw.githubusercontent.com/dyzqy/EasyController/main/Other/Other/version.txt");
            var loader:URLLoader = new URLLoader();
            request.method = URLRequestMethod.GET;
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE, completeHandler);
            loader.load(request);
        }

        function completeHandler(event:Event):void 
        {
            var loadedText:String = "EC_1.1.0";
            var prefix:String = "EC_";

            if (loadedText.indexOf(prefix) == 0) 
            {
                var loadedVersion:String = loadedText.substr(prefix.length);
                var currentVersion:String = version.substr(prefix.length);
                loadedVersion = loadedVersion.replace(/\./g, "");
                currentVersion = currentVersion.replace(/\./g, "");
            }

            if(currentVersion == loadedVersion)
            {
                oldVersion = false;
                // addMessage(0);
            }
            else if(currentVersion < loadedVersion)
            {
                oldVersion = true;
                addMessage(1);
            }
            else if(currentVersion > loadedVersion && !isBeta)
            {
                oldVersion = true;
                addMessage(2);
            }
            else
            {
                oldVersion = false;
                // addMessage(0);
            }
        }

        public function addMessage(errorID:int)
        {
            var link:String = "https://www.google.com";
            createStuff();
            if(errorID == 0)
            {
                title.htmlText = "Correct Version";
                description.htmlText = "There are no issues, you are on the correct version.";
            }
            else if(errorID == 1)
            {
                title.htmlText = "Version Mismatch";
                description.htmlText = "You are on an older version of EasyController. If you consider wanting more functionality, bug fixes and more, please <a href =" + link + " >update by clicking here</a>";
            }
            else if(errorID == 2)
            {
                title.htmlText = "Version Mismatch";
                description.htmlText = "You are on a hier version of public EC. This message isn't supposed to be shown, please put 'versionCheck' to false";
            }
        }

        public function createStuff()
        {
            var square:Sprite = Draw.createRectangle(400, 175, "#000000", 75);
            square.x = Draw.width_center - (square.width / 2);
            square.y = 75;
            _gameScreen.addChild(square);

            this.title = Draw.createTextField(400, 35, 14, "#ffbb00");
            square.addChild(title);

            this.description = Draw.createTextField(400, 35, 14, "#ffbb00");
            description.y = title.height + description.height;
            square.addChild(description);
        }
    }
}
/*
{
    
}*/