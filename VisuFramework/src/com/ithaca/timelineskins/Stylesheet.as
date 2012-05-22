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
package com.ithaca.timelineskins
{
import com.ithaca.timeline.ObselSkin;
import com.ithaca.timeline.TraceLine;
import com.ithaca.timeline.TraceLineGroup;
import com.ithaca.timeline.skins.IconSkin;
import com.ithaca.timeline.ISelector;
import com.ithaca.traces.Obsel;
import com.ithaca.visu.model.Model;

import flash.events.Event;

import mx.events.FlexEvent;

public class Stylesheet
{
	static private var tracelineGroupColorIndex : uint = 0;
	static public var ZoomContextInitPercentWidth : Number = 30;
	static public var renderersSidePadding : Number = 25;
	
	public var obselsSkinsSelectors : Array = new Array();
	
	public function Stylesheet()
	{
	}	
	
	public function getParameteredSkin( obsel : Obsel, traceline :TraceLine ) : ObselSkin
	{
		var obselSkin : ObselSkin = new ObselSkin( obsel, traceline );
		for each ( var item : Object in obselsSkinsSelectors )
		if ( (item.selector as ISelector).isObselMatching( obsel ) )
		{
			obselSkin.styleName = item.id;
			if(item.id == "Marker")
			{
				// check if can edit marker
				if(Model.getInstance().canEditObsel(obsel))
				{
					obselSkin.editable = true;
				}
			}
			break;
		}
		
		return obselSkin;
	}
	
	static public function getTracelineGroupColor( tlg : TraceLineGroup ) : uint
	{
		var fillColors : Array = tlg.getStyle( "fillColors" ) as Array;	
		return fillColors[ tracelineGroupColorIndex++ % fillColors.length ] ;
	}		
	
}
}