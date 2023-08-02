import { config } from "../config.js";

function uuidv4() {
	return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, c =>
		(c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
	);
}

const api = {
	ring: function (sign) {
		fetch(`${config.BASE}/actions/execute`, {
			method: 'POST',
			headers: {
				"mqtt_answer_channel": uuidv4()
			}, body: JSON.stringify({
				"pattern": "ring",
				"environment": {
					"SIGN": sign
				}
			})
		});
	},
	unlock: function (passcode) {
		fetch(`${config.BASE}/actions/execute`, {
			method: 'POST',
			headers: {
				"mqtt_answer_channel": uuidv4()
			}, body: JSON.stringify({
				"pattern": "unlock",
				"environment": {
					"SIGN": sign
				}
			})
		})
	}
}

export { api }
