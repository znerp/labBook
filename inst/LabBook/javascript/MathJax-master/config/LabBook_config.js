/*
 *  /MathJax/config/LabBook_config.js
 *  
 */

MathJax.Hub.Config({
  "HTML-CSS": { scale: 120,},
  tex2jax: {
    inlineMath: [['$','$'], ['\\(','\\)']],
    ignoreClass: ".*",
    processClass: "tex-math"
  }
});


MathJax.Ajax.loadComplete("[MathJax]/config/LabBook_config.js");
