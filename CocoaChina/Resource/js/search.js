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


function getNextPageUrl() {
    var list = document.querySelectorAll('.pagelist td')
    if (list.length == 0) {
        return null
    }
    var item = list[0]
    for (var i = 0; i < list.length; ++i) {
        item = list[i]
        if (item.childElementCount > 0) {
            continue
        }
        if (item.attributes.length > 0) {
            continue
        }
        break
    }
    
    return item.nextElementSibling.querySelector('a').getAttribute('href')
}

var result = {'result':parseResultList(), 'nexturl':getNextPageUrl()}

webkit.messageHandlers.searchhandler.postMessage(result);