/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
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

package com.ithaca.visu.view.session.controls
{
	import com.ithaca.visu.controls.sessions.ActivityElementDetail;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.ActivityElementType;
	import com.ithaca.visu.view.session.controls.skins.StatementEditSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("open")]
	
	public class ActivityDetailEdit extends SkinnableComponent
	{
		[SkinPart("true")]
		public var titleActivity:TextInput;
		
		[SkinPart("true")]
		public var statementGroup:Group;

		[SkinPart("true")]
		public var documentGroup:Group;

		[SkinPart("true")]
		public var memoDisplay:RichEditableText;
		
		private var open:Boolean;
		
		private var _activity:Activity; 
		private var activityChanged : Boolean;
		public var memo:String=""; 
		private var statementList:IList;
		private var documentList:IList; 
		
		public function ActivityDetailEdit()
		{
			super();
			statementList = new ArrayCollection();
			documentList = new ArrayCollection();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == titleActivity)
			{
				titleActivity.text = "ghghghgh";
				//titleDisplay.addEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			
			if (instance == statementGroup)
			{
				trace("add statementGroup");
				if (statementList.length > 0) 
					addStatements(statementList);
			}
			
			if (instance == documentGroup)
			{
				trace("add documentGroup");
				if (documentList.length > 0) 
					addDocuments(documentList);
			}
			
	/*		
			if (instance == titleDisplay)
			{
				titleDisplay.addEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			if (instance == durationDisplay)
			{
				durationDisplay.text = "Durée prévue : " +activity.duration.toString();
			}
			if (instance == startButton)
			{
				startButton.addEventListener(MouseEvent.CLICK,startButton_clickHandler);
			}
			if (instance == statementGroup)
			{
				trace("add statementGroup");
				if (statementList.length > 0) 
					addStatements(statementList);
			}
			
			if (instance == documentGroup)
			{
				trace("add documentGroup");
				if (documentList.length > 0) 
					addDocuments(documentList);
			}
			*/
			if (instance == memoDisplay)
			{
				if (_activity != null)
				{
					if(memo != "")
					{
						memoDisplay.text = memoDisplay.toolTip = memo;
					}else
					{
						setMessageMemo();
					}
				}
			}
			
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
/*			if (instance == titleDisplay)
			{
				titleDisplay.removeEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			if (instance == startButton)
			{
				startButton.removeEventListener(MouseEvent.CLICK,startButton_clickHandler);
			}*/
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (activityChanged)
			{
				activityChanged = false;
				
				titleActivity.toolTip = titleActivity.text = _activity.title;
			//	if (durationDisplay) durationDisplay.text = "Durée prévue : " + _activity.duration.toString();
				parseActivityElements();
				
			}
			if(open)
			{
			/*	var pl:DocumentEdit = new DocumentEdit();
				statementGroup.addElement(pl);*/
/*				var statementEdit:KeywordEdit = new KeywordEdit();
				statementGroup.addElement(statementEdit);*/
/*				var statementEdit:StatementEdit = new StatementEdit();
				statementEdit.percentWidth = 100;
				statementGroup.addElement(statementEdit);*/
			}
		}
		protected function addStatements(list:IList):void
		{
			for each( var activityElement:ActivityElement in list)
			{
				var statementEdit:StatementEdit = new StatementEdit();
				statementEdit.percentWidth = 100;
				statementEdit.activityElement = activityElement;
				statementGroup.addElement(statementEdit);
			}
		}
		
		protected function addDocuments(list:IList):void
		{
			for each( var el:ActivityElement in list)
			{
				var document:DocumentEdit = new DocumentEdit()
				document.activityElement = el;
				documentGroup.addElement(document);
			}
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
				}
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disable" : open? "open" : "normal";
		}
		
		public function titleDisplay_clickHandler(event:MouseEvent):void
		{
			open = !open;
			invalidateSkinState();
			//invalidateProperties();
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
		
		public function addStatement(value:String):void
		{
			// TODO dispatcher
			var stObj:Object = new Object();
			stObj.data = "Statement activity" + " : "+ value;
			stObj.type_element =  ActivityElementType.STATEMENT;
			var activityElement:ActivityElement = new ActivityElement(stObj);
			statementList.addItem(activityElement);
		
			var statementEdit:StatementEdit = new StatementEdit();
			statementEdit.percentWidth = 100;
			statementEdit.activityElement = activityElement;
			statementGroup.addElement(statementEdit);
		}
// MEMO		
		public function setMessageMemo():void
		{
			memoDisplay.text = "entrer un nouveau memo ici";
			memoDisplay.setStyle("fontStyle","italic");
			memoDisplay.setStyle("color","#BBBBBB");
		}
		public function addMemo(value:String):void
		{
			// TODO dispatcher
			memo = value;
		}
	}
}