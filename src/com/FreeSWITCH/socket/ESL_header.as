// ActionScript file

package com.FreeSWITCH.socket {
	import flash.utils.Dictionary;
		
	public class ESL_header
	{
		
		private var header:Dictionary = new Dictionary;
		
		public function ESL_header(str:String):void {

			for each( var line:String in str.split("\n") ) {
				var a:Array = line.split(": ");
				if(a.length != 2) {
					if(line.indexOf("Job-UUID") != -1)
						header[a[0]] = a[1];
					continue;
				}

				header[a[0]] = a[1];
			}
			
		}
		
		public function content_type():String {
			return header["Content-Type"];
		}
		
		public function content_length():int {
			return (int)(header["Content-Length"]) ;
		}
		
		public function getHeader(key:String):String {
			return header[key];
		}	
	
	}

}