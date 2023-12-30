package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.campaign.controllers.EasyController.*;
   
   public class CampaignController
   {
      public var loader:Loader;

      public var stringMap:StringMap;

      public var data:Data;

      public var debug:Debug;

      public var util:Util;

      public var cs:CutScene;

      public var draw:Draw;

      //public var win:Window;

      
      private var _gameScreen:GameScreen;
      
      public function CampaignController(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;

         if(this.draw == null)
         {
            this.loader = new Loader(gameScreen);

            this.draw = loader.draw;
            this.stringMap = loader.stringMap;
            this.data = new Data(gameScreen);
            this.debug = new Debug(gameScreen);
            this.util = new Util(gameScreen);
            this.cs = new CutScene(gameScreen);
            //this.win = new Window(gameScreen)
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

      public function timer() : Number
      {
         return this._gameScreen.game.frame / 30;
      }

      public function center(pos:String = "X") : Number
      {
         pos = pos.toUpperCase();
         if(pos == "X" || pos == "PX")
         {
            return this._gameScreen.game.map.width / 2;
         }
         else if(pos == "Y" || pos == "PY")
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
            for each(rUnit in team.units)
            {
               if(rUnit.isAlive() && unitType == rUnit.type)
               {
                  unitNum += 1;
               }
            }
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

      public function isTime(num:Number) : Boolean
      {
         return Number(this._gameScreen.game.frame / 30) == num;
      }

      public function unitData(un:Unit, infType:String) : *
      {
         un = this._gameScreen.game.unitFactory.getUnit(un.type);

         infType = infType.toLowerCase();
         infType = infType.split(" ").join("");
         if(infType == "hp" || infType == "health")
         {
            return un.health;
         }
         else if(infType == "mhp" || infType == "maxhealth")
         {
            return un.maxHealth;
         }
         else if(infType == "px" || infType == "x")
         {
            return un.px;
         }
         else if(infType == "py" || infType == "y")
         {
            return un.py;
         }
         else if(infType == "flyingheight" || infType == "fh"|| infType == "flyheight")
         {
            return un.flyingHeight;
         }
         else if(infType == "currenttarget" || infType == "currtarget" || infType == "target")
         {
            return un.ai.currentTarget;
         }
         return null;
      }

      public function statuePos(team:Team, pos:String = "x") : Number
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

    public class Debug
    {

      private var _gameScreen:GameScreen;

      private var initilized:Boolean = false;

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
         var textFormat:TextFormat = new TextFormat("Verdana",fSize,16777215);
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
         this.initilized = true;
      }
      
      public function Log(msg:String,  color:String = "#FFFFFF") : void
      {
         if(initilized)
         {
            var formattedMessage:String = "<font color='" + color + "'>" + "[" + CurrentTime() + "] " + msg + "</font>";
            console.htmlText += formattedMessage + "\n";

            var isAtBottom:Boolean = console.scrollV >= console.maxScrollV - console.height / console.textHeight;
            if(isAtBottom)
            {
               console.scrollV = console.maxScrollV;
            }
         }
      }

      public function Clear(msg:Boolean = false, num:int = 0) : void
      {
         if(initilized)
         {
            var addedMessage:String = msg ? "<font color='" + "#FFFFFF" + "'>" + "[" + CurrentTime() + "] " + "Cleared Console." + "</font>" : "";
            console.htmlText = addedMessage;
         }
      }

      public function LogError(msg:String, cl:String = "") : void
      {
         if(initilized)
         {
            var formattedMessage:String = "<font color='#FF0000'>" + "[" + CurrentTime() + ", " + cl + "] " + msg + "</font>";
            console.htmlText += formattedMessage + "\n";

            var isAtBottom:Boolean = console.scrollV >= console.maxScrollV - console.height / console.textHeight;
            if(isAtBottom)
            {
               console.scrollV = console.maxScrollV;
            }
         }
      }

      public function error(msg:String, cl:String = "") : void
      {
         if(initilized)
         {
            var formattedMessage:String = "<font color='#FF0000'>" + "[" + CurrentTime() + ", " + cl + "] " + msg + "</font>";
            console.htmlText += formattedMessage + "\n";

            var isAtBottom:Boolean = console.scrollV >= console.maxScrollV - console.height / console.textHeight;
            if(isAtBottom)
            {
               console.scrollV = console.maxScrollV;
            }
         }
         else
         {
            throw new Error("Class: " + cl + ", " + msg);
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

    public class Util
    {
        private var registeredUnits;

        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
        }

        public function summonUnit(u1:*, copies:int, teamSpawn:Team, returnType:Class = null, type:* = null) : *
        {
            var i:int = 0;
            var unName:int = 0;
            var un:Unit = null;
            var units:Array = [];

            if (u1 is Array)
            {
                var j:int = 0;
                while(j < u1.length)
                {
                    if(!(u1[j] is String))
                    {
                        Debug(_gameScreen).error("Unit Name must be a String. SummonUnit().", "Util");
                    }
                    while(i < copies)
                    {
                        unName = StringMap.unitNameToType(u1[j]);
                        un = _gameScreen.game.unitFactory.getUnit(unName);
                        /*if(type != null)
                        {
                            if (type is Array)
                            {
                                StringMap.setUnitType(un, type[j]);
                            }
                            else if (type is String)
                            {
                                StringMap.setUnitType(un, type);
                            }
                            else
                            {
                                Debug(_gameScreen).error("Invalid parameter for 'unitType'. The parameter must be either a String or an Array of Strings.", "Util");
                            }
                            
                        }*/
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
                    unName = StringMap.unitNameToType(u1);
                    un = _gameScreen.game.unitFactory.getUnit(unName);
                    teamSpawn.spawn(un, _gameScreen.game);
                    teamSpawn.population += un.population;

                    units.push(un);
                    i++;
                }
            }
            else
            {
                Debug(_gameScreen).error("Invalid parameter for 'SummonUnit'. The first parameter must be either a String or an Array of Strings.", "Util");
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
                //_gameScreen.team.enemyTeam.statue.isDieing = true;
                _gameScreen.team.enemyTeam.statue.isDead = true;
                _gameScreen.team.enemyTeam.statue.px = statue.px - 1000;
                _gameScreen.team.enemyTeam.statue.x = statue.x - 1000;
                //_gameScreen.team.enemyTeam.statue.py = 250;
                //_gameScreen.team.enemyTeam.statue.y = 250;
                _gameScreen.team.enemyTeam.statue.alpha = 0;
            }
            else if(infType == "seige")
            {
                //_gameScreen.team.enemyTeam.statue.isDieing = true;
                //_gameScreen.team.enemyTeam.statue.py = 250;
                //_gameScreen.team.enemyTeam.statue.y = 250;

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
                throw new Error(infType + " is not a registered level type.");
            }
            return;
        }

        public function winCondition(type:String, time:int) : void
        {
            var statue:Statue = _gameScreen.team.statue;
            type = type.toLowerCase();
            type = type.split(" ").join("");
            if(type == "time")
            {
                if(int(_gameScreen.game.frame / 30) == time)
                {
                  _gameScreen.team.enemyTeam.statue.px = statue.px;
                  _gameScreen.team.enemyTeam.statue.x = statue.x;
                  _gameScreen.enemyTeam.statue.kill();
                }
            }
        }

        public function challenge(type:String) : void
        {
            var clAmount:int = 0;
            type = type.toLowerCase();
            type = type.split(" ").join("");
            if(type == "gold" || type == "gathergold")
            {
                var gold:int = _gameScreen.team.gold;
                if(gold < _gameScreen.team.gold)
                {
                    clAmount += _gameScreen.team.gold - gold;
                }
            }
            return;
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
            var move:UnitMove = new UnitMove(); 
            move.owner = unit.team.id; 
            move.moveType = UnitCommand.GARRISON; 
            move.arg0 = unit.px; 
            move.arg1 = unit.py; 
            move.units.push(unit.id); 
            move.execute(_gameScreen.game);
        }

        public function loop(sec:int, func:Function) : void
        {
            if (_gameScreen.game.frame % (30 * sec) == 0)
            {
                func();
            }
        }

        public function king(un:Unit) : void
        {
            if(un.isDead)
            {
               un.team.statue.kill();
            }
        }

        public function revive(un:Unit, sec:int) : Unit
        {
            var unit:Unit = null;
            
            if(un.isDead)
            {
                var type:int = unit != null ? un.type : type;
                var team:Team = unit != null ? un.team : team;
                if(param1.game.frame % (30 * sec) == 0)
                {
                    unit = SummonUnit(StringMap.unitTypeToName(un.type), 1, un.team, Unit);
                    return unit;
                }
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
                throw new Error("The first paramater of util.registerUnit() must be a String or an Array of Strings.");
            }
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

        public function createTextField(width:Number, height:Number, fontSize:int, color:uint) : TextField 
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
        
        public function createRectangle(width:Number, height:Number, color:String, transparency:Number) : Shape 
        {
            var rectangle:Shape = new Shape();
            
            rectangle.graphics.beginFill(hexToDecimal(color), transparency);
            rectangle.graphics.drawRect(0, 0, width, height);
            rectangle.graphics.endFill();
            
            return rectangle;
        }

        public function hexToDecimal(hexColor:String) : uint
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
        public static const version:String = "EC_1.2.0";

        public static const date:String = "30-12-2023";

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
