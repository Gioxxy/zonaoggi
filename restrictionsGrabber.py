import asyncio
import datetime
import json
import re
from pyppeteer import launch

def toCamelCase(snake_str):
    components = snake_str.split('-')
    # We capitalize the first letter of each component except the first one
    # with the 'title' method and join them together.
    return components[0] + ''.join(x.title() for x in components[1:])

async def main():
	browser = await launch({
		'headless': True,
		'defaultViewport':  {
				'width': 1680,
				'height': 1050
			}
		})
	page = await browser.newPage()
	# go to covidzone
	await page.goto('https://covidzone.info')
	# accept cookies
	await page.tap('#rcc-confirm-button')
	data = await page.querySelector('#__NEXT_DATA__')
	jsonData = json.loads(await page.evaluate('(el) => el.textContent', data))

	zones = jsonData["props"]["pageProps"]["mapProps"]["colors"]

	restrictions = []

	for zone in zones:
		measures = []
		for measure in zone["measures"]:
			description = measure["description"].replace("[Autocertificazione](/autocertificazione-digitale)", "Autocertificazione").replace("**", "").replace("[", "").replace("]", "")
			description = re.sub(r'''(?i)\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))''', '', description)
			description = description.replace("()", "")
			measures.append({ "icon": toCamelCase(measure["icon"]), "desc": description })
		name = zone["name"].replace("bianco", "bianca").replace("rosso", "rossa").replace("giallo", "gialla").replace("_", " ")
		restrictions.append({ "zoneName": name, "restrictions": measures })

	res = {
		"selfDeclaration": "https://www.interno.gov.it/sites/default/files/2020-10/modello_autodichiarazione_editabile_ottobre_2020.pdf",
		"restrictions": restrictions
	}

	f = open("restrictionsGrabberResult.json", "w", encoding='utf-8')
	f.write(json.dumps(res, indent=2, ensure_ascii=False))
	f.close()
	await browser.close()

asyncio.get_event_loop().run_until_complete(main())