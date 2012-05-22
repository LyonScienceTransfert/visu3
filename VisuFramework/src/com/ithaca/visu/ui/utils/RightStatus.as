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
package com.ithaca.visu.ui.utils
{
	public class RightStatus
	{
		public static const CAN_MODIFY_OTHER_SESSION:uint = 12;
		public static const NUMBER_DIGITS_IN_MASK_RIGHT:uint = 20;
		
		public static function hasRight(profilUser:String , rightUser:uint):Boolean
		{
			if( profilUser.charAt(NUMBER_DIGITS_IN_MASK_RIGHT - 1 - rightUser) == '1' ) 
			{
				return true;
			}else return false;
				
		}

		public static function binaryToNumber(binaryString:String=""):Number{
			var result:Number = 0;
			var nbrChar:int = binaryString.length;
			for(var nChar:int = nbrChar; nChar > 0; nChar--){
				var char:String = binaryString.charAt(nChar-1);
				if(char == '1'){
					result = result + numberInNumber(nbrChar - nChar);
				}
			}
			return result;
			function numberInNumber(N:int):Number
			{
				var result:Number = 1;	
				if(N==0)return result;
				for(var i:int = 0 ; i < N; i++ )
				{
					result = result*2;
				}
				return result;
			}
		}
		
		public static function numberToBinary(iNumber:int):String {
			var result :String = "";
			var oNumber : int = iNumber;
			while (iNumber>0) {
				if (iNumber%2) {
					result = "1"+result;
				} else {
					result = "0"+result;
				}
				iNumber = Math.floor(iNumber/2);
			}
			// left pad with zeros
			while (result.length<NUMBER_DIGITS_IN_MASK_RIGHT) {
				result = "0"+result;
			}
			return result;
		};
	}
}