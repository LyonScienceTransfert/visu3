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
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.ActivityElementType;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.RichEditableText;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("open")]
	[SkinState("normalEditable")]
	
	public class ActivityDetailEdit extends SkinnableComponent
	{
		[SkinPart("true")]
		public var titleActivity:TextInput;
		
		[SkinPart("true")]
		public var statementGroup:Group;

		[SkinPart("true")]
		public var documentGroup:Group;

		[SkinPart("true")] 
		public var keywordGroup:Group;
		
		[SkinPart("true")]
		public var memoDisplay:RichEditableText;
		
		[SkinPart("true")]
		public var durationActivity:NumericStepper;
		
		[SkinPart("true")]
		public var durationActivityLabel:Label;
		
		[SkinPart("true")]
		public var titleActivityLable:Label;
		
		private var open:Boolean;
		private var editabled:Boolean;
		
		private var _activity:Activity; 
		private var activityChanged : Boolean;
		public var memo:String=""; 
		private var memoActivityElement:ActivityElement;
		private var statementList:IList;
		private var documentList:IList; 
		private var keywordList:IList; 
		
		public function ActivityDetailEdit()
		{
			super();
			statementList = new ArrayCollection();
			documentList = new ArrayCollection();
			keywordList = new ArrayCollection();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == titleActivity)
			{
				titleActivity.toolTip = titleActivity.text = _activity.title;
			}
			
			if (instance == titleActivityLable)
			{
				titleActivityLable.text = titleActivityLable.toolTip =   _activity.title;
			}
			
			if (instance == durationActivityLabel)
			{
				durationActivityLabel.text = _activity.duration.toString();
			}
			
			if (instance == durationActivity)
			{
				durationActivity.value = _activity.duration;
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

			if (instance == keywordGroup)
			{
				trace("add keywordGroup");
				if (keywordList.length > 0) 
					addKeywords(keywordList);
			}

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
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (activityChanged)
			{
				activityChanged = false;
				
				parseActivityElements();
				
			}
		}
		
		protected function addStatements(list:IList):void
		{
			for each( var activityElement:ActivityElement in list)
			{
				var statementEdit:StatementEdit = new StatementEdit();
				statementEdit.percentWidth = 100;
				statementEdit.activityElement = activityElement;
				statementEdit.setEditabled(this.editabled);
				statementEdit.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteStatementActivityElement);
				statementEdit.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateStatementActivityElement);
				statementGroup.addElement(statementEdit);
			}
		}
		
		protected function addDocuments(list:IList):void
		{
			for each( var el:ActivityElement in list)
			{
				var document:DocumentEdit = new DocumentEdit()
				document.activityElement = el;
				document.setEditabled(this.editabled);				
				document.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteDocumentActivityElement);
				document.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateDocumentActivityElement);
				documentGroup.addElement(document);
			}
		}

		protected function addKeywords(list:IList):void
		{
			for each( var el:ActivityElement in list)
			{
				var keywordEdit:KeywordEdit = new KeywordEdit();
				keywordEdit.activityElement = el;
				keywordEdit.textKeyword = el.data;
				keywordEdit.setEditabled(this.editabled);
				keywordEdit.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteKeywordActivElement);
				keywordEdit.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateKeywordActivElement);
				keywordGroup.addElement(keywordEdit);			
			}
		}
		
		protected function parseActivityElements():void
		{
			for each (var el:ActivityElement in _activity.getListActivityElement())
			{
				switch(el.type_element)
				{
					case ActivityElementType.MEMO:
						memoActivityElement = el;
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
		
		override protected function getCurrentSkinState():String
		{
			if (!enabled)
			{
				return "disable";
			}else
			if(open){
				if(editabled){
					return "openEditable";
				}else{
					return "open";
				}
			}else
			{
				if(editabled){
					return "normalEditable";
				}else{
					return "normal";
				}
			} 
		}
		
		public function titleDisplay_clickHandler(event:MouseEvent):void
		{
			open = !open;
			invalidateSkinState();
		}
		
		public function setEditabled(value:Boolean):void
		{
			editabled = value;
			this.invalidateProperties();
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
// STATEMENT		
		public function addStatement(value:String):void
		{
			var stObj:Object = new Object();
			stObj.data = value;
			stObj.id_element = 0;
			stObj.type_element =  ActivityElementType.STATEMENT;
			var activityElement:ActivityElement = new ActivityElement(stObj);
			statementList.addItem(activityElement);
			// add activityElement in activity
			this._activity.activityElements.addItem(activityElement);
			
			var addStatementEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_ACTIVITY_ELEMENT);
			addStatementEvent.activity = _activity;
			addStatementEvent.activityElement = activityElement;
			this.dispatchEvent(addStatementEvent);
			
			var statementEdit:StatementEdit = new StatementEdit();
			statementEdit.percentWidth = 100;
			statementEdit.activityElement = activityElement;
			statementEdit.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteStatementActivityElement);
			statementEdit.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateStatementActivityElement);
			statementGroup.addElement(statementEdit);
		}
		// update statement
		private function onUpdateStatementActivityElement(event:SessionEditEvent):void
		{
			var updateActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY_ELEMENT);
			updateActivityElement.activity = _activity;
			updateActivityElement.activityElement = event.activityElement;
			this.dispatchEvent(updateActivityElement);
		}
		// delete statement		
		private function onDeleteStatementActivityElement(event:SessionEditEvent):void
		{
			// delete activityElement from statementList
			var deletingStatement:ActivityElement = event.activityElement;
			var index:int= -1;
			var nbrStatement:int = statementList.length;
			for(var nStatement:int = 0; nStatement < nbrStatement ; nStatement++)
			{
				var statement:ActivityElement = statementList.getItemAt(nStatement) as ActivityElement;
				if(deletingStatement.id_element == statement.id_element)
				{
					index = nStatement;
				}
			}
			if(index == -1)
			{
				Alert.show("You havn't activityElement with title = "+deletingStatement.data,"message error");
			}else{
				statementList.removeItemAt(index);
			}
// TODO update order activity elements !!!
			// delete activityElement from activity
			this.deleteActivityElement(deletingStatement);
			// delete activityElement from statementGroup
			var nbrElement:int = statementGroup.numElements;
			
			for(var nElement:int = 0; nElement < nbrElement; nElement++)
			{
				var statementEdit:StatementEdit = statementGroup.getElementAt(nElement) as StatementEdit;
				if(statementEdit.activityElement.id_element == deletingStatement.id_element)
				{
					statementGroup.removeElementAt(nElement);
					var deletedActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.DELETE_ACTIVITY_ELEMENT);
					deletedActivityElement.activity = _activity;
					deletedActivityElement.activityElement = deletingStatement;
					this.dispatchEvent(deletedActivityElement);
					return;
				}
			}
		}	
