package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.net.*;

    public class Debug
    {
      // FIx no scrolling to end later, add new private class for commands
      private var _gameScreen:GameScreen;

      private var initilized:Boolean = false;

      private var globaldebug:Boolean = false;

      public static var instance:Debug;

      public var inputField:TextField;

      public var statsField:TextField;

      public var consoletext:TextField;

      public var comment:String;


      public function Debug(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;
         Debug.instance = this;
         
         this.statsField = new TextField();
         this.consoletext = new TextField();
      }

      public function stats(fSize:Number = 12) : void
      {
         var textFormat:TextFormat = new TextFormat("Verdana",fSize,16777215);
         statsField.defaultTextFormat = textFormat;
         statsField.multiline = true;
         statsField.wordWrap = true;
         statsField.height = 225;
         statsField.width = 250;

         statsField.antiAliasType = AntiAliasType.ADVANCED;
         statsField.embedFonts = true;

         _gameScreen.userInterface.hud.addChild(statsField);
         statsField.x = 10;
         statsField.y = 10;
         var dropShadowFilter:DropShadowFilter = new DropShadowFilter(4,45,0,1,0,0,1,3);
         var glowFilter:GlowFilter = new GlowFilter(4079166,1,0,0,10,1,false,false);
         glowFilter.blurX = 5;
         glowFilter.blurY = 5;
         statsField.filters = [glowFilter];
      }

      public function console(fSize:int = 14, coms:Boolean = true, _globaldebug:Boolean = false) : void
      {
         var textFormat:TextFormat = new TextFormat("Verdana", int(fSize), 16777215);
         consoletext.defaultTextFormat = textFormat;
         consoletext.multiline = true;
         consoletext.wordWrap = true;
         consoletext.height = 200;
         consoletext.width = 450;
         //consoletext.border = true;
         //consoletext.borderColor = 0xFFFFFF;

         consoletext.antiAliasType = AntiAliasType.ADVANCED;
         consoletext.embedFonts = true;
         
         var background:Shape = new Shape();
         background.graphics.beginFill(0, 0.7);
         background.graphics.drawRect(0, 0, consoletext.width, consoletext.height);
         background.graphics.endFill();

         _gameScreen.userInterface.hud.addChild(background);
         _gameScreen.userInterface.hud.addChild(consoletext);
         addComms(coms, int(fSize));
         consoletext.x = 10;
         consoletext.y = 10;
         background.x = consoletext.x;
         background.y = consoletext.y;
         this.initilized = true;
         globaldebug = _globaldebug;
      }
      
      public function log(msg:String,  color:String = "#FFFFFF") : void
      {
         if(globaldebug)
         {
            gdlog("[" + CurrentTime() + "] " + msg);
         }
         else if(initilized)
         {
            var formattedMessage:String = "<font color='" + color + "'>" + "[" + CurrentTime() + "] " + msg + "</font>";
            consoletext.htmlText += formattedMessage + "\n";

            if(consoletext.scrollV >= consoletext.maxScrollV - consoletext.height / consoletext.textHeight)
            {
               consoletext.scrollV = consoletext.maxScrollV;
            }
         }
      }

      public function clear(msg:Boolean = false, num:int = 0) : void
      {
         if(initilized)
         {
            var addedMessage:String = msg ? "<font color='" + "#FFFFFF" + "'>" + "[" + CurrentTime() + "] " + "Cleared Console." + "</font>" : "";
            consoletext.htmlText = addedMessage;
         }
      }

      public function logError(msg:String, cl:String = "") : void
      {
         if(globaldebug)
         {
            //gdlog("color 04");
            gdlog("[" + CurrentTime() + ", " + cl + "] " + msg);
         }
         else if(initilized)
         {
            var formattedMessage:String = "<font color='#FF0000'>" + "[" + CurrentTime() + ", " + cl + "] " + msg + "</font>";
            consoletext.htmlText += formattedMessage + "\n";

            if(consoletext.scrollV >= consoletext.maxScrollV - consoletext.height / consoletext.textHeight)
            {
               consoletext.scrollV = consoletext.maxScrollV;
            }
         }
      }

      public function error(msg:String, cl:String = "") : void
      {
         if(globaldebug)
         {
            gdlog("[" + CurrentTime() + ", " + cl + "] " + msg);
         }
         else if(initilized)
         {
            var formattedMessage:String = "<font color='#FF0000'>" + "[" + CurrentTime() + ", " + cl + "] " + msg + "</font>";
            consoletext.htmlText += formattedMessage + "\n";

            if(consoletext.scrollV >= consoletext.maxScrollV - consoletext.height / consoletext.textHeight)
            {
               consoletext.scrollV = consoletext.maxScrollV;
            }
            return;
         }
         else
         {
            throw new Error("Class: " + cl + ", " + msg);
         }
      }

      public function Statistics(txt:String, txt2:String = "", txt3:String = "", txt4:String = "", txt5:String = "", txt6:String = "") : void
      {
         statsField.htmlText = txt + "\n" + txt2 + "\n" + txt3 + "\n" + txt4 + "\n" + txt5 + "\n" + txt6;
      }

      public function CurrentTime() : String
      {
         var seconds:Number = this._gameScreen.game.frame / 30;
         var minutes:int = Math.floor(seconds / 60);
         var remainingSeconds:int = seconds % 60;

         var formattedTime:String = minutes.toString() + ":" + (remainingSeconds < 10 ? "0" : "") + remainingSeconds.toString();
         return formattedTime;
      }

      private function gdlog(text:String) : void
      {
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");

         var request:URLRequest = new URLRequest("http://localhost:6969/");
         request.method = URLRequestMethod.POST;

         var variables:URLVariables = new URLVariables();
         variables.deez = text;
         request.data = variables;

         var loader:URLLoader = new URLLoader();
         loader.load(request);

         loader.addEventListener(Event.COMPLETE, function(event:Event):void{
            // Response handling logic here
         });
         loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
            // Error handling logic here
         });
      }

      public function addComms(coms:Boolean = true, fSize:int = 14) : void
      {
         if(coms)
         {
            var bg:Shape = new Shape();
            bg.graphics.beginFill(0, 0.7);
            bg.graphics.drawRect(0, 0, consoletext.width, 20);
            bg.graphics.endFill();

            bg.y = consoletext.y + consoletext.height + bg.height - 5;
            _gameScreen.userInterface.hud.addChild(bg);

            var textFormat:TextFormat = new TextFormat("Verdana", int(fSize), 16777215);
            inputField = new TextField();
            inputField.defaultTextFormat = textFormat;
            inputField.type = TextFieldType.INPUT;

            inputField.antiAliasType = AntiAliasType.ADVANCED;
            inputField.embedFonts = true;

            inputField.height = 20;
            inputField.width = 450;

            _gameScreen.userInterface.hud.addChild(inputField);
            inputField.x = 10;
            inputField.y = bg.y;
            bg.x = inputField.x;
            bg.y = inputField.y;

            inputField.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
         }
      }

      public function handleInput(event:KeyboardEvent):void
      {
         var parts:Array = null;
         var command:String = inputField.text;
         if (event.keyCode == Keyboard.ENTER)
         {
            command = command.toLowerCase();
            command = command.split("-").join("");
            command = command.split("/").join("");
            parts = command.split(" ");
            
            switch(parts[0])
            {
               case "clear":
                  consoletext.htmlText = "";
                  Log("> Cleared consoletext", "#FFFF00");
                  break;
               case "give":
                  var team:String = parts[1].toLowerCase();
                  var currency:String = parts[2].toLowerCase();
                  var amount:int = parts[3];
                  if(team == "team")
                  {
                     if(currency == "gold")
                     {
                        _gameScreen.team.gold += amount;
                     }
                     else if(currency == "mana")
                     {
                        _gameScreen.team.mana += amount;
                     }
                  }
                  else if(team == "enemyteam")
                  {
                     if(currency == "gold")
                     {
                        _gameScreen.team.enemyTeam.gold += amount;
                     }
                     else if(currency == "mana")
                     {
                        _gameScreen.team.enemyTeam.mana += amount;
                     }
                  }
                  Log("> Gave " + team + " " + amount + " of " + currency, "#FFFF00");
                  break;
               case "help":
                  Log("> clear, give", "#FFFF00");
                  break;
               default:
                  Log("> " + command + " is an unknown command, try using 'help'", "#FFFF00");
            }

            inputField.text = "";
         }
      }
   }
}