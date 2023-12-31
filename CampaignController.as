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
            this.util = new Util(gameScreen, this.debug);
            this.cs = new CutScene(gameScreen);
         }
      }
      
      public function update(param1:GameScreen) : void
      {
      }
   }
}