// MEMO		
		public function setMessageMemo():void
		{
			memoDisplay.text = "entrer un nouveau memo ici";
			memoDisplay.setStyle("fontStyle","italic");
			memoDisplay.setStyle("color","#000000");
			// add memo if havn't
			if(memoActivityElement == null){
				var stObj:Object = new Object();
				stObj.data = "";
				stObj.type_element =  ActivityElementType.MEMO;
				stObj.id_element = 0;
				memoActivityElement = new ActivityElement(stObj);	
				// add activityElement in activity
				this._activity.activityElements.addItem(memoActivityElement);
				var addMemoEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_ACTIVITY_ELEMENT);
				addMemoEvent.activity = _activity;
				addMemoEvent.activityElement = memoActivityElement;
				this.dispatchEvent(addMemoEvent);	
			}
		}
		// update memo
		public function updateMemo(value:String):void
		{	
			if(memo != value)
			{
				memo = value;
				memoActivityElement.data = value;
				var updateMemoEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY_ELEMENT);
				updateMemoEvent.activity = _activity;
				updateMemoEvent.activityElement = memoActivityElement;
				this.dispatchEvent(updateMemoEvent);	
			}
		}
// DOCUMENT
		public function addDocument(text:String, link:String, type:String):void
		{
			var stObj:Object = new Object();
			stObj.data = text;
			stObj.url_element = link;
			stObj.type_element =  type;
			stObj.id_element = 0;
			var activityElement:ActivityElement = new ActivityElement(stObj);
			documentList.addItem(activityElement);
			// add activityElement in activity
			this._activity.activityElements.addItem(activityElement);
			var addDocumentEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_ACTIVITY_ELEMENT);
			addDocumentEvent.activity = _activity;
			addDocumentEvent.activityElement = activityElement;
			this.dispatchEvent(addDocumentEvent);
			
			var documentEdit:DocumentEdit = new DocumentEdit();
			documentEdit.percentWidth = 100;
			documentEdit.activityElement = activityElement;
			documentEdit.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteDocumentActivityElement);
			documentEdit.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateDocumentActivityElement);
			documentGroup.addElement(documentEdit);
		}
		
		// update document
		private function onUpdateDocumentActivityElement(event:SessionEditEvent):void
		{
			var updateDocumentElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY_ELEMENT);
			updateDocumentElement.activity = _activity;
			updateDocumentElement.activityElement = event.activityElement;
			this.dispatchEvent(updateDocumentElement);
		}
		// delete document
		private function onDeleteDocumentActivityElement(event:SessionEditEvent):void
		{
			// delete from documenList
			var deletingDocument:ActivityElement = event.activityElement;
			var index:int= -1;
			var nbrDocument:int = documentList.length;
			for(var nDocument:int = 0; nDocument < nbrDocument ; nDocument++)
			{
				var document:ActivityElement = documentList.getItemAt(nDocument) as ActivityElement;
				if(deletingDocument.id_element == document.id_element)
				{
					index = nDocument;
				}
			}
			if(index == -1)
			{
				Alert.show("You havn't activityElement with title = "+deletingDocument.data,"message error");
			}else{
				documentList.removeItemAt(index);
			}
			// delete from activity
			this.deleteActivityElement(deletingDocument);
			// delete from documentGroup
			var nbrElement:int = documentGroup.numElements;
			
			for(var nElement:int =0; nElement < nbrElement; nElement++)
			{
				var documentEdit:DocumentEdit = documentGroup.getElementAt(nElement) as DocumentEdit;
				if(documentEdit.activityElement.id_element == deletingDocument.id_element)
				{
					documentGroup.removeElementAt(nElement);
					var deletedActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.DELETE_ACTIVITY_ELEMENT);
					deletedActivityElement.activity = _activity;
					deletedActivityElement.activityElement = deletingDocument;
					this.dispatchEvent(deletedActivityElement);
					return;
				}
			}
			
		}
