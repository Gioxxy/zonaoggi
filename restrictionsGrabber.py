import asyncio
import datetime
import json
from pyppeteer import launch

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

	await page.tap('[color="giallo"]')
	lis = await page.querySelectorAll('.css-16qr889-Item')
	giallo = []
	for li in lis:
		icon = await page.evaluate('(el) => el.children[0].getAttribute("class")', li)
		desc = await page.evaluate('(el) => el.children[1].textContent', li)
		giallo.append({"icon": icon.replace("fas ", ""), "desc": desc})

	await page.tap('[color="arancione"]')
	lis = await page.querySelectorAll('.css-16qr889-Item')
	arancione = []
	for li in lis:
		icon = await page.evaluate('(el) => el.children[0].getAttribute("class")', li)
		desc = await page.evaluate('(el) => el.children[1].textContent', li)
		arancione.append({"icon": icon.replace("fas ", ""), "desc": desc})

	await page.tap('[color="rosso"]')
	lis = await page.querySelectorAll('.css-16qr889-Item')
	rosso = []
	for li in lis:
		icon = await page.evaluate('(el) => el.children[0].getAttribute("class")', li)
		desc = await page.evaluate('(el) => el.children[1].textContent', li)
		rosso.append({"icon": icon.replace("fas ", ""), "desc": desc})

	res = {"gialla": giallo, "arancione": arancione, "rossa": rosso}

	f = open("restrictionsGrabberResult.json", "w", encoding='utf-8')
	f.write(json.dumps(res, indent=2, ensure_ascii=False))
	f.close()
	await browser.close()

asyncio.get_event_loop().run_until_complete(main())