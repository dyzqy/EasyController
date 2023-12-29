package com.brockw.stickwar.campaign.controllers
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.campaign.*;
    import com.brockw.stickwar.engine.units.*;
   
    public class CampaignArcher extends CampaignController
    {
       
        private var timeForWave:int;

        private var timeTillWave:int;
        
        private var timeForReinforcements:int;

        private var wave:int = -1;

        private var message:InGameMessage;
        
        private var frames:int;
        
        private var arrow:tutorialArrow;

        private var magi:Magikill;

        private var hasStarted:Boolean = false;

        private var nah:Boolean = false;
        
        public function CampaignArcher(param1:GameScreen)
        {
            super(param1);
            this.frames = 0;
        }

        public function start(param1:GameScreen) : void
        {
            debug.SimulateStats(14);
            cs.summonWall(param1.team, data.center("x") - 300, -1, 1200);
            cs.summonWall(param1.team, data.center("x") + 300, 1, 1200);
            util.setLevelType("seige");
        }
        
        override public function update(param1:GameScreen) : void
        {
            var timeWave:String = null;
            var timeReinf:String = null;
            var time:int = 0;
            var unitsToTelep:Array = null;
            cs.message(message,15);
            if(!hasStarted)
            {
                start(param1);
                hasStarted = true;
            }
            timeForReinforcements = 240 - int(data.timer());
            if(timeForWave > 0)
            {
                timeForWave = timeTillWave - (data.timer() - time);
            }
            timeReinf = timeForReinforcements <= 0 ? "-" : timeForReinforcements + "s";
            timeWave = timeForWave > 0 ? timeForWave + "s" : "-";
            debug.Statistics("Next Wave in " + timeWave, "Reinforcements in " + timeReinf, "Wave " + wave);

            switch (wave)
            {
            case -1:
                util.fogOfWar(false);
                message = cs.startMsg("I can't hold them much longer, orginize our units before the next enemy unit wave is dispatched!", "Magikill:")
                cs.cleanUp(false);

                util.summonUnit(["Sword","Meric","Archidon","Sword"], 1, param1.team.enemyTeam);
                util.summonUnit(["Sword","Spearton","Meric","Archidon","Archidon","Sword","Sword"], 1, param1.team);
                util.summonUnit(["Spearton","Meric"], 2, param1.team.enemyTeam);
                magi = util.summonUnit("magikill", 1, param1.team, Unit);
                for each(var un2:Unit in param1.team.enemyTeam.units)
                {
                    un2.px = data.center("x") + random(350, 550);
                    un2.py = data.center("y") + random(50, 125);
                    //(param1.team.units[0]).ai.currentTarget = null;
                    param1.game.projectileManager.initNuke(un2.px,un2.py,param1.team.units[0],300,300,300);
                }
                for each(var un1:Unit in param1.team.units)
                {
                    un1.px = data.center("x") + random(10, 25);
                    un1.py = data.center("y") + random(0, 100);
                    util.move(un1, un1.px, un1.py);
                    if(un1 is Miner)
                    {
                        un1.kill();
                    }
                }
                //magi.nukeSpell((cs.infrontUnit(param1.team)).px, (cs.infrontUnit(param1.team)).py);
                
                
                time = int(data.timer());
                timeForWave = timeTillWave = 15;
                wave++;
                break;

            case 0:
                cs.follow(magi);
                if(timeForWave == 0)
                {
                    util.summonUnit(["Spearton","Meric","Archidon"], 2, param1.team.enemyTeam);
                    for each(var un3:Unit in param1.team.enemyTeam.units)
                    {
                        un3.px = data.center("x") + random(375, 600);
                        un3.py = data.center("y") + random(0, 125);
                    }
                    wave++;
                }
                break;

            case 1:
                if(data.unitAmount(param1.team.enemyTeam) <= 1 && !nah)
                {
                    unitsToTelep = util.summonUnit(["Spearton","Archidon"], 2, param1.team, Array);
                    for each(var un4:Unit in unitsToTelep)
                    {
                        un4.px = data.center("x");
                        un4.py = data.center("y");
                    }
                    unitsToTelep = [];
                    time = int(data.timer());
                    timeForWave = timeTillWave = 10;
                    nah = true;
                }
                if(timeForWave == 0 && nah)
                {
                    util.summonUnit(["Meric","Archidon","Archidon","Archidon","Spearton"], 1, param1.team.enemyTeam);
                    for each(var un5:Unit in param1.team.enemyTeam.units)
                    {
                        un5.px = data.center("x") + random(375, 600);
                        un5.py = data.center("y") + random(0, 125);
                    }
                    nah = false;
                    wave++;
                }
                break;

            case 4:
                param1.team.enemyTeam.statue.kill();
                state++;
            }
            
            if(wave != -1)
            {
                param1.game.team.enemyTeam.attack(true);
            }
        }

        public function random(min:int = 100, max:int = 300) : int
        {
            var randomSign:int = Math.random() < 0.5 ? -1 : 1;
            var randomNumber:Number;
            if (Math.random() < 0.5)
            {
                randomNumber = randomSign * (Math.random() * (min - 1) - max);
            } 
            else 
            {
                randomNumber = randomSign * (Math.random() * (max - min) + min);
            }
            return randomNumber;
        }
    }
}
