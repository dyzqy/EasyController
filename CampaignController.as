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