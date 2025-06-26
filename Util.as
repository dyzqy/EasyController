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

    // TODO: Orginize all of the functions in diffrent categories that explain what they do.
    public class Util
    {
        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
            this.debug = Debug.instance;
        }

        // TODO: finish explaining all of the paramaters. And also test if this works.
        // Summons unit(s) of a specified team.
        // "u1" A specified type of unit or an array of unit types.
        // "copies" How many each specified unit should be spawned.
        public function summonUnit(u1:*, copies:int = 1, teamSpawn:Team = null, func:Function = null, returnType:Class = null) : *
        {
            if(teamSpawn == null)
            {
                teamSpawn = _gameScreen.team;
            }

            var units:Array = [];
            u1 = getUnit(u1);

            if (u1 is Array)
            {
                for(var i:int = 0; i < u1.length; i++)
                {
                    summonUnit(u1, copies, teamSpawn, func, returnType);
                }
            }
            else if(u1 is Int)
            {
                for(int i = 0; i < copies; i++)
                {
                    var un:Unit = _gameScreen.game.unitFactory.getUnit(u1[j]);
                    teamSpawn.spawn(un, _gameScreen.game);
                    teamSpawn.population += un.population;

                    if(func != null)
                    {
                        func(un);
                    }

                    units.push(un);
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
                    return units[0];
                    break;
            }
        }

        // TODO: add Hide unit button in hud function
        // ^ Both of these can be done in same function(?)
        // TODO: add Show unit button in hud function


        // TODO: rework killUnit so destroy is actually reliable.
        // public function killUnit(un:Unit, destroy:Boolean = false) : void
        // {
        //     if(destroy)
        //     {
        //         un.px = 10000;
        //     }
        //     un.kill();
        // }

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

        // TODO: make an addTower function.

        // TODO: Fix this function.
        // public function removeGoldmines(num:int = 8):void 
        // {
        //     if (_gameScreen.game.map.gold.length >= num) 
        //     {
        //         for (var i:int = 0; i < num; i++) {
        //             var gold:Gold = _gameScreen.game.map.gold.pop();
        //             gold.alpha = 0;
        //             var index:int = _gameScreen.game.map.gold.indexOf(gold);
        //             delete _gameScreen.game.map.gold[gold];
        //             if (index != -1) 
        //             {
        //                 _gameScreen.game.map.gold.splice(index, 1);
        //             }
        //         }
        //     }
        // }

        // TODO: Remove this? There is no genuine use for this.
        // public function researchTech(tech:int, team:Team, outcome:Boolean = true) : void
        // {
        //   team.tech.isResearchedMap[tech] = outcome;
        // }

        // TODO: See what to do about this. Does not seem very useful.
        public function fogOfWar(activate:Boolean = false) : void
        {
            _gameScreen.game.fogOfWar.isFogOn = activate;
        }

        // TODO: Remove this, probably.
        // public function setLevelType(infType:String = "") : void
        // {
        //     var statue:Statue = _gameScreen.team.statue;
        //     var enemyStatue:Statue = _gameScreen.team.enemyTeam.statue;
        //     infType = infType.toLowerCase();
        //     infType = infType.split(" ").join("");
        //     if(infType == "ambush")
        //     {
        //         _gameScreen.team.enemyTeam.statue.isDead = true;
        //         _gameScreen.team.enemyTeam.statue.px = statue.px - 1000;
        //         _gameScreen.team.enemyTeam.statue.x = statue.x - 1000;
        //         _gameScreen.team.enemyTeam.statue.alpha = 0;
        //     }
        //     else if(infType == "reverseambush")
        //     {
        //         _gameScreen.team.statue.isDead = true;
        //         _gameScreen.team.statue.px = 0;
        //         _gameScreen.team.statue.x = 0;
        //         _gameScreen.team.statue.alpha = 0;
        //     }
        //     else if(infType == "seige")
        //     {
        //         enemyStatue.isDead = true;
        //         enemyStatue.px = statue.px - 1000;
        //         enemyStatue.x = statue.x - 1000;
        //         enemyStatue.alpha = 0;

        //         statue.isDead = true;
        //         statue.px = enemyStatue.px;
        //         statue.x = enemyStatue.x;
        //         statue.alpha = 0;
        //     }
        //     else if(infType == "" || infType == "normal")
        //     {
        //         return;
        //     }
        //     else
        //     {
        //         debug.error(infType + " is not a registered level type for 'setLevelType()'.", "Util");
        //     }
        // }

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

        // TODO: Remove. This is not needed.
        // public function king(un:Unit) : void
        // {
        //     if(un.isDead || un.isDieing)
        //     {
        //        un.team.statue.kill();
        //     }
        // }

        // TODO: Test if this works.
        public function registerUnit(units:*, team:Team) : void
        {
            var level:* = this._gameScreen.main.campaign.getCurrentLevel();
            units = getUnit(units);

            if(units is Array)
            {
                while(var i:int = 0; i < units.length; i++)
                {
                    registerUnits(units, team);
                }
            }
            else if(units is int)
            {
                var currentUnit:int = units;
                    
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

        // TODO: Rework reinforcements code.
        // public function reinforcements(health:int, maxHealth:int, team:Team, info:* = null, fullHeal:Boolean = true, extra:Boolean = false) : void
        // {
        //     if(team.statue.health <= health && team.statue.maxHealth != maxHealth && !extra)
        //     {
        //         if(info is Function)
        //         {
        //             info();
        //         }
        //         else
        //         {
        //             debug.error("Input for 4th paramater must be a Function. 'reinforcements()'", "Util");
        //         }
                
        //         team.statue.health = fullHeal ? maxHealth : (team.statue.maxHealth / team.statue.health - 1) * maxHealth;
        //         team.statue.maxHealth = maxHealth;
        //         team.statue.healthBar.totalHealth = maxHealth;
        //     }
        // }

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

        // TODO: Use another way to do this?
        // public function passiveCure(type:*, timer:Number) : void
        // {
        //     var un:* = null;
        //     if(type is Team)
        //     {
        //         for each(un in type.units)
        //         {
        //             loop(timer, function():void{
        //                 un.cure();
        //             });
        //         }
        //     }
        //     else if(type is Unit)
        //     {
        //         var un:Unit = type;
        //         loop(timer, function():void{
        //             un.cure();
        //         });
        //     }
        // }
        
        // TODO: Either fix or remove.
        // public function swapUnitButton(units:*, team:Team) : void
        // {
        //     if(!Loader.instance.isDev)
        //     {
        //         debug.error("The 'swapUnitButton()' function is still under work!", "Util")
        //         return;
        //     }
            
        //     var unit1:* = StringMap.unitNameToType(units[0]);
        //     var unit2:* = StringMap.unitNameToType(units[1]);
        //     registerUnit(unit1, team);

        //     var currentXML:* = StringMap.unitTypeToXML(unit2, this._gameScreen.game);
            
        //     var unit:* = team.buttonInfoMap[unit1];
        //     team.buttonInfoMap[unit2] = [unit[0],unit[1],currentXML,0,new cancelButton(),currentXML.cost * team.handicap,unit[6],unit[7],unit[8]];

        //     delete team.buttonInfoMap[unit1];
        //     team.unitsAvailable[unit2] = 1;
        // }

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

        // TODO: Rework this. It does its job too goofily.
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
            return team.unitGroups[getUnit(type)];
        }

        // Gets unit int with whatever data you give it.
        private function getUnit(data:*) : * 
        {
            if(data is String)
            {
                return StringMap.unitNameToType(data);
            }
            else if(data is Int)
            {
                return data;
            }
            else if(data is Array)
            {
                var arrayToReturn:Array = [];
                for(int i = 0; i < data.length; i++)
                {
                    arrayToReturn.push(getUnit(data[i]));
                }

                return arrayToReturn;
            }

            debug.error("Type " + data + " is not supported.", "Util");
            return null;
        }
    }
}