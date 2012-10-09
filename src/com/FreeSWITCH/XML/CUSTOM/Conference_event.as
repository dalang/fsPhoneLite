package com.FreeSWITCH.XML.CUSTOM
{
	import com.FreeSWITCH.XML.ESL_event;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;

	public class Conference_event extends CUSTOM_event
	{
		private var _conferenceName:String;
		private var _conferenceSize:int;
		private var _channelName:String;
		private var _callerUsername:String;
		
		
		private var _status:Conference_status;
		
		private var _memberId:int;
		private var _energyLevel:int;
		private var _action:String;
		private var _oldId:int, _newId:int;
				
		public function Conference_event(eslev:ESL_event)
		{
			_status = Conference_status.NONE;
			var plain:Dictionary = null;
			if (null != eslev)
			{

				plain = eslev.get_plain();
				super(plain["Event-Subclass"]);


				for(var key:Object in plain)
				{
					trace("Conference EVENT "+ key + ", " + plain[key]);
					ParseConferenceEvent(key.toString(), unescape(plain[key]));
				}
			}
		}
		
		public function ParseConferenceEvent(name:String, value:String):void
        {
            switch (name)
            {
                case "Conference-Name":
                    _conferenceName = value;
                    break;               
                case "Caller-Username":
                    _callerUsername = value;
                    break;              
                case "Conference-Size":
                    _conferenceSize = parseInt(value, 10);
                    break;
                case "Action":
                    _action = value;
                    break;
                case "Member-ID":
                    _memberId = parseInt(value, 10);
                    break;
                case "Energy-Level":
                    _energyLevel = parseInt(value, 10);
                    break;
                case "Channel-Name":
                    _channelName = value;
                    break;
                case "Old-ID":
                    _oldId = parseInt(value, 10);
                    break;
                case "New-ID":
                    _newId = parseInt(value, 10);
                    break;
                // the following is conference status setting 
                case "Floor":
                	if(booleanValue(value))
                		this._status.Value |= Conference_status.FLOOR.Value;
                	break;
                case "Video":
               		if(booleanValue(value))
                		this._status.Value |= Conference_status.VIDEO.Value;
                	break;
                case "Hear":
                    if(booleanValue(value))
                		this._status.Value |= Conference_status.HEAR.Value;
                	break;
                case "Speak":
                    if(booleanValue(value))
                		this._status.Value |= Conference_status.SPEAK.Value;
                	break;
                case "Talking":
                    if(booleanValue(value))
                		this._status.Value |= Conference_status.TALKING.Value;
                	break;
                case "Mute-Detect":
                    if(booleanValue(value))
                		this._status.Value |= Conference_status.MUTEDETECT.Value;
                	break;
                    
                default:
                    break;
            }
        }

		public function get ConfName():String {
			return this._conferenceName;
		}
		public function get CallerUsername():String {
			return this._callerUsername;
		}
		public function get ConfSize():int {
			return this._conferenceSize;
		}
		public function get ChanlName():String {
			return this._channelName;
		}
		public function get MemID():int {
			return this._memberId;
		}
		public function get OldID():int {
			return this._oldId;
		}
		public function get NewID():int {
			return this._newId;
		}
		public function get ConfStat():uint {
			return this._status.Value;
		}
		public function get ConfAct():String {
			return this._action;
		}

		        
        public function booleanValue(src:String):Boolean
		{
			var trimmed:String=this.trim(src).toLowerCase();
			return trimmed == "true" || trimmed == "t" || trimmed == "yes" || trimmed == "1";
		}
		
		public function trim(str:String):String{
            return StringUtil.trim(str);
        }
	}
}