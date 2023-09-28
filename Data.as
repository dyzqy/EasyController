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

      public function isTime(num:int) : Boolean
      {
         return int(this._gameScreen.game.frame / 30) == int(num);
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