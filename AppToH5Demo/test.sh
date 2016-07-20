#!/bin/sh

#  test.sh
#  AppToH5Demo
#
#  Created by andrewliu on 16/7/18.
#  Copyright © 2016年 andrewliu. All rights reserved.

var lendUrl = location.toString().split("?")[0];
var zoneUrl = location.host.toString();
var searchUrl = location.search;
var data = { UserId: "" };
CountFun(data, 'http://tongji.niuduz.com/DataCollect/AddData', zoneUrl, lendUrl, searchUrl);
//刮卡请求接口
$(function () {
var id = localStorage.getItem("Id");
if (id>0) {
$.ajax({
url: "/Api/Activity/Verify",
type: "POST",
dataType: 'json',
data: { UserId: localStorage.getItem("Id"), Platform: 3 },
success: function (data) {
if (data.Code == 200) {
if (data.Data.AwardNum == "") {
if (data.Data.IsPhoVali == 1) {
//跳到刮奖页面
$(".tombola").show();
$('#redux').eraser({
completeRatio: .5,
completeFunction: function () {
$.ajax({
url: "/Api/Activity/GetMovieAward",
type: "POST",
dataType: 'json',
data: { UserId: localStorage.getItem("Id"), TypeId: 7, Platform: 3 },
success: function (data) {
if (data.Code == 200) {
$("#navt").val(data.Data.AwardNum);
console.log("awardnum");
} else {
//展示提示信息
$("#word").html(data.Massage);
$(".ati").show();
//    alert(data.Massage);
}
},
error: function (data) {
//报错 do something
}
});
}
});
} else {
//跳到验证手页面
$(".login").show();
$("#loginbtn").click(function () {
if ($("#phonenumber").val().length <= 0) {
alert("请输入手机号码");
return;
}
if (!/^(13[0-9]|14[57]|15[0-35-9]|18[0-9]|17[0-9])[0-9]{8}$/.test($("#phonenumber").val())) {
alert("请输入正确的手机号码");
return;
}
if ($("#verifytxt").val().length <= 0) {
alert("请输入验证码");
return;
}
//if (verifycode == null) {
//    alert("你还未获取验证码");
//    return;
//}

$.ajax({
url: "/Api/Personal/MobileBind",
type: "POST",
dataType: 'json',
data: { Mobile: $("#phonenumber").val(), UserId: localStorage.getItem("Id"), Code: $("#verifytxt").val(), Platform: 3 ,TypeId:4},
success: function (data) {
if (data.Code == 200) {
// 展示刮卡页面
$(".tombola").show();
$(".login").hide();
$(".ati").hide();
$('#redux').eraser({
completeRatio: .1,
completeFunction: function () {
$.ajax({
url: "/Api/Activity/GetMovieAward",
type: "POST",
dataType: 'json',
data: { UserId: localStorage.getItem("Id"), TypeId: 7, Platform: 3 },
success: function (data) {
if (data.Code == 200) {
$("#navt").val(data.Data.AwardNum);
//console.log("awardnum");
} else {
//展示提示信息
$("#word").html(data.Massage);
$(".ati").show();
$(".login").hide();
$(".tombola").hide();

//alert(data.Massage);
}
},
error: function (data) {
//报错 do something
}
});
}
});

} else {
alert(data.Massage);

}
}
});
});
}
} else {
//展示兑奖码
$(".tombola").show();
$("#navt").val(data.Data.AwardNum);
$("#redux").hide();

}

} else {
//展示提示信息
$("#word").html(data.Massage + "<br/>" + "这里有<a href='http://www.mochoujun.com/partner?bqsz' style='color:blue;'>更多活动</a>");
//attition = data.Massage;
$(".ati").show();
}
}
});
} else {
window.location.href = "http://www.mochoujun.com/app#/login";
}

var verifycode = null;
$("#verifybtn").click(function () {
if ($("#phonenumber").val().length <= 0) {
alert("请输入手机号码");
return;
}
if (!/^(13[0-9]|14[57]|15[0-35-9]|18[0-9]|17[0-9])[0-9]{8}$/.test($("#phonenumber").val())) {
alert("请输入正确的手机号码");
return;
}
settime($("#verifybtn"));
$.ajax({
url: "/Api/Auth/SendMobCode",
type: "POST",
dataType: 'json',
data: { Mobile: $("#phonenumber").val(), TypeId: 4, Platform: 3 },
success: function (data) {
if (data.Code == 200) {
verifycode = data.Data;
} else {
$("#verifybtn").removeAttr("disabled");
$("#verifybtn").val("获取验证码");
$("#verifybtn").removeAttr("style");
countdown = 60;
window.clearTimeout(st);
alert(data.Massage);
}
},
error: function (data) {
// 报错 do something
}
});
});
});
var countdown = 60;
var st;
function settime(val) {
if (countdown != 0) {
st = setTimeout(function () {
settime(val);
}, 1000);
}
if (countdown == 0) {
val.removeAttr("disabled");
val.val("获取验证码");
val.removeAttr("style");
countdown = 60;
window.clearTimeout(st);
} else {
val.attr("disabled", true);
val.css({ "background": "#CCC", "color": "#fff" });
val.val("重新发送(" + countdown + ")");
countdown--;
}
}

$(function () {
$.post("/api/Auth/GetShareParameter", { Platform: 3, Url: window.location.href }, function (data) {
wx.config({
appId: data.Data.appId,
timestamp: data.Data.timestamp,
nonceStr: data.Data.nonceStr,
signature: data.Data.sign,
jsApiList: ["onMenuShareTimeline", "onMenuShareAppMessage", "onMenuShareQQ", "onMenuShareWeibo", "onMenuShareQZone"]
});
});
wx.ready(function () {
wx.onMenuShareTimeline({
title: "我在陌筹君领取了免费电影票，端午节可以陪家人看电影啦",
link: location.href,
imgUrl: "http://img.niuduz.com/2016/06/07/d65c4198-5c3a-4c59-87cb-113cbab96e1f.jpg!240",
success: function () {

},
cancel: function () {
}
});
wx.onMenuShareAppMessage({
title: "我在陌筹君领取了免费电影票，端午节可以陪家人看电影啦",
desc: "www.mochoujun.com",
link: location.href,
imgUrl: "http://img.niuduz.com/2016/06/07/d65c4198-5c3a-4c59-87cb-113cbab96e1f.jpg!240",
type: '    ',
dataUrl: '',
success: function () {

},
cancel: function () {
}
});
wx.onMenuShareQQ({
title: "我在陌筹君领取了免费电影票，端午节可以陪家人看电影啦",
desc: "www.mochoujun.com",
link: location.href,
imgUrl: "http://img.niuduz.com/2016/06/07/d65c4198-5c3a-4c59-87cb-113cbab96e1f.jpg!240",
success: function () {
},
cancel: function () {
}
});
wx.onMenuShareWeibo({
title: "我在陌筹君领取了免费电影票，端午节可以陪家人看电影啦",
desc: "www.mochoujun.com",
link: location.href,
imgUrl: "http://img.niuduz.com/2016/06/07/d65c4198-5c3a-4c59-87cb-113cbab96e1f.jpg!240",
success: function () {

},
cancel: function () {
}
});
wx.onMenuShareQZone({
title: "我在陌筹君领取了免费电影票，端午节可以陪家人看电影啦",
desc: "www.mochoujun.com",
link: location.href,
imgUrl: "http://img.niuduz.com/2016/06/07/d65c4198-5c3a-4c59-87cb-113cbab96e1f.jpg!240",
success: function () {
},
cancel: function () {
}
});
})
})
