package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.*;
    import com.brockw.stickwar.campaign.*;
    import com.brockw.stickwar.engine.*;
    import com.brockw.stickwar.engine.Ai.*;
    import com.brockw.stickwar.engine.Ai.command.*;
    import com.brockw.stickwar.engine.Team.*;
    import com.brockw.stickwar.engine.multiplayer.moves.*;
    import com.brockw.stickwar.engine.units.*;
    import flash.utils.*;

    public class Util
    {
        private var _gameScreen:GameScreen;

        

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
        }

        public function SummonUnit(u1:String, copies:int, teamSpawn:Team, param1:GameScreen = null) : void
        {
            var i:int = 0;
            var unN:int = 0;
            var un:Unit = null;
            while(i < copies)
            {
                unN = StringMap.unitNameToType(u1);
                un = _gameScreen.game.unitFactory.getUnit(unN);
                teamSpawn.spawn(un,_gameScreen.game);
                teamSpawn.population += un.population;
                i++;
            }
        }
        
        public function SummonVarUnit(u1:String, teamSpawn:Team, param1:GameScreen = null) : Unit
        {
            var unitVar:Unit = _gameScreen.game.unitFactory.getUnit(StringMap.unitNameToType(u1));
            teamSpawn.spawn(unitVar,_gameScreen.game);
            teamSpawn.population += unitVar.population;
            return unitVar;
        }

        public function killUnit(un:Unit, destroy:Boolean = false) : void
        {
            if(destroy)
            {
                un.px = 10000;
                un.kill();
            }
            else
            {
                un.kill();
            }
        }

        public function removeTower() : void
        {
            var hill:Hill = _gameScreen.game.map.hills.pop();
            if(_gameScreen.game.map.hills.length != 0) 
            { 
                hill.alpha = 0;
                delete _gameScreen.game.map.hills[hill];
            }
        }

        public function researchTech(tech:int, team:Team, outcome:Boolean = true) : void
        {
          team.tech.isResearchedMap[tech] = outcome;
        }

        public function visibFogOfWar(activate:Boolean = false) : void
        {
            _gameScreen.game.fogOfWar.isFogOn = activate;
        }

        public function setLevelType(infType:String = "") : void
        {
            var statue:Statue = _gameScreen.team.statue;
            infType = infType.toLowerCase();
            infType = infType.split(" ").join("");
            if(infType == "ambush")
            {
                //_gameScreen.team.enemyTeam.statue.isDieing = true;
                _gameScreen.team.enemyTeam.statue.isDead = true;
                _gameScreen.team.enemyTeam.statue.px = statue.px - 1000;
                _gameScreen.team.enemyTeam.statue.x = statue.x - 1000;
                //_gameScreen.team.enemyTeam.statue.py = 250;
                //_gameScreen.team.enemyTeam.statue.y = 250;
                _gameScreen.team.enemyTeam.statue.alpha = 0;
            }
            else if(infType == "" || infType == "normal")
            {
                return;
            }
            return;
        }

        public function winCondition(type:String, time:int) : void
        {
            var statue:Statue = _gameScreen.team.statue;
            type = type.toLowerCase();
            type = type.split(" ").join("");
            if(type == "time")
            {
                if(int(_gameScreen.game.frame / 30) == time)
                {
                  _gameScreen.team.enemyTeam.statue.px = statue.px;
                  _gameScreen.team.enemyTeam.statue.x = statue.x;
                  _gameScreen.enemyTeam.statue.kill();
                }
            }
        }

        public function challenge(type:String) : void
        {
            var clAmount:int = 0;
            type = type.toLowerCase();
            type = type.split(" ").join("");
            if(type == "gold" || type == "gathergold")
            {
                var gold:int = _gameScreen.team.gold;
                if(gold < _gameScreen.team.gold)
                {
                    clAmount += _gameScreen.team.gold - gold;
                }
            }
            return;
        }

        public function HoldUnit(unit:Unit = null) : void
        {
            throw new Error('"util.HoldUnit" is obsolete, use "util.hold"')
            return;
        }

        public function MoveUnit(unit:Unit = null, x:Number = 0, y:Number = 0) : void
        {
            throw new Error('"util.MoveUnit" is obsolete, use "util.move"')
            return;
        }

        public function hold(unit:Unit) : void
        {
            var bool:Boolean = false;
            var x:Number = 0;
            var y:Number = 0;
            if(!bool)
            {
                x = unit.px;
                y = unit.py;
                bool = true
            }
            var move:UnitMove = new UnitMove();
            move.owner = unit.team.id; 
            move.moveType = UnitCommand.HOLD; 
            move.arg0 = x; 
            move.arg1 = y; 
            move.units.push(unit.id); 
            move.execute(_gameScreen.game);
        }

        public function move(unit:Unit, x:Number = 0, y:Number = 0) : void
        {
            var move:UnitMove = new UnitMove(); 
            move.owner = _gameScreen.game.team.enemyTeam.id; 
            move.moveType = UnitCommand.MOVE; 
            move.arg0 = x; 
            move.arg1 = y; 
            move.units.push(unit.id); 
            move.execute(_gameScreen.game);
        }

        public function loop(sec:int, func:Function) : void
        {
            if (_gameScreen.game.frame % (30 * sec) == 0)
            {
                func();
            }
        }

        public function king(un:Unit) : void
        {
            if(un.isDead)
            {
               un.team.statue.kill();
            }
        }

        public function revive(un:Unit, sec:int) : Unit
        {
            var unit:Unit = null;
            if(un.isDead)
            {
               if(param1.game.frame % (30 * sec) == 0)
               {
                  unit = SummonVarUnit(StringMap.unitTypeToName(un.type), un.team);
                  return unit;
               }
            }
        }
    }
}