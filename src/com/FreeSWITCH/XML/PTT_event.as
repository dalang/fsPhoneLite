// ActionScript file

package com.FreeSWITCH.XML
{
	import flash.errors.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	public class PTT_event
	{
		private var _responseType:String;
        private var _groupID:String = "";
        private var _responseExtension:String = "";
        private var _certifySuccess:Boolean = false;
        private var _certifyNumber:String = "";
        private var _queueNumber:int = 0;
        private var _queueExtension:String = "";
        
        public function PTT_event(eslev:ESL_event):void{
			var plain:Dictionary = null;
			if (null == eslev)
				return;
			else
				plain = eslev.get_plain();
			
			for(var key:Object in plain)
			{
				trace("PTT EVENT "+ key + ", " + plain[key]);
				ParseCommand(key.toString(), unescape(plain[key]));
			}	
		}		     
        
		public function get ResponseType():String {
			return this._responseType;
		}
		public function set ResponseType(value:String):void {
			this._responseType = value;
		}

        public function get GroupID():String {
        	return this._groupID;
        }
        public function set GroupID(value:String):void {
        	this._groupID = value;
        }

        public function get ResponseExtension():String {
        	return this._responseExtension;
        }
        public function set ResponseExtension(value:String):void {
        	this._responseExtension = value;
        }
        
        public function get CertifySuccess():Boolean {
        	return this._certifySuccess;
        }
        public function set CertifySuccess(value:Boolean):void {
        	this._certifySuccess = value;
        }

        public function get CertifyNumber():String {
        	return this._certifyNumber;
        }
        public function set CertifyNumber(value:String):void {
        	this._certifyNumber = value;
        }

        public function get QueueNumber():int {
        	return this._queueNumber;
        }
        public function set QueueNumber(value:int):void {
        	this._queueNumber = value;
        }
                
        public function get QueueExtension():String {
        	return this._queueExtension;
        }
        public function set QueueExtension(value:String):void {
        	this._queueExtension = value;
        }
        
        public function ParseCommand(name:String, value:String):void
        {
            switch (name)
            {
                case "response_type":
                    ResponseType = value;
                    break;
                case "groupID":
                    GroupID = value;
                    break;
                case "response_extension":
                    ResponseExtension = value;
                    break;
                case "certify_success":
                    CertifySuccess = booleanValue(value);
                    break;
                case "certify_number":
                    CertifyNumber = value;
                    break;
                case "queue_number":
                    QueueNumber = parseInt(value, 10);
                    break;
                case "queue_extension":
                    QueueExtension = value;
                    break;
                    
                default:
                    break;
            }
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