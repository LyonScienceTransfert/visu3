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

package com.lyon2.utils;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import com.ithaca.domain.model.Obsel;

public class UserColor {

	
	public static Map<Integer,Integer> setMapUserColor(List<Obsel> listObsel)
	{
		Map<Integer,Integer> listUserCodeColor = new HashMap<Integer,Integer>(); 
		Integer nbrObsel = listObsel.size();
		for(Integer nObsel = 0; nObsel < nbrObsel ; nObsel++)
		{
			Obsel obsel = listObsel.get(nObsel);
			String obselRdf = obsel.getRdf();
			List <Integer> listUser = getListParams(obselRdf, "hasPresentids");
			List <Integer> listColor = getListParams(obselRdf, "hasPresentcolorscode");
			listUserCodeColor = addObselUserColor(listUser, listColor, listUserCodeColor);		
		}
		return listUserCodeColor;
	}
	
	public static Map<Integer,Integer> addObselUserColor(List <Integer> listUser, List <Integer> listColor, Map<Integer,Integer> listUserCodeColor )
	{
		Integer nbrElement = listUser.size();
    	for(Integer nElement = 0; nElement < nbrElement ; nElement++)
    	{
    		// check if element existe 
    		Integer userId = listUser.get(nElement);
    		Integer codeColor = listColor.get(nElement);
    		if(!listUserCodeColor.containsKey(userId))
    		{
    			listUserCodeColor.put(userId, codeColor);    			
    		}
    	}
    	return listUserCodeColor;
	}
	
	
    public static List<Integer> getListParams(String obselRdf, String nameParam )
    {
    	List<Integer> result= new ArrayList<Integer>();
    	nameParam = nameParam + " (";
    	Boolean calcul= false;
    	for(String temp : obselRdf.split(":"))
    	{ 		
    		for( String par : temp.split("\n"))
    		{
    			Integer nbrChars= par.length()-1;					
    			if(calcul && nbrChars > 2)
    			{
   					String tStr="";
   					// has sumbol tab and new line >> \n\t
   					for(Integer nChar=2; nChar < nbrChars ; nChar++)
    				{
   						char ch = par.charAt(nChar); 						
    					if(ch == ')')
    					{
    						calcul = false;
    						break;
    					}						
    					tStr=tStr+ch;
    				}
    				Integer nbr = Integer.parseInt(tStr);   	
    				result.add(nbr);
    			}
    			if(par.equals(nameParam))
    			{
    				calcul = true;
   				}
    		}		
   			calcul = false;    		
    	}
    	return result;
   }
    
    public static Integer getMaxCodeColor(Map <Integer,Integer> mapCodeColor)
    {
    	Integer result = 0;
    	for (Integer key : mapCodeColor.keySet()){
    		Integer codeColor = mapCodeColor.get(key);
    		result = Math.max(result, codeColor);
    	}
    	return result;
    }
}
