package VersionControl
{
    import flash.events.ContextMenuEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    import mx.core.mx_internal;
//    import mx.resources.ResourceBundle;        
    use namespace mx_internal;
    /**
    * @author anthony
    */
//    public class VersionController extends Application
    public class VersionController
    {
//        [ResourceBundle( 'VersionControl' )]
//        private static var _rb     : ResourceBundle;
//        
        private static var _rbi : Dictionary;

        public static function update(  ) : void
        {
        //    super.updateDisplayList( unscaledWidth, unscaledHeight ); 
            _rbi = new Dictionary( );
//            var rbi : Object = _rb.content;
			var rbi : Object = { Version:ResourceUtil.getInstance().getString('Version'), 
					url:ResourceUtil.getInstance().getString('url'),
					feedback:ResourceUtil.getInstance().getString('feedback')};
            var cm : ContextMenu = new ContextMenu( );
            for( var i : String in rbi )
            {
                var properties     : Array = String( rbi[ i ] ).split( '&' );
                var value         : String = properties[ 0 ];
                var separator     : Boolean = properties[ 1 ] ? properties[ 1 ] == 'false' ? false : true : true;
                var enabled        : Boolean = properties[ 2 ] ? properties[ 2 ] == 'false' ? false : true : true;
                var visible        : Boolean = properties[ 3 ] ? properties[ 3 ] == 'false' ? false : true : true;
                var open        : Boolean = properties[ 4 ] ? properties[ 4 ] == 'false' ? false : true : true;
                var cmi : ContextMenuItem = new ContextMenuItem( value, separator, enabled, visible );
                    cm.customItems.push( cmi ); 
                    cm.hideBuiltInItems( );            
                if( open )
                {
                    cmi.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, openWindow );
                    _rbi[ value ] = properties[ 4 ] ? properties[ 4 ] : ResourceUtil.getInstance().getString('feedback');            
                }
            }
            _application.contextMenu = cm;
        }
        

        private static function openWindow( e : ContextMenuEvent ) : void
        {
            navigateToURL( new URLRequest( _rbi[ e.target.caption ] ), "_blank" );
        }


        /**
        * Forces this class to use the singleton pattern;
        *
        */
        private static var _class         : VersionController;
        private static var _application    : UIComponent;
        public static function getInstance( item :UIComponent  ) :  VersionController
        {
            _application = item;
            if( !_class )
                _class = new VersionController( new SingletonEnforcer( ) );
                
                update( );

            return _class;
        }
        public function VersionController( se : SingletonEnforcer )
        {
            //can Never get here without calling getInstance( );
        }
    }
}
class SingletonEnforcer{ }

