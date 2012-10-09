package events
{
	import com.FreeSWITCH.XML.ESL_event;
	
	import flash.events.Event;

	public class SocketMessageEvent extends Event
	{		
		public static var MESSAGE:String    = "message";
		public static var ESLSTAUS:String   = "eslstatus";
		public static var BLUEBOXSTAUS:String = "bluleboxstatus";
		public static var ESLCMD:String = "eslcommand";
		public static var ESLPTTEVENT:String = "eslpttevent";
		public static var ESLPTTGROUPSEVENT:String = "elspttgroupsevent";
		public static var ESLHEARTBEAT:String = "eslheartbeat";
		public static var ESLCONFERENCEEVENT:String = "eslconferenceevent";

		public var msgType:String;
		public var message:String;
		public var eslev:ESL_event;
		public var data:String;
		
		public function SocketMessageEvent(type:String, msgType:String, message:String, eslev:ESL_event = null, data:String = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.msgType = msgType;
			this.message = message;	
			this.eslev = eslev;
			this.data = data;
		}
		
		public override function clone():Event {
			return new SocketMessageEvent(type, msgType, message, eslev, data, bubbles, cancelable);
		}
		
	}
}