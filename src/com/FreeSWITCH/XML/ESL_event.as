// ActionScript file


package com.FreeSWITCH.XML {
	import flash.errors.*;
	import flash.events.*;
	import flash.utils.Dictionary;
		
	public class ESL_event extends Object
	{
		private var xml:XML;
		private var plain:Dictionary;
		private var type:String;
				

		public function ESL_event(event_type:String, str:String="<xml></xml>"):void{
			type = event_type;
			
			if (type == "xml") { 
				xml = new XML(str);
			} else {
				plain = new Dictionary;
				for each( var line:String in str.split("\n") ) {
					var a:Array = line.split(": ");
					plain[a[0]] = a[1];
				}
			}	
		}

		public function toString():String {
			if (type == "xml" ) {
				return xml.toString();
			} else {
				return plain.toString();
			}
		}
		
		public function event_name():String{
			return get_value("Event-Name");
		}
		
		public function event_subclass():String{
			return get_value("Event-Subclass");
		}
		
		public function get_value(element:String):String{
			if ( type == "xml" ) {
				return unescape(xml.headers.elements(element));
			} else {
				return unescape(plain[element]);
			}
		}
		
		public function get_plain():Dictionary {
			return plain;
		}
		
		public function get_xml():XML {
			return xml;
		}
	}
}
