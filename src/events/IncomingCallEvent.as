package events
{
	
	import flash.events.Event;
	
	public class IncomingCallEvent extends Event{
	
		public static var INCOMING:String    = "incoming";
		public var uuid:String;
		public var name:String;
		public var number:String;
		public var account:String;
		
		public function IncomingCallEvent(type:String, uuid:String, name:String, number:String, account:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.uuid          = uuid;
			this.name      = name;	
			this.number     = number;
			this.account = account;	
		}
		
		public override function clone():Event {
			return new IncomingCallEvent(type,  uuid, name, number, account, bubbles, cancelable);
		}

	}
}