
var XMLJSONProxy = function (error_callback) {
	this.error_callback = error_callback;
	document.write('<embed height="1" width="1" flashvars="allowScriptAccess=sameDomain" quality="high" name="xml_json_proxy" id="xml_json_proxy_swf" style="" src="xml_json_proxy.swf" type="application/x-shockwave-flash"/>');
};

XMLJSONProxy.prototype = {
	get: function(callback, url) {
		var swf = this.load_swf('xml_json_proxy_swf');
		swf.xml_to_json(url, callback, this.error_callback);
	},
	load_swf: function(id) {
		return (navigator.appName.indexOf("Microsoft") !=-1) ? window[id] : document[id];
	}
};
