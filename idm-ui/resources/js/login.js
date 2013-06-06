/*! JavaScript code-behind for login page */
function loginOnClick () {
	$.ajax({type:"post",
			url:"/cgi-bin/cgiip.exe/WService=wsIdM/login.p",
			data: {"user": $("#uxUserName").val(), "domain":$("#uxDomain").val(), "password":$("#uxPassword").val()}
		})
		.done(onDoneLogin)
		.fail(function(jqXHR, errorType, exceptionObject) {alert(" Error fetching data: " + errorType);});
}

function onDoneLogin(data) {
	if (data.error === true )
	{
		htmlTxt = '';
		for (var i = 0; i < data.messages.length ; i++) {
			htmlTxt = htmlTxt + data.messages[i];
		}
		alert(htmlTxt);
	};
	// update UI state
	if (data.error === false) {
		window.location.href = getParameterByName('fromPage');
	}
}

function getParameterByName(name) {
    var match = RegExp('[?&]' + name + '=([^&]*)')
                    .exec(window.location.search);

    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
}

