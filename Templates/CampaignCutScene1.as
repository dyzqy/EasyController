package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class CampaignCutScene1 extends CampaignController
   {
       
      private var state:int = -1;
      private var msg:InGameMessage;
      private var msg1:InGameMessage;
      private var msg2:InGameMessage;
      
      public function CampaignCutScene1(param1:GameScreen)
      {
         super(param1);
      }
      
      override public function update(param1:GameScreen) : void
      {
         cs.message(msg, 6);
         cs.message(msg1, 6);
         cs.message(msg2, 7);

         switch (state)
         {
            case -1:
               util.fogOfWar(false);
               util.removeTower();
               cs.cleanUp(true);
               util.summonUnit("Dead",10,param1.team.enemyTeam);
               util.summonUnit(["Spearton","Swordwrath"],1,param1.team);
               state++;
               for each(var un:Unit in param1.team.units)
               {
                  un.px = data.center("x") + 250;
                  if(un is Miner)
                  {
                     un.kill();
                  }
               }
               for each(var un:Unit in param1.team.enemyTeam.units)
               {
                  un.px = data.center("x") + data.random(0,400);
                  if(un is Miner)
                  {
                     un.kill();
                  }
               }
               
               break;

            case 0:
               cs.follow(cs.infrontUnit(param1.team));
               for each(var un:Unit in param1.team.units)
               {
                  util.move(un, un.px - 225, un.py);
               }
               for each(var un:Unit in param1.team.enemyTeam.units)
               {
                  util.move(un, un.px - 100, un.py);
               }
               if (!msg)
               {
                  debug.console(12,false);
                  msg = cs.startMsg("How did you even make such noise for all these deads to follow us???", "-Swordwrath");
               }
               else if (!param1.contains(msg))
               {
                  state++;
               }
               break;

            case 1:
               cs.follow(cs.infrontUnit(param1.team));
               for each(var un:Unit in param1.team.units)
               {
                  util.move(un, un.px - 225, un.py);
               }
               for each(var un:Unit in param1.team.enemyTeam.units)
               {
                  util.move(un, un.px - 100, un.py);
               }

               if (!msg1)
               {
                  msg1 = cs.startMsg("I don't know man! it happened so quickly, I didn't have any time to react!", "-Spearton");
               }
               else if(!param1.contains(msg1))
               {
                  for each(var un:Unit in param1.team.units)
                  {
                     util.garrison(un);
                  }
                  cs.addlayer();
                  state++;
               }
               break;

            case 2:
               cs.fadelayer(1, true);
               if (cs.statelayer(true))
               {
                  for each(var un:Unit in param1.team.enemyTeam.units)
                  {
                     un.px = data.center("x") * 3;
                     un.kill();
                  }
                  for each(var un:Unit in param1.team.units)
                  {
                     un.px = data.center("x") * 3;
                     un.kill();
                  }
                  cs.cleanUp(false);
                  util.summonUnit(["Spearton","Swordwrath"],1,param1.team);
                  for each(var un:Unit in param1.team.units)
                  {
                     un.px = data.homeX(param1.team) - 400;
                     util.garrison(un);
                  }
                  debug.log("Added +1 to 'state'");
                  state++;
               }
               break;

            case 3:
               cs.fadelayer(3, false);
               if (!msg2)
               {
                  msg2 = cs.startMsg("Phew.. we got out of there. Do you think there is a marrowkai nearby for those many deads to be present?", "-Swordwrath");
               }
               else if (!param1.contains(msg2))
               {
                  cs.removelayer();
                  cs.postCleanUp(true);
                  state++;
               }
               break;
            case 4:
               param1.team.enemyTeam.statue.kill();
               state++;
         }
      }
   }
}
