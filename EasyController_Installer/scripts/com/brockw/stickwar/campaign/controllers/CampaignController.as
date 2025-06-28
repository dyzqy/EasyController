package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.campaign.controllers.EasyController.*;
   
   public class CampaignController
   {
      private var _gameScreen:GameScreen;

      public var loader:Loader;

      public var data:Data;

      public var debug:Debug;

      public var util:Util;

      public var cs:CutScene;
      
      public function CampaignController(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;

         this.loader = new Loader(gameScreen);

         this.data = new Data(gameScreen);
         this.debug = new Debug(gameScreen);
         this.util = new Util(gameScreen);
         this.cs = new CutScene(gameScreen);
      }
      
      public function update(param1:GameScreen) : void
      {
      }
   }
}
package com.brockw.stickwar.campaign.controllers.EasyController
{
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.utils.*;

   // TODO: Orginise all of the functions inside to their respective categories.
   public class Data
   {

      private var _gameScreen:GameScreen;


      public function Data(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;
      }

      // TODO: This is ok, but not ok. Not really DIY
      public function center(pos:String = "x") : Number
      {
         pos = pos.toLowerCase();
         if(pos == "x" || pos == "px")
         {
            return this._gameScreen.game.map.width / 2;
         }
         else if(pos == "y" || pos == "py")
         {
            return this._gameScreen.game.map.height / 2;
         }
         return 0;
      }

      // Returns amount of all units or of a specfic type(s) of unit(s).
      public function unitAmount(team:Team, unitData:* = null) : int
      {
         if(unitName == null)
         {
            return team.units.length;
         }
         else
         {
            var units:* = StringMap.getUnit(unitData);
            if(units is Array)
            {
               var length:int = 0;
               for(var i:int = 0; i < units.length; i++)
               {
                  length += unitAmount(team, units)
               }
               return length;
            }
            else if(units is int)
            {
               return team.unitGroup[units].length;
            }
         }
      }

      private static function isOdd(number:int) : Boolean 
      {
         return number % 2 != 0;
      }

      // TODO: Add description of what it does and of its paramaters
      // There is prob also a better way to do this
      public function isTime(num:Number, doafter:Boolean = false) : Boolean
      {
         // Odd numbers are not devidable by 2
         var frames:int = int(num * 30);
         var gameFrames:* = this._gameScreen.game.frame;
         var result:Boolean = gameFrames == frames;

         if(doafter)
         {
            return gameFrames > frames;
         }
         
         if(this._gameScreen.isFastForward)
         {
            if(isOdd(gameFrames) && isOdd(frames))
            {
               result = gameFrames == frames;
            }
            else if(!isOdd(gameFrames) && !isOdd(frames))
            {
               result = gameFrames == frames;
            }
            else
            {
               result = gameFrames - 1 == frames;
            }
         }

         return result;
      }

      public function campaignInfo(infType:String) : *
      {
         infType = infType.toLowerCase();
         if(infType == "name" || infType == "title")
         {
            return this._gameScreen.main.campaign.getCurrentLevel().title;
         }
         else if(infType == "desc" || infType == "description")
         {
            return this._gameScreen.main.campaign.getCurrentLevel().storyName;
         }
         else if(infType == "num" || infType == "number")
         {
            return this._gameScreen.team.game.main.campaign.currentLevel;
         }
         else if(infType == "diff" || infType == "dif" || infType == "difficulty")
         {
            return this._gameScreen.team.game.main.campaign.difficultyLevel;
         }
         else if(infType == "tip")
         {
            var prefix:String = "Tip: ";
            var tip:String = this._gameScreen.main.campaign.getCurrentLevel().tip;

            if (tip.indexOf(prefix) === 0) {
               return tip.substring(prefix.length);
            }
         }
         return null;
      }

      // TODO: Make this use brock's random number generator instead of AS's.
      public function random(min:Number, max:Number) : *
      {
         return min + Math.floor(Math.random() * (max - min + 1))
      }
   }
}
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
package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.*;
    import com.brockw.stickwar.campaign.*;
    import com.brockw.stickwar.engine.*;
    import com.brockw.stickwar.engine.Ai.*;
    import com.brockw.stickwar.engine.Ai.command.*;
    import com.brockw.stickwar.engine.Team.*;
    import com.brockw.stickwar.engine.multiplayer.moves.*;
    import com.brockw.stickwar.engine.units.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.display.*;

    public class Util
    {
        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
            this.debug = Debug.instance;
        }

    //  # Unit Related Functions. 

        // Summons unit(s) of a specified team.
        // "unitData" A specified type of unit or an array of unit types.
        // "copies" How many each specified unit should be spawned.
        // "teamSpawn" Which team the unit spawns in.
        // "func" A function to run on all units spawned.
        // "returnType" The type that the function should return
        public function summonUnit(unitData:*, copies:int = 1, teamSpawn:Team = null, func:Function = null, returnType:Class = null) : *
        {
            if(teamSpawn == null)
            {
                teamSpawn = _gameScreen.team;
            }

            var units:Array = [];
            var u1:* = StringMap.getUnit(unitData);

            if (u1 is Array)
            {
                for(var i:int = 0; i < u1.length; i++)
                {
                    summonUnit(u1[i], copies, teamSpawn, func, returnType);
                }
            }
            else if(u1 is int)
            {
                for(var i:int = 0; i < copies; i++)
                {
                    var un:Unit = _gameScreen.game.unitFactory.getUnit(u1);
                    teamSpawn.spawn(un, _gameScreen.game);
                    teamSpawn.population += un.population;

                    if(func != null)
                    {
                        func(un);
                    }

                    units.push(un);
                }
            }
            else
            {
                debug.error("Invalid parameter for 'SummonUnit()'. The first parameter must be either a String or an Array of Strings.", "Util");
            }

            switch(returnType)
            {
                case Array:
                    return units;
                    break;

                default:
                    return units[0];
                    break;
            }
        }

        // TODO: Test if this works.
        // Allows a unit(s) of other empires to be summoned.
        // "units" A specified type of unit or an array of unit types.
        // "team" the team to register the unit to.
        public function registerUnit(units:*, team:Team) : void
        {
            var level:* = this._gameScreen.main.campaign.getCurrentLevel();
            units = StringMap.getUnit(units);

            if(units is Array)
            {
                for(var i:int = 0; i < units.length; i++)
                {
                    registerUnits(units[i], team);
                }
            }
            else if(units is int)
            {
                var currentUnit:int = units;
                    
                if(team.unitInfo[currentUnit] == null)
                {
                    team.unitInfo[currentUnit] = [(StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).gold * (StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).mana * level.insaneModifier];
                    var unit:Unit = this._gameScreen.game.unitFactory.getUnit(int(currentUnit));
                    unit.team = team;
                    unit.setBuilding();
                    // TODO: Find a way to set the correct unit building. unit.building is public.
                    // Might be null tho if the team isn't the supposed team? 
                    team.unitInfo[currentUnit].push((team.buildings["BankBuilding"]).type);
                    team.unitGroups[currentUnit] = [];
                    this._gameScreen.game.unitFactory.returnUnit(currentUnit, unit);
                }
            }
            else
            {
                debug.error("The first paramater of util.registerUnit() must be a String or an Array of Strings.", "Util");
            }
        }

        // TODO: add Hide unit button in hud function
        // ^ Both of these can be done in same function(?)
        // TODO: add Show unit button in hud function


        // TODO: rework killUnit so destroy is actually reliable.
        // public function killUnit(un:Unit, destroy:Boolean = false) : void
        // {
        //     if(destroy)
        //     {
        //         un.px = 10000;
        //     }
        //     un.kill();
        // }

        // TODO: Verify if this can run in multiplayer side 
        public function hold(unit:Unit, x:Number = 0, y:Number = 0) : void
        {
            var move:UnitMove = new UnitMove();
            move.owner = unit.team.id; 
            move.moveType = UnitCommand.HOLD; 
            move.arg0 = x; 
            move.arg1 = y; 
            move.units.push(unit.id); 
            move.execute(_gameScreen.game);
        }

        // TODO: Verify if this can run in multiplayer side 
        public function move(unit:Unit, x:Number = 0, y:Number = 0) : void
        {
            var move:UnitMove = new UnitMove(); 
            move.owner = unit.team.id;
            move.moveType = UnitCommand.MOVE; 
            move.arg0 = x; 
            move.arg1 = y; 
            move.units.push(unit.id); 
            move.execute(_gameScreen.game);
        }

        // TODO: Verify if this can run in multiplayer side 
        public function garrison(unit:Unit) : void
        {
            unit.garrison();
        }

        // TODO: Verify if this can run in multiplayer side 
        public function ungarrison(unit:Unit) : void
        {
            unit.ungarrison();
        }

        // TODO: Make this more dynamic. As in make it possible to only instantly build certain units, or have it as a percentage.
        public function instaBuild(team:Team) : void
        {
            var unit:* = null;
            for each(unit in team.unitProductionQueue)
            {
                if(unit.length != 0)
                {
                    unit[0][1] = unit[0][0].createTime + 9;
                }
            }
        }

        // Passively heal units by amount divided by 30.
        public function passiveHeal(type:*, amount:Number, extrateam:Team = null) : void
        {
            var un:* = null;
            var realamount:Number = amount / 30;

            unitsreducedcode(type, function(un:Unit):void{
                if(un.health + realamount <= un.maxHealth)
                {
                    un.health += realamount;
                }
                else
                {
                    un.health += un.maxHealth - un.health;
                }
            }, extrateam);
        }

        // TODO: Use another way to do this?
        // public function passiveCure(type:*, timer:Number) : void
        // {
        //     var un:* = null;
        //     if(type is Team)
        //     {
        //         for each(un in type.units)
        //         {
        //             loop(timer, function():void{
        //                 un.cure();
        //             });
        //         }
        //     }
        //     else if(type is Unit)
        //     {
        //         var un:Unit = type;
        //         loop(timer, function():void{
        //             un.cure();
        //         });
        //     }
        // }

    //  # Utility Related Functions. 

        // TODO: Either fix or remove.
        // public function swapUnitButton(units:*, team:Team) : void
        // {
        //     if(!Loader.instance.isDev)
        //     {
        //         debug.error("The 'swapUnitButton()' function is still under work!", "Util")
        //         return;
        //     }
            
        //     var unit1:* = StringMap.unitNameToType(units[0]);
        //     var unit2:* = StringMap.unitNameToType(units[1]);
        //     registerUnit(unit1, team);

        //     var currentXML:* = StringMap.unitTypeToXML(unit2, this._gameScreen.game);
            
        //     var unit:* = team.buttonInfoMap[unit1];
        //     team.buttonInfoMap[unit2] = [unit[0],unit[1],currentXML,0,new cancelButton(),currentXML.cost * team.handicap,unit[6],unit[7],unit[8]];

        //     delete team.buttonInfoMap[unit1];
        //     team.unitsAvailable[unit2] = 1;
        // }

        // TODO: Rework reinforcements code.
        // public function reinforcements(health:int, maxHealth:int, team:Team, info:* = null, fullHeal:Boolean = true, extra:Boolean = false) : void
        // {
        //     if(team.statue.health <= health && team.statue.maxHealth != maxHealth && !extra)
        //     {
        //         if(info is Function)
        //         {
        //             info();
        //         }
        //         else
        //         {
        //             debug.error("Input for 4th paramater must be a Function. 'reinforcements()'", "Util");
        //         }
                
        //         team.statue.health = fullHeal ? maxHealth : (team.statue.maxHealth / team.statue.health - 1) * maxHealth;
        //         team.statue.maxHealth = maxHealth;
        //         team.statue.healthBar.totalHealth = maxHealth;
        //     }
        // }

        // TODO: Decide if to keep these 2 functions below? They do not abide by the DIY "rule" I set. 
        public function changeStatue(team:Team, statue:String) : void
        {
            team.statueType = statue.toLowerCase();
        }

        public function changeMusic(name:String = "orderInGame") : void
        {
            _gameScreen.game.soundManager.playSoundInBackground(name);
        }

        public function disableFinishers(team:Team = null) : void
        {
            if(team == null)
            {
                _gameScreen.team.isMember = false;
                _gameScreen.team.enemyTeam.isMember = false;
            }
            else if(!(team is Team))
            {
                debug.error("Paramater must be null or a Team. disableFinishers().", "Util");
            }
            else
            {
                team.isMember = false;
            }
        }

    //   # Private functions place :)

        // TODO: Rework this. It does its job too goofily.
        // + I don't even remember what it does lol
        private function unitsreducedcode(type:*, func:Function, extrateam:Team = null) : void
        {
            var un:* = null;
            var realamount:Number = amount / 30;
            if(type is Team)
            {
                for each(un in type.units)
                {
                    func(un);
                }
            }
            else if(type is Array)
            {
                if(type[0] is Unit)
                {
                    for each(un in type.units)
                    {
                        func(un);
                    }
                }
                else if(type[0] is String)
                {
                    var unitGroup:Array = getUnitGroup(type, extrateam);
                    for each(un in unitGroup)
                    {
                        func(un);
                    }
                }
                else
                {
                    debug.error("No registered array type for {" + type + "} is available yet.", "Util");
                }
            }
            else if(type is Unit)
            {
                func(type);
            }
            else if(type is String)
            {
                var unitGroup:Array = getUnitGroup(type, extrateam);
                for each(un in unitGroup)
                {
                    func(un);
                }
            }
            else
            {
                debug.error("{" + type + "} must be either a Team, Unit, String or an Array of Strings/Units.", "Util");
            }
        }

        private function getUnitGroup(type:*, team:Team) : Array
        {
            return team.unitGroups[StringMap.getUnit(type)];
        }
    }
}
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
package com.brockw.stickwar.campaign.controllers.EasyController
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class StringMap
   {
      public function StringMap()
      {
         super();
      }

      // TODO: Add fuzzy search.
      
      public static function unitNameToType(param1:String) : int
      {
        param1 = param1.toLowerCase();
        param1 = param1.split(" ").join("");
         if(param1 == "miner")
         {
            return Unit.U_MINER;
         }
         if(param1 == "swordwrath" || param1 == "sword" || param1 == "swordman")
         {
            return Unit.U_SWORDWRATH;
         }
         if(param1 == "archidon" || param1 == "archer" || param1 == "arch") // "I use arch btw"
         {
            return Unit.U_ARCHER;
         }
         if(param1 == "spearton" || param1 == "spear")
         {
            return Unit.U_SPEARTON;
         }
         if(param1 == "ninja" || param1 == "shadow" || param1 == "shadowrath" || param1 == "shadowwrath")
         {
            return Unit.U_NINJA;
         }
         if(param1 == "flyingcrossbowman" || param1 == "albowtross" || param1 == "albow" || param1 == "crossbowman")
         {
            return Unit.U_FLYING_CROSSBOWMAN;
         }
         if(param1 == "monk" || param1 == "meric")
         {
            return Unit.U_MONK;
         }
         if(param1 == "magikill" || param1 == "magi" || param1 == "magik")
         {
            return Unit.U_MAGIKILL;
         }
         if(param1 == "enslavedgiant" || param1 == "egiant")
         {
            return Unit.U_ENSLAVED_GIANT;
         }
         if(param1 == "chaosminer" || param1 == "minerchaos" || param1 == "cminer" || param1 == "minerc" || param1 == "enslavedminer" || param1 == "eminer")
         {
            return Unit.U_CHAOS_MINER;
         }
         if(param1 == "bomber" || param1 == "bomb")
         {
            return Unit.U_BOMBER;
         }
         if(param1 == "wingadon" || param1 == "eclipsor" || param1 == "wing" || param1 == "eclips")
         {
            return Unit.U_WINGIDON;
         }
         if(param1 == "skelatalmage" || param1 == "skele" || param1 == "marrowkai" || param1 == "marrow")
         {
            return Unit.U_SKELATOR;
         }
         if(param1 == "dead" || param1 == "ded")
         {
            return Unit.U_DEAD;
         }
         if(param1 == "cat" || param1 == "crawler" || param1 == "crawl")
         {
            return Unit.U_CAT;
         }
         if(param1 == "knight" || param1 == "juggerknight" || param1 == "jugg")
         {
            return Unit.U_KNIGHT;
         }
         if(param1 == "medusa" || param1 == "medu")
         {
            return Unit.U_MEDUSA;
         }
         if(param1 == "giant")
         {
            return Unit.U_GIANT;
         }
         if(param1 == "fireelement" || param1 == "fireele" || param1 == "fire")
         {
            return Unit.U_FIRE_ELEMENT;
         }
         if(param1 == "earthelement" || param1 == "earthele" || param1 == "earth")
         {
            return Unit.U_EARTH_ELEMENT;
         }
         if(param1 == "waterelement" || param1 == "waterele" || param1 == "water")
         {
            return Unit.U_WATER_ELEMENT;
         }
         if(param1 == "airelement" || param1 == "airele" || param1 == "air")
         {
            return Unit.U_AIR_ELEMENT;
         }
         if(param1 == "lavaelement" || param1 == "lavaele" || param1 == "charrog" || param1 == "lava")
         {
            return Unit.U_LAVA_ELEMENT;
         }
         if(param1 == "hurricaneelement" || param1 == "hurricaneele" || param1 == "cycloid" || param1 == "hurricane")
         {
            return Unit.U_HURRICANE_ELEMENT;
         }
         if(param1 == "firestormelement" || param1 == "firestormele" || param1 == "infernos" || param1 == "firestorm")
         {
            return Unit.U_FIRESTORM_ELEMENT;
         }
         if(param1 == "treeelement" || param1 == "treeele" || param1 == "treasure" || param1 == "tree")
         {
            return Unit.U_TREE_ELEMENT;
         }
         if(param1 == "scorpionelement" || param1 == "scorpionele" || param1 == "scorpion" || param1 == "scorp")
         {
            return Unit.U_SCORPION_ELEMENT;
         }
         if(param1 == "chromeelement" || param1 == "chromeele" || param1 == "v" || param1 == "chrome")
         {
            return Unit.U_CHROME_ELEMENT;
         }
         if(param1 == "minerelement" || param1 == "minerele" || param1 == "chomper" || param1 == "chomp" || param1 == "eminer")
         {
            return Unit.U_MINER_ELEMENT;
         }
         Debug.instance.error("No match for " + param1, "StringMap")
         return -1;
      }
      
      public static function unitTypeToName(param1:int) : String
      {
         if(param1 == Unit.U_MINER)
         {
            return "Miner";
         }
         if(param1 == Unit.U_SWORDWRATH)
         {
            return "Swordwrath";
         }
         if(param1 == Unit.U_ARCHER)
         {
            return "Archidon";
         }
         if(param1 == Unit.U_SPEARTON)
         {
            return "Spearton";
         }
         if(param1 == Unit.U_NINJA)
         {
            return "Shadowrath";
         }
         if(param1 == Unit.U_FLYING_CROSSBOWMAN)
         {
            return "Albowtross";
         }
         if(param1 == Unit.U_MONK)
         {
            return "Meric";
         }
         if(param1 == Unit.U_MAGIKILL)
         {
            return "Magikill";
         }
         if(param1 == Unit.U_ENSLAVED_GIANT)
         {
            return "Enslaved Giant";
         }
         if(param1 == Unit.U_CHAOS_MINER)
         {
            return "Enslaved Miner";
         }
         if(param1 == Unit.U_BOMBER)
         {
            return "Bomber";
         }
         if(param1 == Unit.U_WINGIDON)
         {
            return "Eclipsor";
         }
         if(param1 == Unit.U_SKELATOR)
         {
            return "Marrowkai";
         }
         if(param1 == Unit.U_DEAD)
         {
            return "Dead";
         }
         if(param1 == Unit.U_CAT)
         {
            return "Crawler";
         }
         if(param1 == Unit.U_KNIGHT)
         {
            return "Juggerknight";
         }
         if(param1 == Unit.U_MEDUSA)
         {
            return "Medusa";
         }
         if(param1 == Unit.U_GIANT)
         {
            return "Giant";
         }
         if(param1 == Unit.U_FIRE_ELEMENT)
         {
            return "Fire Elemental";
         }
         if(param1 == Unit.U_EARTH_ELEMENT)
         {
            return "Earth Elemental";
         }
         if(param1 == Unit.U_WATER_ELEMENT)
         {
            return "Water Elemental";
         }
         if(param1 == Unit.U_AIR_ELEMENT)
         {
            return "Air Elemental";
         }
         if(param1 == Unit.U_LAVA_ELEMENT)
         {
            return "Charrog";
         }
         if(param1 == Unit.U_HURRICANE_ELEMENT)
         {
            return "Cycloid";
         }
         if(param1 == Unit.U_FIRESTORM_ELEMENT)
         {
            return "Infernos";
         }
         if(param1 == Unit.U_TREE_ELEMENT)
         {
            return "Treasure";
         }
         if(param1 == Unit.U_SCORPION_ELEMENT)
         {
            return "Scorpion";
         }
         if(param1 == Unit.U_CHROME_ELEMENT)
         {
            return "V";
         }
         if(param1 == Unit.U_MINER_ELEMENT)
         {
            return "Chomper";
         }
         return "{Target Is Not a Unit}";
      }

      public static function unitTypeToXML(param1:int, param2:StickWar) : XMLList
      {
         if(param1 == Unit.U_MINER)
         {
            return param2.xml.xml.Order.Units.miner;
         }
         if(param1 == Unit.U_SWORDWRATH)
         {
            return param2.xml.xml.Order.Units.swordwrath;
         }
         if(param1 == Unit.U_ARCHER)
         {
            return param2.xml.xml.Order.Units.archer;
         }
         if(param1 == Unit.U_SPEARTON)
         {
            return param2.xml.xml.Order.Units.spearton;
         }
         if(param1 == Unit.U_NINJA)
         {
            return param2.xml.xml.Order.Units.ninja;
         }
         if(param1 == Unit.U_FLYING_CROSSBOWMAN)
         {
            return param2.xml.xml.Order.Units.flyingCrossbowman;
         }
         if(param1 == Unit.U_MONK)
         {
            return param2.xml.xml.Order.Units.monk;
         }
         if(param1 == Unit.U_MAGIKILL)
         {
            return param2.xml.xml.Order.Units.magikill;
         }
         if(param1 == Unit.U_ENSLAVED_GIANT)
         {
            return param2.xml.xml.Order.Units.giant;
         }
         if(param1 == Unit.U_CHAOS_MINER)
         {
            return param2.xml.xml.Chaos.Units.miner;
         }
         if(param1 == Unit.U_BOMBER)
         {
            return param2.xml.xml.Chaos.Units.bomber;
         }
         if(param1 == Unit.U_WINGIDON)
         {
            return param2.xml.xml.Chaos.Units.wingidon;
         }
         if(param1 == Unit.U_SKELATOR)
         {
            return param2.xml.xml.Chaos.Units.skelator;
         }
         if(param1 == Unit.U_DEAD)
         {
            return param2.xml.xml.Chaos.Units.dead;
         }
         if(param1 == Unit.U_CAT)
         {
            return param2.xml.xml.Chaos.Units.cat;
         }
         if(param1 == Unit.U_KNIGHT)
         {
            return param2.xml.xml.Chaos.Units.knight;
         }
         if(param1 == Unit.U_MEDUSA)
         {
            return param2.xml.xml.Chaos.Units.medusa;
         }
         if(param1 == Unit.U_GIANT)
         {
            return param2.xml.xml.Chaos.Units.giant;
         }
         if(param1 == Unit.U_FIRE_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.fireElement;
         }
         if(param1 == Unit.U_EARTH_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.earthElement;
         }
         if(param1 == Unit.U_WATER_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.waterElement;
         }
         if(param1 == Unit.U_AIR_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.airElement;
         }
         if(param1 == Unit.U_LAVA_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.lavaElement;
         }
         if(param1 == Unit.U_HURRICANE_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.hurricaneElement;
         }
         if(param1 == Unit.U_FIRESTORM_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.firestormElement;
         }
         if(param1 == Unit.U_TREE_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.treeElement;
         }
         if(param1 == Unit.U_SCORPION_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.scorpionElement;
         }
         if(param1 == Unit.U_CHROME_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.chrome;
         }
         if(param1 == Unit.U_MINER_ELEMENT)
         {
            return param2.xml.xml.Elemental.Units.miner;
         }
         return null;
      }

      // Gets unit int with whatever data you give it.
      public static function getUnit(data:*) : * 
      {
         if(data is String)
         {
            return unitNameToType(data);
         }
         else if(data is int)
         {
            return data;
         }
         else if(data is Array)
         {
            var arrayToReturn:Array = [];
            for(var i:int = 0; i < data.length; i++)
            {
               arrayToReturn.push(getUnit(data[i]));
            }

            return arrayToReturn;
         }

         debug.error("Type " + data + " is not supported.", "StringMap");
         return null;
      }
   }
}
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
