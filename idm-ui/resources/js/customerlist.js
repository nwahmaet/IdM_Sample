APPLICATION_ROOT = '/cgi-bin/cgiip.exe/WService=wsIdM'; 

$('#options').bind('pageinit', function() {
	$('#options-refresh a').bind('click', refreshList);
});

$('#options').bind('pageshow', function() {
	$.ajax(APPLICATION_ROOT + '/getusercontext.p')
		.done(function (data) {
			// always unbind first so we don't have multiple clicks attached 
			$('#options-login a').unbind('click');
			$('#options-logout a').unbind('click');
			
			// data error means not logged in
			if (data.error === true) {
				$('#options-login a').bind('click', login);
			} else{
				$('#options-logout a').bind('click',logout);
			}
		})
	.fail(function(jqXHR, errorType, exceptionObject) {alert(' Error fetching data: ' + errorType);});
});

$('#custlist').bind('pageinit', function() {
	refreshList();
});

function refreshList() {
	$('#custlist h3').html('Customers');
	$('#custlist-listview').html('');
	
	$('#custlist-footer').addClass('ui-disabled');
	
	// default values
	$('#custlist-nextpage').data('pagesize', 10);
	$('#custlist-nextpage').data('startrow', 0);
	
	$('#custlist-nextpage').unbind('click')
		.bind('click', function(event, ui) {
			loadMoreCustomers();
	});
	
	$.ajax(APPLICATION_ROOT + '/getusercontext.p')
		.done(onSuccessGetUserContext)
		.fail(function(jqXHR, errorType, exceptionObject) {alert(' Error fetching data: ' + errorType);});
}

function onSuccessGetUserContext(data) {
	// data error means not logged in
	if (data.error === true) {
		$('#custlist-content')
			.html('<div class="text-align-center">Please use the Options menu to log in first</div>');
		$('#custlist-listview').html('');
	} else {
		loadCustomers({pageSize: $('#custlist-nextpage').data('pagesize'), startRow: $('#custlist-nextpage').data('startrow')});
	}
}


function login() {
	window.location.href = '/IdM/login.html?fromPage=' + encodeURIComponent(window.location.pathname);
}

function logout() {
	$.ajax(APPLICATION_ROOT + '/logout.p')
	.done(function (data){ 
		alert(data.messages[0]);
		refreshList();
		$.mobile.changePage($('#custlist'));
		})
	.fail(function(jqXHR, errorType, exceptionObject) {alert(' Error fetching data: ' + errorType);});
}

function loadOrders(customerId) {
	$('#ordertable').html('');
	
	$.ajax(APPLICATION_ROOT + '/getcustomerorders.p?customerId=' + customerId)
		.done(onSuccessLoadOrders)
		.fail(function(jqXHR, errorType, exceptionObject) {alert(' Error fetching data: ' + errorType);});
}

function onSuccessLoadOrders(data) {
		var htmlTxt = '<div class="ui-block-a"><div class="ui-bar ui-bar-b" >Number</div></div>'
					+ '<div class="ui-block-b"><div class="ui-bar ui-bar-b" >Order Date</div></div>'
					+ '<div class="ui-block-c"><div class="ui-bar ui-bar-b" >Sales Rep</div></div>'
					+ '<div class="ui-block-d"><div class="ui-bar ui-bar-b" >Status</div></div>'
					+ '<div class="ui-block-e"><div class="ui-bar ui-bar-b" >Cust Num</div></div>'
					;
		
		// loop through data and populate HTML fields, for customer and order.
		for (var i = 0; i < data.orders.length ; i++) {
			htmlTxt  
				+= '<div class="ui-block-a"><div class="ui-bar ui-bar-c" >' + data.orders[i].Ordernum + '</div></div>'
				+ '<div class="ui-block-b"><div class="ui-bar ui-bar-c" >' + data.orders[i].OrderDate + '</div></div>'
				+ '<div class="ui-block-c"><div class="ui-bar ui-bar-c" >' + data.orders[i].SalesRep + '</div></div>'
				+ '<div class="ui-block-d"><div class="ui-bar ui-bar-c" >' + data.orders[i].OrderStatus + '</div></div>'
				+ '<div class="ui-block-e"><div class="ui-bar ui-bar-c" >' + data.orders[i].CustNum + '</div></div>'
				;
		}
		$('#ordertable').html(htmlTxt);
		$('#orderdetail div h1').html('Orders: ' + data.customers[0].Name);
}

