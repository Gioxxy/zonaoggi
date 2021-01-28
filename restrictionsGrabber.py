import asyncio
import datetime
import json
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
	days = len(await page.querySelectorAll('.swiper-slide'))

	bianco = []
	if await page.querySelector('[color="bianco"]'):
		await page.tap('[color="bianco"]')
		lis = await page.querySelectorAll('.css-16qr889-Item')
		for li in lis:
			icon = await page.evaluate('(el) => el.children[0].getAttribute("class")', li)
			desc = await page.evaluate('(el) => el.children[1].textContent', li)
			bianco.append({"icon": toCamelCase(icon.replace("fas fa-", "")), "desc": desc})

	giallo = []
	if await page.querySelector('[color="giallo"]'):
		await page.tap('[color="giallo"]')
		lis = await page.querySelectorAll('.css-16qr889-Item')
		for li in lis:
			icon = await page.evaluate('(el) => el.children[0].getAttribute("class")', li)
			desc = await page.evaluate('(el) => el.children[1].textContent', li)
			giallo.append({"icon": toCamelCase(icon.replace("fas fa-", "")), "desc": desc})

	arancione = []
	if await page.querySelector('[color="arancione"]'):
		await page.tap('[color="arancione"]')
		lis = await page.querySelectorAll('.css-16qr889-Item')
		for li in lis:
			icon = await page.evaluate('(el) => el.children[0].getAttribute("class")', li)
			desc = await page.evaluate('(el) => el.children[1].textContent', li)
			arancione.append({"icon": toCamelCase(icon.replace("fas fa-", "")), "desc": desc})
	
	rosso = []
	if await page.querySelector('[color="rosso"]'):
		await page.tap('[color="rosso"]')
		lis = await page.querySelectorAll('.css-16qr889-Item')
		for li in lis:
			icon = await page.evaluate('(el) => el.children[0].getAttribute("class")', li)
			desc = await page.evaluate('(el) => el.children[1].textContent', li)
			rosso.append({"icon": toCamelCase(icon.replace("fas fa-", "")), "desc": desc})

	res = {
		"selfDeclaration": "https://www.interno.gov.it/sites/default/files/2020-10/modello_autodichiarazione_editabile_ottobre_2020.pdf",
		"restrictions": [
			{
				"zoneName": "bianca",
				"restrictions": bianco
			},
			{
				"zoneName": "gialla",
				"restrictions": giallo
			},
			{
				"zoneName": "arancione",
				"restrictions": arancione
			},
			{
				"zoneName": "rossa",
				"restrictions": rosso
			},
		]
	}

	f = open("restrictionsGrabberResult.json", "w", encoding='utf-8')
	f.write(json.dumps(res, indent=2, ensure_ascii=False))
	f.close()
	await browser.close()

asyncio.get_event_loop().run_until_complete(main())