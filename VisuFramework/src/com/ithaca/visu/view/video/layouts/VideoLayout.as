package com.ithaca.visu.view.video.layouts
{
	
	import com.ithaca.visu.view.video.VideoPanel;
	
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.components.supportClasses.GroupBase;
	import spark.core.NavigationUnit;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class VideoLayout extends LayoutBase
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function VideoLayout()
		{
			super();
		}
		
		public function updateZoom():void
		{
			if (target)
				target.invalidateDisplayList();
		}		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: LayoutBase
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		
		override public function measure():void
		{
			/* var bounds:Point = calculateBounds();
			
			target.measuredWidth = bounds.x;
			target.measuredHeight = bounds.y;*/
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			target.setContentSize(unscaledWidth, unscaledHeight);	

			if(target){
				// set zoomed panel index = 0
				setChildIndexOnZoomInPanel();
				
				var count:int = target.numElements;
				var layoutElement:ILayoutElement;
				var hVideoElement:int;
				var wVideoElement:int;
				var xVideoElement:int;
				var yVideoElement:int;
				// Horizontal offset, to center the video components
				var offset: int = 0;
				for(var i:int = 0; i < count; i++){
					
					// get the current layout element
					layoutElement = target.getElementAt(i);
					
					//resize the eletement to its preferred size by passing NaN for w/h
					layoutElement.setLayoutBoundsSize(NaN,NaN);
					
					var elementVideo:VideoPanel = layoutElement as VideoPanel;

					if(elementVideo.zoomIn)// can see condition i = 0
					{
						hVideoElement = unscaledHeight;
						wVideoElement = unscaledWidth;
						xVideoElement = 0;
						yVideoElement = 0;
						// Normalize component width/height, preserving 4/3 aspect ratio
						if ((unscaledWidth / unscaledHeight) > (4/3))
						{ 
							offset = unscaledWidth;
							wVideoElement = unscaledHeight * 4 / 3;
							offset = int((offset - wVideoElement) / 2);
							xVideoElement = offset;
						}
						else
						{ hVideoElement = unscaledWidth * 3 / 4;}
					}else
					{
						var obj:Object = getXYWHByPosition(i,count)
						hVideoElement = obj.h;
						wVideoElement = obj.w;
						xVideoElement = obj.x;
						yVideoElement = obj.y;
						// Normalize component width/height, preserving 4/3 aspect ratio
						if ((obj.w / obj.h) > (4/3))
						{ 
							wVideoElement = obj.h * 4 / 3;
							var diffX:int = obj.w - wVideoElement;
							xVideoElement = xVideoElement + diffX/2;
						}
						else
						{ hVideoElement = obj.w * 3 / 4; }
					}
					
					layoutElement.setLayoutBoundsSize(wVideoElement, hVideoElement);
					layoutElement.setLayoutBoundsPosition(xVideoElement, yVideoElement);
				}				
			}	
		}
		
		private function getXYWHByPosition(value:int, numVideoPanel:int):Object
		{
			var position:int = 0;
			var temp:int = target.height/4;
			switch(numVideoPanel)
			{
				case 1:
					position = 1;
					break;
				case 2:
					if (value == 1){position = 3}
					break;
				case 3:
					switch(value)
					{
						case 1:
							position = 3;
							break;
						case 2:
							position = 5;
							break;
					}
					break;	
				case 4:
					switch(value)
					{
						case 1:
							position = 3;
							break;
						case 2:
							position = 4;
							break;
						case 3:
							position = 5;
							break;
					}
					break;	
				case 5:
					switch(value)
					{
						case 1:
							position = 2;
							break;
						case 2:
							position = 3;
							break;
						case 3:
							position = 4;
							break;
						case 4:
							position = 5;
							break;
					}
					break;	
				case 6:
					switch(value)
					{
						case 1:
							position = 2;
							break;
						case 2:
							position = 3;
							break;
						case 3:
							position = 4;
							break;
						case 4:
							position = 5;
							break;
						case 5:
							position = 6;
							break;
					}
					break;	
				case 7:
				case 8:
					position = value + 1;
					break;	
				
			}
			var result:Object = new Object();
			result.w = target.width/4; result.h = target.height/4;
			switch(position)
			{
				case 1:
					result.x = 0; result.y = 0+temp; 
					break;
				case 2:
					result.x = 0; result.y = target.height/4+temp; 
					break;
				case 3:
					result.x = 0; result.y = target.height/2+temp; 
					break;
				case 4:
					result.x = target.width/2 - (target.width/3)/2; result.y = target.height/2+temp; 
					break;
				case 5:
					result.x = target.width - result.w;   result.y = target.height/2+temp;
					break;
				case 6:
					result.x =  target.width - result.w;  result.y = target.height/4+temp; 
					break;
				case 7:
					result.x = target.width - result.w;   result.y = 0+temp;
					break;
			}
			return result;
		}
		
		/**
		 * Update deep the zoomed panel at 0(index => 0)
		 */
		private function setChildIndexOnZoomInPanel():void
		{
			var count:int = target.numElements;
			var layoutElement:ILayoutElement;
			var videoPanel:VideoPanel;
			var index:int = -1;
			for(var i:int = 0; i < count; i++)
			{
				layoutElement = target.getElementAt(i);
				videoPanel =  layoutElement as VideoPanel;
				if(videoPanel.zoomIn)
				{
					index = i;
					break;
				}
			}
			if(index > -1 )
			{
				var group:Group = target as Group;
				videoPanel = target.getElementAt(index) as VideoPanel;
				group.setElementIndex(videoPanel,0);
			}
		}
	}
}

