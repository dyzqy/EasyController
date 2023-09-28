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
   import com.brockw.stickwar.market.ItemMap;
   import flash.utils.*;
   
   public class CampaignController
   {
      public static const T_NOT_RESEARCHED:int = 0;

      public static const T_RESEARCHING:int = 1;

      public static const T_RESEARCHED:int = 2;

      public static const version:String = "Easy Modding 1.0.5";

      public var comment:String;
      
      private var _gameScreen:GameScreen;
      
      private var _chat:Chat;
      
      public function CampaignController(param1:GameScreen)
      {
         super();
         this._gameScreen = param1;
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
            unN = ItemMap.unitNameToType(u1);
            un = param1.game.unitFactory.getUnit(unN);
            teamSpawn.spawn(un,param1.game);
            teamSpawn.population += un.population;
            i++;
         }
      }
      
      public function SummonVarUnit(u1:String, unitVar:Unit, teamSpawn:Team, param1:GameScreen) : void
      {
         unitVar = param1.game.unitFactory.getUnit(ItemMap.unitNameToType(u1));
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
      
      public function Test(func:Function, param1:GameScreen = null) : void
      {
      }

      // Messages
      
      public function DebugMsg(msg:String, msg2:String = "", color1:String = "#ffffff", color2:String = "#ff0000") : void
      {
         this.chat.messageReceived(msg,msg2);
      }

      public function SmallText(txt:String, txt2:String = "", txt3:String = "", txt4:String = "", txt5:String = "", txt6:String = "") : void
      {
         CampaignGameScreen(this._gameScreen).debugTextA.htmlText = txt + "\n" + txt2 + "\n" + txt3 + "\n" + txt4 + "\n" + txt5 + "\n" + txt6;
      }
      
      public function DebugFlashErr(msg:String) : void
      {
         throw new Error(msg);
      }

      // All Data

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
            rUnit = this._gameScreen.game.unitFactory.getUnit(ItemMap.unitNameToType(unitName));
            unitType = ItemMap.unitNameToType(unitName);
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
            return null;
         }
         return null;
      }

   }
}

/*  {}
var unitData:Array = getUnitData(this.eGiant);
         SmallText("HomeX: " + getHomeX(param1.team),"Unit px: " + unitData[0],"Unit py: " + unitData[1],"Unit FH " + unitData[2]);*/