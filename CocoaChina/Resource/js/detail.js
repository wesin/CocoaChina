//document.querySelector('header').hidden = true;
var styleTag = document.createElement("style");
styleTag.textContent = 'header {display:none;} .mthead {padding-top:0;}';
document.documentElement.appendChild(styleTag);