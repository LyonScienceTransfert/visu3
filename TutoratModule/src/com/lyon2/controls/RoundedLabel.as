package com.lyon2.controls
{
	import flash.display.Graphics;
	
	import mx.controls.Label;
	
	public class RoundedLabel extends Label
	{
		public var typeLabel:int;
		
		public function RoundedLabel()
		{
			super();
		}
		
		override protected function updateDisplayList( unscW :Number , unscH :Number ):void
		{
			
			super.updateDisplayList(unscW, unscH );
			
			var borderColor:uint = getStyle( 'borderColor' );
			var fillColors :Array = getStyle( 'fillColors' );
			
			var g:Graphics = graphics;
			g.clear();
			
			drawRoundRect( 0, 0, unscW, unscH, 4 , borderColor , .5 );
			drawRoundRect( 1, 1, unscW - 2  , unscH - 2 , 4 , fillColors , .6, verticalGradientMatrix(0,0, unscH * .5 , 15)  );
			
		}
		
	}
}

