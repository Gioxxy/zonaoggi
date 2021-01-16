import asyncio
import datetime
import json
from pyppeteer import launch

def monthToNum(month):
    return {
            'Gennaio': 1,
            'Febbraio': 2,
            'Marzo': 3,
            'Aprile': 4,
            'Maggio': 5,
            'Giugno': 6,
            'Luglio': 7,
            'Agosto': 8,
            'Settembre': 9, 
            'Ottobre': 10,
            'Novembre': 11,
            'Dicembre': 12
    }[month]

async def getDate(page, index, days):
	spans = await page.querySelectorAll('[aria-label="' + str(index) + ' / ' + str(days) + '"] div span')
	month = monthToNum(await page.evaluate('(element) => element.textContent', spans[0]))
	day = int(await page.evaluate('(element) => element.textContent', spans[1]))
	return "2021-" + format(month, '02d') + "-" + format(day, '02d')

async def getZoneName(page, regionId):
	region = await page.querySelector('#' + regionId)
	color = await page.evaluate('(element) => element.getAttribute("color")', region)

	if color == "giallo":
		color = "gialla"
	elif color == "rosso":
		color = "rossa"
	
	return color

async def getName(page, regionId):
	region = await page.querySelector('#' + regionId)
	name = await page.evaluate('(element) => element.getAttribute("title")', region)
	if "bolzano" in name.lower():
		name = "Bolzano"
	elif "trento" in name.lower():
		name = "Trento"
	return name

def getColor(zoneName):
	if zoneName == "gialla":
		return "#FFEB3B"
	elif zoneName == "arancione":
		return "#FF9800"
	elif zoneName == "rossa":
		return "#F44336"
	return "#FFFFFF"

async def getRegion(page, regionId, id, image):
	zoneName = await getZoneName(page, regionId)
	name = await getName(page, regionId)
	color = getColor(zoneName)
	return {
		"id": id,
		"name": name,
		"zoneName": zoneName,
		"color": color,
		"image": image
	}

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

	res = []
	for i in range(1, days + 1, 1):
		await page.tap('[aria-label="' + str(i) + ' / ' + str(days) + '"]')
		day = {
			"date": await getDate(page, i, days),
			"regions": [
				await getRegion(page, "abruzzo", 1, "abruzzo.svg"),
				await getRegion(page, "basilicata", 2, "basilicata.svg"),
				await getRegion(page, "bolzano", 3, "bolzano.svg"),
				await getRegion(page, "calabria", 4, "calabria.svg"),
				await getRegion(page, "campania", 5, "campania.svg"),
				await getRegion(page, "emiliaromagna", 6, "emilia.svg"),
				await getRegion(page, "friuliveneziagiulia", 7, "friuli.svg"),
				await getRegion(page, "lazio", 8, "lazio.svg"),
				await getRegion(page, "liguria", 9, "liguria.svg"),
				await getRegion(page, "lombardia", 10, "lombardia.svg"),
				await getRegion(page, "marche", 11, "marche.svg"),
				await getRegion(page, "molise", 12, "molise.svg"),
				await getRegion(page, "piemonte", 13, "piemonte.svg"),
				await getRegion(page, "puglia", 14, "puglia.svg"),
				await getRegion(page, "sardegna", 15, "sardegna.svg"),
				await getRegion(page, "sicilia", 16, "sicilia.svg"),
				await getRegion(page, "toscana", 17, "toscana.svg"),
				await getRegion(page, "trento", 18, "trento.svg"),
				await getRegion(page, "umbria", 19, "umbria.svg"),
				await getRegion(page, "valledaosta", 20, "valledaosta.svg"),
				await getRegion(page, "veneto", 21, "veneto.svg")
			]
		}

		res.append(day)

	f = open("grabberResult.json", "w")
	f.write(json.dumps(res, indent=2))
	f.close()
	await browser.close()

asyncio.get_event_loop().run_until_complete(main())