function loadMoreCustomers() {
	loadCustomers(
			{pageSize: $('#custlist-nextpage').data('pagesize'), startRow: $('#custlist-nextpage').data('startrow')});
}

function loadCustomers(params) {
	var url = APPLICATION_ROOT + '/getcustomerlist.p'
			+ '?pageSize=' + params.pageSize
			+ '&startRow=' + params.startRow;
	$.ajax({
		type : "GET",
		url : url,
		cache : false,
		success : onSuccessLoadCustomers
	});
}

function onSuccessLoadCustomers(data) {
	var htmltext = $('#custlist-listview').html();
	
	for ( var i = 0; i < data.customers.length; i++) {
		//<li><a href="index.html"><img src="images/fi.png" alt="Finland" class="ui-li-icon">Finland <span class="ui-li-count">12</span></a></li>
		htmltext += 
			'<li data-theme="c" data-id="'
				+ data.customers[i].id
				+ '">'
				+ '<a href="#custdetail" class="ui-link" data-transition="slide">'
				+ '<img src="/IdM/img/flags/' + data.customers[i].Country.toLowerCase() + '.png" alt="' + data.customers[i].Country + '"  class="ui-li-icon">'
				+ data.customers[i].CustNum + '<br>' + data.customers[i].Name + '</a>'
				+ '<a href="#orderdetail" data-icon="grid" data-id="'+ data.customers[i].id + '">OrderDetail</a>'
				+'</li>';
	}
	$('#custlist-listview').html(htmltext);
	
	
	$('#custlist-listview li')
		//only add event handlers to the newly added customer items
		.filter(function (index) {
			return $(this).data('id') >= data.request.startRow;
		})
		.each(function(index) {
			$(this).bind('click', function(event, ui) {
					showCustomer(data.customers[index]);});

			// the <a> element is the 2nd child
			$(this.children[1])
				.bind('click', function(event, ui) {
					loadOrders(data.customers[index].CustNum);
			});
	});
	
	$('#custlist-listview').listview('refresh');
	$('#custlist h3').html('Customers (' + $('#custlist-listview li').length + ')');
	
	if (data.request.allReturned !== true) {
		$('#custlist-footer').removeClass('ui-disabled');
		
		$('#custlist-nextpage').data('pagesize', data.request.pageSize);
		$('#custlist-nextpage').data('startrow', data.request.endRow + 1);
	} else {
		$('#custlist-footer').addClass('ui-disabled');
		
		$('#custlist-nextpage').unbind('click');
		$('#custlist-nextpage').removeData('pagesize');
		$('#custlist-nextpage').removeData('startrow');
	}
}

function showCustomer(customer) {
	$('#customerCustNum').val(customer.CustNum);
	$('#customerName').val(customer.Name);
	$('#customerBalance').val(customer.Balance);
	$('#customerPhone').val(customer.Phone);
	$('#customerAddress').val(customer.Address);
	$('#customerState').val(customer.State);
	$('#customerCity').val(customer.City);
	$('#customerCountry').val(customer.Country)
	$('#customerCountryIcon')
		.attr('src', '/IdM/img/flags/' + customer.Country.toLowerCase()+ '.png')
		.attr('alt', customer.Country);
	
	$('#custdetail-orders').unbind('click')
		.bind('click', function(event, ui) {
			loadOrders(customer.CustNum);
	});

}
