//document.querySelector('header').hidden = true;
var styleTag = document.createElement("style");
styleTag.textContent = 'header {display:none;} .mthead {padding-top:0;} footer {display:none;}';
document.documentElement.appendChild(styleTag);