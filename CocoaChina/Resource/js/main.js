var tjLst = document.querySelectorAll('ul#slide_list li')

function parseLists() {
	list = []
	for (var i = 0; i < tjLst.length; ++i) {
		var item = tjLst[i];
		var url = item.querySelector('li a').getAttribute('href')
		var img = item.querySelector('img')
		var imgUrl = img.getAttribute('src')
		var title = img.getAttribute('title')
		var content = item.querySelector('span i').textContent
		list.push({'title':title, 'url':url, 'imgurl':imgUrl})
	}
	return list
}

webkit.messageHandlers.mainhandler.postMessage(parseLists());
