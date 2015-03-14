!function(e,t){"use strict";t.module("ngMessages",[]).directive("ngMessages",["$compile","$animate","$templateRequest",function(e,n,r){var i="ng-active",a="ng-inactive";return{restrict:"AE",controller:function(){this.$renderNgMessageClasses=t.noop;var e=[];this.registerMessage=function(t,n){for(var r=0;r<e.length;r++)if(e[r].type==n.type){if(t!=r){var i=e[t];e[t]=e[r],t<e.length?e[r]=i:e.splice(0,r)}return}e.splice(t,0,n)},this.renderMessages=function(n,r){function i(e){return null!==e&&e!==!1&&e}n=n||{};var a;t.forEach(e,function(e){a&&!r||!i(n[e.type])?e.detach():(e.attach(),a=!0)}),this.renderElementClasses(a)}},require:"ngMessages",link:function(o,s,l,u){u.renderElementClasses=function(e){e?n.setClass(s,i,a):n.setClass(s,a,i)};var c,d=t.isString(l.ngMessagesMultiple)||t.isString(l.multiple),f=l.ngMessages||l["for"];o.$watchCollection(f,function(e){c=e,u.renderMessages(e,d)});var p=l.ngMessagesInclude||l.include;p&&r(p).then(function(n){var r,i=t.element("<div/>").html(n);t.forEach(i.children(),function(n){n=t.element(n),r?r.after(n):s.prepend(n),r=n,e(n)(o)}),u.renderMessages(c,d)})}}}]).directive("ngMessage",["$animate",function(e){var t=8;return{require:"^ngMessages",transclude:"element",terminal:!0,restrict:"AE",link:function(n,r,i,a,o){for(var s,l,u=r[0],c=u.parentNode,d=0,f=0;d<c.childNodes.length;d++){var p=c.childNodes[d];if(p.nodeType==t&&p.nodeValue.indexOf("ngMessage")>=0){if(p===u){s=f;break}f++}}a.registerMessage(s,{type:i.ngMessage||i.when,attach:function(){l||o(n,function(t){e.enter(t,null,r),l=t})},detach:function(){l&&(e.leave(l),l=null)}})}}}])}(window,window.angular);