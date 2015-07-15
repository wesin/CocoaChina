function parseSpecials() {
	var specialList = document.querySelectorAll('div.special')
	list = []
	for (var i =0 ;i < specialList.length; ++i) {
		var item = specialList[i]
		var imgUrl = item.querySelector('img').getAttribute('src')
		var title = item.querySelector('h4 a').textContent
		var url = item.querySelector('h4 a').getAttribute('href')
		var content = item.querySelector('.special-intro').textContent
        list.push({'title':title, 'url': url, 'imgurl':imgUrl,'content':content})
	}
	return list
}

var result = {'special':parseSpecials()}

webkit.messageHandlers.mainhandler.postMessage(result);