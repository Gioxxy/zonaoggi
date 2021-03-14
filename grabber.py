import asyncio
import datetime
import json
from pyppeteer import launch

def monthToNum(month):
    return {
            'gennaio': 1,
            'febbraio': 2,
            'marzo': 3,
            'aprile': 4,
            'maggio': 5,
            'giugno': 6,
            'luglio': 7,
            'agosto': 8,
            'settembre': 9, 
            'ottobre': 10,
            'novembre': 11,
            'dicembre': 12
    }[month.lower()]

async def getDate(page, index, days):
	spans = await page.querySelectorAll('[aria-label="' + str(index) + ' / ' + str(days) + '"] div span')
	month = monthToNum(await page.evaluate('(element) => element.textContent', spans[0]))
	day = int(await page.evaluate('(element) => element.textContent', spans[1]))
	return "2021-" + format(month, '02d') + "-" + format(day, '02d')

async def getZoneName(page, regionId):
	region = await page.querySelector('#' + regionId)
	color = await page.evaluate('(element) => element.getAttribute("color")', region)

	color = color.replace("giallo", "gialla").replace("rosso", "rossa").replace("bianco", "bianca").replace("_", " ")
	
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
	elif zoneName == "arancione rafforzato":
		return "#FF5722"
	return "#FCFCFC"

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
				await getRegion(page, "IT-65", 1, "abruzzo.svg"),
				await getRegion(page, "IT-77", 2, "basilicata.svg"),
				await getRegion(page, "IT-32", 3, "bolzano.svg"),
				await getRegion(page, "IT-78", 4, "calabria.svg"),
				await getRegion(page, "IT-72", 5, "campania.svg"),
				await getRegion(page, "IT-45", 6, "emilia.svg"),
				await getRegion(page, "IT-36", 7, "friuli.svg"),
				await getRegion(page, "IT-62", 8, "lazio.svg"),
				await getRegion(page, "IT-42", 9, "liguria.svg"),
				await getRegion(page, "IT-25", 10, "lombardia.svg"),
				await getRegion(page, "IT-57", 11, "marche.svg"),
				await getRegion(page, "IT-67", 12, "molise.svg"),
				await getRegion(page, "IT-21", 13, "piemonte.svg"),
				await getRegion(page, "IT-75", 14, "puglia.svg"),
				await getRegion(page, "IT-88", 15, "sardegna.svg"),
				await getRegion(page, "IT-82", 16, "sicilia.svg"),
				await getRegion(page, "IT-52", 17, "toscana.svg"),
				await getRegion(page, "IT-32-T", 18, "trento.svg"),
				await getRegion(page, "IT-55", 19, "umbria.svg"),
				await getRegion(page, "IT-23", 20, "valledaosta.svg"),
				await getRegion(page, "IT-34", 21, "veneto.svg")
			]
		}

		res.append(day)

	f = open("grabberResult.json", "w")
	f.write(json.dumps(res, indent=2))
	f.close()
	await browser.close()

asyncio.get_event_loop().run_until_complete(main())