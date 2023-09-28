package com.brockw.stickwar.campaign.controllers
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
   
   public class CampaignController
   {
      public var loader:Loader;

      public var stringMap:StringMap;

      public var data:Data;

      public var debug:Debug;


      
      private var _gameScreen:GameScreen;
      
      private var _chat:Chat;
      
      public function CampaignController(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;
         this.loader = new Loader(gameScreen);

         this.stringMap = new StringMap();
         this.data = new Data(gameScreen);
         this.debug = new Debug(gameScreen);

         //this._userInterface = CampaignGameScreen(param1).userInterface;
         //this._chat = param1.game.userInterface.chat;
      }
      
      public function update(param1:GameScreen) : void
      {
      }

      // Units
      
      public function SummonUnit(u1:String, copies:int, teamSpawn:Team, param1:GameScreen) : void
      {
         var i:int = 0;
         var unN:int = 0;
         var un:Unit = null;
         while(i < copies)
         {
            unN = StringMap.unitNameToType(u1);
            un = param1.game.unitFactory.getUnit(unN);
            teamSpawn.spawn(un,param1.game);
            teamSpawn.population += un.population;
            i++;
         }
      }
      
      public function SummonVarUnit(u1:String, unitVar:Unit, teamSpawn:Team, param1:GameScreen) : void
      {
         unitVar = param1.game.unitFactory.getUnit(StringMap.unitNameToType(u1));
         teamSpawn.spawn(unitVar,param1.game);
         teamSpawn.population += unitVar.population;
      }

      // Unit Commands
      
      public function MoveUnit(unit:Unit, px:Number, py:Number) : void
      {
      }
      
      public function HoldUnit(unit:Unit) : void
      {
         unit = this._gameScreen.game.unitFactory.getUnit(unit.type);
         unit.ai.setCommand(this._gameScreen.game,new HoldCommand(this._gameScreen.game));
         unit.ai.mayAttack = false;
      }
      
      // ???

      public function MakeArrow() : void
      {
      }
      
      

      // All Data

      

   }
}

/*  {}
var unitData:Array = getUnitData(this.eGiant);
         SmallText("HomeX: " + getHomeX(param1.team),"Unit px: " + unitData[0],"Unit py: " + unitData[1],"Unit FH " + unitData[2]);*/
package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.controllers.EasyController.*;

    public class Loader
    {
        public static const version:String = "EasyController 1.0.6";

        public static const date:String = "27-7-2023";

        public static const developer:String = "dyzqy";


        private var _gameScreen:GameScreen;

        public var stringMap:StringMap;

        //public var data:Data;

        //public var debug:Debug;

        public function Loader(gameScreen:GameScreen)
        {
            super();
            this.stringMap = new StringMap();
            this._gameScreen = gameScreen;
            //this.data = new Data(gameScreen);
            //this.debug = new Debug(gameScreen);
        }
    }
}package com.brockw.stickwar.campaign.controllers.EasyController
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

        public function getLvlTime() : Number
      {
         return this._gameScreen.game.frame / 30;
      }
      
      public function getLvlCenter(pos:String = "X") : Number
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

      public function getUnitAmount(team:Team, unitName:String = "") : int
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

      public function stateTime(state:int, currState:int, timeSec:int) : Boolean
      {
         return state == currState && timeSec == int(getLvlTime());
      }

      public function getUnitData(un:Unit, infType:String) : *
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

      public function getStatuePos(team:Team, pos:String = "x") : Number
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

      public function getHomeX(team:Team) : Number
      {
         return team.homeX;
      }

      public function getCampaignInfo(infType:String) : *
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

      public function getResearchedMap() : Array
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

      public function getCameraPos() : Number
      {
         return this._gameScreen.game.screenX;
      }

      public function getTechState(techNum:int, team:Team) : int
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

      public function getTeamState(team:Team) : int
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

      public function getTeamInfo(infType:String, team:Team) : *
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
}package com.brockw.stickwar.campaign.controllers.EasyController
{
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
   }
}package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.CampaignGameScreen;
    import flash.filters.*;
    import flash.text.*;

    public class Debug
    {

      private var _gameScreen:GameScreen;

      public var debugTextA:TextField;

      public var comment:String;

      public function Debug(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;
         this.debugTextA = new TextField();
      }

      public function Statistics(txt:String, txt2:String = "", txt3:String = "", txt4:String = "", txt5:String = "", txt6:String = "") : void
      {
         debugTextA.htmlText = txt + "\n" + txt2 + "\n" + txt3 + "\n" + txt4 + "\n" + txt5 + "\n" + txt6;
      }

      public function SimulateStats() : void
      {
         doDebugText(_gameScreen);
      }
      
      public function Log(msg:String) : void
      {
         trace(msg);
         throw new Error(msg);
      }

      public function LogError(msg:String) : void
      {
         throw new Error(msg);
      }


      public function doDebugText(gameScreen:GameScreen) : *
      {
         var textFormat:TextFormat = new TextFormat("Arial",12,16777215);
         debugTextA.defaultTextFormat = textFormat;
         debugTextA.multiline = true;
         debugTextA.wordWrap = true;
         debugTextA.height = 225;
         debugTextA.width = 250;
         gameScreen.userInterface.hud.addChild(debugTextA);
         debugTextA.x = 10;
         debugTextA.y = 10;
         var dropShadowFilter:DropShadowFilter = new DropShadowFilter(4,45,0,1,0,0,1,3);
         var glowFilter:GlowFilter = new GlowFilter(4079166,1,0,0,10,1,false,false);
         glowFilter.blurX = 5;
         glowFilter.blurY = 5;
         debugTextA.filters = [glowFilter];
      }
    }
}
