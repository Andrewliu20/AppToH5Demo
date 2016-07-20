#!/bin/sh

#  Script.sh
#  AppToH5Demo
#
#  Created by andrewliu on 16/7/17.
#  Copyright © 2016年 andrewliu. All rights reserved.

function CountFun(registerInfo, postUrl, zoneUrl, lendUrl,searchUrl) {
var register = 0;
var userId = "";
if (registerInfo != null) {
register = 1;
userId = registerInfo["UserId"];
}
//var lendUrl = location.toString().split('?')[0];
//var zoneUrl = location.host.toString();

var theRequest = GetRequest(searchUrl);//获取请求参数
theRequest["Keywords"] = theRequest["keyword"];
theRequest["SourceId"] = theRequest["source"];
var key = theRequest["Keywords"] + theRequest["SourceId"] + zoneUrl;
var guid = uuid();
theRequest["time"] = new Date();//设置日期 第一次访问存Cookie
theRequest["ZoneUrl"] = lendUrl;
// PC端存Cookie
if (CheckClientPc()) {
var angentCookie = getCookie("agent");
if (angentCookie == null || angentCookie == "undefined" || angentCookie == undefined) {
setCookie("agent", guid);
}
var cookie = getCookie(key);
theRequest["GuId"] = getCookie("agent");
if (cookie == null || cookie == "undefined") {
if (theRequest["Keywords"] != undefined && theRequest["SourceId"] != undefined) {
setCookie(key, JSON.stringify(theRequest));
}
}
//如果注册则从Cookie中取出第一次访问的关键词、渠道以及时间信息
if (register == 1) {
if (cookie != null) {
var cookieData = JSON.parse(cookie);
theRequest["time"] = cookieData["time"];
theRequest["Keywords"] = cookieData["Keywords"];
theRequest["SourceId"] = cookieData["SourceId"];
}
}
} else {
// 移动端存入localstorage
var angentStorage = localStorage.getItem("agent");
if (angentStorage == null || angentStorage == "undefined" || angentStorage == undefined) {
localStorage.setItem("agent", guid);
}
theRequest["GuId"] = localStorage.getItem("agent");
var storage = localStorage.getItem(key);
if (storage == null || storage == "undefined") {
if (theRequest["Keywords"] != undefined && theRequest["SourceId"] != undefined) {
localStorage.setItem(key, JSON.stringify(theRequest));
}
}
if (register == 1) {
if (storage != null) {
var storageData = JSON.parse(storage);
theRequest["time"] = storageData["time"];
theRequest["Keywords"] = storageData["Keywords"];
theRequest["SourceId"] = storageData["SourceId"];
}
}
}

theRequest["Register"] = register;
theRequest["UserId"] = userId == "" ? 0 : userId;
var data = { Keywords: theRequest["Keywords"], SourceId: theRequest["SourceId"], Register: theRequest["Register"], UserId: theRequest["UserId"], Time: theRequest["time"], AcrossLink: lendUrl, ZoneUrl: theRequest["ZoneUrl"], GuId: theRequest["GuId"] };
if (data.Keywords == undefined || data.SourceId == undefined) {
//console.log("非标准格式推广链接");
return;
}
PostInfo(data, postUrl);
}

function GetRlinkStau(postUrl, errorUrl) {
var theRequest = GetRequest();//获取请求参数
theRequest["Keywords"] = theRequest["keyword"];
theRequest["SourceId"] = theRequest["source"];
var data = { Keywords: theRequest["Keywords"], SourceId: theRequest["SourceId"], LendUrl: location.toString().split('?')[0] };
if (theRequest["Keywords"] == null || theRequest["SourceId"] == null)
return;
$.ajax({
cache: true,
url: postUrl,
data: data,//iframe下叫form1的表单
dataType: 'jsonp',
jsonp: 'callback',
context: this,
async: false,
error: function () {
window.location.href = errorUrl;
},
success: function (result) {
if (result != "1") {
window.location.href = errorUrl;
}
}
});
}

//提交数据
function PostInfo(dataCollection, postUrl) {
$.ajax({
cache: true,
type: "POST",
url: postUrl,
dataType: 'jsonp',
data: dataCollection,//iframe下叫form1的表单
jsonp: 'callback',
context: this,
async: true,
error: function (request) {
console.log(request);
//console.log("非标准格式推广");
},
success: function (data) {
if (data[0].key == "1")
alert(data[0].value);
//console.log(data);
//console.log("1");
}
});
}
//获取推广链接信息
function GetRequest(search) {
//var url = location.search; //获取url中"?"符后的字串
var url = search; //获取url中"?"符后的字串
var theRequest = new Object();
if (url.indexOf("?") != -1) {
var str = url.substr(1);
strs = str.split("&");
for (var i = 0; i < strs.length; i++) {
theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
}
}
return theRequest;
}
//设置Cookie
function setCookie(name, value) {
var days = 30;
var exp = new Date();
exp.setTime(exp.getTime() + days * 24 * 60 * 60 * 1000);
document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
}
//清除Cookie
function delCookie(name) {
var exp = new Date();
exp.setTime(exp.getTime() - 1);
var cval = getCookie(name);
if (cval != null)
document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
}
//获取Cookie
function getCookie(name) {
var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
if (arr = document.cookie.match(reg))
return unescape(arr[2]);
else
return null;
}

function CheckClientPc() {

if (/AppleWebKit.*Mobile/i.test(navigator.userAgent)) {
return false;
}
return true;
//if (window.location.toString().indexOf('pref=padindex') != -1) {
//    return true;
//} else {
//    return false;
//    if (/AppleWebKit.*Mobile/i.test(navigator.userAgent) || (/MIDP|SymbianOS|NOKIA|SAMSUNG|LG|NEC|TCL|Alcatel|BIRD|DBTEL|Dopod|PHILIPS|HAIER|LENOVO|MOT-|Nokia|SonyEricsson|SIE-|Amoi|ZTE/.test(navigator.userAgent))) {
//        if (window.location.href.indexOf("?mobile") < 0) {
//            try {
//                if (/Android|Windows Phone|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)) {
//                    return false;
//                } else if (/iPad/i.test(navigator.userAgent)) {
//                    return false;
//                }
//            } catch(e) {
//                return false;
//            }
//        }
//    }
//}
}

function uuid() {
var s = [];
var hexDigits = "0123456789abcdef";
for (var i = 0; i < 36; i++) {
s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
}
s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
s[8] = s[13] = s[18] = s[23] = "-";

var uuid = s.join("");
return uuid;
}