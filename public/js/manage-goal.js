function addMetrics() {
    $.ajax({
         url: "./add-progress",
         type: "POST",
         data: $("body :input").serialize(),
	 success: function(data) {
	     data = JSON.parse(data);
	     console.log(data);
	     alert(data.message);
	     if ( data.status == 'success' ) {
	     	window.location.replace(data.redirect);
	     }
	 }
    });
}