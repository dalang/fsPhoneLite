package events
{
	import flash.events.Event;

	public class LogMessageEvent extends Event
	{
		public static var LOG:String = "log";
		public static var RTMPLOG:String    = "rtmplog";
		public static var ESLLOG:String = "esllog";
		public static var ESLSTATUS:String = "eslstatus";
		public var msgType:String;
		public var message:String;
		
		public function LogMessageEvent(type:String, msgType:String, message:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.msgType = msgType;
			this.message = message;
		}
		
		public override function clone():Event {
			return new LogMessageEvent(type, msgType, message, bubbles, cancelable);
		}		
	}
}
