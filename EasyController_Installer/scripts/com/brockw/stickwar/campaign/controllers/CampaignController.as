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
      public var center:Object;

      // public var randomNumbers:Vector.<int>;

      private var _gameScreen:GameScreen;


      public function Data(gameScreen:GameScreen)
      {
         this._gameScreen = gameScreen;

         // Added new center variable(to replace function)
         // center = {
         //    x: this._gameScreen.game.map.width / 2, 
         //    y: this._gameScreen.game.map.height / 2
         // }

         // randomNumbers = new Vector.<int>();
      }

      // Returns amount of all units or of a specfic type(s) of unit(s).
      public function unitAmount(team:Team, unitData:* = null) : int
      {
         if(unitData == null)
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
                  length += unitAmount(team, units[i]);
               }
               return length;
            }
            else if(units is int)
            {
               return team.unitGroup[units].length;
            }
         }
      }

      // TODO: Add description of what it does and of its paramaters
      /*
       * 10/08/2025 dyzqy: Added a much more accurate way to check time, even if fast forward is on. 
       * Re-edited file to check if game is fast-forwarded before doing the extra calcs
       * 02/10/2025 dyzqy: Made it use compiler paramater & variable name as these functions are called every frame.
       */
      public function isTime(param1:Number) : Boolean
      {
         var _loc2_:int = int(param1 * 30); // Target Frame
         var _loc3_:int = this._gameScreen.game.frame; // Current Frame

         if(this._gameScreen.isFastForward)
         {
            _loc3_ = _loc3_ - _loc3_ % 2 + _loc2_ % 2;
         }

         return _loc3_ == _loc2_;
      }

      /*
       * 02/10/2025 dyzqy: Tells you if it has looped.
       * param1 is the second at which it should have looped.
       * param2 is when the loop has been first initiated, must have for accurate looping.
       */
      public function hasLooped(param1:Number, param2:Number = 0) : Boolean
      {
         var _loc3_:int = int(param1 * 30); // Target Frame
         var _loc4_:int = this._gameScreen.game.frame + int(param2 * 30); // Current Frame

         if(this._gameScreen.isFastForward)
         {
            _loc4_ = _loc4_ - _loc4_ % 2 + _loc3_ % 2;
         }

         return _loc4_ % _loc3_ == 0;
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

      /* 11/08/2025 dyzqy: Random now uses the game's built in random number generator instead of the unreliable AS Math one.
         02/10/2025 dyzqy: Added randomNumber vector to keep track of all of the randomly generated numbers.
      */
      public function random(min:Number, max:Number) : int
      {
         var num:int = int(min + this._gameScreen.game.random.nextInt() % (max + 1));
         // randomNumbers.push(num);
         return num;
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
      private var _gameScreen:GameScreen;

      private var initilized:Boolean = false;

      public static var instance:Debug;

      public var inputField:TextField;

      public var consoletext:TextField;

      public var comment:String;


      public function Debug(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;
         Debug.instance = this;
         
         // this.statsField = new TextField();
         this.consoletext = new TextField();
      }

      public function setup(fSize:int = 12, coms:Boolean = true) : void
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
         // globaldebug = _globaldebug;
      }
      
      public function log(msg:String,  color:String = "#FFFFFF") : void
      {
         if(initilized)
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
         if(initilized)
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
         if(initilized)
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

    // import flash.net.FileReference;

    public class Util
    {
        public var preferedTeam:Team;

        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
            this.debug = Debug.instance;

            // this.preferedTeam = gameScreen.game.teamA;
        }

    //  # Unit Related Functions. 

        // Summons unit(s) of a specified team.
        // "unitData" A specified type of unit or an array of unit types.
        // "copies" How many each specified unit should be spawned.
        // "team" Which team the unit spawns in.
        // "f" A function to run on all units spawned.
        // "returnType" The type that the function should return
        public function summonUnit(unitData:*, copies:int = 1, team:Team = null, f:Function = null, returnType:Class = null) : *
        {
            if(preferedTeam == null) preferedTeam = _gameScreen.team;
            if(team == null) team = preferedTeam;

            var units:Array = [];
            var u1:* = StringMap.getUnit(unitData);

            if (u1 is Array)
            {
                for(var i:int = 0; i < u1.length; i++)
                {
                    summonUnit(u1[i], copies, team, f, returnType);
                }
            }
            else if(u1 is int)
            {
                for(var i:int = 0; i < copies; i++)
                {
                    var un:Unit = _gameScreen.game.unitFactory.getUnit(u1);
                    team.spawn(un, _gameScreen.game);
                    team.population += un.population;

                    if(f != null)
                    {
                        f(un);
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

        // private function spawnUnitObj(obj:Object) : *
        // {
        //     if(!Loader.instance.isDev)
        //     {
        //         debug.error("'spawnUnitObj()' function is still under work!", "Util")
        //         return;
        //     }

        //     var testObject:Object = {
        //         team: {
        //             swordwrath: {
        //                 copies: 5,
        //                 f: function() {}
        //             }
        //         },
        //         enemyTeam:{}
        //     }

        //     return null;
        // }

        // TODO: Test if this works.
        // Allows a unit(s) of other empires to be summoned.
        // "units" A specified type of unit or an array of unit types.
        // "team" the team to register the unit to.
        public function registerUnit(units:*, team:Team) : void
        {
            if(preferedTeam == null) preferedTeam = _gameScreen.team;            
            if(team == null) team = preferedTeam;

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

        // TODO: test & make description for function and its paramaters
        public function toggleUnitButton(unitData:*, team:Team) : void
        {
            if(team == null)
            {
                team = this.preferedTeam;
            }

            var units:* = StringMap.getUnit(unitData);

            if(units is Array)
            {
                for(var i:int = 0; i < units.length; i++)
                {
                    toggleUnitButton(units[i]);
                }
            }
            else if(units is int)
            {
                var unit:int = units;
                if(team.unitsAvailable[unit] == null)
                {
                    team.unitsAvailable[unit] = 1; 
                }
                else
                {
                    delete team.unitsAvailable[unit];
                }
            }
        }

        // TODO: test if it works.
        public function deleteUnit(un:Unit) : void
        {
            un.kill();
            un.timeOfDeath = 30 * 20 + 1;
        }

        // TODO: Verify if this can run in multiplayer side 
        public function hold(unit:Unit, x:Number = 0, y:Number = 0) : void
        {
            // var move:UnitMove = new UnitMove();
            // move.owner = unit.team.id; 
            // move.moveType = UnitCommand.HOLD; 
            // move.arg0 = x; 
            // move.arg1 = y; 
            // move.units.push(unit.id); 
            // move.execute(_gameScreen.game);

            // 07/10/2025 dyzqy: Reworked how hold command words.
            unit.ai.setCommand(_gameScreen.game,new HoldCommand(_gameScreen.game));

            // var move:UnitMove = new UnitMove();
            // move.fromString([unit.team.id, this._gameScreen.game.frame, ]);
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

        // TODO: Decide if to keep these 2 functions below? They do not abide by the DIY "rule" I set. 
        public function changeStatue(team:Team, statue:String) : void
        {
            if(preferedTeam == null) preferedTeam = _gameScreen.team;            
            if(team == null) team = preferedTeam;
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

        // TODO: make it so if you are not on Dev, do not allow to save file.
        // public function saveFile(value:String, name:String = "data.txt") : void
        // {
        //     if(!Loader.instance.isDev)
        //     {

        //     }
        //     var file:FileReference = new FileReference();
        //     file.save(value, name);
        // }

        // TODO: Rework this. It does its job too goofily.
        // + I don't even remember what it does lol
        private function unitsreducedcode(type:*, f:Function, extrateam:Team = null) : void
        {
            var un:* = null;
            var realamount:Number = amount / 30;
            if(type is Team)
            {
                for each(un in type.units)
                {
                    f(un);
                }
            }
            else if(type is Array)
            {
                if(type[0] is Unit)
                {
                    for each(un in type.units)
                    {
                        f(un);
                    }
                }
                else if(type[0] is String)
                {
                    var unitGroup:Array = getUnitGroup(type, extrateam);
                    for each(un in unitGroup)
                    {
                        f(un);
                    }
                }
                else
                {
                    debug.error("No registered array type for {" + type + "} is available yet.", "Util");
                }
            }
            else if(type is Unit)
            {
                f(type);
            }
            else if(type is String)
            {
                var unitGroup:Array = getUnitGroup(type, extrateam);
                for each(un in unitGroup)
                {
                    f(un);
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

        // 06/10/2025 dyzqy: Added global state.
        public var state:int = 0;
        // 06/10/2025 dyzqy: Added new messages object for the new update function.
        public var messages:Object = {};

        public function CutScene(gs:GameScreen)
        {
            _gameScreen = gs;
        }

        public function update() : void
        {
            for(var _loc1_:String in messages)
            {
                var _loc2_:InGameMessage = messages[_loc1_].mc;
                var _loc3_:Object = messages[_loc1_];
                if(_gameScreen.contains(_loc2_) && _loc2_.visible)
                {
                    // Check if there is no time set, and set the first frame the message is visible on screen.
                    if(_loc3_.time == -1) messages[_loc1_].time = _gameScreen.game.frame;
                    _loc2_.update();

                    // Check if it has lived longer than its lifespan.
                    if(_loc3_.time + _loc3_.lifetime < _gameScreen.game.frame) 
                    {
                        if(!_loc3_.remove) _loc2_.visible = false;
                        else
                        {
                            _gameScreen.removeChild(_loc2_);
                            delete messages[_loc1_];
                        }
                    }
                }
            }
        }

        // 07/10/2025 dyzqy: Added register function that adds your message inside the Object for usage.
        public function registerMessage(name:String, message:InGameMessage, lifespan:Number = -1, toRemove:Boolean = true) : void
        {
            if(messages[name]) Debug.instance.error("registerMessage(): Message with name '" + name + "' already exists.", "CutScene");
            if(message == null) Debug.instance.error("registerMessage(): No viable InGameMessage given.", "CutScene");
            
            messages[name] = {
                time: -1, 
                lifetime: lifespan != null ? int(lifespan * 30) : Number.MAX_VALUE,
                remove: toRemove, 
                mc: message
            };
        }
        
        /* 13/08/2025 dyzqy: Added error message when you input an invalid parameter type. */
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
            else
            {
                Debug.instance.error("Invalid parameter for 'follow()'. The parameter must be either a Unit or a Number.", "CutScene");
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
        public function enableUI() : void
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
                /* 13/08/2023 dyzqy: Fixed oversight, incrementing "i" twice. */
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
      private static var unitNames:Array = [
      "miner",
      "swordwrath", 
      "archidon", 
      "spearton", 
      "ninja", "shadowrath", 
      "flyingcrossbowman", "albowtross", 
      "monk", "meric", 
      "magikill", 
      "enslavedgiant",
      "chaosminer", "enslavedminer",
      "bomber",
      "wingidon", "eclipsor",
      "skeletalmage", "marrowkai",
      "dead",
      "cat", "crawler",
      "juggerknight",
      "medusa",
      "giant",
      "earthelement",
      "waterelement",
      "fireelement",
      "airelement",
      "lavaelement", "charrog",
      "hurricaneelement", "cycloid",
      "firestormelement", "infernos",
      "treeelement", "treature",
      "scorpion",
      "chromeelement", "v",
      "minerelement", "chomper"
      ];

      public function StringMap()
      {
         super();
      }
      
      public static function unitNameToType(param1:String) : int
      {
         param1 = param1.toLowerCase();
         param1 = param1.split(" ").join("");
         // Get the best match from fuzzy search
         
         var searchResults:Array = fuzzySearch(param1, unitNames);
         if (searchResults.length > 0) 
         {
            param1 = searchResults[0]; // Use the best match
         }

         if(param1 == "miner")
         {
            return Unit.U_MINER;
         }
         if(param1 == "swordwrath")
         {
            return Unit.U_SWORDWRATH;
         }
         if(param1 == "archidon")
         {
            return Unit.U_ARCHER;
         }
         if(param1 == "spearton")
         {
            return Unit.U_SPEARTON;
         }
         if(param1 == "ninja" || param1 == "shadowrath")
         {
            return Unit.U_NINJA;
         }
         if(param1 == "flyingcrossbowman" || param1 == "albowtross")
         {
            return Unit.U_FLYING_CROSSBOWMAN;
         }
         if(param1 == "monk" || param1 == "meric")
         {
            return Unit.U_MONK;
         }
         if(param1 == "magikill")
         {
            return Unit.U_MAGIKILL;
         }
         if(param1 == "enslavedgiant")
         {
            return Unit.U_ENSLAVED_GIANT;
         }
         if(param1 == "chaosminer" || param1 == "enslavedminer")
         {
            return Unit.U_CHAOS_MINER;
         }
         if(param1 == "bomber")
         {
            return Unit.U_BOMBER;
         }
         if(param1 == "wingadon" || param1 == "eclipsor")
         {
            return Unit.U_WINGIDON;
         }
         if(param1 == "skelatalmage" || param1 == "marrowkai")
         {
            return Unit.U_SKELATOR;
         }
         if(param1 == "dead")
         {
            return Unit.U_DEAD;
         }
         if(param1 == "cat" || param1 == "crawler")
         {
            return Unit.U_CAT;
         }
         if(param1 == "juggerknight")
         {
            return Unit.U_KNIGHT;
         }
         if(param1 == "medusa")
         {
            return Unit.U_MEDUSA;
         }
         if(param1 == "giant")
         {
            return Unit.U_GIANT;
         }
         if(!Loader.instance.isSW2)
         {
            if(param1 == "fireelement")
            {
               return Unit.U_FIRE_ELEMENT;
            }
            if(param1 == "earthelement")
            {
               return Unit.U_EARTH_ELEMENT;
            }
            if(param1 == "waterelement")
            {
               return Unit.U_WATER_ELEMENT;
            }
            if(param1 == "airelement")
            {
               return Unit.U_AIR_ELEMENT;
            }
            if(param1 == "lavaelement"|| param1 == "charrog")
            {
               return Unit.U_LAVA_ELEMENT;
            }
            if(param1 == "hurricaneelement" || param1 == "cycloid")
            {
               return Unit.U_HURRICANE_ELEMENT;
            }
            if(param1 == "firestormelement" || param1 == "infernos")
            {
               return Unit.U_FIRESTORM_ELEMENT;
            }
            if(param1 == "treeelement" || param1 == "treasure")
            {
               return Unit.U_TREE_ELEMENT;
            }
            if(param1 == "scorpion")
            {
               return Unit.U_SCORPION_ELEMENT;
            }
            if(param1 == "chromeelement"|| param1 == "v")
            {
               return Unit.U_CHROME_ELEMENT;
            }
            if(param1 == "minerelement" || param1 == "chomper")
            {
               return Unit.U_MINER_ELEMENT;
            }
         }
         // Debug.instance.error("No match for " + param1, "StringMap");
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
         if(!Loader.instance.isSW2)
         {
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
               return "Treature";
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
         }
         return "{Invalid Value}";
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
         if(!Loader.instance.isSW2)
         {
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

      // Fuzzy Search implemantaion
      private static function fuzzySearch(query:String, items:Array):Array 
      {
         if (!query || query.length == 0) {
            return items.slice(); // Return copy of original array
         }
         
         if (items.length == 0) {
            return []; // Can't return anything from empty array
         }
         
         var results:Array = [];
         var queryLower:String = query.toLowerCase();
         var queryLen:int = queryLower.length;
         
         for each (var item:String in items) 
         {
            var score:int = getLevenshteinScore(queryLower, item.toLowerCase(), queryLen);
            results.push({text: item, score: score});
         }
         
         // Sort by score (higher is better)
         results.sortOn("score", Array.NUMERIC | Array.DESCENDING);
         
         // Ensure we always return at least one result (the best match)
         if (results.length == 0) {
            return [items[0]]; // Return first item as fallback
         }
         
         var finalResults:Array = [];
         for each (var result:Object in results) 
         {
            finalResults.push(result.text);
         }
         
         return finalResults;
      }

      private static function getLevenshteinScore(query:String, target:String, queryLen:int):int 
      {
         var targetLen:int = target.length;
         
         // Exact match gets highest score
         if (query == target) {
            return 1000;
         }
         
         // Check for exact substring match
         var substringIndex:int = target.indexOf(query);
         if (substringIndex >= 0) {
            // Prefer matches at the beginning
            return 500 - substringIndex;
         }
         
         // Use simplified Levenshtein distance for fuzzy matching
         var matrix:Array = [];
         var i:int
         var j:int;
         
         // Initialize matrix
         for (i = 0; i <= queryLen; i++) {
            matrix[i] = [];
            matrix[i][0] = i;
         }
         for (j = 0; j <= targetLen; j++) {
            matrix[0][j] = j;
         }
         
         // Fill matrix
         for (i = 1; i <= queryLen; i++) {
            for (j = 1; j <= targetLen; j++) {
                  var cost:int = (query.charAt(i - 1) == target.charAt(j - 1)) ? 0 : 1;
                  matrix[i][j] = Math.min(
                     matrix[i - 1][j] + 1,      // deletion
                     matrix[i][j - 1] + 1,      // insertion
                     matrix[i - 1][j - 1] + cost // substitution
                  );
            }
         }
         
         var distance:int = matrix[queryLen][targetLen];
         
         // Convert distance to score (lower distance = higher score)
         // Always return a score, even for poor matches
         return Math.max(1, 100 - (distance * 5)); // Minimum score of 1
      }
   }
}
package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.campaign.controllers.EasyController.*;
    import com.brockw.stickwar.GameScreen;

    public class Loader
    {
        public static const version:String = "1.3.1";

        public static const date:String = "15-11-2025";

        public static const developer:String = "dyzqy";

        public static const help:String = "AsePlayer, Clementchuah, s07, RinasSam"; // in alphabetical order, not in help amount.

        public static var instance:Loader;


        public var isBeta:Boolean = true;

        public var isDev:Boolean = true;

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
