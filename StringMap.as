package com.brockw.stickwar.campaign.controllers.EasyController
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class StringMap
   {
      public function StringMap()
      {
         super();
      }
      
      public static function unitNameToType(param1:String) : int
      {
        param1 = param1.toLowerCase();
        param1 = param1.split(" ").join("");
         if(param1 == "miner")
         {
            return Unit.U_MINER;
         }
         if(param1 == "swordwrath" || param1 == "sword" || param1 == "swordman")
         {
            return Unit.U_SWORDWRATH;
         }
         if(param1 == "archidon" || param1 == "archer" || param1 == "arch")
         {
            return Unit.U_ARCHER;
         }
         if(param1 == "spearton" || param1 == "spear")
         {
            return Unit.U_SPEARTON;
         }
         if(param1 == "ninja" || param1 == "shadow" || param1 == "shadowrath" || param1 == "shadowwrath")
         {
            return Unit.U_NINJA;
         }
         if(param1 == "flyingcrossbowman" || param1 == "albowtross" || param1 == "albow" || param1 == "crossbowman")
         {
            return Unit.U_FLYING_CROSSBOWMAN;
         }
         if(param1 == "monk" || param1 == "meric")
         {
            return Unit.U_MONK;
         }
         if(param1 == "magikill" || param1 == "magi" || param1 == "magik")
         {
            return Unit.U_MAGIKILL;
         }
         if(param1 == "enslavedgiant" || param1 == "egiant")
         {
            return Unit.U_ENSLAVED_GIANT;
         }
         if(param1 == "chaosminer" || param1 == "minerchaos" || param1 == "cminer" || param1 == "minerc" || param1 == "enslavedminer" || param1 == "eminer")
         {
            return Unit.U_CHAOS_MINER;
         }
         if(param1 == "bomber" || param1 == "bomb")
         {
            return Unit.U_BOMBER;
         }
         if(param1 == "wingadon" || param1 == "eclipsor" || param1 == "wing" || param1 == "eclips")
         {
            return Unit.U_WINGIDON;
         }
         if(param1 == "skelatalmage" || param1 == "skele" || param1 == "marrowkai" || param1 == "marrow")
         {
            return Unit.U_SKELATOR;
         }
         if(param1 == "dead" || param1 == "ded")
         {
            return Unit.U_DEAD;
         }
         if(param1 == "cat" || param1 == "crawler" || param1 == "crawl")
         {
            return Unit.U_CAT;
         }
         if(param1 == "knight" || param1 == "juggerknight" || param1 == "jugg")
         {
            return Unit.U_KNIGHT;
         }
         if(param1 == "medusa" || param1 == "medu")
         {
            return Unit.U_MEDUSA;
         }
         if(param1 == "giant")
         {
            return Unit.U_GIANT;
         }
         if(param1 == "fireelement" || param1 == "fireele" || param1 == "fire")
         {
            return Unit.U_FIRE_ELEMENT;
         }
         if(param1 == "earthelement" || param1 == "earthele" || param1 == "earth")
         {
            return Unit.U_EARTH_ELEMENT;
         }
         if(param1 == "waterelement" || param1 == "waterele" || param1 == "water")
         {
            return Unit.U_WATER_ELEMENT;
         }
         if(param1 == "airelement" || param1 == "airele" || param1 == "air")
         {
            return Unit.U_AIR_ELEMENT;
         }
         if(param1 == "lavaelement" || param1 == "lavaele" || param1 == "charrog" || param1 == "lava")
         {
            return Unit.U_LAVA_ELEMENT;
         }
         if(param1 == "hurricaneelement" || param1 == "hurricaneele" || param1 == "cycloid" || param1 == "hurricane")
         {
            return Unit.U_HURRICANE_ELEMENT;
         }
         if(param1 == "firestormelement" || param1 == "firestormele" || param1 == "infernos" || param1 == "firestorm")
         {
            return Unit.U_FIRESTORM_ELEMENT;
         }
         if(param1 == "treeelement" || param1 == "treeele" || param1 == "treasure" || param1 == "tree")
         {
            return Unit.U_TREE_ELEMENT;
         }
         if(param1 == "scorpionelement" || param1 == "scorpionele" || param1 == "scorpion" || param1 == "scorp")
         {
            return Unit.U_SCORPION_ELEMENT;
         }
         if(param1 == "chromeelement" || param1 == "chromeele" || param1 == "v" || param1 == "chrome")
         {
            return Unit.U_CHROME_ELEMENT;
         }
         if(param1 == "minerelement" || param1 == "minerele" || param1 == "chomper" || param1 == "chomp" || param1 == "eminer")
         {
            return Unit.U_MINER_ELEMENT;
         }
         Debug.instance.error("No match for " + param1, "StringMap")
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

      public static function setUnitType(param1:Unit, param2:String) : void
      {
         if(param1.type == Unit.U_MINER)
         {
            param1.minerType = param2;
         }
         if(param1.type == Unit.U_SWORDWRATH)
         {
            param1.swordwrathType = param2;
         }
         if(param1.type == Unit.U_ARCHER)
         {
            param1.archerType = param2;
         }
         if(param1.type == Unit.U_SPEARTON)
         {
            param1.speartonType = param2;
         }
         if(param1.type == Unit.U_NINJA)
         {
            param1.ninjaType = param2;
         }
         if(param1.type == Unit.U_FLYING_CROSSBOWMAN)
         {
            param1.flyingCrossbowmanType = param2;
         }
         if(param1.type == Unit.U_MONK)
         {
            param1.monkType = param2;
         }
         if(param1.type == Unit.U_MAGIKILL)
         {
            param1.magikillType = param2;
         }
         if(param1.type == Unit.U_ENSLAVED_GIANT)
         {
            param1.enslavedgiantType = param2;
         }
         if(param1.type == Unit.U_CHAOS_MINER)
         {
            param1.chaosminerType = param2;
         }
         if(param1.type == Unit.U_BOMBER)
         {
            param1.bomberType = param2;
         }
         if(param1.type == Unit.U_WINGIDON)
         {
            param1.wingidonType = param2;
         }
         if(param1.type == Unit.U_SKELATOR)
         {
            param1.skelatorType = param2;
         }
         if(param1.type == Unit.U_DEAD)
         {
            param1.deadType = param2;
         }
         if(param1.type == Unit.U_CAT)
         {
            param1.catType = param2;
         }
         if(param1.type == Unit.U_KNIGHT)
         {
            param1.knightType = param2;
         }
         if(param1.type == Unit.U_MEDUSA)
         {
            param1.medusaType = param2;
         }
         if(param1.type == Unit.U_GIANT)
         {
            param1.giantType = param2;
         }
         if(param1.type == Unit.U_FIRE_ELEMENT)
         {
            param1.fireElementType = param2;
         }
         if(param1.type == Unit.U_EARTH_ELEMENT)
         {
            param1.earthElementType = param2;
         }
         if(param1.type == Unit.U_WATER_ELEMENT)
         {
            param1.waterElementType = param2;
         }
         if(param1.type == Unit.U_AIR_ELEMENT)
         {
            param1.airElementType = param2;
         }
         if(param1.type == Unit.U_LAVA_ELEMENT)
         {
            param1.lavaElementType = param2;
         }
         if(param1.type == Unit.U_HURRICANE_ELEMENT)
         {
            param1.hurricaneElementType = param2;
         }
         if(param1.type == Unit.U_FIRESTORM_ELEMENT)
         {
            param1.infernosType = param2;
         }
         if(param1.type == Unit.U_SCORPION_ELEMENT)
         {
            param1.scorpType = param2;
         }
         if(param1.type == Unit.U_CHROME_ELEMENT)
         {
            param1.chromeElementType = param2;
         }
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
         return null;
      }
   }
}