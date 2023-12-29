package com.brockw.stickwar.campaign.controllers.EasyController
{
    import flash.display.*;
    import flash.text.*;
    import flash.ui.*;
    
    public class Draw
    {

        public static const screen_width:Number = 850;

        public static const screen_height:Number = 700;

        public static const width_center:Number = 425;

        public static const height_center:Number = 350;

        public function Draw()
        {
            super();
        }

        public function createTextField(width:Number, height:Number, fontSize:int, color:uint) : TextField 
        {
            var textField:TextField = new TextField();
            
            textField.width = width;
            textField.height = height;
        
            var textFormat:TextFormat = new TextFormat("Arial", int(fontSize), hexToDecimal(color));
            textField.defaultTextFormat = textFormat;
            textField.multiline = true;
            textField.wordWrap = true;

            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.embedFonts = true;
            
            return textField;
        }
        
        public function createRectangle(width:Number, height:Number, color:String, transparency:Number) : Shape 
        {
            var rectangle:Shape = new Shape();
            
            rectangle.graphics.beginFill(hexToDecimal(color), transparency);
            rectangle.graphics.drawRect(0, 0, width, height);
            rectangle.graphics.endFill();
            
            return rectangle;
        }

        public function hexToDecimal(hexColor:String) : uint
        {
            hexColor = hexColor.replace("#", "");
            var red:uint = uint("0x" + hexColor.substr(0, 2));
            var green:uint = uint("0x" + hexColor.substr(2, 2));
            var blue:uint = uint("0x" + hexColor.substr(4, 2));
            
            var decimalColor:uint = (red << 16) | (green << 8) | blue;

            return decimalColor;
        }
    }
}