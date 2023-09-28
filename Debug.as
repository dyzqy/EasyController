package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class Debug
    {

      private var _gameScreen:GameScreen;

      public var inputField:TextField;

      public var stats:TextField;

      public var console:TextField;

      public var comment:String;

      public function Debug(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;
         
         this.stats = new TextField();
         this.console = new TextField();
      }

      public function SimulateStats(fSize:Number = 12) : void
      {
         var textFormat:TextFormat = new TextFormat("Arial",fSize,16777215);
         stats.defaultTextFormat = textFormat;
         stats.multiline = true;
         stats.wordWrap = true;
         stats.height = 225;
         stats.width = 250;

         stats.antiAliasType = AntiAliasType.ADVANCED;
         stats.embedFonts = true;

         _gameScreen.userInterface.hud.addChild(stats);
         stats.x = 10;
         stats.y = 10;
         var dropShadowFilter:DropShadowFilter = new DropShadowFilter(4,45,0,1,0,0,1,3);
         var glowFilter:GlowFilter = new GlowFilter(4079166,1,0,0,10,1,false,false);
         glowFilter.blurX = 5;
         glowFilter.blurY = 5;
         stats.filters = [glowFilter];
      }

      public function SimulateConsole(fSize:int = 14, coms:Boolean = true) : void
      {
         var textFormat:TextFormat = new TextFormat("Verdana", int(fSize), 16777215);
         console.defaultTextFormat = textFormat;
         console.multiline = true;
         console.wordWrap = true;
         console.height = 200;
         console.width = 450;
         //console.border = true;
         //console.borderColor = 0xFFFFFF;

         console.antiAliasType = AntiAliasType.ADVANCED;
         console.embedFonts = true;
         
         var background:Shape = new Shape();
         background.graphics.beginFill(0, 0.7);
         background.graphics.drawRect(0, 0, console.width, console.height);
         background.graphics.endFill();

         _gameScreen.userInterface.hud.addChild(background);
         _gameScreen.userInterface.hud.addChild(console);
         addComms(coms, int(fSize));
         console.x = 10;
         console.y = 10;
         background.x = console.x;
         background.y = console.y;
      }
      
      public function Log(msg:String,  color:String = "#FFFFFF") : void
      {
         var formattedMessage:String = "<font color='" + color + "'>" + "[" + CurrentTime() + "] " + msg + "</font>";
         console.htmlText += formattedMessage + "\n";

         var isAtBottom:Boolean = console.scrollV >= console.maxScrollV - console.height / console.textHeight;
         if(isAtBottom)
         {
            console.scrollV = console.maxScrollV;
         }
      }

      public function LogError(msg:String, cl:String = "") : void
      {
         var formattedMessage:String = "<font color='#FF0000'>" + "[" + CurrentTime() + ", " + cl + "] " + msg + "</font>";
         console.htmlText += formattedMessage + "\n";

         var isAtBottom:Boolean = console.scrollV >= console.maxScrollV - console.height / console.textHeight;
         if(isAtBottom)
         {
            console.scrollV = console.maxScrollV;
         }
      }

      public function Statistics(txt:String, txt2:String = "", txt3:String = "", txt4:String = "", txt5:String = "", txt6:String = "") : void
      {
         stats.htmlText = txt + "\n" + txt2 + "\n" + txt3 + "\n" + txt4 + "\n" + txt5 + "\n" + txt6;
      }

      public function CurrentTime() : String
      {
         var seconds:Number = this._gameScreen.game.frame / 30;
         var minutes:int = Math.floor(seconds / 60);
         var remainingSeconds:int = seconds % 60;

         var formattedTime:String = minutes.toString() + ":" + (remainingSeconds < 10 ? "0" : "") + remainingSeconds.toString();
         return formattedTime;
      }

      public function addComms(coms:Boolean = true, fSize:int = 14) : void
      {
         if(coms)
         {
            var bg:Shape = new Shape();
            bg.graphics.beginFill(0, 0.7);
            bg.graphics.drawRect(0, 0, console.width, 20);
            bg.graphics.endFill();

            bg.y = console.y + console.height + bg.height - 5;
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
                  console.htmlText = "";
                  Log("> Cleared console", "#FFFF00");
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