(function(){window.bloodhound=function(){var i,n,t,r,e,o;return n=[{string:navigator.userAgent,subString:"Chrome",identity:"Chrome"},{string:navigator.userAgent,subString:"OmniWeb",versionSearch:"OmniWeb/",identity:"OmniWeb"},{string:navigator.vendor,subString:"Apple",identity:"Safari",versionSearch:"Version"},{prop:window.opera,identity:"Opera",versionSearch:"Version"},{string:navigator.vendor,subString:"iCab",identity:"iCab"},{string:navigator.vendor,subString:"KDE",identity:"Konqueror"},{string:navigator.userAgent,subString:"Firefox",identity:"Firefox"},{string:navigator.vendor,subString:"Camino",identity:"Camino"},{string:navigator.userAgent,subString:"Netscape",identity:"Netscape"},{string:navigator.userAgent,subString:"MSIE",identity:"Explorer",versionSearch:"MSIE"},{string:navigator.userAgent,subString:"Gecko",identity:"Mozilla",versionSearch:"rv"},{string:navigator.userAgent,subString:"Mozilla",identity:"Netscape",versionSearch:"Mozilla"}],r=[{string:navigator.platform,subString:"Win",identity:"Windows"},{string:navigator.platform,subString:"Mac",identity:"Mac"},{string:navigator.userAgent,subString:"iPhone",identity:"iPhone/iPod"},{string:navigator.platform,subString:"Linux",identity:"Linux"}],o=function(i){var n,t,r,e;for(t=0,r=i.length;r>t;t++)if(n=i[t],n.prop||-1!==(null!=(e=n.string)?e.indexOf(n.subString):void 0))return n},t=function(i,n){var t;return t=i.indexOf(n),-1!==t?parseFloat(i.substring(t+n.length+1)):void 0},i=o(n),e={browser:i.identity,os:o(r).identity,version:t(navigator.userAgent||navigator.appVersion,i.versionSearch||i.identity)||"an unknown version"}}}).call(this);

(function(){
  browser_info = bloodhound()
  mixpanel.track("pageview", {
    title: document.title,
    url: window.location.href,
    $browser: "" + browser_info.browser + " " + browser_info.version,
    $os: browser_info.os
  });
}).call(this)