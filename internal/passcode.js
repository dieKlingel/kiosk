import { api } from "./api.js"

class Passcode {
	characters = '1234567890';

	append(sender) {
		htmx.find("#passcode").value += sender.innerText;
	}

	remove() {
		htmx.find("#passcode").value = htmx.find("#passcode").value.slice(0, -1);
	}

	clear() {
		htmx.find("#passcode").value = "";
	}

	submit() {
		const code = htmx.find("#passcode").value;
		api.unlock(code);

		this.randomize();
		this.clear();
	}

	randomize() {
		this.characters = this.characters.split('').sort(function () { return 0.5 - Math.random() }).join('');
		const buttons = htmx.findAll(htmx.find(".numpad"), "button[number]");
		for (let i = 0; i < buttons.length; i++) {
			buttons[i].innerText = this.characters[i];
		}
	}
}

const passcode = new Passcode();

export { passcode }
