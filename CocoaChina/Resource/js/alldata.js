
function parseMainLists() {
	var mainLst = document.querySelectorAll('ul#slide_list li')
	list = []
	for (var i = 0; i < mainLst.length; ++i) {
		var item = mainLst[i];
		var url = item.querySelector('li a').getAttribute('href')
		var img = item.querySelector('img')
		var imgUrl = img.getAttribute('src')
		var title = img.getAttribute('title')
		var content = item.querySelector('span i').textContent
		list.push({'title':title, 'url':url, 'imgurl':imgUrl, 'content':content})
	}
	return list
}

function parseNewLists() {
	var newLst = document.querySelectorAll('.forum-c ul li')
	list = []
	for (var i = 0; i < newLst.length; ++i) {
		var item = newLst[i];
		var url = item.querySelector('li a').getAttribute('href')
		var imgUrl = item.querySelector('img').getAttribute('src')
		var title = item.querySelector('li a').getAttribute('title')
		var content = item.querySelector('li a div p').textContent
        var time = item.querySelector('div span').textContent.replace(/\s+/g,"");
		list.push({'title':title, 'url':url, 'imgurl':imgUrl, 'content':content, 'time':time})
	}
	return list
}

var result = {'main':parseMainLists(),'new':parseNewLists()}

webkit.messageHandlers.mainhandler.postMessage(result);


