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
package com.lyon2.controls.utils
{
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;

    [ResourceBundle("HumanDate")]

    public final class TimeUtils
    {
        private static const ressourceManager:IResourceManager = ResourceManager.getInstance();

        private static var time_table:Array = [
            new TimeUnit(3155760000, /* Siècle */
                ressourceManager.getString('HumanDate', 'short_century'),
                ressourceManager.getString('HumanDate', 'century')),
            new TimeUnit(31557600, /* Année */
                ressourceManager.getString('HumanDate', 'short_year'),
                ressourceManager.getString('HumanDate', 'year')),
            new TimeUnit(2592000, /* Mois */
                ressourceManager.getString('HumanDate', 'short_month'),
                ressourceManager.getString('HumanDate', 'month')),
            new TimeUnit(604800, /* Semaine */
                ressourceManager.getString('HumanDate', 'short_week'),
                ressourceManager.getString('HumanDate', 'week')),
            new TimeUnit(86400, /* Jour */
                ressourceManager.getString('HumanDate', 'short_day'),
                ressourceManager.getString('HumanDate', 'day')),
            new TimeUnit(3600, /* Heure */
                ressourceManager.getString('HumanDate', 'short_hour'),
                ressourceManager.getString('HumanDate', 'hour')),
            new TimeUnit(60, /* minute */
                ressourceManager.getString('HumanDate', 'short_minute'),
                ressourceManager.getString('HumanDate', 'minute')),
            new TimeUnit(1, /* seconde */
                ressourceManager.getString('HumanDate', 'short_second'),
                ressourceManager.getString('HumanDate', 'second'))
            ];

         public static function formatTimeString(numberOfSeconds:Number):String
         {
            if(isNaN(numberOfSeconds)){return '00:00'};
            if(numberOfSeconds) {
            var str:String='';
            var hours:int = numberOfSeconds/3600;
            if(hours>0) {
                str+=hours+':';
            }
            var min:int = (numberOfSeconds%3600)/60;
            if(min<10)
                str+='0';
            str+=min+':';
            var sec:int = (numberOfSeconds%3600)%60;
            if(sec<10)
                str+='0';
            str+=sec;
            return str;
            } else
                return '00:00';
          }

        public static function relativeTime (to:Date, ref:Date=null, short:Boolean=false):String
        {
            ref ||= new Date();
            var diff_abs:Number = Math.abs(to.time - ref.time);
            var futur:Boolean = to.time > ref.time;


            for each (var t:TimeUnit in time_table)
            {
                var rest:Number = int(diff_abs/(t.value*1000));
                var unit:String;
                var message:String;
                if (futur)
                    message = ressourceManager.getString('HumanDate', 'futur');
                else
                    message = ressourceManager.getString('HumanDate', 'past');
                if (rest >= 1)
                {
                    if (rest == 1) unit = short? t.short_unit : t.long_unit.replace(/(\(([^\|)]*)\|?([^\|)]*)\))/,"$2");
                    if (rest > 1) unit = short? t.short_unit : t.long_unit.replace(/(\(([^\|)]*)\|?([^\|)]*)\))/,"$3");
                    return message.split("%d").join(rest+" "+unit).concat(".");
                }
            }
            return "";
        }


        public static function formatHHMM(date:Date):String {
            var s:String = "";
            s+=date.hours;
            s+=":" + asTwoDigitString(date.minutes);
            return s;
        }

        public static function formatHHMMSS(seconds:Number):String {
            var s:String = "";
            var hours:Number = int(seconds/3600);
            var rest:Number = int(seconds%3600);
            var minutes:Number = int(rest/60);
            var seconds:Number = int(rest%60);

            if(hours > 0) {
                s+=hours+":";
            }
            s+=asTwoDigitString(minutes)+":"+asTwoDigitString(seconds);
            return s;
        }

        private static function asTwoDigitString(n:Number):String {
            return (n<10?"0":"")+n;
        }

        public static function formatDDMMYYYY(date:Date):String {
            return asTwoDigitString(date.date) +"-"+asTwoDigitString(date.month +1)+"-"+date.fullYear;
        }

        public static function formatVisuDateTime(date:Date):String {
            var time:String = formatHHMM(date);
            var dateOnly:String = formatDDMMYYYY(date);
            return dateOnly + " " + time;
        }

        public static function compareDates (date1 : Object, date2 : Object) : int
        {
            if(date1==null && date2==null)
                return 0;
            if(date1==null)
                return 1;
            if(date2 == null)
                return -1;

            var date1Timestamp : Number = (date1 as Date).getTime ();
            var date2Timestamp : Number = (date2 as Date).getTime ();

            var result : Number = -1;

            if (date1Timestamp == date2Timestamp)
            {
                result = 0;
            }
            else if (date1Timestamp > date2Timestamp)
            {
                result = 1;
            }

            return result;
        }
    }
}
