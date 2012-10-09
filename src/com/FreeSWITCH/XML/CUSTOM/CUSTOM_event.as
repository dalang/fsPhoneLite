package com.FreeSWITCH.XML.CUSTOM
{
	import flash.errors.*;
	import flash.events.*;
	
	public class CUSTOM_event
	{
		private var _eventSubclass:String;
		
		public function CUSTOM_event(value:String)
		{
			this._eventSubclass = value;
		}
		
		public function get Subclass():String {
			return this._eventSubclass;
		}
	}
}