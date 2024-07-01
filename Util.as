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
    import flash.text.*;
    import flash.display.*;

    public class Util
    {
        private var registeredUnits:Array;

        private var customUnits:*;

        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
            this.debug = Debug.instance;
        }

        public function summonUnit(u1:*, copies:int = 1, teamSpawn:Team = null, returnType:Class = null, type1:* = null, variable1:* = null) : *
        {
            if(teamSpawn == null)
            {
                teamSpawn = _gameScreen.team;
            }
            var i:int = 0;
            var unName:int = 0;
            var un:Unit = null;
            var units:Array = [];
            var type:* = null;
            var variable:* = null;

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
                    if(type1 is Array)
                    {
                        type = type1[j];
                    }
                    if(variable1 is Array)
                    {
                        variable = variable1[j];
                    }
                    while(i < copies)
                    {
                        unName = StringMap.unitNameToType(u1[j]);
                        un = _gameScreen.game.unitFactory.getUnit(unName);
                        if(type != null && variable != null)
                        {
                            un[variable] = type;
                        }
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
                    if(type1 is String)
                    {
                        type = type1;
                    }
                    if(variable1 is String)
                    {
                        variable = variable1;
                    }
                    unName = StringMap.unitNameToType(u1);
                    un = _gameScreen.game.unitFactory.getUnit(unName);
                    if(type != null && variable != null)
                    {
                        un[variable] = type;
                    }
                    teamSpawn.spawn(un, _gameScreen.game);
                    teamSpawn.population += un.population;

                    units.push(un);
                    i++;
                }
            }
            else
            {
                debug.error("Invalid parameter for 'SummonUnit()'. The first parameter must be either a String or an Array of Strings.", "Util");
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

        /*public function removeGoldmines(num:int = 8):void 
        {
            if (_gameScreen.game.map.gold.length >= num) 
            {
                for (var i:int = 0; i < num; i++) {
                    var gold:Gold = _gameScreen.game.map.gold.pop();
                    gold.alpha = 0;
                    var index:int = _gameScreen.game.map.gold.indexOf(gold);
                    delete _gameScreen.game.map.gold[gold];
                    if (index != -1) 
                    {
                        _gameScreen.game.map.gold.splice(index, 1);
                    }
                }
            }
        }*/

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
                _gameScreen.team.enemyTeam.statue.isDead = true;
                _gameScreen.team.enemyTeam.statue.px = statue.px - 1000;
                _gameScreen.team.enemyTeam.statue.x = statue.x - 1000;
                _gameScreen.team.enemyTeam.statue.alpha = 0;
            }
            else if(infType == "reverseambush")
            {
                _gameScreen.team.statue.isDead = true;
                _gameScreen.team.statue.px = 0;
                _gameScreen.team.statue.x = 0;
                _gameScreen.team.statue.alpha = 0;
            }
            else if(infType == "seige")
            {
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
                debug.error(infType + " is not a registered level type for 'setLevelType()'.", "Util");
            }
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
            unit.garrison();
        }

        public function ungarrison(unit:Unit) : void
        {
            unit.ungarrison();
        }

        public function king(un:Unit) : void
        {
            if(un.isDead || un.isDieing)
            {
               un.team.statue.kill();
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

        public function instaBuild(team:Team) : void
        {
            var unit:* = null;
            for each(unit in team.unitProductionQueue)
            {
                if(unit.length != 0)
                {
                    unit[0][1] = unit[0][0].createTime + 9;
                }
            }
        }

        public function restoreHealth(type:*) : void
        {
            unitsreducedcode(type, function(un:Unit):void{
                un.health = un.maxHealth;
            });
            
        }

        public function passiveHeal(type:*, amount:Number, extrateam:Team = null) : void
        {
            var un:* = null;
            var realamount:Number = amount / 30;

            unitsreducedcode(type, function(un:Unit):void{
                if(un.health + realamount <= un.maxHealth)
                {
                    un.health += realamount;
                }
                else
                {
                    un.health += un.maxHealth - un.health;
                }
            }, extrateam);
        }

        /*public function passiveCure(type:*, timer:Number) : void
        {
            var un:* = null;
            if(type is Team)
            {
                for each(un in type.units)
                {
                    loop(timer, function():void{
                        un.cure();
                    });
                }
            }
            else if(type is Unit)
            {
                var un:Unit = type;
                loop(timer, function():void{
                    un.cure();
                });
            }
        }*/
        
        public function swapUnitButton(units:*, team:Team) : void
        {
            if(!Loader.instance.isDev)
            {
                debug.error("The 'swapUnitButton()' function is still under work!", "Util")
                return;
            }
            
            var unit1:* = StringMap.unitNameToType(units[0]);
            var unit2:* = StringMap.unitNameToType(units[1]);
            registerUnit(unit1, team);

            var currentXML:* = StringMap.unitTypeToXML(unit2, this._gameScreen.game);
            
            var unit:* = team.buttonInfoMap[unit1];
            team.buttonInfoMap[unit2] = [unit[0],unit[1],currentXML,0,new cancelButton(),currentXML.cost * team.handicap,unit[6],unit[7],unit[8]];

            delete team.buttonInfoMap[unit1];
            team.unitsAvailable[unit2] = 1;
        }

        public function changeStatue(team:Team, statue:String) : void
        {
            statue = statue.toLowerCase();
            team.statueType = statue;
        }

        public function changeMusic(name:String = "orderInGame") : void
        {
            _gameScreen.game.soundManager.playSoundInBackground(name);
        }

        public function disableFinishers(team:Team = null) : void
        {
            disableDFs(team);
        }

        public function disableDuels(team:Team = null) : void
        {
            disableDFs(team);
        }

        private function disableDFs(team:Team = null) : void
        {
            if(team == null)
            {
                _gameScreen.team.isMember = false;
                _gameScreen.team.enemyTeam.isMember = false;
            }
            else if(!(team is Team))
            {
                debug.error("Paramater must be null or a Team. disableDuels()/disableFinishers().", "Util");
            }
            else
            {
                team.isMember = false;
            }
        }

        // Private functions place :)

        private function unitsreducedcode(type:*, func:Function, extrateam:Team = null) : void
        {
            var un:* = null;
            var realamount:Number = amount / 30;
            if(type is Team)
            {
                for each(un in type.units)
                {
                    func(un);
                }
            }
            else if(type is Array)
            {
                if(type[0] is Unit)
                {
                    for each(un in type.units)
                    {
                        func(un);
                    }
                }
                else if(type[0] is String)
                {
                    var unitGroup:Array = getUnitGroup(type, extrateam);
                    for each(un in unitGroup)
                    {
                        func(un);
                    }
                }
                else
                {
                    debug.error("No registered array type for {" + type + "} is available yet.", "Util");
                }
            }
            else if(type is Unit)
            {
                func(type);
            }
            else if(type is String)
            {
                var unitGroup:Array = getUnitGroup(type, extrateam);
                for each(un in unitGroup)
                {
                    func(un);
                }
            }
            else
            {
                debug.error("{" + type + "} must be either a Team, Unit, String or an Array of Strings/Units.", "Util");
            }
        }

        private function getUnitGroup(type:*, team:Team) : Array
        {
            var un:* = null;
            var result:Array = [];

            if(type is String)
            {
                var unitType:int = StringMap.unitNameToType(type);
                return team.unitGroups[unitType];
            }
            return null;
        }
    }
}