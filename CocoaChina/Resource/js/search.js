function parseResultList() {
	var resultList = document.querySelectorAll('.leftSide.float-l div ul li')
	list = []
	for (var i =0 ;i < resultList.length; ++i) {
		var item = resultList[i]
		var title = item.querySelector('.clearfix.newstitle a').textContent
		var url = item.querySelector('.clearfix.newstitle a').getAttribute('href')
		var content = item.querySelectorAll('div')[1].textContent
		var time = item.querySelector('.post-time').textContent
		var click = item.querySelectorAll('.float-l span')[1].textContent
        list.push({'title':title, 'url': url, 'time':time,'click':click,'content':content})
	}
	return list
}

var result = {'result':parseResultList()}

webkit.messageHandlers.searchhandler.postMessage(result);