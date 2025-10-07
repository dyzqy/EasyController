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

    // import flash.net.FileReference;

    public class Util
    {
        public var preferredTeam:Team;

        private var _gameScreen:GameScreen;

        private var debug:Debug;

        public function Util(gameScreen:GameScreen)
        {
            super();
            this._gameScreen = gameScreen;
            this.debug = Debug.instance;

            this.preferredTeam = gameScreen.team;
        }

    //  # Unit Related Functions. 

        // Summons unit(s) of a specified team.
        // "unitData" A specified type of unit or an array of unit types.
        // "copies" How many each specified unit should be spawned.
        // "teamSpawn" Which team the unit spawns in.
        // "func" A function to run on all units spawned.
        // "returnType" The type that the function should return
        public function summonUnit(unitData:*, copies:int = 1, teamSpawn:Team = null, func:Function = null, returnType:Class = null) : *
        {
            if(teamSpawn == null)
            {
                teamSpawn = preferredTeam;
            }

            var units:Array = [];
            var u1:* = StringMap.getUnit(unitData);

            if (u1 is Array)
            {
                for(var i:int = 0; i < u1.length; i++)
                {
                    summonUnit(u1[i], copies, teamSpawn, func, returnType);
                }
            }
            else if(u1 is int)
            {
                for(var i:int = 0; i < copies; i++)
                {
                    var un:Unit = _gameScreen.game.unitFactory.getUnit(u1);
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

                default:
                    return units[0];
                    break;
            }
        }

        // TODO: Test if this works.
        // Allows a unit(s) of other empires to be summoned.
        // "units" A specified type of unit or an array of unit types.
        // "team" the team to register the unit to.
        public function registerUnit(units:*, team:Team) : void
        {
            if(team == null) team = preferredTeam;

            var level:* = this._gameScreen.main.campaign.getCurrentLevel();
            units = StringMap.getUnit(units);

            if(units is Array)
            {
                for(var i:int = 0; i < units.length; i++)
                {
                    registerUnits(units[i], team);
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
                    // TODO: Find a way to set the correct unit building. unit.building is public.
                    // Might be null tho if the team isn't the supposed team? 
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

        // TODO: test & make description for function and its paramaters
        public function toggleUnitButton(unitData:*, team:Team) : void
        {
            if(team == null)
            {
                team = this.preferedTeam;
            }

            var units:* = StringMap.getUnit(unitData);

            if(units is Array)
            {
                for(var i:int = 0; i < units.length; i++)
                {
                    toggleUnitButton(units[i]);
                }
            }
            else if(units is int)
            {
                var unit:int = units;
                if(team.unitsAvailable[unit] == null)
                {
                    team.unitsAvailable[unit] = 1; 
                }
                else
                {
                    delete team.unitsAvailable[unit];
                }
            }
        }

        // TODO: test if it works.
        public function deleteUnit(un:Unit) : void
        {
            un.kill();
            un.timeOfDeath = 30 * 20 + 1;
        }

        // TODO: Verify if this can run in multiplayer side 
        public function hold(unit:Unit, x:Number = 0, y:Number = 0) : void
        {
            // var move:UnitMove = new UnitMove();
            // move.owner = unit.team.id; 
            // move.moveType = UnitCommand.HOLD; 
            // move.arg0 = x; 
            // move.arg1 = y; 
            // move.units.push(unit.id); 
            // move.execute(_gameScreen.game);

            // 07/10/2025 dyzqy: Reworked how hold command words.
            unit.ai.setCommand(_gameScreen.game,new HoldCommand(_gameScreen.game));

            // var move:UnitMove = new UnitMove();
            // move.fromString([unit.team.id, this._gameScreen.game.frame, ]);
        }

        // TODO: Verify if this can run in multiplayer side 
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

        // TODO: Verify if this can run in multiplayer side 
        public function garrison(unit:Unit) : void
        {
            unit.garrison();
        }

        // TODO: Verify if this can run in multiplayer side 
        public function ungarrison(unit:Unit) : void
        {
            unit.ungarrison();
        }

        // TODO: Make this more dynamic. As in make it possible to only instantly build certain units, or have it as a percentage.
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

        // Passively heal units by amount divided by 30.
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

    //  # Utility Related Functions. 

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

        // TODO: Decide if to keep these 2 functions below? They do not abide by the DIY "rule" I set. 
        public function changeStatue(team:Team, statue:String) : void
        {
            if(team == null) team = preferredTeam;
            team.statueType = statue.toLowerCase();
        }

        public function changeMusic(name:String = "orderInGame") : void
        {
            _gameScreen.game.soundManager.playSoundInBackground(name);
        }

        public function disableFinishers(team:Team = null) : void
        {
            if(team == null)
            {
                _gameScreen.team.isMember = false;
                _gameScreen.team.enemyTeam.isMember = false;
            }
            else if(!(team is Team))
            {
                debug.error("Paramater must be null or a Team. disableFinishers().", "Util");
            }
            else
            {
                team.isMember = false;
            }
        }

    //   # Private functions place :)

        // TODO: make it so if you are not on Dev, do not allow to save file.
        // public function saveFile(value:String, name:String = "data.txt") : void
        // {
        //     if(!Loader.instance.isDev)
        //     {

        //     }
        //     var file:FileReference = new FileReference();
        //     file.save(value, name);
        // }

        // TODO: Rework this. It does its job too goofily.
        // + I don't even remember what it does lol
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
            return team.unitGroups[StringMap.getUnit(type)];
        }
    }
}
