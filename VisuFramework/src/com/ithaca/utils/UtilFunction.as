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
package com.ithaca.utils
{
    import com.adobe.crypto.MD5;
    import com.ithaca.documentarisation.RetroDocumentConst;
    import com.ithaca.visu.model.Model;
    
    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;
    
    import mx.collections.ArrayCollection;
    import mx.utils.URLUtil;


    public class UtilFunction
    {

        private static var fxgt: _FxGettext = FxGettext;

        public static function isEmptyMessage(value: String): Boolean
        {
            return (value.match('^\s*$'));
        }

        public static function getLabelDate(date: Date, separateur: String): String
        {
            if (date == null) return "?";
            var day: int = date.getDate();
            var dayString: String = day.toString();
            if(day < 10){ dayString = "0"+dayString;};
            var month: int = date.getMonth() +1;
            var monthString: String = month.toString();
            if(month < 10){ monthString = "0"+monthString;};
            var result: String = date.getUTCFullYear().toString()+separateur+monthString+separateur+dayString;
            return result;
        }

        public static function getHourMinDate(date: Date): String
        {
            if(date == null) return "?";
            var heureString: String = date.getHours().toString();
            var heure: Number = date.getHours(); if(heure < 10 ){heureString = "0"+heureString;}
            var minuteString: String = date.getMinutes().toString();
            var minute: Number = date.getMinutes(); if(minute < 10 ){minuteString = "0"+minuteString;}
            return heureString+": "+minuteString;
        }

        // example return : 22 Fev 
        public static function getDate(date: Date): String
        {
            if(date == null) return "?";
            var day: int = date.getDate();
            var dayString: String = day.toString();
            if(day < 10){ dayString = "0"+dayString;};
            var monthStringBig: String = getMonthString(date).toLowerCase();
            var monthStringShot: String = StringUtils.firstLetterCap(monthStringBig) + monthStringBig.substr(1,2);
            var result: String = dayString + " "+monthStringShot;
            return result;
        }
        
        // example return : 22 Fev 16: 00
        public static function getDateMonthHourMin(date: Date): String
        {
            if(date == null) return "?";
            var day: int = date.getDate();
            var dayString: String = day.toString();
            if(day < 10){ dayString = "0"+dayString;};
            var monthStringBig: String = getMonthString(date).toLowerCase();
            var monthStringShot: String = StringUtils.firstLetterCap(monthStringBig) + monthStringBig.substr(1,2);
            var result: String = dayString + " "+monthStringShot+" "+ getHourMinDate(date);
            return result;
        }

        // example return : 22 Fev. 2011, à 16: 00
        public static function getDateMonthYearHourMin(date: Date): String
        {
            if(date == null) return "?";
            var day: int = date.getDate();
            var dayString: String = day.toString();
            if(day < 10){ dayString = "0"+dayString;};
            var monthStringBig: String = getMonthString(date).toLowerCase();
            var monthStringShot: String = StringUtils.firstLetterCap(monthStringBig) + monthStringBig.substr(1,2);
            var year: String = date.getFullYear().toString();
            var result: String = dayString + " "+monthStringShot+". "+ year+", à "+ getHourMinDate(date);
            return result;
        }
        // param : minutes
        // example return 22 h 15 min
        //
        public static function getHourMin(value: int): String
        {
            var hourString: String = "0";
            var hour: int = value/60;
            var day: int = hour/24;
            if (hour >= 24 ) { hour = hour - day*24; }
            if(hour > 0){ hourString = hour.toString() };
            var minute: int = value - hour*60 - day*24*60;
            var minuteString: String = minute.toString()
            if(minute < 10 ){minuteString = "0"+minuteString;}
            var result: String = hourString + " h " + minuteString+ " min";
            return result;
        }
        // param : seconds
        // example 188 seconds
        // return mm:ss 
        public static function getMinSec(value:int):String
        {
            if(value && value > 0)
            {
                var minute: int = value / 60 ;
                var minuteString:String = minute.toString();
                if(minute < 10 ){minuteString = "0"+ minuteString};
                var seconds:int = value - minute *60;
                var secondsString:String = seconds.toString();
                if(seconds < 10 ){secondsString = "0"+secondsString};
                var result:String = minuteString+":"+secondsString;
                return result;
            }else
                return "00:00";
        }
        /**
        * param : date 
        * @return : String 
        */
        public static function getDateFormatYYY_MM_DD(date:Date):String{
            var month:uint = date.getMonth()+1;
            var monthString:String = month.toString();
            if(month < 10){
                monthString = '0'+monthString;
            }
            var day:uint = date.date;
            var dayString:String = day.toString();
            if(day < 10){
                dayString = '0'+dayString;
            }
            return date.getFullYear().toString()+"-"+monthString+"-"+dayString;
        }
        /**
        * param : list objects navigateurDay
        * @return : index
        */
        public static function getIndexNewDateNavigatuerDay(list:ArrayCollection, date:Date):int
        {
            var nbrObject:int = list.length;
            for(var nObject:int = 0 ; nObject < nbrObject; nObject++)
            {
                var navigateurDay:Object = list.getItemAt(nObject) as Object;
                var dateNavigateurDay:Date = navigateurDay.fullDate;
                if(date < dateNavigateurDay)
                {
                    return nObject;
                }
            }
            return nbrObject;
        }
        public static function checkVideoId(value: String): Boolean
        {
            var ar: Array=value.split('?');
            if(ar.length==2)
            {
                var params: Object = URLUtil.stringToObject(ar[1],"&");
                if( params.hasOwnProperty("v"))
                {
                    return true;
                }
            }
            return false;
        }

        public static function createRetroDocumentXML(titreDoc: String, descriptionDoc: String, createurDoc: String, createDateDoc: Date, modifyDateDoc: Date): String
        {
            var root: XML = new XML("<"+RetroDocumentConst.TAG_RETROSPECTION_DOCUMENT+"/>");
            var stringTitre: String = "<title><![CDATA["+titreDoc+"]]></title>";
            var titre: XML = new XML(stringTitre);
            root.appendChild(titre);
            var stringDescription: String = "<description><![CDATA["+descriptionDoc+"]]></description>";
            var description: XML = new XML(stringDescription);
            root.appendChild(description);
            var stringCreateur: String = "<creator><![CDATA["+createurDoc+"]]></creator>";
            var createur: XML = new XML(stringCreateur);
            root.appendChild(createur);
            var stringCreateDate: String = "<creation-date><![CDATA["+createDateDoc+"]]></creation-date>";
            var createDate: XML = new XML(stringCreateDate);
            root.appendChild(createDate);
            var stringModifyDate: String = "<last-modified><![CDATA["+modifyDateDoc+"]]></last-modified>";
            var modifyDate: XML = new XML(stringModifyDate);
            root.appendChild(modifyDate);
            var result: String = root.toXMLString();
            result = "<?xml version='1.0' encoding='UTF-8'?>" + result;
            return result;
        }
        public static function getMonthString(date: Date): String
        {
            /* FIXME: should be properly rewritten using DateFormatter */
            var month: Number = date.getMonth();
            var monthNames: Array = [ 
                fxgt.gettext("JANVIER"),
                fxgt.gettext("FÉVRIER"),
                fxgt.gettext("MARS"),
                fxgt.gettext("AVRIL"),
                fxgt.gettext("MAI"),
                fxgt.gettext("JUIN"),
                fxgt.gettext("JUILLET"),
                fxgt.gettext("AOÛT"),
                fxgt.gettext("SEPTEMBRE"),
                fxgt.gettext("OCTOBRE"),
                fxgt.gettext("NOVEMBRE"),
                fxgt.gettext("DÉCEMBRE")
            ];
            return monthNames[month];
        }

        public static function getNumberEntier(value: Number): Number
        {
            var result: String = value.toString();
            result = result.split(".")[0];
            return new Number(result);
        }
        /**
        * criptage the passwor
        * md5(md5(pass)+word)
        */
        public static function getCryptWord(value:String):String
        {
            //var result:String = MD5.hash(MD5.hash(value) + Model.getInstance().server);
			// desactivate MD5 for the test VISU
            var result:String = value;
            return result;
        }
    }
}
