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
	     	refreshChart(goal);
	     }
	 }
    });
}

function refreshChart(goalId) {
	$.ajax({
         url: "./manage/fetch_statistics",
         type: "GET",
         data: 'g=' + goalId,
	 success: function(data) {
		 data = JSON.parse(data);
		 needed = data.needed;
		 percents = data.percents;
		 createChart();
	 }
    });
}

function completeGoal() {
	$.ajax({
         url: "./manage/complete",
         type: "POST",
         data: 'g=' + goal,
	 success: function(data) {
		 data = JSON.parse(data);
	     console.log(data);
	     alert(data.message);
	     location.reload(false);
	 }
    });
}