/*
 * XML2JSONMLObject
 *
 * Convert XML to an object that can be serialized to JSONML.
 * By: Dominiek ter Heide - http://dominiek.com/
 *
 * - Derived from code written by Alessandro Crugnola - http://www.sephiroth.it/file_detail.php?id=129#
 * - Refactored and documented by Phil Powell - http://www.sillydomainname.com
 */

package xmltojson {
	import flash.xml.*;

	class XML2JSONMLObject {
				
		private static var instance:XML2JSONMLObject;
		private var _jsonmlObject:Object;
			
		public static function deserialize( xml:XMLDocument ):Object
		{
			XML2JSONMLObject.instance = new XML2JSONMLObject();
			return instance.nodeToJSONMLElment(xml.firstChild);
		}
		
		private function nodeToJSONMLElment( parent:XMLNode ):Array
		{
			var element:Array = new Array();
			element[0] = parent.nodeName;
			element[1] = parent.attributes;
			var i = 2;
			
			if( parent.hasChildNodes() )
			{
				var nodes:Array = parent.childNodes;
				
				while( nodes.length > 0 )
				{
					var node:XMLNode = XMLNode( nodes.shift() );
					
					if (!node.nodeName) continue;
					
					element[i] = nodeToJSONMLElment(node);
					i++;					
				}
				
			}
			
			if(parent.nodeValue) {
				element[i] = parent.nodeValue;
			}
			
			return element;
		}
		
	}
}