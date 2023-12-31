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
        private var registeredUnits;

        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen, debugCl:Debug = null)
        {
            super();
            this._gameScreen = gameScreen;
            this.debug = debugCl;
        }

        public function summonUnit(u1:*, copies:int, teamSpawn:Team, returnType:Class = null, type:* = null) : *
        {
            var i:int = 0;
            var unName:int = 0;
            var un:Unit = null;
            var units:Array = [];

            if (u1 is Array)
            {
                var j:int = 0;
                while(j < u1.length)
                {
                    if(!(u1[j] is String))
                    {
                        debug.error("Unit Name must be a String. SummonUnit().", "Util");
                        return;
                    }
                    while(i < copies)
                    {
                        unName = StringMap.unitNameToType(u1[j]);
                        un = _gameScreen.game.unitFactory.getUnit(unName);
                        /*if(type != null)
                        {
                            if (type is Array)
                            {
                                StringMap.setUnitType(un, type[j]);
                            }
                            else if (type is String)
                            {
                                StringMap.setUnitType(un, type);
                            }
                            else
                            {
                                debug.error("Invalid parameter for 'unitType'. The parameter must be either a String or an Array of Strings.", "Util");
                            }
                            
                        }*/
                        teamSpawn.spawn(un, _gameScreen.game);
                        teamSpawn.population += un.population;

                        units.push(un);
                        i++;
                    }
                    i = 0;
                    j++;
                }
            }
            else if (u1 is String)
            {
                while (i < copies)
                {
                    unName = StringMap.unitNameToType(u1);
                    un = _gameScreen.game.unitFactory.getUnit(unName);
                    teamSpawn.spawn(un, _gameScreen.game);
                    teamSpawn.population += un.population;

                    units.push(un);
                    i++;
                }
            }
            else
            {
                debug.error("Invalid parameter for 'SummonUnit'. The first parameter must be either a String or an Array of Strings.", "Util");
            }

            switch(returnType)
            {
                case Array:
                    return units;
                    break;

                case Unit:
                    return units[0];
                    break;

                case String:
                    return StringMap.unitTypeToName(units[0].type);
                    break;

                case int:
                    return units[0].type;
                    break;

                default:
                    return null;
                    break;
            }
        }

        public function killUnit(un:Unit, destroy:Boolean = false) : void
        {
            if(destroy)
            {
                un.px = 10000;
            }
            un.kill();
        }

        public function removeTower() : void
        {
            if(_gameScreen.game.map.hills.length != 0) 
            {
                var hill:Hill = _gameScreen.game.map.hills.pop();
                var index:int = _gameScreen.game.map.hills.indexOf(hill);
                hill.alpha = 0;
                delete _gameScreen.game.map.hills[hill];
                if (index != -1)
                {
                    _gameScreen.game.map.hills.splice(index, 1);
                }
            }
        }

        public function researchTech(tech:int, team:Team, outcome:Boolean = true) : void
        {
          team.tech.isResearchedMap[tech] = outcome;
        }

        public function fogOfWar(activate:Boolean = false) : void
        {
            _gameScreen.game.fogOfWar.isFogOn = activate;
        }

        public function setLevelType(infType:String = "") : void
        {
            var statue:Statue = _gameScreen.team.statue;
            var enemyStatue:Statue = _gameScreen.team.enemyTeam.statue;
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
            else if(infType == "seige")
            {
                //_gameScreen.team.enemyTeam.statue.isDieing = true;
                //_gameScreen.team.enemyTeam.statue.py = 250;
                //_gameScreen.team.enemyTeam.statue.y = 250;

                enemyStatue.isDead = true;
                enemyStatue.px = statue.px - 1000;
                enemyStatue.x = statue.x - 1000;
                enemyStatue.alpha = 0;

                statue.isDead = true;
                statue.px = enemyStatue.px;
                statue.x = enemyStatue.x;
                statue.alpha = 0;
            }
            else if(infType == "" || infType == "normal")
            {
                return;
            }
            else
            {
                debug.error(infType + " is not a registered level type for 'setLeveltype()'.", "Util");
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

        public function hold(unit:Unit, x:Number = 0, y:Number = 0) : void
        {
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
            move.owner = unit.team.id;
            move.moveType = UnitCommand.MOVE; 
            move.arg0 = x; 
            move.arg1 = y; 
            move.units.push(unit.id); 
            move.execute(_gameScreen.game);
        }

        public function garrison(unit:Unit) : void
        {
            var move:UnitMove = new UnitMove(); 
            move.owner = unit.team.id; 
            move.moveType = UnitCommand.GARRISON; 
            move.arg0 = unit.px; 
            move.arg1 = unit.py; 
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
                var type:int = unit != null ? un.type : type;
                var team:Team = unit != null ? un.team : team;
                if(param1.game.frame % (30 * sec) == 0)
                {
                    unit = SummonUnit(StringMap.unitTypeToName(un.type), 1, un.team, Unit);
                    return unit;
                }
            }
        }

        public function registerUnit(units:*, team:Team) : void
        {
            var i:int = 0;
            if(units is Array)
            {
                var level:* = this._gameScreen.main.campaign.getCurrentLevel();
                while (i < units.length)
                {
                    var currentUnit:* = StringMap.unitNameToType(units[i]);
                    
                    if(team.unitInfo[currentUnit] == null)
                    {
                        team.unitInfo[currentUnit] = [(StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).gold * (StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).mana * level.insaneModifier];
                        var unit:Unit = this._gameScreen.game.unitFactory.getUnit(int(currentUnit));
                        unit.team = team;
                        unit.setBuilding();
                        team.unitInfo[currentUnit].push((team.buildings["BankBuilding"]).type);
                        team.unitGroups[currentUnit] = [];
                        this._gameScreen.game.unitFactory.returnUnit(currentUnit, unit);
                    }
                    i++;
                }
            }
            else if(units is String)
            {
                var level:* = this._gameScreen.main.campaign.getCurrentLevel();
                var currentUnit:* = StringMap.unitNameToType(units);
                    
                if(team.unitInfo[currentUnit] == null)
                {
                    team.unitInfo[currentUnit] = [(StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).gold * (StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).mana * level.insaneModifier];
                    var unit:Unit = this._gameScreen.game.unitFactory.getUnit(int(currentUnit));
                    unit.team = team;
                    unit.setBuilding();
                    team.unitInfo[currentUnit].push((team.buildings["BankBuilding"]).type);
                    team.unitGroups[currentUnit] = [];
                    this._gameScreen.game.unitFactory.returnUnit(currentUnit, unit);
                }
            }
            else if(units is int)
            {
                var level:* = this._gameScreen.main.campaign.getCurrentLevel();
                var currentUnit:* = units;
                    
                if(team.unitInfo[currentUnit] == null)
                {
                    team.unitInfo[currentUnit] = [(StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).gold * (StringMap.unitTypeToXML(currentUnit, this._gameScreen.game)).mana * level.insaneModifier];
                    var unit:Unit = this._gameScreen.game.unitFactory.getUnit(int(currentUnit));
                    unit.team = team;
                    unit.setBuilding();
                    team.unitInfo[currentUnit].push((team.buildings["BankBuilding"]).type);
                    team.unitGroups[currentUnit] = [];
                    this._gameScreen.game.unitFactory.returnUnit(currentUnit, unit);
                }
            }
            else
            {
                debug.error("The first paramater of util.registerUnit() must be a String or an Array of Strings.", "Util");
            }
        }

        public function reinforcements(health:int, maxHealth:int, team:Team, info:* = null, fullHeal:Boolean = true, extra:Boolean = false) : void
        {
            if(team.statue.health <= health && team.statue.maxHealth != maxHealth && !extra)
            {
                if(info is Function)
                {
                    info();
                }
                else
                {
                    debug.error("Input for 4th paramater must be a Function. 'reinforcements()'", "Util");
                }
                
                team.statue.health = fullHeal ? maxHealth : (team.statue.maxHealth / team.statue.health - 1) * maxHealth;
                team.statue.maxHealth = maxHealth;
                team.statue.healthBar.totalHealth = maxHealth;
            }
        }

        public function modifyDefence(type:String, team:Team, info:Array = null) : void
        {
            type = type.toLowerCase();
            type = type.split(" ").join("");

            var defence:* = team.castleDefence;
            var unit:Unit = null;
            var i:int = 0;
            switch(type)
            {
                case "add":
                    unit = summonUnit(info[0], info[1], team, Unit);
                    
                    unit.flyingHeight = 390;
                    unit.pz = -unit.flyingHeight;
                    unit.py = _gameScreen.game.map.height / 2 * defence.units.length / _gameScreen.game.xml.xml.Order.Tech.castleArchers.num;
                    unit.y = unit.py;
                    unit.px = team.homeX + team.direction * 180 - team.direction * defence.units.length * 8;
                    unit.x = unit.px;
                    unit.isInteractable = false;
                    unit.healthBar.visible = false;

                    var hold:HoldCommand = new HoldCommand(_gameScreen.game);
                    unit.ai.setCommand(_gameScreen.game,hold);
                    defence.units.push(unit);
                    break;
                case "replace":

                    break;
                case "remove":
                    while (i > (defense.units.length - info[0]))
                    {
                        unit = defence.units[i];
                        if(_gameScreen.game.battlefield.contains(unit))
                        {
                            _gameScreen.game.battlefield.removeChild(unit);
                        }
                        i--;
                    }
                    break;
            }
        }
    }
}