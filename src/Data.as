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
                  length += unitAmount(team, units[i])
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
      /* 10/08/2025 dyzqy: Added a much more accurate way to check time, even if fast forward is on. */
      public function isTime(num:Number, doafter:Boolean = false) : Boolean
      {
         var targetFrame:int = int(num * 30);
         var currentFrame:int = this._gameScreen.game.frame;

         currentFrame = currentFrame - currentFrame % 2 + targetFrame % 2;

         return currentFrame == targetFrame;
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