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
package business
{

	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.vo.SGBDObsel;
	import com.ithaca.visu.events.VisuActivityElementEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.Model;
	
	import flash.events.IEventDispatcher;
	
	import modules.TutoratModule;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class TutoratManager
	{
		// properties
		[Bindable]
		public var listActivities:ArrayCollection = new ArrayCollection();
		
		private var logger : ILogger = Log.getLogger('TutoratManager');
		
		private var dispatcher:IEventDispatcher;
		
		private var listTrace:ArrayCollection = new ArrayCollection()
		
		// constructor
		public function TutoratManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
			
		/**
		 * Set activity list 
		 */
		public function onLoadListActivity(arrActivities:Array):void
		{
			if(this.listActivities.length == 0){
				var nbrActivities:uint = arrActivities.length;
				for(var nActivity:uint = 0; nActivity < nbrActivities; nActivity++){
					var obj:Object = arrActivities[nActivity];
					var activity:Activity = new Activity(obj);
					this.listActivities.addItem(activity);
					var activityId:int = obj.id_activity;
					var visuActivtyElementEvent:VisuActivityElementEvent = new VisuActivityElementEvent(VisuActivityElementEvent.LOAD_LIST_ACTIVITY_ELEMENTS);
					visuActivtyElementEvent.activityId = activityId;
					this.dispatcher.dispatchEvent(visuActivtyElementEvent);
				}	
			}
		}
		
		public function onLoadListActivityElement(listActivityElement:Array, activityId:int):void
		{
			// DEBAG MODE without load list activity
			var activity:Activity = this.getActivityById(activityId);
			if(activity != null)
			{
				var nbrActivity:int = activity.getListActivityElement().length;
				if((activity != null) && ( nbrActivity == 0))
				{
					activity.setListActivityElement(listActivityElement);
					listActivities.itemUpdated( activity, activity.activityElements);
					var ev:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.SHOW_LIST_ACTIVITY);
//					ev.listActivity = this.listActivities;
					var modulTutorat:TutoratModule = Model.getInstance().getCurrentTutoratModule() as TutoratModule;
					//modulTutorat.updateView(this.listActivities);
					// FIXME : If using dispatcher => Error : many instances the TutoratModule
					//TypeError: Error #1034: Echec de la contrainte de type : c
					//onversion de com.ithaca.visu.events::VisuActivityEvent@2d2a6191 en com.ithaca.visu.events.VisuActivityEvent impossible.
					//this.dispatcher.dispatchEvent(ev);
				}
			}
		}
		
		public function getMarks(event:Object):void
		{
			var listObsel:Array = event as Array;
			var nbrObsel:Number = listObsel.length;
			for(var nObsel:Number = 0; nObsel < nbrObsel; nObsel++)
			{
				var obselVO:SGBDObsel = listObsel[nObsel];
				
				addObsel(obselVO);
				if(nObsel == 100)
				{
					
				}
			}
			
			creatDoc();
		}
		
		private function creatDoc():void
		{
			var result:String ="<table>";
			var nbrTrace:int = this.listTrace.length;
			for(var nTrace:int = 0 ; nTrace < nbrTrace; nTrace++)
			{
				var trc:Object = this.listTrace[nTrace];
				var listObsel:ArrayCollection = trc.listObsel;
				var tempStr:String = "";
				var nbrObsel:int = listObsel.length;
				for(var nObsel:int = 0 ; nObsel < nbrObsel; nObsel++)
				{
					var obsel:Obsel = listObsel[nObsel];
					tempStr = tempStr + "<tr>";
					if(true)
					{
					 var date:Date = new Date();
					 date.setTime(obsel.begin);		
					 tempStr = tempStr + "<td>"+ date.toString() + "</td>";
					}else
					{
						tempStr = tempStr + "<td>"+ "--" + "</td>";
					}

					 var owner:String = obsel.uid.toString();
					 var text:String = obsel.props["text"];
					 
					 tempStr = tempStr + "<td>"+ owner + "</td>";
					 tempStr = tempStr + "<td>"+ text + "</td>";
					 
				}
				tempStr = tempStr + "</tr>\n";
				result = result+ tempStr;
			}
			
			result = result+ "</table>";
			Alert.show(result,"");
		}
		
		
		
		private function addObsel(value:SGBDObsel):void{
			var obsel:Obsel = Obsel.fromRDF(value.rdf);
			var text:String = obsel.props["text"];
			if(true)
			{
				var nom:String = value.trace;
				var trc:Object = getTrace(nom);
				var listObsel:ArrayCollection = trc.listObsel;
				
				listObsel.addItem(obsel);
			}
		}
		
		private function getTrace(value:String):Object
		{
			var nbrTrace:int = this.listTrace.length;
			for(var nTrace:int = 0 ; nTrace < nbrTrace; nTrace++)
			{
				var trc:Object = this.listTrace[nTrace];
				var nomTrace:String = trc.nom;
				if(value == nomTrace)
				{
					return trc;
				}
			}
			var newTrace:Object = {nom:value , listObsel:new ArrayCollection()};
			this.listTrace.addItem(newTrace);
			return newTrace;
		}
		
			
		public function onErrorgetMarks(event:Object):void
		{
			
		}
		
		
		public function errorGetTrace(event:Object):void
		{
			
		}
		
		public function error(event:Object):void
		{
			
		}
		
		private function getActivityById(value:int):Activity
		{
			var nbrActivity:uint = this.listActivities.length;
			for(var nActivity:uint = 0; nActivity < nbrActivity;nActivity++)
			{
				var activity:Activity = this.listActivities[nActivity];
				var activityId:int = activity.id_activity;
				if(activityId == value)
				{
					return activity;
				}
			}
			return null;
		}
	}
}