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
        public static const version:String = "EC_1.2.2";

        public static const date:String = "31-12-2023";

        public static const developer:String = "dyzqy";

        public static const help:String = "AsePlayer, s07, RinasSam"; // in alphabetical order, not in help amount.


        public var versionCheck:Boolean = false;

        public var isBeta:Boolean = false;

        private var description:TextField;

        private var title:TextField;

        private var _gameScreen:GameScreen;

        public var stringMap:StringMap;

        public var draw:Draw;

        public var oldVersion:Boolean;

        public function Loader(gameScreen:GameScreen)
        {
            super();
            this.stringMap = new StringMap();
            this.draw = new Draw();
            this._gameScreen = gameScreen;
            allowDomain("raw.githubusercontent.com");
            if(versionCheck && !isBeta)
            {
                verifyVersion(version);
            }
        }

        public function verifyVersion(currentVersion:String)
        {
            allowDomain("raw.githubusercontent.com");
            var request:URLRequest = new URLRequest("https://raw.githubusercontent.com/dyzqy/EasyController/main/Other/version.txt");
            var loader:URLLoader = new URLLoader();
            request.method = URLRequestMethod.GET;
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE, completeHandler);
            loader.load(request);
        }

        function completeHandler(event:Event):void 
        {
            var loadedText:String = loader.data;
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
                description.htmlText = "You are on a hier version of public EasyController. This message isn't supposed to be shown, please put 'versionCheck' to false or contact the developer(" + developer + ").";
            }
        }

        public function createStuff() : void
        {
            var container:Sprite = new Sprite();
            _gameScreen.addChild(container);

            var square:Shape = draw.createRectangle(400, 175, "#000000", 75);
            square.x = 425 - (square.width / 2);
            square.y = 75;
            container.addChild(square);

            this.title = draw.createTextField(400, 35, 14, "#ffbb00");
            container.addChild(title);

            this.description = draw.createTextField(400, 35, 14, "#ffbb00");
            description.y = title.height + description.height;
            container.addChild(description);
        }

        public function allowDomain(site:String = "raw.githubusercontent.com") : void
        {
            Security.allowDomain(site);
            /*Security.allowInsecureDomain(site);
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");*/
        }
    }
}