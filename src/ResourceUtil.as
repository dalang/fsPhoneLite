package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ResourceUtil extends EventDispatcher
	{
		import mx.resources.IResourceManager;
		import mx.resources.ResourceManager;
		import mx.controls.Alert;

		private static const BUNDLE_NAME:String = "fsPhoneLite";
		
		[Bindable]
		public static var resourceManager:IResourceManager = null;
		private static var instance:ResourceUtil = null;
		private static var currentLanguage:String = "zh_CN";

		public static function getInstance():ResourceUtil {
			if(instance == null) {
				instance = new ResourceUtil();
				resourceManager = ResourceManager.getInstance();
				resourceManager.initializeLocaleChain([currentLanguage]);
			}
			return instance;
		}

		public function changeLanguage(languageName:String):void {
			resourceManager.localeChain.localeChain = [languageName];
			currentLanguage = languageName;
			dispatchChange();
		}

		[Bindable("change")]
		public function getImage(resName:String):Class {
			var result:Class = resourceManager.getClass(BUNDLE_NAME, resName, currentLanguage);
			return result;
		}

		[Bindable("change")]
		public function getString(resName:String, para:Array = null):String {
			var result:String = resourceManager.getString(BUNDLE_NAME, resName, para, currentLanguage);
			return result;
		}

		private function dispatchChange():void
		{
			dispatchEvent(new Event("change"));
		}
	}
}