/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import flash.display.Graphics;
	
	import spark.primitives.supportClasses.FilledElement;
	/**
	 * Draw a Pie primitive
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * 
	 * @example 
	 * <p>The following code draws a Pie primitive</p>
	 * <listing version="3.0" >
	 * &lt;uigfx:Pie 
	 *     angle="60" startAngle="20"
	 *     innerRadius="0.3"
	 *     offset="8" innerOffset="8"
	 *     width="400" height="250" 
	 *     horizontalCenter="0" verticalCenter="0"&gt;
	 *    
	 *     &lt;uigfx:stroke&gt;
	 *         &lt;s:SolidColorStroke color="#222222" /&gt;
	 *     &lt;/uigfx:stroke&gt;
	 *     
	 *     &lt;uigfx:fill&gt;
	 *         &lt;s:SolidColor color="#009EE0" /&gt;
	 *     &lt;/uigfx:fill&gt;
	 * 
	 *     &lt;uigfx:filters&gt;
	 *         &lt;s:DropShadowFilter color="#000000" inner="true" distance="1" blurX="4" blurY="4" quality="3" alpha="0.8" /&gt;
	 *     &lt;/uigfx:filters&gt;
	 *        
	 * &lt;/uigfx:Pie&gt;
	 * </listing>
	 */
	public class Pie extends FilledElement
	{
		/**
		 * Constructor
		 */
		public function Pie()
		{
			super();
		}
		
		private var _startAngle : Number = 0;
		private var _angle : Number = 0;
		
		private var _innerRadius : Number = 0;
		private var _gap : Number = 0;
		
		private var _offset : Number = 0;
		private var _innerOffset : Number = 0;
		
		private var _explosion : Number = 0;
		
		/**
		 * Defines an explode offset for the Pie (from center). Value expressed in pixel
		 */
		public function get explosion():Number
		{
			return _explosion;
		}
		/**
		 * @private
		 */
		public function set explosion(value:Number):void
		{
			_explosion = value;
			invalidateDisplayList();
		}
		
		/**
		 * Defines an external offset for the Pie. Value expressed in pixel
		 */
		public function get offset():Number
		{
			return _offset;
		}
		/**
		 * @private
		 */
		public function set offset(value:Number):void
		{
			_offset = value;
			invalidateDisplayList();
		}
		
		/**
		 * Defines an internal offset for the Pie. Value expressed in pixel
		 */
		public function get innerOffset():Number
		{
			return _innerOffset;
		}
		/**
		 * @private
		 */
		public function set innerOffset(value:Number):void
		{
			_innerOffset = value;
			invalidateDisplayList();
		}
		/**
		 * Defines the start angle (in degree) of the primitive
		 */
		public function get startAngle():Number
		{
			return _startAngle;
		}
		/**
		 * @private
		 */
		public function set startAngle(value:Number):void
		{
			_startAngle = value;
			invalidateDisplayList();
		}
		
		/**
		 * Defines the angle in degree of the primitive
		 */
		public function get angle():Number
		{
			return _angle;
		}
		/**
		 * @private
		 */
		public function set angle(value:Number):void
		{
			if( Math.abs( value ) > 360 ) value = 360;
			_angle = value;
			invalidateDisplayList();
		}
		/**
		 * Defines the inner radius of the primitive. Value is expressed as a percentage, with a number between 0 and 1
		 */
		public function get innerRadius():Number
		{
			return _innerRadius;
		}
		/**
		 * @private
		 */
		public function set innerRadius(value:Number):void
		{
			if( Math.abs( value ) > 1 ) value = 1;
			if( Math.abs( value ) < 0 ) value = 0;
			_innerRadius = value;
			invalidateDisplayList();
		}
		/**
		 * Defines the gap of the Pie. Value is expressed as a degree angle
		 */
		public function get gap():Number
		{
			return _gap;
		}
		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			_gap = value;
			invalidateDisplayList();
		}
		/**
		 * @private
		 */
		private function getCosValue( angle : Number, value : Number ) : Number
		{
			return Math.cos( angle ) * value;
		}
		/**
		 * @private
		 */
		private function getSinValue( angle : Number, value : Number ) : Number
		{
			return Math.sin( angle ) * value;
		}
		
		/**
		 * Draw the primitive
		 */
		override protected function draw(g:Graphics) : void
		{
			var nangle : Number = Math.max( angle-gap, 0) / 180 * Math.PI;    
			var numSegments:Number = Math.ceil(Math.abs(nangle)/ (Math.PI/4) );
			var angleSegment:Number = nangle/numSegments;
			
			var theta:Number = -angleSegment;
			var radAngle : Number = -(startAngle + (gap/2)) / 180 * Math.PI;
			
			var startRadAngle : Number = radAngle;
			
			var midRadAngle : Number;
			
			var controlx:Number;
			var controly:Number;
			var posx:Number;
			var posy:Number;
			
			var xoffset : Number = offset;
			var yoffset : Number = offset;
			
			var xinnerOffset : Number = innerOffset;
			var yinnerOffset : Number = innerOffset;
			
			var xexplosion : Number = explosion;
			var yexplosion : Number = explosion;
			
			if( width > height ) {
				yoffset = height/width * offset;
				yinnerOffset = height/width * innerOffset;
				yexplosion = height/width * explosion;
			}
			if( width < height ) {
				xoffset = width/height * offset;
				xinnerOffset = width/height * innerOffset;
				xexplosion = width/height * explosion;
			}
			
			var centerX : Number = drawX+width/2;
			var centerY : Number = drawY+height/2;
			
			if (numSegments > 0)
			{
				var segCount : Number = 0;
				
				posx =  centerX + getCosValue(radAngle, width/2+xoffset  + xexplosion );
				posy =  centerY + getSinValue(radAngle, height/2+yoffset + yexplosion );
				
				g.moveTo(posx, posy);
				
				for (; segCount < numSegments; segCount++)
				{
					
					radAngle += theta;
					midRadAngle = radAngle - theta / 2;
					
					posx = centerX + getCosValue( radAngle, width/2+xoffset + xexplosion);
					posy = centerY + getSinValue( radAngle, height/2+yoffset + yexplosion);
					
					controlx = centerX + getCosValue( midRadAngle, (width/2+xoffset + xexplosion) / Math.cos(theta / 2));
					controly = centerY + getSinValue( midRadAngle, (height/2+yoffset + yexplosion) / Math.cos(theta / 2));
					
					g.curveTo(controlx, controly, posx, posy);
				}
				
				if( innerRadius > 0 ) {
					posx = centerX + getCosValue( radAngle, Math.max(width*innerRadius/2 - xinnerOffset + xexplosion, 0));
					posy = centerY + getSinValue( radAngle, Math.max(height*innerRadius/2 - yinnerOffset + yexplosion, 0));
					
					if( gap == 0 && angle == 360 ){
						g.moveTo( posx, posy );
					}
					else {
						g.lineTo( posx, posy );
					}
					
					segCount = numSegments;
					for (; segCount>0; segCount--) {
						radAngle -= theta;
						midRadAngle = radAngle + theta / 2;
						
						posx=centerX + getCosValue( radAngle, Math.max(width*innerRadius/2 - xinnerOffset + xexplosion, 0));
						posy=centerY + getSinValue( radAngle, Math.max(height*innerRadius/2 - yinnerOffset + yexplosion, 0));
						
						controlx=centerX + getCosValue( midRadAngle, ( Math.max(width*innerRadius/2 - xinnerOffset + xexplosion, 0)) / Math.cos(theta/2) );
						controly=centerY + getSinValue( midRadAngle, ( Math.max(height*innerRadius/2 - yinnerOffset + yexplosion, 0)) / Math.cos(theta/2) );
						
						g.curveTo( controlx, controly, posx, posy );
					}
					
					if( gap != 0 ) {
						posx = centerX + getCosValue( radAngle, Math.max(width*innerRadius/2 - xinnerOffset + xexplosion, 0));
						posy = centerY + getSinValue( radAngle, Math.max(height*innerRadius/2 - yinnerOffset + yexplosion, 0));
						
						g.lineTo( posx, posy );
					}
				}
					
				else if( gap != 0 || (angle < 360 && angle > 0) ){
					
					g.lineTo( centerX, centerY );
					
				}
				
				if( (angle < 360 && angle > 0) ) {
					g.lineTo( centerX + getCosValue(startRadAngle, width/2+xoffset  + xexplosion ), centerY + getSinValue(startRadAngle, height/2+yoffset + yexplosion ) );
				}
				
				
			}
		}
	}
}