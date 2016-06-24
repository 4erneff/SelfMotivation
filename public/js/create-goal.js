var editCounter = 0;
var addedMetrics = 0;

function addMetric () {
	valueType = $("#add-value").val();
	about = $("#add-about").val();
	aim = $("#add-aim").val();
	console.log(valueType + ' ' + about + ' ' + aim);

	validationResult = validateMetric(valueType, about, aim);

	if(validationResult.status === "OK") {
		example = $('*[data-for="time-row"]')[0];
		row = $(example).clone();
		valueTypeField = $(row).find('[data-for="value-type"]')[0];
		aboutField = $(row).find('[data-for="about"]')[0];
		aimField = $(row).find('[data-for="aim"]')[0];
		$(valueTypeField).text(valueType);
		$(aboutField).text(about);
		$(aimField).text(aim);
		$(valueTypeField).attr('name', 'metric[' + addedMetrics + '][value]');
		$(aboutField).attr('name', 'metric[' + addedMetrics + '][about]');
		$(aimField).attr('name', 'metric[' + addedMetrics + '][aim]');
		addedMetrics ++;
		$(row).css('visibility', "visible");
		$('table').find('tr:last').prev().after(row);
	} else {
		alert(validationResult.msg);
	}
}

function validateMetric(valueType, about, aim) {
	if( !valueType || valueType.length > 32) {
		return { 'status': "FAILED", 'msg': "Value type should be between 1 and 32 characters logn!"};
	}
	if( !about || about.length > 32) {
		return { 'status': "FAILED", 'msg': "About text should be between 1 and 32 characters logn!"};
	}
	if( !aim || aim.length > 10) {
		return { 'status': "FAILED", 'msg': "Aimed value should be between 1 and 9 characters logn!"};
	}
	if ( !aim.match(/^\d+$/) ) { 
		return { 'status': "FAILED", 'msg': "Aimed value must be integer!"};
	}
	return { 'status': "OK", 'msg': "OK"};
}

function editMetric (button) {

	currentRow = $(button).parents('tr')[0];
	value = ($(currentRow).find('td')[0]);
	about = ($(currentRow).find('td')[1]);
	aim = ($(currentRow).find('td')[2]);
	example = $("#add-value").parents('tr')[0];
	row = $(example).clone();
	newValue = $(row).find('input')[0];
	newAbout = $(row).find('input')[1];
	newAim = $(row).find('input')[2];
	$(newValue).val($(value).text());
	$(newAbout).val($(about).text());
	$(newAim).val($(aim).text());
	$(newValue).attr('id', "edit-value-" + editCounter);
	$(newAbout).attr('id', "edit-about-" + editCounter);
	$(newAim).attr('id', "edit-aim-" + editCounter);
	butt = $(row).find("#add-metric")[0];
	$(butt).text("Done");
	$(butt).attr('onclick', "finishEditting(this)");
	$(currentRow).replaceWith(row);
	editCounter ++;
}

function finishEditting(button) { 
	currentRow = $(button).parents('tr')[0];
	value = $($(currentRow).find('input')[0]).val();
	about = $($(currentRow).find('input')[1]).val();
	aim = $($(currentRow).find('input')[2]).val();

	validationResult = validateMetric(value, about, aim);
	console.log(value + ' ' + about + ' ' + aim );

	if(validationResult.status === "OK") {
		example = $('*[data-for="time-row"]')[0];
		row = $(example).clone();
		valueTypeField = $(row).find('[data-for="value-type"]')[0];
		aboutField = $(row).find('[data-for="about"]')[0];
		aimField = $(row).find('[data-for="aim"]')[0];
		$(valueTypeField).text(value);
		$(aboutField).text(about);
		$(aimField).text(aim);
		$(valueTypeField).attr('name', 'metric[' + addedMetrics + '][value]');
		$(aboutField).attr('name', 'metric[' + addedMetrics + '][about]');
		$(aimField).attr('name', 'metric[' + addedMetrics + '][aim]');
		addedMetrics ++;
		$(row).css('visibility', "visible");
		$(currentRow).replaceWith(row);
	} else {
		alert(validationResult.msg);
	}
}

function deleteMetric(button) { 
    console.log("baba");
    $(button).parents("tr").remove();
}

function serializeMetrics() {
	result = "";
	counter = 0;
	fiedls = $(".metric-field");
	for (var i = fiedls.length - 1; i >= 0; i--) {
		field = fiedls[i];
		result += ($(field).attr('name') + '=' + $(field).text() + '&');
		counter ++;
	};
	return result;
}

function sendGoalRequest() {
    $.ajax({
         url: "./new",
         type: "POST",
         data: $("body :input").serialize() + serializeMetrics(),
	 success: function(data) {
	     console.log(data);
	 }
    });
}