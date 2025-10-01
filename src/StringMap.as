package com.brockw.stickwar.campaign.controllers.EasyController
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class StringMap
   {
      private static var unitNames:Array = [
      "miner",
      "swordwrath", 
      "archidon", 
      "spearton", 
      "ninja", "shadowrath", 
      "flyingcrossbowman", "albowtross", 
      "monk", "meric", 
      "magikill", 
      "enslavedgiant",
      "chaosminer", "enslavedminer",
      "bomber",
      "wingidon", "eclipsor",
      "skeletalmage", "marrowkai",
      "dead",
      "cat", "crawler",
      "juggerknight",
      "medusa",
      "giant",
      "earthelement",
      "waterelement",
      "fireelement",
      "airelement",
      "lavaelement", "charrog",
      "hurricaneelement", "cycloid",
      "firestormelement", "infernos",
      "treeelement", "treature",
      "scorpion",
      "chromeelement", "v",
      "minerelement", "chomper"
      ];

      public function StringMap()
      {
         super();
      }
      
      public static function unitNameToType(param1:String) : int
      {
         param1 = param1.toLowerCase();
         param1 = param1.split(" ").join("");
         // Get the best match from fuzzy search
         
         var searchResults:Array = fuzzySearch(param1, unitNames);
         if (searchResults.length > 0) 
         {
            param1 = searchResults[0]; // Use the best match
         }

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
         if(param1 == "ninja" || param1 == "shadowrath")
         {
            return Unit.U_NINJA;
         }
         if(param1 == "flyingcrossbowman" || param1 == "albowtross")
         {
            return Unit.U_FLYING_CROSSBOWMAN;
         }
         if(param1 == "monk" || param1 == "meric")
         {
            return Unit.U_MONK;
         }
         if(param1 == "magikill")
         {
            return Unit.U_MAGIKILL;
         }
         if(param1 == "enslavedgiant")
         {
            return Unit.U_ENSLAVED_GIANT;
         }
         if(param1 == "chaosminer" || param1 == "enslavedminer")
         {
            return Unit.U_CHAOS_MINER;
         }
         if(param1 == "bomber")
         {
            return Unit.U_BOMBER;
         }
         if(param1 == "wingadon" || param1 == "eclipsor")
         {
            return Unit.U_WINGIDON;
         }
         if(param1 == "skelatalmage" || param1 == "marrowkai")
         {
            return Unit.U_SKELATOR;
         }
         if(param1 == "dead")
         {
            return Unit.U_DEAD;
         }
         if(param1 == "cat" || param1 == "crawler")
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
         if(!Loader.instance.isSW2)
         {
            if(param1 == "fireelement")
            {
               return Unit.U_FIRE_ELEMENT;
            }
            if(param1 == "earthelement")
            {
               return Unit.U_EARTH_ELEMENT;
            }
            if(param1 == "waterelement")
            {
               return Unit.U_WATER_ELEMENT;
            }
            if(param1 == "airelement")
            {
               return Unit.U_AIR_ELEMENT;
            }
            if(param1 == "lavaelement"|| param1 == "charrog")
            {
               return Unit.U_LAVA_ELEMENT;
            }
            if(param1 == "hurricaneelement" || param1 == "cycloid")
            {
               return Unit.U_HURRICANE_ELEMENT;
            }
            if(param1 == "firestormelement" || param1 == "infernos")
            {
               return Unit.U_FIRESTORM_ELEMENT;
            }
            if(param1 == "treeelement" || param1 == "treasure")
            {
               return Unit.U_TREE_ELEMENT;
            }
            if(param1 == "scorpion")
            {
               return Unit.U_SCORPION_ELEMENT;
            }
            if(param1 == "chromeelement"|| param1 == "v")
            {
               return Unit.U_CHROME_ELEMENT;
            }
            if(param1 == "minerelement" || param1 == "chomper")
            {
               return Unit.U_MINER_ELEMENT;
            }
         }
         // Debug.instance.error("No match for " + param1, "StringMap");
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
         if(!Loader.instance.isSW2)
         {
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
               return "Treature";
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
         }
         return "{Invalid Value}";
      }

      public static function unitTypeToXML(param1:int, param2:StickWar) : XMLList
      {
         if(param1 == Unit.U_MINER)
         {
            return param2.xml.xml.Order.Units.miner;
         }
         if(param1 == Unit.U_SWORDWRATH)
         {
            return param2.xml.xml.Order.Units.swordwrath;
         }
         if(param1 == Unit.U_ARCHER)
         {
            return param2.xml.xml.Order.Units.archer;
         }
         if(param1 == Unit.U_SPEARTON)
         {
            return param2.xml.xml.Order.Units.spearton;
         }
         if(param1 == Unit.U_NINJA)
         {
            return param2.xml.xml.Order.Units.ninja;
         }
         if(param1 == Unit.U_FLYING_CROSSBOWMAN)
         {
            return param2.xml.xml.Order.Units.flyingCrossbowman;
         }
         if(param1 == Unit.U_MONK)
         {
            return param2.xml.xml.Order.Units.monk;
         }
         if(param1 == Unit.U_MAGIKILL)
         {
            return param2.xml.xml.Order.Units.magikill;
         }
         if(param1 == Unit.U_ENSLAVED_GIANT)
         {
            return param2.xml.xml.Order.Units.giant;
         }
         if(param1 == Unit.U_CHAOS_MINER)
         {
            return param2.xml.xml.Chaos.Units.miner;
         }
         if(param1 == Unit.U_BOMBER)
         {
            return param2.xml.xml.Chaos.Units.bomber;
         }
         if(param1 == Unit.U_WINGIDON)
         {
            return param2.xml.xml.Chaos.Units.wingidon;
         }
         if(param1 == Unit.U_SKELATOR)
         {
            return param2.xml.xml.Chaos.Units.skelator;
         }
         if(param1 == Unit.U_DEAD)
         {
            return param2.xml.xml.Chaos.Units.dead;
         }
         if(param1 == Unit.U_CAT)
         {
            return param2.xml.xml.Chaos.Units.cat;
         }
         if(param1 == Unit.U_KNIGHT)
         {
            return param2.xml.xml.Chaos.Units.knight;
         }
         if(param1 == Unit.U_MEDUSA)
         {
            return param2.xml.xml.Chaos.Units.medusa;
         }
         if(param1 == Unit.U_GIANT)
         {
            return param2.xml.xml.Chaos.Units.giant;
         }
         if(!Loader.instance.isSW2)
         {
            if(param1 == Unit.U_FIRE_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.fireElement;
            }
            if(param1 == Unit.U_EARTH_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.earthElement;
            }
            if(param1 == Unit.U_WATER_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.waterElement;
            }
            if(param1 == Unit.U_AIR_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.airElement;
            }
            if(param1 == Unit.U_LAVA_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.lavaElement;
            }
            if(param1 == Unit.U_HURRICANE_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.hurricaneElement;
            }
            if(param1 == Unit.U_FIRESTORM_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.firestormElement;
            }
            if(param1 == Unit.U_TREE_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.treeElement;
            }
            if(param1 == Unit.U_SCORPION_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.scorpionElement;
            }
            if(param1 == Unit.U_CHROME_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.chrome;
            }
            if(param1 == Unit.U_MINER_ELEMENT)
            {
               return param2.xml.xml.Elemental.Units.miner;
            }
         }
         return null;
      }

      // Gets unit int with whatever data you give it.
      public static function getUnit(data:*) : * 
      {
         if(data is String)
         {
            return unitNameToType(data);
         }
         else if(data is int)
         {
            return data;
         }
         else if(data is Array)
         {
            var arrayToReturn:Array = [];
            for(var i:int = 0; i < data.length; i++)
            {
               arrayToReturn.push(getUnit(data[i]));
            }

            return arrayToReturn;
         }

         debug.error("Type " + data + " is not supported.", "StringMap");
         return null;
      }

      // Fuzzy Search implemantaion
      private static function fuzzySearch(query:String, items:Array):Array 
      {
         if (!query || query.length == 0) {
            return items.slice(); // Return copy of original array
         }
         
         if (items.length == 0) {
            return []; // Can't return anything from empty array
         }
         
         var results:Array = [];
         var queryLower:String = query.toLowerCase();
         var queryLen:int = queryLower.length;
         
         for each (var item:String in items) 
         {
            var score:int = getLevenshteinScore(queryLower, item.toLowerCase(), queryLen);
            results.push({text: item, score: score});
         }
         
         // Sort by score (higher is better)
         results.sortOn("score", Array.NUMERIC | Array.DESCENDING);
         
         // Ensure we always return at least one result (the best match)
         if (results.length == 0) {
            return [items[0]]; // Return first item as fallback
         }
         
         var finalResults:Array = [];
         for each (var result:Object in results) 
         {
            finalResults.push(result.text);
         }
         
         return finalResults;
      }

      private static function getLevenshteinScore(query:String, target:String, queryLen:int):int 
      {
         var targetLen:int = target.length;
         
         // Exact match gets highest score
         if (query == target) {
            return 1000;
         }
         
         // Check for exact substring match
         var substringIndex:int = target.indexOf(query);
         if (substringIndex >= 0) {
            // Prefer matches at the beginning
            return 500 - substringIndex;
         }
         
         // Use simplified Levenshtein distance for fuzzy matching
         var matrix:Array = [];
         var i:int
         var j:int;
         
         // Initialize matrix
         for (i = 0; i <= queryLen; i++) {
            matrix[i] = [];
            matrix[i][0] = i;
         }
         for (j = 0; j <= targetLen; j++) {
            matrix[0][j] = j;
         }
         
         // Fill matrix
         for (i = 1; i <= queryLen; i++) {
            for (j = 1; j <= targetLen; j++) {
                  var cost:int = (query.charAt(i - 1) == target.charAt(j - 1)) ? 0 : 1;
                  matrix[i][j] = Math.min(
                     matrix[i - 1][j] + 1,      // deletion
                     matrix[i][j - 1] + 1,      // insertion
                     matrix[i - 1][j - 1] + cost // substitution
                  );
            }
         }
         
         var distance:int = matrix[queryLen][targetLen];
         
         // Convert distance to score (lower distance = higher score)
         // Always return a score, even for poor matches
         return Math.max(1, 100 - (distance * 5)); // Minimum score of 1
      }
   }
}