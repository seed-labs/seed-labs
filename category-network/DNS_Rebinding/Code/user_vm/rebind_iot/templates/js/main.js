const units = {
	Celsius: unescape('%B0C'),
	Fahrenheit: unescape('%B0F')
};

const config = {
	minTemp: 0,
	maxTemp: 100,
	unit: "Celsius"
};

// Change min and max temperature values

const tempValueInputs = document.querySelectorAll("input[type='text']");

tempValueInputs.forEach((input) => {
	input.addEventListener("change", (event) => {
		const newValue = event.target.value;

		if(isNaN(newValue)) {
			return input.value = config[input.id];
		} else {
			config[input.id] = input.value;
			range[input.id.slice(0, 3)] = config[input.id]; // Update range
			return renderTemperature(); // Update temperature
		}
	});
});

// Change temperature

let range = document.querySelector("input[type='range']");
const temperature = document.getElementById("temperature");

function renderTemperature() {
	temperature.style.height = (range.value - config.minTemp) / (config.maxTemp - config.minTemp) * 100 + "%";
	temperature.dataset.value = range.value + units[config.unit];
}

function updateTemperature() {
	$.get('/password', function(data) {
		$.post('/temperature?value=' + range.value + '&password=' + data.password, function(data) {
			console.debug('response from the server: ');
			console.debug(data);
			renderTemperature();
		});
	});
}

range.addEventListener("input", updateTemperature);


function pollTemperature() {
	$.get('/temperature', function(data) {
		if (!data.hasOwnProperty('temperature')) {
			console.error('server does not send the correct data');
		} else {
			let newTemperature = data.temperature;
			if (newTemperature !== Number(range.value)) {
				console.log('newTemperature is [' + newTemperature + '], range.value is [' + range.value + ']');
				console.log('set temperature to ' + newTemperature + ' as informed by the server.');
				range.value = newTemperature;
			}
			renderTemperature();
		}
	});
}

setInterval(pollTemperature, 1000);
