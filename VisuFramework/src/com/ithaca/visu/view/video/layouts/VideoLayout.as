/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
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
		private var _zoomMax:Boolean = false;
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
			// set zoomIn
			_zoomMax  = true;
			if (target)
				target.invalidateDisplayList();
			
		}	
		public function set zoomMax(value:Boolean):void
		{
			_zoomMax = value;
			if (target)
				target.invalidateDisplayList();
		}
		public function get zoomMax():Boolean
		{
			return _zoomMax;
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
				setChildIndexOnZoomInPanel(0);
				
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
					// mode zoom max
					if(zoomMax)
					{
						if((unscaledWidth / unscaledHeight) > (4/3))
						{
							// will add on right side the zoomOut video
							if(elementVideo.zoomIn)
							{
								tempW = getWidthZoomMax(unscaledWidth, count);
								wVideoElement = tempW;
								tempH = wVideoElement * 3 / 4;
								// for one stream
								if(count == 1)
								{
									if(tempH > unscaledHeight)
									{
										hVideoElement = unscaledHeight;
										wVideoElement = (hVideoElement/3)*4;
									}else
									{
										hVideoElement = tempH;
									}
									xVideoElement = (unscaledWidth - wVideoElement)/2 ;
									yVideoElement = (unscaledHeight - hVideoElement)/2;
								}else
								if (count == 4) // all videos has same size
								{
									tempW = unscaledWidth/2;
									tempH = (tempW/4)*3;
									if(tempH*2 > unscaledHeight )
									{
										hVideoElement = unscaledHeight/2;
										wVideoElement = (hVideoElement/3)*4
									}else
									{
										hVideoElement = tempH;
									}
									xVideoElement = ((unscaledWidth - wVideoElement*2)/3)*2 + wVideoElement ;
									yVideoElement = (unscaledHeight - hVideoElement*2)/2 + hVideoElement;
								}else
								if (count == 6) // all videos has same size
								{
									tempW = unscaledWidth/3;
									tempH = (tempW/4)*3;
									if(tempH*2 > unscaledHeight )
									{
										hVideoElement = unscaledHeight/2;
										wVideoElement = (hVideoElement/3)*4
									}else
									{
										hVideoElement = tempH;
									}
									xVideoElement = ((unscaledWidth - wVideoElement*3)/4)*3 + wVideoElement*2;
									yVideoElement = (unscaledHeight - hVideoElement*2)/2 + hVideoElement;
								}else
								if (count == 8 || count == 9) // all videos has same size
								{
									tempW = unscaledWidth/3;
									tempH = (tempW/4)*3;
									if(tempH*3 > unscaledHeight )
									{
										hVideoElement = unscaledHeight/3;
										wVideoElement = (hVideoElement/3)*4
									}else
									{
										hVideoElement = tempH;
									}
									xVideoElement = ((unscaledWidth - wVideoElement*3)/4)*3 + wVideoElement*2 ;
									yVideoElement = (unscaledHeight - hVideoElement*3)/2 + hVideoElement*2;
								}else
								if(count == 3) // superposition Video
								{
									wVideoElement = (unscaledWidth/8)*2;
									hVideoElement = (wVideoElement/4)*3;
									xVideoElement =  unscaledWidth/2 - wVideoElement/2
									yVideoElement = unscaledHeight - hVideoElement;
								}else
								if(count == 5) // superposition Video
								{
									wVideoElement = unscaledWidth/8;
									hVideoElement = (wVideoElement/4)*3;
									xVideoElement =  unscaledWidth/2 - wVideoElement/2
									yVideoElement = unscaledHeight - hVideoElement;
								}else
								{
									if(tempH > unscaledHeight/3)
									{
										hVideoElement = unscaledHeight/3;
										wVideoElement = (hVideoElement/3)*4;
									}else
									{
										hVideoElement = tempH;
									}
									xVideoElement = unscaledWidth - wVideoElement ;
									yVideoElement = unscaledHeight - hVideoElement;
								}
							}else
							{
								obj = getXYWHByPositionByUnscaledWidthMax(i,count,unscaledWidth, unscaledHeight)
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
								tempH = getHeightZoomMax(unscaledWidth, unscaledHeight,count);
								hVideoElement = tempH;
								tempW = (hVideoElement/3)*4;
								if(count == 1)
								{
									if(tempW > unscaledWidth)
									{
										wVideoElement = unscaledWidth;
										hVideoElement = (wVideoElement/4)*3;
									}
									xVideoElement = (unscaledWidth - wVideoElement)/2 ;
									yVideoElement = (unscaledHeight - hVideoElement)/2;
								}else
								if(count == 3) // superposition Video
								{
									hVideoElement = unscaledHeight/4;
									wVideoElement = (hVideoElement/3)*4;
									xVideoElement =  unscaledWidth - wVideoElement;
									yVideoElement = unscaledHeight - hVideoElement;
								}else
								if (count == 4) // all videos has same size
								{
									tempW = unscaledWidth/2;
									tempH = (tempW/4)*3;
									if(tempH*2 > unscaledHeight )
									{
										hVideoElement = unscaledHeight/2;
										wVideoElement = (hVideoElement/3)*4
									}else										{
										hVideoElement = tempH;
										wVideoElement = tempW;
									}
									xVideoElement = ((unscaledWidth - wVideoElement*2)/3)*2 + wVideoElement ;
									yVideoElement = ((unscaledHeight - hVideoElement*2)/3)*2 + hVideoElement;
								}else
								if(count == 5) // superposition Video
								{
									wVideoElement = unscaledWidth/4;
									hVideoElement = (wVideoElement/4)*3;
									xVideoElement =  unscaledWidth/2 - wVideoElement/2
									yVideoElement = unscaledHeight - hVideoElement;
								}else
								if (count == 6) // all videos has same size
								{
									tempW = unscaledWidth/2;
									tempH = (tempW/4)*3;
									if(tempH*3 > unscaledHeight )
									{
										hVideoElement = unscaledHeight/3;
										wVideoElement = (hVideoElement/3)*4
									}else
									{
										hVideoElement = tempH;
										wVideoElement = tempW;
									}
									xVideoElement = ((unscaledWidth - wVideoElement*2)/3)*2 + wVideoElement;
									yVideoElement = (unscaledHeight - hVideoElement*3)/4 + hVideoElement*2;
								}else
								if (count == 8) // all videos has same size
								{
									tempW = unscaledWidth/2;
									tempH = (tempW/4)*3;
									if(tempH*4 > unscaledHeight )
									{
										hVideoElement = unscaledHeight/4;
										wVideoElement = (hVideoElement/3)*4
									}else
									{
										hVideoElement = tempH;
										wVideoElement = tempW;
									}
									xVideoElement = ((unscaledWidth - wVideoElement*2)/3)*2 + wVideoElement;
									yVideoElement = (unscaledHeight - hVideoElement*4)/5 + hVideoElement*3;
								}else
								if(count == 9) // superposition Video
								{
									hVideoElement = unscaledHeight/8;
									wVideoElement = (hVideoElement/3)*4;
									xVideoElement =  unscaledWidth - wVideoElement
									yVideoElement = unscaledHeight - hVideoElement;
								}else
								if(count == 10) // superposition Video
								{
									hVideoElement = unscaledHeight/6;
									wVideoElement = (hVideoElement/3)*4;
									xVideoElement =  unscaledWidth - wVideoElement
									yVideoElement = unscaledHeight - hVideoElement;
								}else
								{
									if(tempW > unscaledWidth/4)
									{
										wVideoElement = unscaledWidth/4;
										hVideoElement = (wVideoElement/4)*3;
										
									}else
									{
										wVideoElement = tempW; 
									}
									xVideoElement = unscaledWidth - wVideoElement ;
									yVideoElement = unscaledHeight - hVideoElement;
								}
							}else
							{
								obj = getXYWHByPositionByUnscaledHeightMax(i,count,unscaledWidth, unscaledHeight)
								hVideoElement = obj.h;
								wVideoElement = obj.w;
								xVideoElement = obj.x;
								yVideoElement = obj.y;	
							}
						}
					}else
					// mode zoom in	
					{
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
									if(count == 2){xVideoElement = 0}
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
									if(count ==2){yVideoElement = 0};
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
					}
					layoutElement.setLayoutBoundsSize(wVideoElement, hVideoElement);
					layoutElement.setLayoutBoundsPosition(xVideoElement, yVideoElement);
				}				
			}
			if(zoomMax)
			{
				// set zoomed VideoPanel over others
				setChildIndexOnZoomInPanel(count-1);
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
				case 8:
				case 9:
				case 10:
					result = (unscaledWidth/7) *4;
					break;
			}
			return result;
		}
		
		private function getWidthZoomMax(unscaledWidth:int, numVideoPanel:int):int
		{
			var result:int = unscaledWidth;
			switch (numVideoPanel)
			{
				case 2:
					result = unscaledWidth/5;
					break;
				case 3:
					result = unscaledWidth/2;
					break;
				case 4:
					result = unscaledWidth/4;
					break;
				case 5:
					result = unscaledWidth/2;
					break;
				case 6:
					result = unscaledWidth/8;
					break;
				case 7:
					result = unscaledWidth/10;
					break;
				case 8:
					result = unscaledWidth/10;
					break;
				case 9:
					result = unscaledWidth/10;
					break;
				case 10:
					result = unscaledWidth/10;
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
				case 7:
				case 8:
				case 9:
				case 10:
					result = unscaledHeight/2;
					break;
			}
			return result;
		}
		
		private function getHeightZoomMax(unscaledWidth:int, unscaledHeight:int, numVideoPanel:int):int
		{
			var result:int = unscaledHeight;
			switch (numVideoPanel)
			{
			case 2:
				result = unscaledHeight/4;
				break;
			case 3:
				result = unscaledHeight/7;
				break;
			case 4:
				result = unscaledHeight/7;
				break;
			case 5:
				result = unscaledHeight/7;
				break;
			case 6:
				result = unscaledHeight/8;
				break;
			case 7:
			case 8:
			case 9:
			case 10:
				result = unscaledHeight/7;
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
			
			var deltaY:int = 0;
			
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
					
					if(value > 3)
					{
						value = value - 3;
						deltaY = result.h;
					}
					result.x = tempW*(value-1) + tempX; 
					result.y = result.y + deltaY;
					break;	
				case 8:
				case 9:
				case 10:
					// 3 col and 3 row
					result.h = result.h/3;
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
					if(value > 6)
					{
						value = value - 6;
						deltaY = result.h*2;
					}else
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
			var deltaX:int = 0;
			
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
					if(value > 3)
					{
						value = value - 3;
						deltaX = result.w;
					}
					result.y = tempH*(value-1) + tempY; 
					result.x = result.x + deltaX;
					break;
				case 8:
				case 9:
				case 10:
					// 3 coll and 3 row
					result.w = result.w/3;
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
					if(value > 6)
					{
						value = value - 6;
						deltaX = result.w*2;
					}else 
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
		private function getXYWHByPositionByUnscaledWidthMax(value:int, numVideoPanel:int, unscaledWidth:int, unscaledHeight:int):Object
		{
			var result:Object = new Object();
			var wZoomIn:int = getWidthZoomMax(unscaledWidth, numVideoPanel);
			var hZoomIn:int = (wZoomIn/4) * 3;
			
			if(hZoomIn > unscaledHeight/3)
			{
				hZoomIn = unscaledHeight/3;
				wZoomIn = (hZoomIn/3)*4;
			}
			var hForAllMax:int = unscaledHeight - hZoomIn;
			
			result.w = unscaledWidth - wZoomIn;
			
			result.x = 0;
			var deltaX:int = 0;
			var deltaY:int = 0;
			var koeff:int = 0;
			var tempH:int;
			var tempY:int;
			var div3:int = value/3;
			switch(numVideoPanel)
			{
				case 1:
					result.w = wZoomIn;
					result.h = (result.w /4)*3;
					result.x = unscaledWidth - result.w;
					result.y = unscaledHeight - result.h;
					break;
				case 2:
					result.w = unscaledWidth - wZoomIn;
					result.h = (result.w /4)*3;
					if(result.h > unscaledHeight)
					{
						result.h = unscaledHeight;
						result.w = (result.h/3)*4
					}
					result.x = (unscaledWidth - wZoomIn - result.w)/2;
					result.y = unscaledHeight - result.h;
					break;
				case 3:
					result.w = unscaledWidth/2;
					result.h = (result.w/4)*3;
					if(result.h > unscaledHeight )
					{
						result.h = unscaledHeight;
						result.w = (result.h/3)*4
					}
					deltaX = (unscaledWidth - result.w*2)/3;
					result.x =  deltaX*(value) + result.w*(value-1);
					result.y = (unscaledHeight - result.h)/3;
					break;
				case 4:
				case 5:
					result.w = unscaledWidth/2;
					result.h = (result.w/4)*3;
					if(result.h*2 > unscaledHeight )
					{
						result.h = unscaledHeight/2;
						result.w = (result.h/3)*4
					}
					deltaX = (unscaledWidth - result.w*2)/3;
					deltaY = (unscaledHeight - result.h*2)/3;
					koeff = 1;
					if(value%2 > 0 ){koeff = 0};
					result.x =  deltaX*(koeff+1) + result.w*(koeff);
					result.y = (unscaledHeight - result.h*2)/2 + result.h*(div3) + deltaY*(div3 + 1);
					break;	
				case 6:
					result.w = unscaledWidth/3;
					result.h = (result.w/4)*3;
					if(result.h*2 > unscaledHeight )
					{
						result.h = unscaledHeight/2;
						result.w = (result.h/3)*4
					}
					deltaX = (unscaledWidth - result.w*3)/4;
					deltaY = (unscaledHeight - result.h*2)/3;
					switch(value)
					{
					case 1:
					case 4:
						koeff = 0;
						break;
					case 2:
					case 5:
						koeff = 1;
						break;
					case 3:
					case 6:
						koeff = 2;
						break;
					}
					result.x =  deltaX*(koeff+1) + result.w*(koeff);
					result.y = (unscaledHeight - result.h*2)/2 +  result.h*(int((value-1)/3)) + deltaY*(int((value-1)/3) + 1);
					break;
				case 7:
					result.w = (unscaledWidth - wZoomIn)/3;
					result.h = (result.w/4)*3;
					if(result.h*2 > unscaledHeight )
					{
						result.h = unscaledHeight/2;
						result.w = (result.h/3)*4
					}
					deltaX = (unscaledWidth - result.w*3 - wZoomIn)/4;
					deltaY = (unscaledHeight - result.h*2)/3;
					switch(value)
					{
					case 1:
					case 4:
						koeff = 0;
						break;
					case 2:
					case 5:
						koeff = 1;
						break;
					case 3:
					case 6:
						koeff = 2;
						break;
					}
					result.x =  deltaX*(koeff+1) + result.w*(koeff);
					result.y = (unscaledHeight - result.h*2)/3 +  result.h*(int((value-1)/3)) + deltaY*(int((value-1)/3) + 1);
					break;
				case 8:
				case 9:
					result.w = unscaledWidth/3;
					result.h = (result.w/4)*3;
					if(result.h*3 > unscaledHeight )
					{
						result.h = unscaledHeight/3;
						result.w = (result.h/3)*4
					}
					deltaX = (unscaledWidth - result.w*3)/4;
					deltaY = (unscaledHeight - result.h*3)/4;
					switch(value)
					{
					case 1:
					case 4:
					case 7:
						koeff = 0;
						break;
					case 2:
					case 5:
					case 8:
						koeff = 1;
						break;
					case 3:
					case 6:
					case 9:
						koeff = 2;
						break;
					}
					result.x =  deltaX*(koeff+1) + result.w*(koeff);
					result.y = (unscaledHeight - result.h*3)/2 +  result.h*(int((value-1)/3)) + deltaY*(int((value-1)/3) + 1);
					break;
				case 10:
					// 3 coll x 3row +1 
					result.w = (unscaledWidth - wZoomIn)/3;
					result.h = (result.w/4)*3;
					if(result.h*3 > unscaledHeight )
					{
						result.h = unscaledHeight/3;
						result.w = (result.h/3)*4
					}
					deltaX = ((unscaledWidth - wZoomIn) - result.w*3)/4;
					deltaY = (unscaledHeight - result.h*3)/4;

					switch(value)
					{
						case 1:
						case 4:
						case 7:
							koeff = 0;
							break;
						case 2:
						case 5:
						case 8:
							koeff = 1;
							break;
						case 3:
						case 6:
						case 9:
							koeff = 2;
							break;
					}
					result.x =  deltaX*(koeff+1) + result.w*(koeff);
					result.y = (unscaledHeight - result.h*3)/2 +  result.h*(int((value-1)/3)) + deltaY*(int((value-1)/3) + 1);
					break;
			}
			return result;
		}
		private function getXYWHByPositionByUnscaledHeightMax(value:int, numVideoPanel:int, unscaledWidth:int, unscaledHeight:int):Object
		{
			var result:Object = new Object();
			var hZoomIn:int = getHeightZoomMax(unscaledWidth, unscaledHeight, numVideoPanel);
			var wZoomIn:int = (hZoomIn/3) * 4;
			if(wZoomIn > unscaledWidth/4)
			{
				wZoomIn = unscaledWidth/4;
				hZoomIn = (wZoomIn/4)*3;
			}
			result.h = unscaledHeight - hZoomIn;
			result.w = (result.h/3)*4;
			result.y = hZoomIn;
			var div3:int = value/3;
			var hForAllMax:int = unscaledHeight - hZoomIn;
			
			var deltaY:int = 0;
			var deltaX:int = 0;
			var koeff:int = 0;
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
				result.h = hForAllMax; 
				result.w = (result.h/3)*4;
				if(result.w > unscaledWidth)
				{
					result.w = 	unscaledWidth;
					result.h = (result.w/4)*3
				}
				result.x = (unscaledWidth - result.w)/2;
				result.y = (unscaledHeight - result.h - hZoomIn)/2;
				break;
			case 3:
				result.h = unscaledHeight/2;
				result.w = (result.h/3)*4;
				if(result.w > unscaledWidth )
				{
					result.w = 	unscaledWidth;
					result.h = (result.w/4)*3
				}
				deltaY = (unscaledHeight - result.h*2)/3;
				result.y =  deltaY*(value) + result.h*(value-1);
				result.x = (unscaledWidth - result.w)/3;
				break;
			case 4:
			case 5:
				result.w = unscaledWidth/2;
				result.h = (result.w/4)*3;
				if(result.h*2 > unscaledHeight )
				{
					result.h = unscaledHeight/2;
					result.w = (result.h/3)*4
				}
				deltaX = (unscaledWidth - result.w*2)/3;
				deltaY = (unscaledHeight - result.h*2)/3;
				koeff = 1;
				if(value%2 > 0 ){koeff = 0};
				result.x =  deltaX*(koeff+1) + result.w*(koeff);
				result.y = result.h*(div3) + deltaY*(div3 + 1);
				break;	
/*			case 4:
				result.h = hForAllMax/3;
				result.w = (result.h/3)*4;
				if(result.w > unscaledWidth )
				{
					result.w = 	unscaledWidth;
					result.h = (result.w/4)*3
				}
				deltaY = (unscaledHeight - result.h*3)/4;
				result.y =  deltaY*(value) + result.h*(value-1);
				result.x = (unscaledWidth - result.w)/2;
				break;
			case 5:
				result.h = hForAllMax/4;
				result.w = (result.h/3)*4;
				if(result.w > unscaledWidth )
				{
					result.w = 	unscaledWidth;
					result.h = (result.w/4)*3
				}
				deltaY = (unscaledHeight - result.h*4)/4;
				result.y =  deltaY*(value) + result.h*(value-1);
				result.x = (unscaledWidth - result.w)/2;
				break;*/	
			
			case 6:
			case 7:
				result.w = unscaledWidth/2;
				result.h = (result.w/4)*3;
				if(result.h*3 > unscaledHeight)
				{
					result.h = (unscaledHeight)/3;
					result.w = (result.h/3)*4
				}
				deltaX = (unscaledWidth - result.w*2)/3;
				deltaY = (unscaledHeight - result.h*3)/4;
				koeff = 1;
				if(value%2 > 0 ){koeff = 0};
				result.x =  deltaX*(koeff+1) + result.w*(koeff);
				
				var val3:int = (value-1)/2
				var rr:int = result.h*(val3)
				var dd:int = deltaY*(val3 + 1)
				result.y = (unscaledHeight - result.h*3)/4 +  rr + dd;
				// FIXME : can move block with 6 video on right side
				break;
			case 8:
			case 9:
				result.w = unscaledWidth/2;
				result.h = (result.w/4)*3;
				if(result.h*4 > unscaledHeight )
				{
					result.h = unscaledHeight/4;
					result.w = (result.h/3)*4
				}
				deltaX = (unscaledWidth - result.w*2)/3;
				deltaY = (unscaledHeight - result.h*4)/3;
				koeff = 1;
				if(value%2 > 0 ){koeff = 0};
				result.x =  deltaX*(koeff+1) + result.w*(koeff);
				result.y = (unscaledHeight - result.h*4)/2 +  result.h*(int((value-1)/2)) + deltaY*(int((value-1)/2) + 1);
				break;
			case 10:
				// 3 coll x 3row +1 
				result.w = (unscaledWidth)/3;
				result.h = (result.w/4)*3;
				if(result.h*3 > unscaledHeight )
				{
					result.h = unscaledHeight/3;
					result.w = (result.h/3)*4
				}
				deltaX = ((unscaledWidth) - result.w*3)/4;
				deltaY = (unscaledHeight - result.h*3)/4;
				
				switch(value)
				{
				case 1:
				case 4:
				case 7:
					koeff = 0;
					break;
				case 2:
				case 5:
				case 8:
					koeff = 1;
					break;
				case 3:
				case 6:
				case 9:
					koeff = 2;
					break;
				}
				result.x =  deltaX*(koeff+1) + result.w*(koeff);
				result.y = (unscaledHeight - result.h*3)/4 +  result.h*(int((value-1)/3)) + deltaY*(int((value-1)/3));
				break;
			}
			return result;
		}		
		/**
		 * Update deep the zoomed panel at 0(index => 0)
		 */
		private function setChildIndexOnZoomInPanel(newIndex:int):void
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
				group.setElementIndex(videoPanel,newIndex);
			}
		}
	}
}

