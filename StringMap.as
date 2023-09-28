package com.brockw.stickwar.campaign.controllers.EasyController
{
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class StringMap
   {

      var units:Array = ["miner", "swordwrath", "archidon", "meric", "magikill", "spearton", "shadowrath", "albowtross", "egiant", "eminer", "crawler", "dead", "marrowkai", "medusa", "bomber", "juggerknight", "eclipsor", "giant", "earth", "water", "air", "fire", "treasure", "infernos", "cycloid", "scorpion", "v", "chomper"];

      public function StringMap()
      {
         super();
      }

      function LevenshteinDistance(s1:String, s2:String) : int 
      {
         var distance:Array = new Array(s1.length + 1);

         for (var i:int = 0; i <= s1.length; i++) 
         {
            distance[i] = new Array(s2.length + 1);
            distance[i][0] = i;
         }

         for (var j:int = 0; j <= s2.length; j++) 
         {
            distance[0][j] = j;
         }

         for (var i:int = 1; i <= s1.length; i++) 
         {
            for (var j:int = 1; j <= s2.length; j++) {
                  var cost:int = (s1.charAt(i - 1) == s2.charAt(j - 1)) ? 0 : 1;
                  distance[i][j] = Math.min(
                     Math.min(distance[i - 1][j] + 1, distance[i][j - 1] + 1),
                     distance[i - 1][j - 1] + cost
                  );
            }
         }

         return distance[s1.length][s2.length];
      }

      function DetermineUnit(name:String) : String
      {
         var minDistance:int = int.MAX_VALUE;
         var bestMatch:String = null;

         for each (var unit:String in units) 
         {
            var distance:int = LevenshteinDistance(name.toLowerCase(), unit.toLowerCase());
            if (distance < minDistance) 
            {
               minDistance = distance;
               bestMatch = unit;
            }
         }

         return bestMatch;
      }
      
      public static function unitNameToType(param1:String) : int
      {
        param1 = DetermineUnit(param1);
         if(param1 == "miner")
         {
            return Unit.U_MINER;
         }
         if(param1 == "swordwrath")
         {
            return Unit.U_SWORDWRATH;
         }
         if(param1 == "archidon")
         {
            return Unit.U_ARCHER;
         }
         if(param1 == "spearton")
         {
            return Unit.U_SPEARTON;
         }
         if(param1 == "shadowwrath")
         {
            return Unit.U_NINJA;
         }
         if(param1 == "albowtross")
         {
            return Unit.U_FLYING_CROSSBOWMAN;
         }
         if(pparam1 == "meric")
         {
            return Unit.U_MONK;
         }
         if(param1 == "magikill")
         {
            return Unit.U_MAGIKILL;
         }
         if(param1 == "egiant")
         {
            return Unit.U_ENSLAVED_GIANT;
         }
         if(param1 == "eminer")
         {
            return Unit.U_CHAOS_MINER;
         }
         if(param1 == "bomber")
         {
            return Unit.U_BOMBER;
         }
         if(param1 == "eclipsor")
         {
            return Unit.U_WINGIDON;
         }
         if(param1 == "marrowkai")
         {
            return Unit.U_SKELATOR;
         }
         if(param1 == "dead")
         {
            return Unit.U_DEAD;
         }
         if(param1 == "crawler")
         {
            return Unit.U_CAT;
         }
         if(param1 == "juggerknight")
         {
            return Unit.U_KNIGHT;
         }
         if(param1 == "medusa")
         {
            return Unit.U_MEDUSA;
         }
         if(param1 == "giant")
         {
            return Unit.U_GIANT;
         }
         if(param1 == "fire")
         {
            return Unit.U_FIRE_ELEMENT;
         }
         if(param1 == "earth")
         {
            return Unit.U_EARTH_ELEMENT;
         }
         if(param1 == "water")
         {
            return Unit.U_WATER_ELEMENT;
         }
         if(param1 == "air")
         {
            return Unit.U_AIR_ELEMENT;
         }
         if(param1 == "lava")
         {
            return Unit.U_LAVA_ELEMENT;
         }
         if(param1 == "cycloid")
         {
            return Unit.U_HURRICANE_ELEMENT;
         }
         if(param1 == "infernos")
         {
            return Unit.U_FIRESTORM_ELEMENT;
         }
         if(param1 == "treasure")
         {
            return Unit.U_TREE_ELEMENT;
         }
         if(param1 == "scorpion")
         {
            return Unit.U_SCORPION_ELEMENT;
         }
         if(param1 == "v")
         {
            return Unit.U_CHROME_ELEMENT;
         }
         if(param1 == "chomper")
         {
            return Unit.U_MINER_ELEMENT;
         }
         return -1;
      }
      
      public static function unitTypeToName(param1:int) : String
      {
         if(param1 == Unit.U_MINER)
         {
            return "Miner";
         }
         if(param1 == Unit.U_SWORDWRATH)
         {
            return "Swordwrath";
         }
         if(param1 == Unit.U_ARCHER)
         {
            return "Archidon";
         }
         if(param1 == Unit.U_SPEARTON)
         {
            return "Spearton";
         }
         if(param1 == Unit.U_NINJA)
         {
            return "Shadowrath";
         }
         if(param1 == Unit.U_FLYING_CROSSBOWMAN)
         {
            return "Albowtross";
         }
         if(param1 == Unit.U_MONK)
         {
            return "Meric";
         }
         if(param1 == Unit.U_MAGIKILL)
         {
            return "Magikill";
         }
         if(param1 == Unit.U_ENSLAVED_GIANT)
         {
            return "Enslaved Giant";
         }
         if(param1 == Unit.U_CHAOS_MINER)
         {
            return "Enslaved Miner";
         }
         if(param1 == Unit.U_BOMBER)
         {
            return "Bomber";
         }
         if(param1 == Unit.U_WINGIDON)
         {
            return "Eclipsor";
         }
         if(param1 == Unit.U_SKELATOR)
         {
            return "Marrowkai";
         }
         if(param1 == Unit.U_DEAD)
         {
            return "Dead";
         }
         if(param1 == Unit.U_CAT)
         {
            return "Crawler";
         }
         if(param1 == Unit.U_KNIGHT)
         {
            return "Juggerknight";
         }
         if(param1 == Unit.U_MEDUSA)
         {
            return "Medusa";
         }
         if(param1 == Unit.U_GIANT)
         {
            return "Giant";
         }
         if(param1 == Unit.U_FIRE_ELEMENT)
         {
            return "Fire Elemental";
         }
         if(param1 == Unit.U_EARTH_ELEMENT)
         {
            return "Earth Elemental";
         }
         if(param1 == Unit.U_WATER_ELEMENT)
         {
            return "Water Elemental";
         }
         if(param1 == Unit.U_AIR_ELEMENT)
         {
            return "Air Elemental";
         }
         if(param1 == Unit.U_LAVA_ELEMENT)
         {
            return "Charrog";
         }
         if(param1 == Unit.U_HURRICANE_ELEMENT)
         {
            return "Cycloid";
         }
         if(param1 == Unit.U_FIRESTORM_ELEMENT)
         {
            return "Infernos";
         }
         if(param1 == Unit.U_TREE_ELEMENT)
         {
            return "Treasure";
         }
         if(param1 == Unit.U_SCORPION_ELEMENT)
         {
            return "Scorpion";
         }
         if(param1 == Unit.U_CHROME_ELEMENT)
         {
            return "V";
         }
         if(param1 == Unit.U_MINER_ELEMENT)
         {
            return "Chomper";
         }
         return "{Target Is Not a Unit}";
      }
   }
}