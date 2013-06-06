/** cookies.js
 * Adapted from http://www.quirksmode.org/js/cookies.html
 * 
 * Usage:
    // Setting a cookie
	$.cookie('myCookie':'myValue');

	// Creating cookie with all availabl options
	$.cookie('myCookie2', 'myValue2', { expires: 7, path: '/', domain: 'example.com', secure: true });
	
	// Get a cookie
	$.cookie('myCookie');
	
	// Delete a cookie
	$.cookie('myCookie', null);
 */

function setCookie(name, value, days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		var expires = "; expires=" + date.toGMTString();
	} else
		var expires = "";
	document.cookie = name + "=" + value + expires + "; path=/";
}

function getCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for ( var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ')
			c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) == 0)
			return c.substring(nameEQ.length, c.length);
	}
	return null;
}

function deleteCookie(name) {
	setCookie(name, "", -1);
}
