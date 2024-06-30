package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.campaign.controllers.EasyController.*;
   
   public class CampaignController
   {
      public var loader:Loader;

      public var data:Data;

      public var debug:Debug;

      public var util:Util;

      public var cs:CutScene;

      public var draw:Draw;

      public var pp:ProjectilePlus;
      
      private var _gameScreen:GameScreen;
      
      public function CampaignController(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;

         if(this.draw == null)
         {
            this.loader = new Loader(gameScreen);

            this.draw = loader.draw;
            this.data = new Data(gameScreen);
            this.debug = new Debug(gameScreen);
            this.util = new Util(gameScreen);
            this.cs = new CutScene(gameScreen);
            this.pp = new ProjectilePlus(gameScreen,this.util);
         }
      }
      
      public function update(param1:GameScreen) : void
      {
      }
   }
}