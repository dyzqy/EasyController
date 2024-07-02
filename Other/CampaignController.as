package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.campaign.controllers.EasyController.*;
   
   public class CampaignController
   {
      public var loader:Loader;

      public var data:Data;

      public var debug:Debug;

      public var util:Util;

      public var cs:CutScene;

      public var draw:Draw;

      public var pp:ProjectilePlus;
      
      private var _gameScreen:GameScreen;
      
      public function CampaignController(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;

         if(this.draw == null)
         {
            this.loader = new Loader(gameScreen);

            this.draw = loader.draw;
            this.data = new Data(gameScreen);
            this.debug = new Debug(gameScreen);
            this.util = new Util(gameScreen);
            this.cs = new CutScene(gameScreen);
            this.pp = new ProjectilePlus(gameScreen,this.util);
         }
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

   public class Data
   {
      public static const T_NOT_RESEARCHED:int = 0;

      public static const T_RESEARCHING:int = 1;

      public static const T_RESEARCHED:int = 2;


      private var _gameScreen:GameScreen;


      public function Data(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;
      }

      public function timer(type:String = "frames") : Number
      {
         return this._gameScreen.game.frame;
      }

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

      public function unitAmount(team:Team, unitName:String = "") : int
      {
         var rUnit:Unit = null;
         var unitType:int = 0;
         var unitNum:int = 0;

         if(unitName != "")
         {
            rUnit = this._gameScreen.game.unitFactory.getUnit(StringMap.unitNameToType(unitName));
            unitType = StringMap.unitNameToType(unitName);
            unitNum = team.unitGroup[unitType].length;
         }
         else
         {
            for each(rUnit in team.units)
            {
               if(rUnit.isAlive())
               {
                  unitNum += 1;
               }
            }
         }
         return unitNum;
      }

      public function state(state:int, currState:int) : Boolean
      {
         return state == currState;
      }

      public static function isOdd(number:int) : Boolean 
      {
         return number % 2 != 0;
      }

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

      public function statuePosition(team:Team, pos:String = "x") : Number
      {
         pos = pos.toUpperCase();
         if(pos == "X" || pos == "PX")
         {
            return team.statue.px;
         }
         else if(pos == "Y" || pos == "PY")
         {
            return team.statue.py;
         }
         return 0;
      }

      public function statueType(team:Team) : String
      {
         return team.statueType;
      }

      public function homeX(team:Team) : Number
      {
         return team.homeX;
      }

      public function campaignInfo(infType:String) : *
      {
         infType = infType.toUpperCase();
         if(infType == "NAME" || infType == "TITLE")
         {
            return this._gameScreen.main.campaign.getCurrentLevel().title;
         }
         else if(infType == "DESC" || infType == "DESCRIPTION")
         {
            return this._gameScreen.main.campaign.getCurrentLevel().storyName;
         }
         else if(infType == "NUM" || infType == "NUMBER")
         {
            return this._gameScreen.team.game.main.campaign.currentLevel;
         }
         else if(infType == "DIFF" || infType == "DIFFICULTY" || infType == "DIF")
         {
            return this._gameScreen.team.game.main.campaign.difficultyLevel;
         }
         else if(infType == "TIP")
         {
            var prefix:String = "Tip: ";
            var tip:String = this._gameScreen.main.campaign.getCurrentLevel().tip;

            if (tip.indexOf(prefix) === 0) {
               return tip.substring(prefix.length);
            }
         }
         return null;
      }

      public function researchedMap() : Array
      {
         var researchedTechs:Array = new Array(61);

         var availableTechs:Dictionary = Tech.isResearchedMap;

         var i = 0;
         for(i = 0; i >= -61; i--)
         {
            if(availableTechs[i] == true)
            {
               researchedTechs[Math.abs(i)] = i;
            } else {
               researchedTechs[Math.abs(i)] = 0;
            }
         }
         return researchedTechs;
      }

      public function cameraPos() : Number
      {
         return this._gameScreen.game.screenX;
      }

      public function techState(techNum:int, team:Team) : int
      {
         if(team.tech.isResearched(techNum))
         {
            return T_RESEARCHED;
         } 
         else if(team.tech.isResearching(techNum))
         {
            return T_RESEARCHING;
         }
         else if(!team.tech.isResearching(techNum) && !team.tech.isResearched(techNum))
         {
            return T_NOT_RESEARCHED;
         }
         return null;
      }

      public function teamState(team:Team) : int
      {
         if(team.currentAttackState == Team.G_GARRISON)
         {
            return Team.G_GARRISON;
         } 
         else if(team.currentAttackState == Team.G_DEFEND)
         {
            return Team.G_DEFEND;
         }
         else if(team.currentAttackState == Team.G_ATTACK)
         {
            return Team.G_ATTACK;
         }
         return null;
      }

      public function teamInfo(infType:String, team:Team) : *
      {
         infType = infType.toUpperCase();
         infType = infType.split(" ").join("");
         if(infType == "GOLD" || infType == "G")
         {
            return team.gold;
         }
         else if(infType == "MANA" || infType == "M")
         {
            return team.mana;
         }
         else if(infType == "POPULATION" || infType == "POP" || infType == "P")
         {
            return team.population;
         }
         else if(infType == "STATUE")
         {
            return team.statue.health;
         }
         return null;
      }

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
        private var registeredUnits:Array;

        private var customUnits:*;

        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
            this.debug = Debug.instance;
        }

        public function summonUnit(u1:*, copies:int = 1, teamSpawn:Team = null, returnType:Class = null, type1:* = null, variable1:* = null) : *
        {
            if(teamSpawn == null)
            {
                teamSpawn = _gameScreen.team;
            }
            var i:int = 0;
            var unName:int = 0;
            var un:Unit = null;
            var units:Array = [];
            var type:* = null;
            var variable:* = null;

            if (u1 is Array)
            {
                var j:int = 0;
                while(j < u1.length)
                {
                    if(!(u1[j] is String))
                    {
                        debug.error("Unit Name must be a String. SummonUnit().", "Util");
                        return;
                    }
                    if(type1 is Array)
                    {
                        type = type1[j];
                    }
                    if(variable1 is Array)
                    {
                        variable = variable1[j];
                    }
                    while(i < copies)
                    {
                        unName = StringMap.unitNameToType(u1[j]);
                        un = _gameScreen.game.unitFactory.getUnit(unName);
                        if(type != null && variable != null)
                        {
                            un[variable] = type;
                        }
                        teamSpawn.spawn(un, _gameScreen.game);
                        teamSpawn.population += un.population;

                        units.push(un);
                        i++;
                    }
                    i = 0;
                    j++;
                }
            }
            else if (u1 is String)
            {
                while (i < copies)
                {
                    if(type1 is String)
                    {
                        type = type1;
                    }
                    if(variable1 is String)
                    {
                        variable = variable1;
                    }
                    unName = StringMap.unitNameToType(u1);
                    un = _gameScreen.game.unitFactory.getUnit(unName);
                    if(type != null && variable != null)
                    {
                        un[variable] = type;
                    }
                    teamSpawn.spawn(un, _gameScreen.game);
                    teamSpawn.population += un.population;

                    units.push(un);
                    i++;
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

                case Unit:
                    return units[0];
                    break;

                case String:
                    return StringMap.unitTypeToName(units[0].type);
                    break;

                case int:
                    return units[0].type;
                    break;

                default:
                    return null;
                    break;
            }
        }

        public function killUnit(un:Unit, destroy:Boolean = false) : void
        {
            if(destroy)
            {
                un.px = 10000;
            }
            un.kill();
        }

        public function removeTower() : void
        {
            if(_gameScreen.game.map.hills.length != 0) 
            {
                var hill:Hill = _gameScreen.game.map.hills.pop();
                var index:int = _gameScreen.game.map.hills.indexOf(hill);
                hill.alpha = 0;
                delete _gameScreen.game.map.hills[hill];
                if (index != -1)
                {
                    _gameScreen.game.map.hills.splice(index, 1);
                }
            }
        }

        /*public function removeGoldmines(num:int = 8):void 
        {
            if (_gameScreen.game.map.gold.length >= num) 
            {
                for (var i:int = 0; i < num; i++) {
                    var gold:Gold = _gameScreen.game.map.gold.pop();
                    gold.alpha = 0;
                    var index:int = _gameScreen.game.map.gold.indexOf(gold);
                    delete _gameScreen.game.map.gold[gold];
                    if (index != -1) 
                    {
                        _gameScreen.game.map.gold.splice(index, 1);
                    }
                }
            }
        }*/

        public function researchTech(tech:int, team:Team, outcome:Boolean = true) : void
        {
          team.tech.isResearchedMap[tech] = outcome;
        }

        public function fogOfWar(activate:Boolean = false) : void
        {
            _gameScreen.game.fogOfWar.isFogOn = activate;
        }

        public function setLevelType(infType:String = "") : void
        {
            var statue:Statue = _gameScreen.team.statue;
            var enemyStatue:Statue = _gameScreen.team.enemyTeam.statue;
            infType = infType.toLowerCase();
            infType = infType.split(" ").join("");
            if(infType == "ambush")
            {
                _gameScreen.team.enemyTeam.statue.isDead = true;
                _gameScreen.team.enemyTeam.statue.px = statue.px - 1000;
                _gameScreen.team.enemyTeam.statue.x = statue.x - 1000;
                _gameScreen.team.enemyTeam.statue.alpha = 0;
            }
            else if(infType == "reverseambush")
            {
                _gameScreen.team.statue.isDead = true;
                _gameScreen.team.statue.px = 0;
                _gameScreen.team.statue.x = 0;
                _gameScreen.team.statue.alpha = 0;
            }
            else if(infType == "seige")
            {
                enemyStatue.isDead = true;
                enemyStatue.px = statue.px - 1000;
                enemyStatue.x = statue.x - 1000;
                enemyStatue.alpha = 0;

                statue.isDead = true;
                statue.px = enemyStatue.px;
                statue.x = enemyStatue.x;
                statue.alpha = 0;
            }
            else if(infType == "" || infType == "normal")
            {
                return;
            }
            else
            {
                debug.error(infType + " is not a registered level type for 'setLevelType()'.", "Util");
            }
        }

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

        public function garrison(unit:Unit) : void
        {
            unit.garrison();
        }

        public function ungarrison(unit:Unit) : void
        {
            unit.ungarrison();
        }

        public function king(un:Unit) : void
        {
            if(un.isDead || un.isDieing)
            {
               un.team.statue.kill();
            }
        }

        public function registerUnit(units:*, team:Team) : void
        {
            var i:int = 0;
            if(units is Array)
            {
                var level:* = this._gameScreen.main.campaign.getCurrentLevel();
                while (i < units.length)
                {
                    var currentUnit:* = StringMap.unitNameToType(units[i]);
                    
                    if(team.unitInfo[currentUnit] == null)
                    {
                        team.unitInfo[currentUnit] = [(StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).gold * (StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).mana * level.insaneModifier];
                        var unit:Unit = this._gameScreen.game.unitFactory.getUnit(int(currentUnit));
                        unit.team = team;
                        unit.setBuilding();
                        team.unitInfo[currentUnit].push((team.buildings["BankBuilding"]).type);
                        team.unitGroups[currentUnit] = [];
                        this._gameScreen.game.unitFactory.returnUnit(currentUnit, unit);
                    }
                    i++;
                }
            }
            else if(units is String)
            {
                var level:* = this._gameScreen.main.campaign.getCurrentLevel();
                var currentUnit:* = StringMap.unitNameToType(units);
                    
                if(team.unitInfo[currentUnit] == null)
                {
                    team.unitInfo[currentUnit] = [(StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).gold * (StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).mana * level.insaneModifier];
                    var unit:Unit = this._gameScreen.game.unitFactory.getUnit(int(currentUnit));
                    unit.team = team;
                    unit.setBuilding();
                    team.unitInfo[currentUnit].push((team.buildings["BankBuilding"]).type);
                    team.unitGroups[currentUnit] = [];
                    this._gameScreen.game.unitFactory.returnUnit(currentUnit, unit);
                }
            }
            else if(units is int)
            {
                var level:* = this._gameScreen.main.campaign.getCurrentLevel();
                var currentUnit:* = units;
                    
                if(team.unitInfo[currentUnit] == null)
                {
                    team.unitInfo[currentUnit] = [(StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).gold * (StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).mana * level.insaneModifier];
                    var unit:Unit = this._gameScreen.game.unitFactory.getUnit(int(currentUnit));
                    unit.team = team;
                    unit.setBuilding();
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

        public function reinforcements(health:int, maxHealth:int, team:Team, info:* = null, fullHeal:Boolean = true, extra:Boolean = false) : void
        {
            if(team.statue.health <= health && team.statue.maxHealth != maxHealth && !extra)
            {
                if(info is Function)
                {
                    info();
                }
                else
                {
                    debug.error("Input for 4th paramater must be a Function. 'reinforcements()'", "Util");
                }
                
                team.statue.health = fullHeal ? maxHealth : (team.statue.maxHealth / team.statue.health - 1) * maxHealth;
                team.statue.maxHealth = maxHealth;
                team.statue.healthBar.totalHealth = maxHealth;
            }
        }

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

        public function restoreHealth(type:*) : void
        {
            unitsreducedcode(type, function(un:Unit):void{
                un.health = un.maxHealth;
            });
            
        }

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

        /*public function passiveCure(type:*, timer:Number) : void
        {
            var un:* = null;
            if(type is Team)
            {
                for each(un in type.units)
                {
                    loop(timer, function():void{
                        un.cure();
                    });
                }
            }
            else if(type is Unit)
            {
                var un:Unit = type;
                loop(timer, function():void{
                    un.cure();
                });
            }
        }*/
        
        public function swapUnitButton(units:*, team:Team) : void
        {
            if(!Loader.instance.isDev)
            {
                debug.error("The 'swapUnitButton()' function is still under work!", "Util")
                return;
            }
            
            var unit1:* = StringMap.unitNameToType(units[0]);
            var unit2:* = StringMap.unitNameToType(units[1]);
            registerUnit(unit1, team);

            var currentXML:* = StringMap.unitTypeToXML(unit2, this._gameScreen.game);
            
            var unit:* = team.buttonInfoMap[unit1];
            team.buttonInfoMap[unit2] = [unit[0],unit[1],currentXML,0,new cancelButton(),currentXML.cost * team.handicap,unit[6],unit[7],unit[8]];

            delete team.buttonInfoMap[unit1];
            team.unitsAvailable[unit2] = 1;
        }

        public function changeStatue(team:Team, statue:String) : void
        {
            statue = statue.toLowerCase();
            team.statueType = statue;
        }

        public function changeMusic(name:String = "orderInGame") : void
        {
            _gameScreen.game.soundManager.playSoundInBackground(name);
        }

        public function disableFinishers(team:Team = null) : void
        {
            disableDFs(team);
        }

        public function disableDuels(team:Team = null) : void
        {
            disableDFs(team);
        }

        private function disableDFs(team:Team = null) : void
        {
            if(team == null)
            {
                _gameScreen.team.isMember = false;
                _gameScreen.team.enemyTeam.isMember = false;
            }
            else if(!(team is Team))
            {
                debug.error("Paramater must be null or a Team. disableDuels()/disableFinishers().", "Util");
            }
            else
            {
                team.isMember = false;
            }
        }

        // Private functions place :)

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
            var un:* = null;
            var result:Array = [];

            if(type is String)
            {
                var unitType:int = StringMap.unitNameToType(type);
                return team.unitGroups[unitType];
            }
            return null;
        }
    }
} 
package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.engine.Team.*;
    import com.brockw.stickwar.engine.projectile.*;
    import com.brockw.stickwar.engine.units.*;
    import flash.utils.*;

    public class ProjectilePlus
    {
        private var gameScreen:GameScreen;

        private var util:Util;

        // All arrays

        private var firewalls:Array = [];

        private var eletowers:Array = [];

        private var mines:Array = [];

        private var triggers:Array = [];

        // private var sandstorm:Array = []:

        // privare var thorn:Array = [];

        public function ProjectilePlus(gs:GameScreen, utilities:Util)
        {
            this.gameScreen = gs;
            this.util = utilities;
            super();
        }

        public function firewall(px:*, team:Team, size:int, num:int, fireFrames:int = 60, fireDamage:Number = 1, radius:int = 15) : void
        {
            var i:int = 0;
            var fires:Array = [];
            while(i < num)
            {
                gameScreen.game.projectileManager.initFireOnTheGround(px,i * team.game.map.height / num,0,team,team.direction,size);
                fires.push(getProjectile()); // add to array, but won't use it for now 
                i++;
            }
            var firewallinf:Array = [px,team,radius,team.game.frame,fireFrames,fireDamage,fires];
            firewalls.push(firewallinf);
        }

        public function teslatower(px:*, py:*, team:Team, range:int = 300, lifeFrames:int = 1200, frequency:int = 3) : void
        {
            team.game.projectileManager.initSandstormTower(px,py,0,team,team.direction,lifeFrames);
            var sandstorminf:Array = [px,py,team,range,lifeFrames,team.game.frame,frequency,null,new Dictionary()];
            eletowers.push(sandstorminf);
        }

        public function landmine(px:Number, py:Number, team:Team, size:Number = 0.25, damage:Number = 50, fireFrames:int = 60, fireDamage:Number = 1) : void
        {
            team.game.projectileManager.initMound(px,py,0,team,team.direction);
            var mound:MoundOfDirt = MoundOfDirt(getProjectile());
            var minesinf:Array = [px,py,team,mound,size];
            mound.scaleX *= size;
            mound.scaleY *= size;
            mines.push(minesinf);
        }

        public function trigger(px:Number, py:Number, team:Team, width:Number, height:Number, func:Function) : void
        {
            var info:Array = [px, py, team, width, height, func];
            triggers.push(info);
        }

        // Update Stuff, you only need to run updateProjectiles :thumbsup:

        public function updateProjectiles() : void
        {
            updateFireWalls(gameScreen);
            updateEleTowers(gameScreen);
            updateMines(gameScreen);
            // add trigger
        }

        private function updateFireWalls(gs:GameScreen)
        {
            //[px,team,radius,team.game.frame,fireFrames,fireDamage,fires]
            if(firewalls.length == 0)
            {
                return;
            }
            var i:int = 0;
            while(i < firewalls.length)
            {
                var j:int = 0;
                var firewall:Object = firewallobj(firewalls[i]);

                var fires:Array = firewall.fires;
                var radius:int = firewall.radius;
                //break;

                if(fires.length == 0)
                {
                    firewalls.splice(firewalls.indexOf(firewalls[i]),1);
                    i--;
                    break;
                }
                
                gs.game.spatialHash.mapInArea(firewall.px - radius, 0, firewall.px + radius, gs.game.map.height, function(param1:Unit):*
                {
                    if(param1.team != firewall.team && param1.pz == 0)
                    {
                        if(Math.abs(param1.px - firewall.px) < radius)
                        {
                            param1.setFire(firewall.fireFrames,firewall.fireDamage);
                        }
                    }
                });
            }
        }

        private function updateEleTowers(gs:GameScreen)
        {
            if(eletowers.length == 0)
            {
                return;
            }
            var i:int = 0;
            while(i < eletowers.length)
            {
                var targetUnit:Unit = eletowers[i][7]
                var unitsInArea:Dictionary = eletowers[i][8];
                if(eletowers[i][4] > gs.game.frame - eletowers[i][5])
                {
                    gs.game.spatialHash.mapInArea(eletowers[i][0] - eletowers[i][3],0,eletowers[i][0] + eletowers[i][3],gs.game.map.height,function(param1:Unit):void
                    {
                        var sandstormRange:int = int(eletowers[i][3]);
                        var frequency:int = 30 * eletowers[i][6];
                        if(param1.team != eletowers[i][2] && param1.pz == 0)
                        {
                            if(Math.abs(param1.px - eletowers[i][0]) < sandstormRange)
                            {
                                if(targetUnit == null || targetUnit.isDead || targetUnit.isDieing)
                                {
                                    targetUnit = param1;
                                }
                                if(unitsInArea == null)
                                {
                                    unitsInArea = new Dictionary();
                                }
                                if(unitsInArea[param1] == null)
                                {
                                    unitsInArea[param1] = param1.team.game.frame;
                                }
                                if((param1.team.game.frame - unitsInArea[param1]) % frequency == 0 && param1 == targetUnit)
                                {
                                    param1.damage(Unit.D_NO_SOUND,50,null);
                                    param1.team.game.projectileManager.initLightning(air,param1,0);
                                }
                            }
                            else if(Math.abs(param1.px - eletowers[i][0]) > sandstormRange)
                            {
                                if(unitsInArea != null && unitsInArea[param1] != null)
                                {
                                    unitsInArea[param1] = null;
                                    targetUnit = null;
                                }
                            }
                        }
                    });
                    i++;
                }
                else
                {
                    eletowers.splice(eletowers.indexOf(eletowers[i]),1);
                    i--;
                }
            }
        }

        private function updateMines(gs:GameScreen) : void
        {
            if(mines.length == 0)
            {
                return;
            }
            var i:int = 0;
            while(i < mines.length)
            {
                var mine:Object = mineobj(mines[i]);
                var team:Team = mine.team;
                if(mine.mound.isReadyForCleanup() || mine.mound == null)
                {
                    gs.game.projectileManager.initMound(mine.px,mine.py,0,mine.team,mine.direction);
                    team = mine.team;
                    var mound:MoundOfDirt = MoundOfDirt(getProjectile());
                    mound.scaleX *= mine.size;
                    mound.scaleY *= mine.size;
                    mines[i][3] = mound;
                    mine.mound = mound;
                }
                var radius:Number = mine.size * 6.5;
                gs.game.spatialHash.mapInArea(mine.px - radius,mine.py - radius,mine.px + radius,mine.py + radius,function(param1:Unit):void
                {
                    if(param1.team != mine.team && param1.pz == 0)
                    {
                        // debug.Log("Moving the ash is future dyz\'s problem lmaoo","#ff4040");
                        gs.game.projectileManager.initNuke(mine.px,mine.py,param1.team.enemyTeam.statue,50,0.5,30 * 3);
                        var nuke:Nuke = Nuke(getProjectile(5));
                        var j:int = 0;
                        while(j < 5)
                        {
                            var fire:FireOnTheGround = FireOnTheGround(getProjectile(j));
                            var px:* = nuke.px - fire.px;
                            var py:* = nuke.py - fire.py;
                            fire.px = mine.px + px;
                            fire.py = mine.py + py;
                            j++;
                        }
                        nuke.px = mine[0];
                        nuke.py = mine[1];
                        nuke.x = nuke.px;
                        nuke.y = nuke.py;
                        mines.splice(mines.indexOf(mines[i]),1);
                        removeProjectile(mine.mound);
                    }
                });
                i++;
            }
        }

        // useful functions that lessen work :)

        private function mineobj(info:Array) : Object
        {
            var obj:Object = {
                px: info[0],
                py: info[1],
                team: info[2],
                direction: info[2].direction,
                mound: info[3],
                size: info[4]
            };
            return obj;
        }

        private function firewallobj(info:Array) : Object
        {
            var obj:Object = {
                px: info[0],
                team: info[1],
                radius: info[2],
                frame: info[3],
                fireFrames: info[4],
                fireDamage: info[5],
                fires: info[6]
            };
            return obj;
        }

        private function getProjectile(num:int = 0) : *
        {
            if(gameScreen.game.projectileManager.projectiles.length == 0)
            {
                Debug.instance.error("No available projectiles to obtain. getProjectile()","ProjectilePlus");
                return null;
            }
            var length:int = int(gameScreen.game.projectileManager.projectiles.length);
            return gameScreen.game.projectileManager.projectiles[length - (1 + num)];
        }

        private function removeProjectile(projectile:Projectile) : void
        {
            projectile.px = -10;
            return;
            // projectileMap ain't public, so gotta make do with what we got lel
            gameScreen.game.projectileManager.projectileMap[projectile.type].returnItem(projectile);
            if(gameScreen.game.battlefield.contains(projectile))
            {
                gameScreen.game.battlefield.removeChild(projectile);
            }
            gameScreen.game.projectileManager.projectiles.splice(gameScreen.game.projectileManager.projectiles.indexOf(projectile),1);
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

        public function follow(un:*) : void
        {
            if(un is Unit)
            {
                _gameScreen.game.targetScreenX = un.px - _gameScreen.game.map.screenWidth / 2;
            }
            else if(un is int || un is Number)
            {
                _gameScreen.game.targetScreenX = int(un);
            }
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
package com.brockw.stickwar.campaign.controllers.EasyController
{
    import flash.display.*;
    import flash.text.*;
    import flash.ui.*;
    
    public class Draw
    {

        public static const screen_width:Number = 850;

        public static const screen_height:Number = 700;

        public static const width_center:Number = 425;

        public static const height_center:Number = 350;

        public function Draw()
        {
            super();
        }

        public static function createTextField(width:Number, height:Number, fontSize:int, color:uint) : TextField 
        {
            var textField:TextField = new TextField();
            
            textField.width = width;
            textField.height = height;
        
            var textFormat:TextFormat = new TextFormat("Arial", int(fontSize), hexToDecimal(color));
            textField.defaultTextFormat = textFormat;
            textField.multiline = true;
            textField.wordWrap = true;

            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.embedFonts = true;
            
            return textField;
        }
        
        public static function createRectangle(width:Number, height:Number, color:String, transparency:Number) : Shape 
        {
            var rectangle:Shape = new Shape();
            
            rectangle.graphics.beginFill(hexToDecimal(color), transparency);
            rectangle.graphics.drawRect(0, 0, width, height);
            rectangle.graphics.endFill();
            
            return rectangle;
        }

        public static function hexToDecimal(hexColor:String) : uint
        {
            hexColor = hexColor.replace("#", "");
            var red:uint = uint("0x" + hexColor.substr(0, 2));
            var green:uint = uint("0x" + hexColor.substr(2, 2));
            var blue:uint = uint("0x" + hexColor.substr(4, 2));
            
            var decimalColor:uint = (red << 16) | (green << 8) | blue;

            return decimalColor;
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
         if(param1 == "archidon" || param1 == "archer" || param1 == "arch")
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

      public static function setUnitType(param1:Unit, param2:String) : void
      {
         if(param1.type == Unit.U_MINER)
         {
            param1.minerType = param2;
         }
         if(param1.type == Unit.U_SWORDWRATH)
         {
            param1.swordwrathType = param2;
         }
         if(param1.type == Unit.U_ARCHER)
         {
            param1.archerType = param2;
         }
         if(param1.type == Unit.U_SPEARTON)
         {
            param1.speartonType = param2;
         }
         if(param1.type == Unit.U_NINJA)
         {
            param1.ninjaType = param2;
         }
         if(param1.type == Unit.U_FLYING_CROSSBOWMAN)
         {
            param1.flyingCrossbowmanType = param2;
         }
         if(param1.type == Unit.U_MONK)
         {
            param1.monkType = param2;
         }
         if(param1.type == Unit.U_MAGIKILL)
         {
            param1.magikillType = param2;
         }
         if(param1.type == Unit.U_ENSLAVED_GIANT)
         {
            param1.enslavedgiantType = param2;
         }
         if(param1.type == Unit.U_CHAOS_MINER)
         {
            param1.chaosminerType = param2;
         }
         if(param1.type == Unit.U_BOMBER)
         {
            param1.bomberType = param2;
         }
         if(param1.type == Unit.U_WINGIDON)
         {
            param1.wingidonType = param2;
         }
         if(param1.type == Unit.U_SKELATOR)
         {
            param1.skelatorType = param2;
         }
         if(param1.type == Unit.U_DEAD)
         {
            param1.deadType = param2;
         }
         if(param1.type == Unit.U_CAT)
         {
            param1.catType = param2;
         }
         if(param1.type == Unit.U_KNIGHT)
         {
            param1.knightType = param2;
         }
         if(param1.type == Unit.U_MEDUSA)
         {
            param1.medusaType = param2;
         }
         if(param1.type == Unit.U_GIANT)
         {
            param1.giantType = param2;
         }
         if(param1.type == Unit.U_FIRE_ELEMENT)
         {
            param1.fireElementType = param2;
         }
         if(param1.type == Unit.U_EARTH_ELEMENT)
         {
            param1.earthElementType = param2;
         }
         if(param1.type == Unit.U_WATER_ELEMENT)
         {
            param1.waterElementType = param2;
         }
         if(param1.type == Unit.U_AIR_ELEMENT)
         {
            param1.airElementType = param2;
         }
         if(param1.type == Unit.U_LAVA_ELEMENT)
         {
            param1.lavaElementType = param2;
         }
         if(param1.type == Unit.U_HURRICANE_ELEMENT)
         {
            param1.hurricaneElementType = param2;
         }
         if(param1.type == Unit.U_FIRESTORM_ELEMENT)
         {
            param1.infernosType = param2;
         }
         if(param1.type == Unit.U_SCORPION_ELEMENT)
         {
            param1.scorpType = param2;
         }
         if(param1.type == Unit.U_CHROME_ELEMENT)
         {
            param1.chromeElementType = param2;
         }
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
   }
} 
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
        public static const version:String = "1.3.0";

        public static const date:String = "30-06-2024";

        public static const developer:String = "dyzqy";

        public static const help:String = "AsePlayer, s07, RinasSam"; // in alphabetical order, not in help amount.

        public static const link:String = "https://dyzqy.github.io/";

        public var versionCheck:Boolean = false;

        public var isBeta:Boolean = true;

        public var isDev:Boolean = false;

        private var description:TextField;

        private var title:TextField;

        private var _gameScreen:GameScreen;

        public var stringMap:StringMap;

        public var draw:Draw;

        public var oldVersion:Boolean;

        public static var instance:Loader;

        public function Loader(gameScreen:GameScreen)
        {
            super();
            Loader.instance = this;
            this.stringMap = new StringMap();
            this.draw = new Draw();
            this._gameScreen = gameScreen;
            Security.allowDomain("dyzqy.github.io");
            Security.allowInsecureDomain("dyzqy.github.io");
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
            if(versionCheck && !isBeta)
            {
                verifyVersion();
            }
        }

        public function verifyVersion()
        {
            Security.allowDomain("dyzqy.github.io");
            Security.allowInsecureDomain("dyzqy.github.io");
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
            var request:URLRequest = new URLRequest(link + "other/EasyController/version.txt");
            var loader:URLLoader = new URLLoader();
            request.method = URLRequestMethod.GET;
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE, completeHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
                throw new Error("Version request error: " + event.text);
            });
            loader.load(request);
        }

        function completeHandler(event:Event):void 
        {
            var loadedText:String = loader.data;
            var prefix:String = "";
            var loadedVersion:String = loadedText;
            var currentVersion:String = version;
            loadedVersion = loadedVersion.replace(/\./g, "");
            currentVersion = currentVersion.replace(/\./g, "");
            throw new Erorr(loadedVersion + ", " + currentVersion)

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
            container.x = 300;
            container.y = 300;
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
    }
} 
