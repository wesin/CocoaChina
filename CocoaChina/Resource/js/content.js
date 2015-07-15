
function parseContentList() {
	var contents = document.querySelectorAll('div.leftSide.float-l.article-list div ul li')
	var list = []
	for (var i = 0; i < contents.length; ++i) {
		var item = contents[i]
		var title = item.querySelector('.newsinfor a').getAttribute('title')
		var content = item.querySelector('.newsinfor').textContent
		var imgUrl = item.querySelector('img').getAttribute('src')
		var url = item.querySelector('.newsinfor a').getAttribute('href')
		var time = item.querySelector('.post-time').textContent
		var click = item.querySelectorAll('.float-l span')[1].textContent
		list.push({'title':title, 'content':content,'imgurl':imgUrl, 'time':time,'click':click,'url':url})
	}
	var nextUrl = document.querySelector('.thisclass').nextSibling.getAttribute('href')
	return {"content":list, "nexturl":nextUrl}
}

webkit.messageHandlers.contenthandler.postMessage(parseContentList());

