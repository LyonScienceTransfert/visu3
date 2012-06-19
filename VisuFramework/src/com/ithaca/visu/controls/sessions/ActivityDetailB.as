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
package com.ithaca.visu.controls.sessions
{
	import com.ithaca.utils.ExtendToolTip;
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.visu.controls.sessions.skins.KeywordSkin;
	import com.ithaca.visu.controls.sessions.skins.KeywordSkinCorexpert;
	import com.ithaca.visu.controls.sessions.skins.StatementSkin;
	import com.ithaca.visu.controls.sessions.skins.StatementSkinCorexpert;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.ActivityElementType;
	import com.ithaca.visu.ui.utils.IconEnum;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.ToolTipEvent;
	import mx.utils.StringUtil;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	import spark.layouts.VerticalLayout;
	
	[SkinState("normal")]
	[SkinState("open")]
	// Bubling event
	[Event(name="startActivity",type="com.ithaca.visu.events.VisuActivityEvent")]
	
	public class ActivityDetailB extends SkinnableComponent
	{
		
		[SkinPart("true")]
		public var titleDisplay : TextBase;
		
		[SkinPart("true")]
		public var durationDisplay : TextBase;
		
		[SkinPart("true")]
		public var startButton : Button;
		
		[SkinPart("true")]
		public var statementGroup : Group;
		
		[SkinPart("true")]
		public var documentGroup : Group;

		[SkinPart("true")]
		public var keywordGroup : Group;
		
		[SkinPart("false")]
		public var memoDisplay : Label;
		
		private var open:Boolean;
		
		private var _activity:Activity; 
		private var activityChanged : Boolean;
		
		private var statementList:ArrayCollection;
		private var documentList:IList; 
		private var keywordList:IList; 
		private var memo:String=""; 
		private var TOOL_TIPS_IMAGE_WIDTH:int = 160;
		
        [Bindable]
        private var fxgt: _FxGettext = FxGettext;
		
		public function ActivityDetailB()
		{
			super();
            
            // initialisation gettext
            fxgt = FxGettext;
            
			statementList = new ArrayCollection();
			documentList = new ArrayCollection();
			keywordList = new ArrayCollection();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == titleDisplay)
			{
				titleDisplay.addEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			if (instance == durationDisplay)
			{
				durationDisplay.text = StringUtil.substitute(fxgt.gettext('Durée prévue : {0} min'), activity.duration.toString());
			}
			if (instance == startButton)
			{
				startButton.addEventListener(MouseEvent.CLICK,startButton_clickHandler);
			}
			if (instance == statementGroup)
			{
				trace("add statementGroup");
				if (statementList.length > 0)
				{
					sortByOrder(statementList)
					addStatements(statementList);					
				}else
				{
					var labelStatement:Label = new Label();
					labelStatement.text = fxgt.gettext("Aucune consigne n'est définie pour cette activité...");
					statementGroup.addElement(labelStatement);
				}
			}
			
			if (instance == documentGroup)
			{
				trace("add documentGroup");
				if (documentList.length > 0)
				{
					addDocuments(documentList);					
				}else
				{
					var labelDocument:Label = new Label();
					var layout:VerticalLayout = new VerticalLayout();
					documentGroup.layout =  layout;
					labelDocument.text = fxgt.gettext("Aucun document n'est défini pour cette activité...");
					documentGroup.addElement(labelDocument);
				}
			}

			if (instance == keywordGroup)
			{
				trace("add keywordGroup");
				if (keywordList.length > 0)
				{
					addKeywords(keywordList);					
				}else
				{
					var labelKeyword:Label = new Label();
					labelKeyword.text = fxgt.gettext("Aucun mot-clé n'est défini pour cette activité...");
					keywordGroup.height = 30;
					keywordGroup.addElement(labelKeyword);
				}
			}
			
			if (instance == memoDisplay)
			{
				if (_activity != null) memoDisplay.text = memoDisplay.toolTip = memo;
			}
			
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == titleDisplay)
			{
				titleDisplay.removeEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			if (instance == startButton)
			{
				startButton.removeEventListener(MouseEvent.CLICK,startButton_clickHandler);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (activityChanged)
			{
				activityChanged = false;
				
				titleDisplay.toolTip = titleDisplay.text = _activity.title;
				if (durationDisplay) durationDisplay.text = StringUtil.substitute(fxgt.gettext('Durée prévue : {0} min'), activity.duration.toString());
				parseActivityElements();
				
			}
			
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disable" : open? "open" : "normal";
		}
		
		protected function parseActivityElements():void
		{
			for each (var el:ActivityElement in _activity.getListActivityElement())
			{
				switch(el.type_element)
				{
					case ActivityElementType.MEMO:
						memo = el.data;				
						break;
					case ActivityElementType.STATEMENT:					
						statementList.addItem(el);
						break;
					case ActivityElementType.IMAGE:
						documentList.addItem(el);
						break;
					case ActivityElementType.VIDEO:
						documentList.addItem(el);
						break;
					case ActivityElementType.KEYWORD:
						keywordList.addItem(el);
						break;
				}
			}
		}
		protected function addStatements(list:IList):void
		{
			for each( var el:ActivityElement in list)
			{
				var s:ActivityElementDetail = new ActivityElementDetail();
				s.setStyle("skinClass",StatementSkinCorexpert);
				s.percentWidth = 100;
				s.label = el.data;
				s.activityElement = el;
				s.doubleClickEnabled = true;
				statementGroup.addElement(s);
			}
		}
        protected function addDocuments(list:IList):void
        {
            for each( var el:ActivityElement in list)
            {
                var image:ImageActivity = new ImageActivity()
                // image par default
                var source:String = IconEnum.getPathByName("video"); 
                if(el.type_element == "image")
                {
                    source = el.url_element;
                }else
                {
                    // get first frame video 
                    source = VisuUtils.getVideoYoutubeFirstFrame(el.url_element);
                }
                image.source = source;
                image.toolTip = el.data;
                image.activityElement = el;
                image.doubleClickEnabled = true;
                image.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, onToolTipsCreate);
                image.addEventListener(ToolTipEvent.TOOL_TIP_SHOW, onToolTipsShown);
                documentGroup.addElement(image);
            }
        }
		
		protected function addKeywords(list:IList):void
		{
			for each( var el:ActivityElement in list)
			{
				var s:ActivityElementDetail = new ActivityElementDetail();
				s.setStyle("skinClass",KeywordSkinCorexpert);
				s.label = el.data;
				s.activityElement = el;
				s.doubleClickEnabled = true;
				keywordGroup.addElement(s);	
			}
		}
				
		private function onToolTipsCreate(event:ToolTipEvent):void{
			event.toolTip = this.createTip(event.currentTarget.toolTip, event.currentTarget.source);
		} 
		
		private function createTip(tip:String, urlImage:String):ExtendToolTip{
			var imageToolTip:ExtendToolTip = new ExtendToolTip();
			imageToolTip.ImageTip = urlImage;
			imageToolTip.TipText = tip;
			imageToolTip.setSizeImage(TOOL_TIPS_IMAGE_WIDTH);
			return imageToolTip;
		}
		private function onToolTipsShown(event:ToolTipEvent):void{
			var toolTip:ExtendToolTip = event.toolTip as ExtendToolTip;
			toolTip.y = toolTip.y  - TOOL_TIPS_IMAGE_WIDTH;
		}	
		
		[Bindable("activityChanged")]
		public function get activity():Activity
		{
			return _activity;
		}
		
		public function set activity(value:Activity):void
		{
			if( _activity == value) return;
			_activity = value;
			activityChanged = true;
			dispatchEvent( new Event("activityChanged"));
			invalidateProperties();
		}
		public function titleDisplay_clickHandler(event:MouseEvent):void
		{
			open = !open;
			invalidateSkinState();
		}
		protected function startButton_clickHandler(event:MouseEvent):void
		{
			var e:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.START_ACTIVITY);
			e.activity = activity;
			dispatchEvent(e);
			if( open == false )
			{
				open = true;
				invalidateSkinState();
			}
		}
		
		// SORT by order
		private function sortByOrder(list:ArrayCollection):void
		{
			var sort:Sort = new Sort();
			// There is only one sort field, so use a null first parameter.
			sort.fields = [new SortField("order_activity_element", true)];
			list.sort = sort;
			list.refresh();
		}
	}
}