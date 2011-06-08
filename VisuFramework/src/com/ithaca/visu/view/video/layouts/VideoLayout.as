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
				var tempW:int;
				var tempH:int;
				var obj:Object;
				// Horizontal offset, to center the video components
				var offset: int = 0;
				for(var i:int = 0; i < count; i++){
					
					// get the current layout element
					layoutElement = target.getElementAt(i);
					
					//resize the eletement to its preferred size by passing NaN for w/h
					layoutElement.setLayoutBoundsSize(NaN,NaN);
					
					var elementVideo:VideoPanel = layoutElement as VideoPanel;
					
					if((unscaledWidth / unscaledHeight) > (4/3))
					{
						// will add on right side the zoomOut video
						if(elementVideo.zoomIn)
						{
							tempW = getWidthZoomIn(unscaledWidth, count);
							wVideoElement = tempW;
							tempH = wVideoElement * 3 / 4;
							if(tempH > unscaledHeight)
							{
								hVideoElement = unscaledHeight;
								wVideoElement = (hVideoElement/3)*4;
								xVideoElement = (tempW - wVideoElement)/2;
								yVideoElement = 0;
							}else
							{
								hVideoElement = tempH;
								xVideoElement = 0;
								yVideoElement = (unscaledHeight - tempH)/2;
							}
						}else
						{
							obj = getXYWHByPositionByUnscaledWidth(i,count,unscaledWidth, unscaledHeight)
							hVideoElement = obj.h;
							wVideoElement = obj.w;
							xVideoElement = obj.x;
							yVideoElement = obj.y;
						}
					}
					else
					{
						// will add on bottom side the zoomOut video
						if(elementVideo.zoomIn)
						{
							tempH = getHeightZoomIn(unscaledWidth, unscaledHeight,count);
							hVideoElement = tempH;
							tempW = (hVideoElement/3)*4;
							if(tempW > unscaledWidth)
							{
								wVideoElement = unscaledWidth;
								hVideoElement = (wVideoElement/4)*3;
								xVideoElement = 0;
								yVideoElement = (tempH - hVideoElement)/2;
							}else
							{
								xVideoElement = (unscaledWidth - tempW)/2;
								yVideoElement = 0;
								wVideoElement = tempW; 
							}
						}else
						{
							obj = getXYWHByPositionByUnscaledHeight(i,count,unscaledWidth, unscaledHeight)
							hVideoElement = obj.h;
							wVideoElement = obj.w;
							xVideoElement = obj.x;
							yVideoElement = obj.y;	
						}
					}
					layoutElement.setLayoutBoundsSize(wVideoElement, hVideoElement);
					layoutElement.setLayoutBoundsPosition(xVideoElement, yVideoElement);
				}				
			}	
		}
		
		private function getWidthZoomIn(unscaledWidth:int, numVideoPanel:int):int
		{
			var result:int = unscaledWidth;
			switch (numVideoPanel)
			{
				case 3:
					result = (unscaledWidth/6) *4;
					break;
				case 4:
					result = (unscaledWidth/4) *3;
					break;
				case 5:
					result = (unscaledWidth/5) *4;
					break;
				case 6:
				case 7:
					result = (unscaledWidth/3) *2;
					break;
			}
			return result;
		}
		
		private function getHeightZoomIn(unscaledWidth:int, unscaledHeight:int, numVideoPanel:int):int
		{
			var result:int = unscaledHeight;
			switch (numVideoPanel)
			{
				case 3:
					result = unscaledHeight - unscaledWidth*3/8;
					break;
				case 4:
					result = unscaledHeight - unscaledWidth/4;
					break;
				case 5:
					result = unscaledHeight - unscaledWidth*3/16;
					break;
				case 6:
				case 7:
					result = (unscaledHeight/3)*2;
					break;
			}
			return result;
		}
		
		private function getXYWHByPositionByUnscaledHeight(value:int, numVideoPanel:int, unscaledWidth:int, unscaledHeight:int):Object
		{
			var result:Object = new Object();
			var hZoomIn:int = getHeightZoomIn(unscaledWidth, unscaledHeight, numVideoPanel);
			var wZoomIn:int = (wZoomIn/4) * 3;
			result.h = unscaledHeight - hZoomIn;
			result.w = (result.h/3)*4;
			result.y = hZoomIn;
			
			var tempW:int;
			var tempX:int;
			switch(numVideoPanel)
			{
				case 1:
					result.h = hZoomIn;
					result.w = (result.h/3)*4;
					result.x = unscaledWidth - result.w;
					result.y = unscaledHeight - result.h;
				case 2:
					result.h = hZoomIn/4;
					result.w = (result.h/3)*4;
					result.x = unscaledWidth - result.w;
					result.y = unscaledHeight - result.h;
					break;
				case 3:
				case 4:
				case 5:
					tempW = (result.h/3)*4;
					
					tempX = 0;
					if(tempW*(numVideoPanel - 1) > unscaledWidth)
					{
						tempW = unscaledWidth/(numVideoPanel - 1);
						result.h = (tempW/4)*3;
					}else
					{
						tempX = (unscaledWidth - tempW*(numVideoPanel-1))/2;
					}
					result.w = tempW;
					
					result.x = tempW*(value-1) + tempX; 
					break;	
				
				case 6:
				case 7:
					// 3 col and 2 row
					result.h = result.h/2;
					tempW = (result.h/3)*4;
					
					tempX = 0;
					if(tempW*3 > unscaledWidth)
					{
						tempW = unscaledWidth/3;
						result.h = (tempW/4)*3;
					}else
					{
						tempX = (unscaledWidth - tempW*3)/2;
					}
					result.w = tempW;
					
					var deltaY:int = 0;
					if(value > 3)
					{
						value = value - 3;
						deltaY = result.h;
					}
					result.x = tempW*(value-1) + tempX; 
					result.y = result.y + deltaY;
					break;	
			}
			return result;
		}
		
		private function getXYWHByPositionByUnscaledWidth(value:int, numVideoPanel:int, unscaledWidth:int, unscaledHeight:int):Object
		{
			var result:Object = new Object();
			var wZoomIn:int = getWidthZoomIn(unscaledWidth, numVideoPanel);
			var hZoomIn:int = (wZoomIn/4) * 3
			result.w = unscaledWidth - wZoomIn;
			
			result.x = wZoomIn;
			
			var tempH:int;
			var tempY:int;
			switch(numVideoPanel)
			{
				case 1:
					result.w = wZoomIn;
					result.h = (result.w /4)*3;
					result.x = unscaledWidth - result.w;
					result.y = unscaledHeight - result.h;
				case 2:
					result.w = wZoomIn/5;
					result.h = (result.w /4)*3;
					result.x = unscaledWidth - result.w;
					result.y = unscaledHeight - result.h;
					break;
				case 3:
				case 4:
				case 5:
					tempH = (result.w /4)*3;
					tempY = 0;
					if(tempH*(numVideoPanel-1) > unscaledHeight)
					{
						tempH = unscaledHeight/(numVideoPanel-1);
						result.w = (tempH/3)*4;
					}else
					{
						tempY = (unscaledHeight - tempH*(numVideoPanel-1))/2;
					}
					result.h = tempH;
					
					result.y = tempH*(value-1) + tempY; 
					break;	
				case 6:
				case 7:
					// 2 col and 3 row 
					result.w = result.w/2;
					tempH = (result.w /4)*3;
					if(tempH*3 > unscaledHeight)
					{
						tempH = unscaledHeight/3;
						result.w = (tempH/3)*4;
					}else
					{
						tempY = (unscaledHeight - tempH*3)/2;
					}
					result.h = tempH;
					// second row videoPanel
					var deltaX:int = 0;
					if(value > 3)
					{
						value = value - 3;
						deltaX = result.w;
					}
					
					result.y = tempH*(value-1) + tempY; 
					result.x = result.x + deltaX;
					
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

