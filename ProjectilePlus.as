package com.brockw.stickwar.campaign.controllers.EasyController
{
    import com.brockw.stickwar.GameScreen;
    import com.brockw.stickwar.engine.Team.*;
    import com.brockw.stickwar.engine.projectile.*;
    import com.brockw.stickwar.engine.units.*;
    import flash.utils.*;

    public class ProjectilePlus
    {
        private var gameScreen:GameScreen;

        private var util:Util;

        // All arrays

        private var firewalls:Array = [];

        private var eletowers:Array = [];

        private var mines:Array = [];

        private var triggers:Array = [];

        // private var sandstorm:Array = []:

        // privare var thorn:Array = [];

        public function ProjectilePlus(gs:GameScreen, utilities:Util)
        {
            this.gameScreen = gs;
            this.util = utilities;
            super();
        }

        public function firewall(px:*, team:Team, size:int, num:int, fireFrames:int = 60, fireDamage:Number = 1, radius:int = 15) : void
        {
            var i:int = 0;
            var fires:Array = [];
            while(i < num)
            {
                gameScreen.game.projectileManager.initFireOnTheGround(px,i * team.game.map.height / num,0,team,team.direction,size);
                fires.push(getProjectile()); // add to array, but won't use it for now 
                i++;
            }
            var firewallinf:Array = [px,team,radius,team.game.frame,fireFrames,fireDamage,fires];
            firewalls.push(firewallinf);
        }

        public function teslatower(px:*, py:*, team:Team, range:int = 300, lifeFrames:int = 1200, frequency:int = 3) : void
        {
            team.game.projectileManager.initSandstormTower(px,py,0,team,team.direction,lifeFrames);
            var sandstorminf:Array = [px,py,team,range,lifeFrames,team.game.frame,frequency,null,new Dictionary()];
            eletowers.push(sandstorminf);
        }

        public function landmine(px:Number, py:Number, team:Team, size:Number = 0.25, damage:Number = 50, fireFrames:int = 60, fireDamage:Number = 1) : void
        {
            team.game.projectileManager.initMound(px,py,0,team,team.direction);
            var mound:MoundOfDirt = MoundOfDirt(getProjectile());
            var minesinf:Array = [px,py,team,mound,size];
            mound.scaleX *= size;
            mound.scaleY *= size;
            mines.push(minesinf);
        }

        public function trigger(px:Number, py:Number, team:Team, width:Number, height:Number, func:Function) : void
        {
            var info:Array = [px, py, team, width, height, func];
            triggers.push(info);
        }

        // Update Stuff, you only need to run updateProjectiles :thumbsup:

        public function updateProjectiles() : void
        {
            updateFireWalls(gameScreen);
            updateEleTowers(gameScreen);
            updateMines(gameScreen);
            // add trigger
        }

        private function updateFireWalls(gs:GameScreen)
        {
            //[px,team,radius,team.game.frame,fireFrames,fireDamage,fires]
            if(firewalls.length == 0)
            {
                return;
            }
            var i:int = 0;
            while(i < firewalls.length)
            {
                var j:int = 0;
                var firewall:Object = firewallobj(firewalls[i]);

                var fires:Array = firewall.fires;
                var radius:int = firewall.radius;
                //break;

                if(fires.length == 0)
                {
                    firewalls.splice(firewalls.indexOf(firewalls[i]),1);
                    i--;
                    break;
                }
                
                gs.game.spatialHash.mapInArea(firewall.px - radius, 0, firewall.px + radius, gs.game.map.height, function(param1:Unit):*
                {
                    if(param1.team != firewall.team && param1.pz == 0)
                    {
                        if(Math.abs(param1.px - firewall.px) < radius)
                        {
                            param1.setFire(firewall.fireFrames,firewall.fireDamage);
                        }
                    }
                });
            }
        }

        private function updateEleTowers(gs:GameScreen)
        {
            if(eletowers.length == 0)
            {
                return;
            }
            var i:int = 0;
            while(i < eletowers.length)
            {
                var targetUnit:Unit = eletowers[i][7]
                var unitsInArea:Dictionary = eletowers[i][8];
                if(eletowers[i][4] > gs.game.frame - eletowers[i][5])
                {
                    gs.game.spatialHash.mapInArea(eletowers[i][0] - eletowers[i][3],0,eletowers[i][0] + eletowers[i][3],gs.game.map.height,function(param1:Unit):void
                    {
                        var sandstormRange:int = int(eletowers[i][3]);
                        var frequency:int = 30 * eletowers[i][6];
                        if(param1.team != eletowers[i][2] && param1.pz == 0)
                        {
                            if(Math.abs(param1.px - eletowers[i][0]) < sandstormRange)
                            {
                                if(targetUnit == null || targetUnit.isDead || targetUnit.isDieing)
                                {
                                    targetUnit = param1;
                                }
                                if(unitsInArea == null)
                                {
                                    unitsInArea = new Dictionary();
                                }
                                if(unitsInArea[param1] == null)
                                {
                                    unitsInArea[param1] = param1.team.game.frame;
                                }
                                if((param1.team.game.frame - unitsInArea[param1]) % frequency == 0 && param1 == targetUnit)
                                {
                                    param1.damage(Unit.D_NO_SOUND,50,null);
                                    param1.team.game.projectileManager.initLightning(air,param1,0);
                                }
                            }
                            else if(Math.abs(param1.px - eletowers[i][0]) > sandstormRange)
                            {
                                if(unitsInArea != null && unitsInArea[param1] != null)
                                {
                                    unitsInArea[param1] = null;
                                    targetUnit = null;
                                }
                            }
                        }
                    });
                    i++;
                }
                else
                {
                    eletowers.splice(eletowers.indexOf(eletowers[i]),1);
                    i--;
                }
            }
        }

        private function updateMines(gs:GameScreen) : void
        {
            if(mines.length == 0)
            {
                return;
            }
            var i:int = 0;
            while(i < mines.length)
            {
                var mine:Object = mineobj(mines[i]);
                var team:Team = mine.team;
                if(mine.mound.isReadyForCleanup() || mine.mound == null)
                {
                    gs.game.projectileManager.initMound(mine.px,mine.py,0,mine.team,mine.direction);
                    team = mine.team;
                    var mound:MoundOfDirt = MoundOfDirt(getProjectile());
                    mound.scaleX *= mine.size;
                    mound.scaleY *= mine.size;
                    mines[i][3] = mound;
                    mine.mound = mound;
                }
                var radius:Number = mine.size * 6.5;
                gs.game.spatialHash.mapInArea(mine.px - radius,mine.py - radius,mine.px + radius,mine.py + radius,function(param1:Unit):void
                {
                    if(param1.team != mine.team && param1.pz == 0)
                    {
                        // debug.Log("Moving the ash is future dyz\'s problem lmaoo","#ff4040");
                        gs.game.projectileManager.initNuke(mine.px,mine.py,param1.team.enemyTeam.statue,50,0.5,30 * 3);
                        var nuke:Nuke = Nuke(getProjectile(5));
                        var j:int = 0;
                        while(j < 5)
                        {
                            var fire:FireOnTheGround = FireOnTheGround(getProjectile(j));
                            var px:* = nuke.px - fire.px;
                            var py:* = nuke.py - fire.py;
                            fire.px = mine.px + px;
                            fire.py = mine.py + py;
                            j++;
                        }
                        nuke.px = mine[0];
                        nuke.py = mine[1];
                        nuke.x = nuke.px;
                        nuke.y = nuke.py;
                        mines.splice(mines.indexOf(mines[i]),1);
                        removeProjectile(mine.mound);
                    }
                });
                i++;
            }
        }

        // useful functions that lessen work :)

        private function mineobj(info:Array) : Object
        {
            var obj:Object = {
                px: info[0],
                py: info[1],
                team: info[2],
                direction: info[2].direction,
                mound: info[3],
                size: info[4]
            };
            return obj;
        }

        private function firewallobj(info:Array) : Object
        {
            var obj:Object = {
                px: info[0],
                team: info[1],
                radius: info[2],
                frame: info[3],
                fireFrames: info[4],
                fireDamage: info[5],
                fires: info[6]
            };
            return obj;
        }

        private function getProjectile(num:int = 0) : *
        {
            if(gameScreen.game.projectileManager.projectiles.length == 0)
            {
                Debug.instance.error("No available projectiles to obtain. getProjectile()","ProjectilePlus");
                return null;
            }
            var length:int = int(gameScreen.game.projectileManager.projectiles.length);
            return gameScreen.game.projectileManager.projectiles[length - (1 + num)];
        }

        private function removeProjectile(projectile:Projectile) : void
        {
            projectile.px = -10;
            return; // projectileMap ain't public, so gotta make do with what we got lel
           
            gameScreen.game.projectileManager.projectileMap[projectile.type].returnItem(projectile);
            if(gameScreen.game.battlefield.contains(projectile))
            {
                gameScreen.game.battlefield.removeChild(projectile);
            }
            gameScreen.game.projectileManager.projectiles.splice(gameScreen.game.projectileManager.projectiles.indexOf(projectile),1);
        }
    }
}