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

      public var randomNumbers:Vector.<int> = new Vector.<int>();

      private var _gameScreen:GameScreen;


      public function Data(gameScreen:GameScreen)
      {
         this._gameScreen = gameScreen;

         // Added new center variable(to replace function)
         center = {
            x: this._gameScreen.game.map.width / 2, 
            y: this._gameScreen.game.map.height / 2
         }
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
      /**
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

      /**
       * 02/10/2025 dyzqy: Tells you if it has looped.
       * param1 is the second at which it should have looped.
       * param2 is when the loop has been first initiated, must have for accurate looping.
       */
      public function hasLooped(param1:Number, param2:Number = 0) : Boolean
      {
         var _loc2_:int = int(param1 * 30); // Target Frame
         var _loc3_:int = this._gameScreen.game.frame + int(param2 * 30); // Current Frame

         if(this._gameScreen.isFastForward)
         {
            _loc3_ = _loc3_ - _loc3_ % 2 + _loc2_ % 2;
         }

         return _loc3_ % _loc2_ == 0;
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
         randomNumbers.push(num);
         return num;
      }
   }
}