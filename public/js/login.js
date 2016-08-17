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

function signupPOST() {
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

function passwordForgottenPOST() {
    $.ajax({
         url: "../password_forgotten",
         type: "POST",
         data: $("#password-forgotten-form").serialize(),
	 success: function(data) {
	     console.log(data);
	     data = JSON.parse(data);
	     if ( data.status === 'success' ) {
		$("#error-msg").empty();
		$("#success-msg").html(data.message);
             } else {
		$("#success-msg").empty();
	        $("#error-msg").html(data.message);
	     }
	 }
    });
}

function passwordForgottenChangePOST() {
    $.ajax({
         url: "../forgotten/change",
         type: "POST",
         data: $("#password-forgotten-change-form").serialize(),
	 success: function(data) {
	     console.log(data);
	     data = JSON.parse(data);
	     if ( data.status === 'success' ) {
			$("#error-msg").empty();
			alert(data.message);	
			window.location.replace(data.redirect);
         } else {
			$("#success-msg").empty();
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


