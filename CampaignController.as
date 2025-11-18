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

		/* Scythe */
		/* General Variables: */
		protected var P_customUnits:Array.<Unit>;
		protected var AI_customUnits:Array.<Unit>;

		/* Music Variables: */
		protected var musicPoints:Array.<int>;
		protected var musicIndex:int; //Set this to musicPoints.length - 1 upon start.

		/* Codepointers: */
		protected var uniqueStarts:Array.<Function>;
		protected var uniqueUpdate:Array.<Function>;

		/* TODO: Figure out how to handle those two later. */
		protected var uniqueWinEffect:Function = function(param1:GameScreen):void {};
		protected var uniqueLossEffect:Function = function(param1:GameScreen):void {};
		
		public function CampaignController(gameScreen:GameScreen)
		{
			super();
			this._gameScreen = gameScreen;

			this.loader = new Loader(gameScreen);

			this.data = new Data(gameScreen);
			this.debug = new Debug(gameScreen);
			this.util = new Util(gameScreen);
			this.cs = new CutScene(gameScreen);

			this.uniqueStarts = [I_Default];
			this.uniqueUpdates = [U_Default];
		}
		
		public function update(param1:GameScreen) : void
		{
		}

		/* These functions are a stub for future modders to edit things across all controllers. */
		protected function I_Default(param1:GameScreen) : void
		{

		}

		protected function U_Default(pram1:GameScreen) : void
		{

		}
	}
}
