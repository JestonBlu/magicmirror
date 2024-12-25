/* MagicMirror² Config Sample
 *
 * By Michael Teeuw https://michaelteeuw.nl
 * MIT Licensed.
 *
 * For more information on how you can configure this file
 * see https://docs.magicmirror.builders/configuration/introduction.html
 * and https://docs.magicmirror.builders/modules/configuration.html
 *
 * You can use environment variables using a `config.js.template` file instead of `config.js`
 * which will be converted to `config.js` while starting. For more information
 * see https://docs.magicmirror.builders/configuration/introduction.html#enviromnent-variables
 */
let config = {
	address: "0.0.0.0",	    // Address to listen on, can be:
							// - "localhost", "127.0.0.1", "::1" to listen on loopback interface
							// - another specific IPv4/6 to listen on a specific interface
							// - "0.0.0.0", "::" to listen on any interface
							// Default, when address config is left out or empty, is "localhost"
	port: 8080,
	basePath: "/",			// The URL path where MagicMirror² is hosted. If you are using a Reverse proxy
					  		// you must set the sub path here. basePath must end with a /
	ipWhitelist: [],	    // Set [] to allow all IP addresses
															// or add a specific IPv4 of 192.168.1.5 :
															// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
															// or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
															// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],

	useHttps: false, 		// Support HTTPS or not, default "false" will use HTTP
	httpsPrivateKey: "", 	// HTTPS private key path, only require when useHttps is true
	httpsCertificate: "", 	// HTTPS Certificate path, only require when useHttps is true

	language: "en",
	locale: "en-US",
	logLevel: ["INFO", "LOG", "WARN", "ERROR"], // Add "DEBUG" for even more logging
	timeFormat: 12,
	units: "imperial",

	modules: [
		{
			module: "alert",
		},
		{
			module: "updatenotification",
			position: "top_bar"
		},
		{
			module: "clock",
			position: "top_left"
		},
		{
			module: "calendar",
			header: "School Calendar -- Next 2 Weeks",
			position: "top_left",
			config: {
				calendars: [
					{
						fetchInterval: 7 * 24 * 60 * 60 * 1000,
						symbol: "calendar-check",
						url: "https://ww.dunlapcusd.net/ICalendarHandler?calendarId=4679524",
					}
				],
				maxTitleLength: 50,
				wrapEvents: true,
				fade: false,
				maximumNumberOfDays: 14
			}
		},
		{
			module: "weather",
			position: "top_right",
			header: "Home",
			config: {
				weatherProvider: "openweathermap",
				type: "current",
				location: "Peoria",
				locationID: "4905687", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
				apiKey: "474f0b78217f6a136caf8155b5d4fe17",
				showPrecipitationProbability: true
			}
		},
		{
			module: "weather",
			position: "top_right",
			header: "Forecast",
			config: {
					weatherProvider: "openweathermap",
					type: "forecast",
					location: "Peoria",
					locationID: "4905687", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
					apiKey: "474f0b78217f6a136caf8155b5d4fe17"
			}
		},
		{
			module: "weather",
			position: "bottom_right",
			header: "Nana's House",
			config: {
				weatherProvider: "openweathermap",
				type: "current",
				location: "Sharpsburg",
				locationID: "4491086", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
				apiKey: "474f0b78217f6a136caf8155b5d4fe17",
				onlyTemp: true
			}
		},
		{
			module: "weather",
			position: "bottom_right",
			header: "Pop and Poppie's House",
			config: {
				weatherProvider: "openweathermap",
				type: "current",
				location: "Crawfordville",
				locationID: "4152267", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
				apiKey: "474f0b78217f6a136caf8155b5d4fe17",
				onlyTemp: true
			}
		},
		{
			module: "MMM-eswordoftheday",
			position: "bottom_left"
		},
		{
			module: 'MMM-Unsplash',
			position: 'fullscreen_below',
			config: {
				collections: '789878',
				apiKey: 'wBm_Zg6vc6mizbr14qvZKIHmeQ6BLYjuz6ZjXWHwBzw'
			}
		},
		// {
		// 	module: "MMM-Pollen",
		// 	position: "top_center",
		// 	header: "Pollen Forecast",
		// 	config: {
		// 		updateInterval: 3 * 60 * 60 * 1000, // every 3 hours
		// 		zip_code: "61614"
		// 	}
		// },
	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {module.exports = config;}
