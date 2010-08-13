/*
 * LocalFilesystemService.as
 * This file is part of Actionscript GNU Gettext
 *
 * Copyright (C) 2009 - Vincent Petithory
 *
 * Actionscript GNU Gettext is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Actionscript GNU Gettext is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Actionscript GNU Gettext; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, 
 * Boston, MA  02110-1301  USA
 */
package gnu.as3.gettext.services 
{
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;

	import gnu.as3.gettext.parseMOBytes;
	import gnu.as3.gettext.MOFile;
	
/*	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;*/
	
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

    public class LocalFilesystemService 
								extends EventDispatcher 
								implements IGettextService 
    {
        public function LocalFilesystemService(baseURL:String = null)
        {
            super();
            if (baseURL)
                this._baseURL = baseURL;
        }
        
        private var _baseURL:String;
        
        public function get baseURL():String
        {
            return _baseURL;
        }
        
        private var _domainName:String;
        
        public function get domainName():String
        {
        	return this._domainName;
        }
        
        private var data:ByteArray;
        
		public function get catalog():MOFile
		{
			return parseMOBytes(this.data);
		}
        
        public function reset():void
		{
			this._domainName = null;
			this.data = null;
		}
		
        public function load(path:String, domainName:String):void
        {
 /*           this._domainName = domainName;
            var hasErrors:Boolean = false;
            try 
            {
		        var moFile:File = new File(this._baseURL+File.separator+path);
				if (!moFile.exists)
					throw new TypeError("No input mo file");
				
				var stream:FileStream = new FileStream();
				stream.open(moFile, FileMode.READ);
				var moBytes:ByteArray = new ByteArray();
				stream.readBytes(moBytes);
				stream.close();
				moBytes.position = 0;
				this.data = moBytes;
			} catch (e:Error)
			{
				hasErrors = true;
				// call this on a later frame to have a consistent 
				// behavior with all other (asynchronous) services
				setTimeout(this.dispatchEvent, 10, 
					new IOErrorEvent(
						IOErrorEvent.IO_ERROR,false,false,e.message
					)
				);
			}
			if (!hasErrors)
			{
				// call this on a later frame to have a consistent 
				// behavior with all other (asynchronous) services
				setTimeout(this.dispatchEvent, 10, new Event(Event.COMPLETE));
			}*/
        }
        
    }
    
}
