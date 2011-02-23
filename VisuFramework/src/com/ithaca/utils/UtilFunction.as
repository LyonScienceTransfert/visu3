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
package com.ithaca.utils
{
	import com.ithaca.documentarisation.RetroDocumentConst;
	
	import mx.utils.URLUtil;

	public class UtilFunction
	{
		public static function isEmptyMessage(value:String):Boolean
		{
			var nbrChar:int = value.length;
			for(var nChar:int = 0; nChar < nbrChar ; nChar++)
			{
				var char:String = value.charAt(nChar);
				if(char != " ")
				{
					return false;
				}
			}
			return true;
		}
		
		public static function getLabelDate(date:Date,separateur:String):String
		{
			var day:int = date.getDate();
			var dayString:String = day.toString();
			if(day < 10){ dayString = "0"+dayString;};
			var mount:int = date.getMonth() +1;
			var mountString:String = mount.toString();
			if(mount < 10){	mountString = "0"+mountString;};
			var result:String = date.getUTCFullYear().toString()+separateur+mountString+separateur+dayString;
			return result;
		}
		
		public static function getHeurMinDate(date:Date):String
		{
			var heureString:String = date.getHours().toString();
			var  heure:Number = date.getHours(); if(heure < 10 ){heureString = "0"+heureString;}
			var minuteString:String = date.getMinutes().toString();
			var  minute:Number = date.getMinutes(); if(minute < 10 ){minuteString = "0"+minuteString;}
			return heureString+":"+minuteString;
		}
		
		public static function checkVideoId(value:String):Boolean
		{
			var ar:Array=value.split('?');
			if(ar.length==2)
			{
				var params:Object = URLUtil.stringToObject(ar[1],"&");	 		
				if( params.hasOwnProperty("v"))
				{
					return true;
				}
			}
			return false;
		}
		
		public static function createRetroDocumentXML(titreDoc:String, descriptionDoc:String, createurDoc:String, createDateDoc:Date, modifyDateDoc:Date):String
		{
			var root:XML = new XML("<"+RetroDocumentConst.TAG_RETROSPECTION_DOCUMENT+"/>");	
			var stringTitre:String = "<title>"+titreDoc+"</title>";
			var titre:XML = new XML(stringTitre);
			root.appendChild(titre);
			var stringDescription:String = "<description>"+descriptionDoc+"</description>";
			var description:XML = new XML(stringDescription);
			root.appendChild(description);
			var stringCreateur:String = "<creator>"+createurDoc+"</creator>";
			var createur:XML = new XML(stringCreateur);
			root.appendChild(createur);
			var stringCreateDate:String = "<creation-date>"+createDateDoc+"</creation-date>";
			var createDate:XML = new XML(stringCreateDate);
			root.appendChild(createDate);
			var stringModifyDate:String = "<last-modified>"+modifyDateDoc+"</last-modified>";
			var modifyDate:XML = new XML(stringModifyDate);
			root.appendChild(modifyDate);
			var result:String = root.toXMLString();
			result = "<?xml version='1.0' encoding='UTF-8'?>" + result;
			return result;
		}
		
	}
}