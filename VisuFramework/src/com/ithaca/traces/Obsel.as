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
package com.ithaca.traces
{
	import com.lyon2.visu.vo.ObselVO;
	
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.StringUtil;

    [Bindable]
    public class Obsel extends EventDispatcher 
    {
        public var type: String = "Generic";

        /* Begin and end time */
        public var begin: Number;
        public var end: Number;
		// FIXME , maybe uid => subject
        public var uid: uint = 0;
        /* Dictionary holding the various obsel properties
         * (dependant on the type).
         */
        public var props: Object = new Object();
		
        private static var quote_regexp: RegExp = /"/g;
        private static var eol_regexp: RegExp = /\r/g;

        private static var logger:ILogger = Log.getLogger("com.ithaca.traces.Obsel");

        public function Obsel(my_type: String, uid: int = 0, props: Object=null, begin: Number = 0, end: Number = 0)
        {
            this.type = my_type;
            if (begin == 0)
                begin = new Date().time;
            if (end == 0)
                end = begin;
            this.begin = begin;
            this.end = end;
            this.uid = uid;
            if (props != null)
            {
                // Copy given properties
                for (var prop: String in props)
                    this.props[prop] = props[prop];
            }
        }
       
        /**
         * Convert a turtle representation to its value
         */
        private static function repr2value(s: String, isTime: Boolean = false): *
        {
            var res: *;
            var a: Array;

            if (s == '"[null value]"')
            {
                res = null;
            }
            else
            {
                a = s.match(/^"(.+)"$/);
                if (a)
                {
                    // String
                    res = a[1].replace('\\"', '"').replace('\\n', "\n");
                }
                else
                {
                    a = s.match(/^<(.+)>$/);
                    if (a)
                    {
                        // Reference. Consider as a string for the moment.
                        res = a[1];
                    }
                    else
                    {
                        // Should be an integer
                        res = Number(s);
						// s is an empty string
						if(isNaN(res))
							res = "";
                        //if (isTime)
                        //    res = res / TIME_FACTOR;
                    }
                }
            }
            return res;
        }

        /**
         * Update the Obsel data from a RDF/turtle serialization
         *
         * <p>Some constraints on the formatting: 
         *     * semicolons must end each line (except for lists)
         *     * lists are begun with a single ( as data at the end of a
         *       line, then one value per line, then ended with );
         *     * the obsel must end with a . alone on a line.
         *
         * @param rdf The RDF string
         */
        public function updateFromRDF(rdf: String): void
        {
            var a: Array = null;
            var inData: Boolean = false;
            var listData: Array = null;

            for each (var l: String in rdf.split(/\n/))
            {
                l = StringUtil.trim(l);
                if (l == ".")
                    break;
                //trace("Processing " + l);
                a = l.match(/.+\s+a\s+:(\w+)\s*;/);
                if (a)
                {
                    this.type = a[1];
                    a = null;
                    inData = true;
                    continue;
                }
                if (! inData)
                    continue;
                if (listData)
                {
                    a=l.match(/(.*)\s*\)\s*;$/);
                    if (a)
                    {
                        // End of list
                        if (StringUtil.trim(a[1]).length != 0)
                        {
                            // There is a last item
                            listData.push(repr2value(StringUtil.trim(a[1])));
                        }
                        listData = null;
                        continue;
                    }
                    listData.push(repr2value(l));
                    continue;
                }
                a = l.match(/^(?:ktbs|):has(\w+)\s+(.+?)\s*;?$/);
                if (a)
                {
                    /*
                    for (var i: int = 0 ; i < a.length ; i++)
                    {
                        trace("Property " + i + ": " + a[i]);
                    }
                    */
                    var name: String = a[1].charAt(0).toLowerCase() + a[1].substr(1);
                    var data: String = a[2];
                    if (data == "(")
                    {
                        // Beginning of a list
                        // FIXME: there may be data just after the (, this case is not taken into account here.
                        listData = new Array();
                        this.props[name] = listData;
                        continue;
                    }
                    else switch (name)
                    {
                        case "begin":
                        case "end":
                            // Convert seconds back to ms
                            this[name] = repr2value(data, true)
                            // Let's hope actionscript will use this
                            // break to get out the switch scope, and
                            // not out of the loop.
                            break;
                        case "subject":
                            this.uid = repr2value(data);
                        case "trace":
                            // We should check against the destination trace URI/id
                            break;
                        default:
                            if (name.indexOf("timestamp") > -1)
                                // Time value
                                this.props[name] = repr2value(data, true)
                            else
                                this.props[name] = repr2value(data);
                            break;
                    }
                }
                else
                {
                    logger.error("Error in fromRDF : " + l);
                }

            }
        }


        /**
         * Generate an Obsel from a RDF/turtle serialization
         *
         * See updateFromRDF for constraints on TTL format.
         *
         * @param rdf The RDF string
         *
         * @return The obsel
         */
        public static function fromRDF(data: String): Obsel
        {
            var o: Obsel = new Obsel("Generic");
            o.updateFromRDF(data);
            return o;
        }
		
		override public function toString(): String
		{
			var s: String = "Obsel " + this.type + " [" + this.uid + "] : (" ;
			for (var p: String in this.props)
				s = s + p + "=" + this.props[p].toString().replace("\n", "\\n") + ", "
			s = s + ")"
			return s;
		}
    }
}
