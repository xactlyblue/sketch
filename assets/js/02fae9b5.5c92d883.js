"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[331],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>m});var r=n(67294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function i(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var c=r.createContext({}),s=function(e){var t=r.useContext(c),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(c.Provider,{value:t},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},y=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,a=e.originalType,c=e.parentName,u=i(e,["components","mdxType","originalType","parentName"]),p=s(n),y=o,m=p["".concat(c,".").concat(y)]||p[y]||d[y]||a;return n?r.createElement(m,l(l({ref:t},u),{},{components:n})):r.createElement(m,l({ref:t},u))}));function m(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=n.length,l=new Array(a);l[0]=y;var i={};for(var c in t)hasOwnProperty.call(t,c)&&(i[c]=t[c]);i.originalType=e,i[p]="string"==typeof e?e:o,l[1]=i;for(var s=2;s<a;s++)l[s]=n[s];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}y.displayName="MDXCreateElement"},76647:(e,t,n)=>{n.r(t),n.d(t,{contentTitle:()=>l,default:()=>p,frontMatter:()=>a,metadata:()=>i,toc:()=>c});var r=n(87462),o=(n(67294),n(3905));const a={},l=void 0,i={type:"mdx",permalink:"/sketch/",source:"@site/pages/index.md",description:"Sketch",frontMatter:{}},c=[{value:"Purpose",id:"purpose",level:2},{value:"Documentation",id:"documentation",level:2},{value:"Installation",id:"installation",level:2},{value:"Wally",id:"wally",level:3},{value:"Rojo",id:"rojo",level:3}],s={toc:c},u="wrapper";function p(e){let{components:t,...n}=e;return(0,o.kt)(u,(0,r.Z)({},s,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("div",{align:"center"},(0,o.kt)("h1",null,"Sketch"),(0,o.kt)("p",null,"A visual debugging library for Roblox")),(0,o.kt)("p",null,"Sketch is a visual debugging library for Roblox, allowing you to render visual representations of rays, text and shapes with ease.\nThis project is still in it's infancy, and is just meant to be a quick utility library."),(0,o.kt)("h2",{id:"purpose"},"Purpose"),(0,o.kt)("p",null,"Visually representing information in the 3D World has always been a bit of a hassle on Roblox. After all, even simple visible text\nneeds to be mounted on a ",(0,o.kt)("a",{parentName:"p",href:"https://create.roblox.com/docs/reference/engine/classes/BillboardGui"},"BillboardGui")," which then needs to be\nattached to an Adornee. This library aims to solve this problem without being destructive or harmful to your normal workflow."),(0,o.kt)("h2",{id:"documentation"},"Documentation"),(0,o.kt)("p",null,"The project's early documentation can be found ",(0,o.kt)("a",{parentName:"p",href:"https://xactlyblue.github.io/sketch"},"here"),". It's is still rather early in development, and though it is completely functional,\nit does not yet have thorough documentation beyond the APIs (and some examples you can find in the ",(0,o.kt)("inlineCode",{parentName:"p"},"src/example/")," folder). Hopefully proper documentation can be sorted out some time soon."),(0,o.kt)("h2",{id:"installation"},"Installation"),(0,o.kt)("h3",{id:"wally"},"Wally"),(0,o.kt)("p",null,(0,o.kt)("a",{parentName:"p",href:"https://github.com/UpliftGames/wally"},"Wally")," is a package manager for Roblox, allowing you to integrate this (and countless other unique and helpful libraries)\ndirectly into your project through a controlled system. To use this library in wally, you can simply add the following to your ",(0,o.kt)("inlineCode",{parentName:"p"},"wally.toml"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-toml"},'Sketch = "xactlyblue/sketch@1.0.0"\n')),(0,o.kt)("h3",{id:"rojo"},"Rojo"),(0,o.kt)("p",null,"If you don't want to use a package manager like Wally, you can git-clone the source code directly into the folder you'd prefer and ",(0,o.kt)("a",{parentName:"p",href:"https://rojo.space"},"Rojo")," can take care of the rest."),(0,o.kt)("p",null,(0,o.kt)("inlineCode",{parentName:"p"},'git clone "https://github.com/xactlyblue/sketch"')))}p.isMDXComponent=!0}}]);