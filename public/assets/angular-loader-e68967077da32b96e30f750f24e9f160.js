!function(){"use strict";function e(e,t){return t=t||Error,function(){var n,r,i=arguments[0],a="["+(e?e+":":"")+i+"] ",o=arguments[1],s=arguments;for(n=a+o.replace(/\{\d+\}/g,function(e){var t=+e.slice(1,-1);return t+2<s.length?toDebugString(s[t+2]):e}),n=n+"\nhttp://errors.angularjs.org/1.3.14/"+(e?e+"/":"")+i,r=2;r<arguments.length;r++)n=n+(2==r?"?":"&")+"p"+(r-2)+"="+encodeURIComponent(toDebugString(arguments[r]));return new t(n)}}function t(t){function n(e,t,n){return e[t]||(e[t]=n())}var r=e("$injector"),i=e("ng"),a=n(t,"angular",Object);return a.$$minErr=a.$$minErr||e,n(a,"module",function(){var e={};return function(t,a,o){var s=function(e,t){if("hasOwnProperty"===e)throw i("badname","hasOwnProperty is not a valid {0} name",t)};return s(t,"module"),a&&e.hasOwnProperty(t)&&(e[t]=null),n(e,t,function(){function e(e,t,r,i){return i||(i=n),function(){return i[r||"push"]([e,t,arguments]),u}}if(!a)throw r("nomod","Module '{0}' is not available! You either misspelled the module name or forgot to load it. If registering a module ensure that you specify the dependencies as the second argument.",t);var n=[],i=[],s=[],l=e("$injector","invoke","push",i),u={_invokeQueue:n,_configBlocks:i,_runBlocks:s,requires:a,name:t,provider:e("$provide","provider"),factory:e("$provide","factory"),service:e("$provide","service"),value:e("$provide","value"),constant:e("$provide","constant","unshift"),animation:e("$animateProvider","register"),filter:e("$filterProvider","register"),controller:e("$controllerProvider","register"),directive:e("$compileProvider","directive"),config:l,run:function(e){return s.push(e),this}};return o&&l(o),u})}})}t(window)}(window),angular.Module;