package com.FreeSWITCH.XML.CUSTOM
{
	public final class Conference_status
	{
		public static const NONE:Conference_status = new Conference_status(0);
		public static const FLOOR:Conference_status = new Conference_status(1<<0);
		public static const VIDEO:Conference_status = new Conference_status(1<<1);
		public static const HEAR:Conference_status = new Conference_status(1<<2);
		public static const SPEAK:Conference_status = new Conference_status(1<<3);
		public static const TALKING:Conference_status = new Conference_status(1<<4);
		public static const MUTEDETECT:Conference_status = new Conference_status(1<<5);

          
        private static var _limit:Boolean = limit();  
          
        private var _value:Object;  
          
        public function Conference_status(value:Object) {  
            if (_limit) {  
                throw new Error("Cannot initialize Enum outside!");  
                return;  
            }  
            this._value = value;
        }  
          
          
        private static function limit():Boolean {  
            return true;  
        }  
          
        public function toString():String {  
            switch(this._value as uint) {  
                case 1<<0:  
                    return "FLOOR";  
                case 1<<1:  
                    return "VIDEO";  
                case 1<<2:  
                    return "HEAR";  
                case 1<<3:  
                    return "SPEAK";  
                case 1<<4:  
                    return "TALKING";  
                case 1<<5:  
                    return "MUTEDETECT";                      
            }  
            return "Undefined STATUS!";  
        }  
        
        public function get Value():uint {
			return this._value as uint;
		}
		public function set Value(value:uint):void {
			this._value = value;
		}
	}
}