// KEYWORD	
		public function addKeyword(value:String):void
		{
			var keyObj:Object = new Object();
			keyObj.id_element = 0;
			keyObj.data = value;
			keyObj.type_element =  ActivityElementType.KEYWORD;
			var activityElement:ActivityElement = new ActivityElement(keyObj);
			activity.getListActivityElement().addItem(activityElement);
			var addActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_ACTIVITY_ELEMENT);
			// keyword hasn't activity
			addActivityElement.activity = activity;
			addActivityElement.activityElement = activityElement;
			this.dispatchEvent(addActivityElement);
			
			var keywordEdit:KeywordEdit = new KeywordEdit();
			keywordEdit.textKeyword = value;
			keywordEdit.activityElement = activityElement;
			keywordEdit.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteKeywordActivElement);
			keywordEdit.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateKeywordActivElement);
			keywordGroup.addElement(keywordEdit);
		}
		// delete keyword 
		private function onDeleteKeywordActivElement(event:SessionEditEvent):void
		{
			var deletingKeyword:ActivityElement = event.activityElement;				
			// delet activityElement from activity
			this.deleteActivityElement(deletingKeyword);
			// delete activityElement from keywordGroup
			var nbrElement:int = keywordGroup.numElements;
			
			for(var nElement:int =0; nElement < nbrElement; nElement++)
			{
				var documentEdit:KeywordEdit = keywordGroup.getElementAt(nElement) as KeywordEdit;
				if(documentEdit.activityElement.id_element == deletingKeyword.id_element)
				{
					keywordGroup.removeElementAt(nElement);
					var deletedActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.DELETE_ACTIVITY_ELEMENT);
					// keyword hasn't activity
					deletedActivityElement.activity = null;
					deletedActivityElement.activityElement = deletingKeyword;
					this.dispatchEvent(deletedActivityElement);
					return;
				}
			}
		}
		// update keyword
		private function onUpdateKeywordActivElement(event:SessionEditEvent):void
		{
			var updatedActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY_ELEMENT);
			// keyword hasn't activity
			updatedActivityElement.activity = null;
			updatedActivityElement.activityElement = event.activityElement;
			this.dispatchEvent(updatedActivityElement);
			
		}
// TITRE ACTIVITY
		public function addTitreActivity(value:String):void
		{
			if(_activity.title != value)
			{
				_activity.title = value;
				var changeTitreEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY);
				changeTitreEvent.activity = _activity;
				this.dispatchEvent(changeTitreEvent); 
			}
		}
// DELETE ACTIVITY
		public function deleteActivity():void
		{
			var deleteActivityEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.DELETE_ACTIVITY);
			deleteActivityEvent.activity = _activity;
			this.dispatchEvent(deleteActivityEvent);
		}
// DURATION 
		public function changeDuration(value:Number):void
		{
			_activity.duration = value;
			var changeDurationEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY);
			changeDurationEvent.activity = _activity;
			this.dispatchEvent(changeDurationEvent);	
		}
// DELETE ACTIVITY ELEMENT FROM ACTIVITY
		private function deleteActivityElement(deletingActivityElement:ActivityElement):void
		{
			var indexAr:int = -1;
			var arrActivityElement:ArrayCollection = this._activity.getListActivityElement();
			var nbrActivityElement:int = arrActivityElement.length;
			for(var nActivityElement:int = 0; nActivityElement < nbrActivityElement ; nActivityElement++)
			{
				var activityElement:ActivityElement = arrActivityElement.getItemAt(nActivityElement) as ActivityElement;
				if(deletingActivityElement.id_element == activityElement.id_element)
				{
					indexAr = nActivityElement;
				}
			}
			if(indexAr == -1)
			{
				Alert.show("You havn't activityElement in activity = "+activity.title,"message error");
			}else{
				arrActivityElement.removeItemAt(indexAr);
			}	
		}
	}
}