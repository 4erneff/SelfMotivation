function loginPOST() {
    $.ajax({
         url: "../login",
         type: "POST",
         data: $(".form-signin").serialize(),
	 success: function(data) {
	     data = JSON.parse(data);
	     if ( data.status === 'success' ) {
		window.location.replace(data.redirect);
             } else {
	        $("#error-msg").html(data.message);
	     }
	 }
    });
}

function signupPOST(data) {
    $.ajax({
         url: "../user/create",
         type: "POST",
         data: $(".form-registration").serialize(),
	 success: function(data) {
	     console.log(data);
	     data = JSON.parse(data);
	     if ( data.status === 'success' ) {
		$("#error-msg").empty();
		$("#success-msg").html(data.message);
		sleep(5000);		
		window.location.replace(data.redirect);
             } else {
	        $("#error-msg").html(data.message);
	     }
	 }
    });
}

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}
