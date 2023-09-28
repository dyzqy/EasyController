package com.brockw.stickwar.campaign.controllers.EasyController
{
    import flash.display.*;
    import flash.text.*;
    import flash.ui.*;
    
    public class Draw
    {

        public static const screen_width:String = 850;

        public static const screen_height:String = 700;

        public static const width_center:String = 425;

        public static const height_center:String = 350;

        public function Draw()
        {
            super();
        }

        function createTextField(width:Number, height:Number, fontSize:int color:uint) : TextField 
        {
            var textField:TextField = new TextField();
            
            textField.width = width;
            textField.height = height;
        
            var textFormat:TextFormat = new TextFormat("Arial", int(fSize), hexToDecimal(color));
            textField.defaultTextFormat = textFormat;
            textField.multiline = true;
            textField.wordWrap = true;

            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.embedFonts = true;
            
            return textField;
        }

        function createRectangle(width:Number, height:Number, color:string, transparency:Number) : Shape 
        {
            var rectangle:Shape = new Shape();
            
            rectangle.graphics.beginFill(hexToDecimal(color), transparency);
            rectangle.graphics.drawRect(0, 0, width, height);
            rectangle.graphics.endFill();
            
            return rectangle;
        }

        function hexToDecimal(hexColor:String) : uint
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