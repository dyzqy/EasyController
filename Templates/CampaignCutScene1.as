package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   
   public class CampaignTutorial extends CampaignController
   {
       
      private var state:int = -1;
      private var msg:InGameMessage;
      private var msg1:InGameMessage;
      private var msg2:InGameMessage;
      
      public function CampaignTutorial(param1:GameScreen)
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
               util.SummonUnit("Dead",30,param1.team.enemyTeam);
               util.SummonUnit("Spearton",1,param1.team);
               util.SummonUnit("Swordwrath",1,param1.team);
               state++;
               
               break;

            case 0:
               for each(var un:Unit in param1.team.units)
               {
                  util.moveUnit(un, un.px + 25, un.py)
               }
               for each(var un:Unit in param1.team.enemyTeam.units)
               {
                  util.moveUnit(un, un.px + 10, un.py)
               }
               if (!msg)
               {
                  debug.SimulateConsole(12,false);
                  msg = cs.startMsg("How did you even make such noise for all these deads to follow us???", "-Swordwrath");
               }
               else if (!param1.contains(msg))
               {
                  state++;
               }
               break;

            case 1:
               if (!msg1)
               {
                  msg1 = cs.startMsg("I don't know man! it happened so quickly, I didn't have any time to react!", "-Spearton");
               }
               else if(!param1.contains(msg1))
               {
                  cs.addlayer();
                  state++;
               }
               break;

            case 2:
               cs.fadelayer(1, true);
               debug.Log(cs.statelayer(true) + ", " + cs.statelayer(false));
               if (cs.statelayer(true))
               {
                  debug.Log("Added +1 to 'state'");
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
                  state++;
                  cs.removelayer();
               }
               break;
         }
      }
   }
}
