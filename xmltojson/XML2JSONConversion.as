/*
 * XML2JSONConversion
 *
 * Convert XML to an object that can be serialized to JSONML.
 * By: Dominiek ter Heide - http://dominiek.com/
 *
 */

package xmltojson {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;
	  import flash.xml.*;
		import com.adobe.serialization.json.*;

    public class XML2JSONConversion extends Sprite {
	
				public var url:String;
				public var callback:String;
				public var error_callback:String;

        public function XML2JSONConversion(url:String, callback:String, error_callback:String) {
						this.url = url;
						this.callback = callback;
						this.error_callback = error_callback;
	
	
            var loader:URLLoader = new URLLoader();
            configureListeners(loader);

            var request:URLRequest = new URLRequest(url);
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);

						var xml:XML = new XML(loader.data);
						var xDoc:XMLDocument = new XMLDocument();
					  xDoc.parseXML(xml.toXMLString());
					
						var xml_as_object:Object = XML2JSONMLObject.deserialize(xDoc);
						
						var json_encoder:JSONEncoder = new JSONEncoder(xml_as_object);
						
						XML2JSONConversion.execute_javascript(this.callback + "('"+this.url+"', "+json_encoder.getString()+");");
        }

        private function openHandler(event:Event):void {
        }

        private function progressHandler(event:ProgressEvent):void {
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
						error('http_error', 'Security error occurred while connecting to server.');
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
						error('http_error', 'The HTTP server gave us a wrong status.');
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
						error('http_error', 'An i/o error occurred.');
        }

				private static function redirect_to(path:String, target_self:Boolean=false):void {
		      var request:URLRequest = new URLRequest(path);
		      try {
		        navigateToURL(request, target_self ? '_self' : '_top');
		      }
		      catch (e:Error) {
						trace('error executing javascript');
		      }
				}

				private static function execute_javascript(js:String):void {
	        XML2JSONConversion.redirect_to('javascript: '+js, true);
	      }
	
				private function error(code, message) {
					trace(code);
					XML2JSONConversion.execute_javascript(this.error_callback + "('"+code+"', '"+message+"');");
				}

    }
}
