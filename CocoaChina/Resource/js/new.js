var tjLst = document.querySelectorAll('.forum-c ul li')

function parseLists() {
	list = []
	for (var i = 0; i < tjLst.length; ++i) {
		var item = tjLst[i];
		var url = item.querySelector('li a').getAttribute('href')
		var imgUrl = item.querySelector('img').getAttribute('src')
		var title = item.querySelector('li a').getAttribute('title')
		var content = item.querySelector('div p').textContent
        var time = item.querySelector('div span').textContent.replace(/\s+/g,"");
		list.push({'title':title, 'url':url, 'imgurl':imgUrl, 'content':content, 'time':time})
	}
	return list
}

webkit.messageHandlers.mainhandler.postMessage(parseLists());
