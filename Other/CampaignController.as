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
   
   public class CampaignController
   {
      public static const T_NOT_RESEARCHED:int = 0;

      public static const T_IS_RESEARCHING:int = 1;

      public static const T_RESEARCHED:int = 2;

      public static const version:String = "Easy Modding 1.0.4";

      public var comment:String;
      
      private var _gameScreen:GameScreen;
      
      private var _chat:Chat;
      
      public function CampaignController(param1:GameScreen)
      {
         super();
         this._gameScreen = param1;
         //this._userInterface = param1.userInterface;
         //this._chat = param1.userInterface.chat;
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

      public function getUnitData(un:Unit) : Array
      {
         un = this._gameScreen.game.unitFactory.getUnit(un.type);
         var result:Array = [un.px,un.py,un.flyingHeight,un.ai.currentTarget];
         return result;
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
         return 0;
      }


      public function getResearchedMap() : Array
      {
         public var researchedTechs[61]; 

         var availableTechs = tech.isResearchedMap(); 

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
   }
}

/*  {}
var unitData:Array = getUnitData(this.eGiant);
         SmallText("HomeX: " + getHomeX(param1.team),"Unit px: " + unitData[0],"Unit py: " + unitData[1],"Unit FH " + unitData[2]);*/