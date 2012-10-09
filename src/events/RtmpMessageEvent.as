package events
{
	
	import flash.events.Event;
	
	public class RtmpMessageEvent extends Event{
		
		public static var MESSAGE:String    = "message";
		public static var NETSTAUS:String   = "netstatus";
		public static var SIP_Login:String 	= "sip_login";
		public static var SIP_REGISTER:String 		= "sip_register";

		public static var CALLSTATE:String  = "callstate";
		public static var RECORDSTATE:String  = "recordstate";
		public var msgType:String;
		public var message:String;
		
		public function RtmpMessageEvent(type:String, msgType:String, message:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.msgType = msgType;
			this.message = message;	
		}
		
		public override function clone():Event {
			return new RtmpMessageEvent(type, msgType, message, bubbles, cancelable);
		}
	}
}