!function(e,t,n){"use strict";function r(e){var t;if(t=e.match(u)){var n=new Date(0),r=0,a=0;return t[9]&&(r=i(t[9]+t[10]),a=i(t[9]+t[11])),n.setUTCFullYear(i(t[1]),i(t[2])-1,i(t[3])),n.setUTCHours(i(t[4]||0)-r,i(t[5]||0)-a,i(t[6]||0),i(t[7]||0)),n}return e}function i(e){return parseInt(e,10)}function a(e,t,n){var r="";for(0>e&&(r="-",e=-e),e=""+e;e.length<t;)e="0"+e;return n&&(e=e.substr(e.length-t)),r+e}function o(e,r,i,a){function o(e,n,r,i){return t.isFunction(e)?e:function(){return t.isNumber(e)?[e,n,r,i]:[200,e,n,r]}}function u(e,o,s,u,c,g,v){function $(e){return t.isString(e)||t.isFunction(e)||e instanceof RegExp?e:t.toJson(e)}function y(t){function i(){var n=t.response(e,o,s,c);b.$$respHeaders=n[2],u(m(n[0]),m(n[1]),b.getAllResponseHeaders(),m(n[3]||""))}function l(){for(var e=0,t=p.length;t>e;e++)if(p[e]===i){p.splice(e,1),u(-1,n,"");break}}return!a&&g&&(g.then?g.then(l):r(l,g)),i}var b=new l,w=f[0],x=!1;if(w&&w.match(e,o)){if(!w.matchData(s))throw new Error("Expected "+w+" with different data\nEXPECTED: "+$(w.data)+"\nGOT:      "+s);if(!w.matchHeaders(c))throw new Error("Expected "+w+" with different headers\nEXPECTED: "+$(w.headers)+"\nGOT:      "+$(c));if(f.shift(),w.response)return void p.push(y(w));x=!0}for(var k,C=-1;k=d[++C];)if(k.match(e,o,s,c||{})){if(k.response)(a?a.defer:h)(y(k));else{if(!k.passThrough)throw new Error("No response defined !");i(e,o,s,u,c,g,v)}return}throw new Error(x?"No response defined !":"Unexpected request: "+e+" "+o+"\n"+(w?"Expected "+w:"No more request expected"))}function c(e){t.forEach(["GET","DELETE","JSONP","HEAD"],function(t){u[e+t]=function(r,i){return u[e](t,r,n,i)}}),t.forEach(["PUT","POST","PATCH"],function(t){u[e+t]=function(n,r,i){return u[e](t,n,r,i)}})}var d=[],f=[],p=[],h=t.bind(p,p.push),m=t.copy;return u.when=function(e,t,r,i){var l=new s(e,t,r,i),u={respond:function(e,t,r,i){return l.passThrough=n,l.response=o(e,t,r,i),u}};return a&&(u.passThrough=function(){return l.response=n,l.passThrough=!0,u}),d.push(l),u},c("when"),u.expect=function(e,t,n,r){var i=new s(e,t,n,r),a={respond:function(e,t,n,r){return i.response=o(e,t,n,r),a}};return f.push(i),a},c("expect"),u.flush=function(n,r){if(r!==!1&&e.$digest(),!p.length)throw new Error("No pending request to flush !");if(t.isDefined(n)&&null!==n)for(;n--;){if(!p.length)throw new Error("No more pending request to flush !");p.shift()()}else for(;p.length;)p.shift()();u.verifyNoOutstandingExpectation(r)},u.verifyNoOutstandingExpectation=function(t){if(t!==!1&&e.$digest(),f.length)throw new Error("Unsatisfied requests: "+f.join(", "))},u.verifyNoOutstandingRequest=function(){if(p.length)throw new Error("Unflushed requests: "+p.length)},u.resetExpectations=function(){f.length=0,p.length=0},u}function s(e,n,r,i){this.data=r,this.headers=i,this.match=function(n,r,i,a){return e!=n?!1:this.matchUrl(r)?t.isDefined(i)&&!this.matchData(i)?!1:t.isDefined(a)&&!this.matchHeaders(a)?!1:!0:!1},this.matchUrl=function(e){return n?t.isFunction(n.test)?n.test(e):t.isFunction(n)?n(e):n==e:!0},this.matchHeaders=function(e){return t.isUndefined(i)?!0:t.isFunction(i)?i(e):t.equals(i,e)},this.matchData=function(e){return t.isUndefined(r)?!0:r&&t.isFunction(r.test)?r.test(e):r&&t.isFunction(r)?r(e):r&&!t.isString(r)?t.equals(t.fromJson(t.toJson(r)),t.fromJson(e)):r==e},this.toString=function(){return e+" "+n}}function l(){l.$$lastInstance=this,this.open=function(e,t,n){this.$$method=e,this.$$url=t,this.$$async=n,this.$$reqHeaders={},this.$$respHeaders={}},this.send=function(e){this.$$data=e},this.setRequestHeader=function(e,t){this.$$reqHeaders[e]=t},this.getResponseHeader=function(e){var r=this.$$respHeaders[e];return r?r:(e=t.lowercase(e),(r=this.$$respHeaders[e])?r:(r=n,t.forEach(this.$$respHeaders,function(n,i){r||t.lowercase(i)!=e||(r=n)}),r))},this.getAllResponseHeaders=function(){var e=[];return t.forEach(this.$$respHeaders,function(t,n){e.push(n+": "+t)}),e.join("\n")},this.abort=t.noop}t.mock={},t.mock.$BrowserProvider=function(){this.$get=function(){return new t.mock.$Browser}},t.mock.$Browser=function(){var e=this;this.isMock=!0,e.$$url="http://server/",e.$$lastUrl=e.$$url,e.pollFns=[],e.$$completeOutstandingRequest=t.noop,e.$$incOutstandingRequestCount=t.noop,e.onUrlChange=function(t){return e.pollFns.push(function(){(e.$$lastUrl!==e.$$url||e.$$state!==e.$$lastState)&&(e.$$lastUrl=e.$$url,e.$$lastState=e.$$state,t(e.$$url,e.$$state))}),t},e.$$checkUrlChange=t.noop,e.cookieHash={},e.lastCookieHash={},e.deferredFns=[],e.deferredNextId=0,e.defer=function(t,n){return n=n||0,e.deferredFns.push({time:e.defer.now+n,fn:t,id:e.deferredNextId}),e.deferredFns.sort(function(e,t){return e.time-t.time}),e.deferredNextId++},e.defer.now=0,e.defer.cancel=function(r){var i;return t.forEach(e.deferredFns,function(e,t){e.id===r&&(i=t)}),i!==n?(e.deferredFns.splice(i,1),!0):!1},e.defer.flush=function(n){if(t.isDefined(n))e.defer.now+=n;else{if(!e.deferredFns.length)throw new Error("No deferred tasks to be flushed");e.defer.now=e.deferredFns[e.deferredFns.length-1].time}for(;e.deferredFns.length&&e.deferredFns[0].time<=e.defer.now;)e.deferredFns.shift().fn()},e.$$baseHref="/",e.baseHref=function(){return this.$$baseHref}},t.mock.$Browser.prototype={poll:function(){t.forEach(this.pollFns,function(e){e()})},addPollFn:function(e){return this.pollFns.push(e),e},url:function(e,n,r){return t.isUndefined(r)&&(r=null),e?(this.$$url=e,this.$$state=t.copy(r),this):this.$$url},state:function(){return this.$$state},cookies:function(e,n){return e?void(t.isUndefined(n)?delete this.cookieHash[e]:t.isString(n)&&n.length<=4096&&(this.cookieHash[e]=n)):(t.equals(this.cookieHash,this.lastCookieHash)||(this.lastCookieHash=t.copy(this.cookieHash),this.cookieHash=t.copy(this.cookieHash)),this.cookieHash)},notifyWhenNoOutstandingRequests:function(e){e()}},t.mock.$ExceptionHandlerProvider=function(){var e;this.mode=function(t){switch(t){case"log":case"rethrow":var n=[];e=function(e){if(n.push(1==arguments.length?e:[].slice.call(arguments,0)),"rethrow"===t)throw e},e.errors=n;break;default:throw new Error("Unknown mode '"+t+"', only 'log'/'rethrow' modes are allowed!")}},this.$get=function(){return e},this.mode("rethrow")},t.mock.$LogProvider=function(){function e(e,t,n){return e.concat(Array.prototype.slice.call(t,n))}var n=!0;this.debugEnabled=function(e){return t.isDefined(e)?(n=e,this):n},this.$get=function(){var r={log:function(){r.log.logs.push(e([],arguments,0))},warn:function(){r.warn.logs.push(e([],arguments,0))},info:function(){r.info.logs.push(e([],arguments,0))},error:function(){r.error.logs.push(e([],arguments,0))},debug:function(){n&&r.debug.logs.push(e([],arguments,0))}};return r.reset=function(){r.log.logs=[],r.info.logs=[],r.warn.logs=[],r.error.logs=[],r.debug.logs=[]},r.assertEmpty=function(){var e=[];if(t.forEach(["error","warn","info","log","debug"],function(n){t.forEach(r[n].logs,function(r){t.forEach(r,function(t){e.push("MOCK $log ("+n+"): "+String(t)+"\n"+(t.stack||""))})})}),e.length)throw e.unshift("Expected $log to be empty! Either a message was logged unexpectedly, or an expected log message was not checked and removed:"),e.push(""),new Error(e.join("\n---------\n"))},r.reset(),r}},t.mock.$IntervalProvider=function(){this.$get=["$browser","$rootScope","$q","$$q",function(e,r,i,a){var o=[],s=0,l=0,u=function(u,c,d,f){function p(){if(g.notify(h++),d>0&&h>=d){var i;g.resolve(h),t.forEach(o,function(e,t){e.id===v.$$intervalId&&(i=t)}),i!==n&&o.splice(i,1)}m?e.defer.flush():r.$apply()}var h=0,m=t.isDefined(f)&&!f,g=(m?a:i).defer(),v=g.promise;return d=t.isDefined(d)?d:0,v.then(null,null,u),v.$$intervalId=s,o.push({nextTime:l+c,delay:c,fn:p,id:s,deferred:g}),o.sort(function(e,t){return e.nextTime-t.nextTime}),s++,v};return u.cancel=function(e){if(!e)return!1;var r;return t.forEach(o,function(t,n){t.id===e.$$intervalId&&(r=n)}),r!==n?(o[r].deferred.reject("canceled"),o.splice(r,1),!0):!1},u.flush=function(e){for(l+=e;o.length&&o[0].nextTime<=l;){var t=o[0];t.fn(),t.nextTime+=t.delay,o.sort(function(e,t){return e.nextTime-t.nextTime})}return e},u}]};var u=/^(\d{4})-?(\d\d)-?(\d\d)(?:T(\d\d)(?:\:?(\d\d)(?:\:?(\d\d)(?:\.(\d{3}))?)?)?(Z|([+-])(\d\d):?(\d\d)))?$/;if(t.mock.TzDate=function(e,n){var i=new Date(0);if(t.isString(n)){var o=n;if(i.origDate=r(n),n=i.origDate.getTime(),isNaN(n))throw{name:"Illegal Argument",message:"Arg '"+o+"' passed into TzDate constructor is not a valid date string"}}else i.origDate=new Date(n);var s=new Date(n).getTimezoneOffset();i.offsetDiff=60*s*1e3-1e3*e*60*60,i.date=new Date(n+i.offsetDiff),i.getTime=function(){return i.date.getTime()-i.offsetDiff},i.toLocaleDateString=function(){return i.date.toLocaleDateString()},i.getFullYear=function(){return i.date.getFullYear()},i.getMonth=function(){return i.date.getMonth()},i.getDate=function(){return i.date.getDate()},i.getHours=function(){return i.date.getHours()},i.getMinutes=function(){return i.date.getMinutes()},i.getSeconds=function(){return i.date.getSeconds()},i.getMilliseconds=function(){return i.date.getMilliseconds()},i.getTimezoneOffset=function(){return 60*e},i.getUTCFullYear=function(){return i.origDate.getUTCFullYear()},i.getUTCMonth=function(){return i.origDate.getUTCMonth()},i.getUTCDate=function(){return i.origDate.getUTCDate()},i.getUTCHours=function(){return i.origDate.getUTCHours()},i.getUTCMinutes=function(){return i.origDate.getUTCMinutes()},i.getUTCSeconds=function(){return i.origDate.getUTCSeconds()},i.getUTCMilliseconds=function(){return i.origDate.getUTCMilliseconds()},i.getDay=function(){return i.date.getDay()},i.toISOString&&(i.toISOString=function(){return a(i.origDate.getUTCFullYear(),4)+"-"+a(i.origDate.getUTCMonth()+1,2)+"-"+a(i.origDate.getUTCDate(),2)+"T"+a(i.origDate.getUTCHours(),2)+":"+a(i.origDate.getUTCMinutes(),2)+":"+a(i.origDate.getUTCSeconds(),2)+"."+a(i.origDate.getUTCMilliseconds(),3)+"Z"});var l=["getUTCDay","getYear","setDate","setFullYear","setHours","setMilliseconds","setMinutes","setMonth","setSeconds","setTime","setUTCDate","setUTCFullYear","setUTCHours","setUTCMilliseconds","setUTCMinutes","setUTCMonth","setUTCSeconds","setYear","toDateString","toGMTString","toJSON","toLocaleFormat","toLocaleString","toLocaleTimeString","toSource","toString","toTimeString","toUTCString","valueOf"];return t.forEach(l,function(e){i[e]=function(){throw new Error("Method '"+e+"' is not implemented in the TzDate mock")}}),i},t.mock.TzDate.prototype=Date.prototype,t.mock.animate=t.module("ngAnimateMock",["ng"]).config(["$provide",function(e){var n=[];e.value("$$animateReflow",function(e){var t=n.length;return n.push(e),function(){n.splice(t,1)}}),e.decorator("$animate",["$delegate","$$asyncCallback","$timeout","$browser",function(e,r,i){var a={queue:[],cancel:e.cancel,enabled:e.enabled,triggerCallbackEvents:function(){r.flush()},triggerCallbackPromise:function(){i.flush(0)},triggerCallbacks:function(){this.triggerCallbackEvents(),this.triggerCallbackPromise()},triggerReflow:function(){t.forEach(n,function(e){e()}),n=[]}};return t.forEach(["animate","enter","leave","move","addClass","removeClass","setClass"],function(t){a[t]=function(){return a.queue.push({event:t,element:arguments[0],options:arguments[arguments.length-1],args:arguments}),e[t].apply(e,arguments)}}),a}])}]),t.mock.dump=function(e){function n(e){var i;return t.isElement(e)?(e=t.element(e),i=t.element("<div></div>"),t.forEach(e,function(e){i.append(t.element(e).clone())}),i=i.html()):t.isArray(e)?(i=[],t.forEach(e,function(e){i.push(n(e))}),i="[ "+i.join(", ")+" ]"):i=t.isObject(e)?t.isFunction(e.$eval)&&t.isFunction(e.$apply)?r(e):e instanceof Error?e.stack||""+e.name+": "+e.message:t.toJson(e,!0):String(e),i}function r(e,n){n=n||"  ";var i=[n+"Scope("+e.$id+"): {"];for(var a in e)Object.prototype.hasOwnProperty.call(e,a)&&!a.match(/^(\$|this)/)&&i.push("  "+a+": "+t.toJson(e[a]));for(var o=e.$$childHead;o;)i.push(r(o,n+"  ")),o=o.$$nextSibling;return i.push("}"),i.join("\n"+n)}return n(e)},t.mock.$HttpBackendProvider=function(){this.$get=["$rootScope","$timeout",o]},t.mock.$TimeoutDecorator=["$delegate","$browser",function(e,n){function r(e){var n=[];return t.forEach(e,function(e){n.push("{id: "+e.id+", time: "+e.time+"}")}),n.join(", ")}return e.flush=function(e){n.defer.flush(e)},e.verifyNoPendingTasks=function(){if(n.deferredFns.length)throw new Error("Deferred tasks to flush ("+n.deferredFns.length+"): "+r(n.deferredFns))},e}],t.mock.$RAFDecorator=["$delegate",function(e){var t=[],n=function(e){var n=t.length;return t.push(e),function(){t.splice(n,1)}};return n.supported=e.supported,n.flush=function(){if(0===t.length)throw new Error("No rAF callbacks present");for(var e=t.length,n=0;e>n;n++)t[n]();t=[]},n}],t.mock.$AsyncCallbackDecorator=["$delegate",function(){var e=[],n=function(t){e.push(t)};return n.flush=function(){t.forEach(e,function(e){e()}),e=[]},n}],t.mock.$RootElementProvider=function(){this.$get=function(){return t.element("<div ng-app></div>")}},t.module("ngMock",["ng"]).provider({$browser:t.mock.$BrowserProvider,$exceptionHandler:t.mock.$ExceptionHandlerProvider,$log:t.mock.$LogProvider,$interval:t.mock.$IntervalProvider,$httpBackend:t.mock.$HttpBackendProvider,$rootElement:t.mock.$RootElementProvider}).config(["$provide",function(e){e.decorator("$timeout",t.mock.$TimeoutDecorator),e.decorator("$$rAF",t.mock.$RAFDecorator),e.decorator("$$asyncCallback",t.mock.$AsyncCallbackDecorator),e.decorator("$rootScope",t.mock.$RootScopeDecorator)}]),t.module("ngMockE2E",["ng"]).config(["$provide",function(e){e.decorator("$httpBackend",t.mock.e2e.$httpBackendDecorator)}]),t.mock.e2e={},t.mock.e2e.$httpBackendDecorator=["$rootScope","$timeout","$delegate","$browser",o],t.mock.$RootScopeDecorator=["$delegate",function(e){function t(){for(var e,t=0,n=[this.$$childHead];n.length;)for(e=n.shift();e;)t+=1,n.push(e.$$childHead),e=e.$$nextSibling;return t}function n(){for(var e,t=this.$$watchers?this.$$watchers.length:0,n=[this.$$childHead];n.length;)for(e=n.shift();e;)t+=e.$$watchers?e.$$watchers.length:0,n.push(e.$$childHead),e=e.$$nextSibling;return t}var r=Object.getPrototypeOf(e);return r.$countChildScopes=t,r.$countWatchers=n,e}],e.jasmine||e.mocha){var c=null,d=[],f=function(){return!!c};t.mock.$$annotate=t.injector.$$annotate,t.injector.$$annotate=function(e){return"function"!=typeof e||e.$inject||d.push(e),t.mock.$$annotate.apply(this,arguments)},(e.beforeEach||e.setup)(function(){d=[],c=this}),(e.afterEach||e.teardown)(function(){var e=c.$injector;d.forEach(function(e){delete e.$inject}),t.forEach(c.$modules,function(e){e&&e.$$hashKey&&(e.$$hashKey=n)}),c.$injector=null,c.$modules=null,c=null,e&&(e.get("$rootElement").off(),e.get("$browser").pollFns.length=0),t.forEach(t.element.fragments,function(e,n){delete t.element.fragments[n]}),l.$$lastInstance=null,t.forEach(t.callbacks,function(e,n){delete t.callbacks[n]}),t.callbacks.counter=0}),e.module=t.mock.module=function(){function e(){if(c.$injector)throw new Error("Injector already created, can not register a module!");var e=c.$modules||(c.$modules=[]);t.forEach(n,function(n){e.push(t.isObject(n)&&!t.isArray(n)?function(e){t.forEach(n,function(t,n){e.value(n,t)})}:n)})}var n=Array.prototype.slice.call(arguments,0);return f()?e():e};var p=function(e,t){this.message=e.message,this.name=e.name,e.line&&(this.line=e.line),e.sourceId&&(this.sourceId=e.sourceId),e.stack&&t&&(this.stack=e.stack+"\n"+t.stack),e.stackArray&&(this.stackArray=e.stackArray)};p.prototype.toString=Error.prototype.toString,e.inject=t.mock.inject=function(){function e(){var e=c.$modules||[],i=!!c.$injectorStrict;e.unshift("ngMock"),e.unshift("ng");var a=c.$injector;a||(i&&t.forEach(e,function(e){"function"==typeof e&&t.injector.$$annotate(e)}),a=c.$injector=t.injector(e,i),c.$injectorStrict=i);for(var o=0,s=n.length;s>o;o++){c.$injectorStrict&&a.annotate(n[o]);try{a.invoke(n[o]||t.noop,this)}catch(l){if(l.stack&&r)throw new p(l,r);throw l}finally{r=null}}}var n=Array.prototype.slice.call(arguments,0),r=new Error("Declaration Location");return f()?e.call(c):e},t.mock.inject.strictDi=function(e){function t(){if(e!==c.$injectorStrict){if(c.$injector)throw new Error("Injector already created, can not modify strict annotations");c.$injectorStrict=e}}return e=arguments.length?!!e:!0,f()?t():t}}}(window,window.angular);