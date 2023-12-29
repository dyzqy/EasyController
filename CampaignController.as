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

      //public var win:Window;

      
      private var _gameScreen:GameScreen;
      
      public function CampaignController(gameScreen:GameScreen)
      {
         super();
         this._gameScreen = gameScreen;

         if(this.draw == null)
         {
            this.draw = new Draw();
            this.loader = new Loader(gameScreen);

            this.stringMap = loader.stringMap;
            this.data = new Data(gameScreen);
            this.debug = new Debug(gameScreen);
            this.util = new Util(gameScreen);
            this.cs = new CutScene(gameScreen);
            //this.win = new Window(gameScreen)
         }
      }
      
      public function update(param1:GameScreen) : void
      {
      }
   }
}