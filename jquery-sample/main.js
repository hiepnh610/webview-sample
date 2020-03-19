'use strict';

var showDialog = function() {
  $('#form').on('click', 'button', function(e) {
    e.preventDefault();

    var val = $(this).siblings('#full-name').val();

    if (val) {
      if (window.webkit) {
        return window.webkit.messageHandlers.sampleFunction.postMessage(val);
      }
    }
  });
};

var webview = {
  listenerFromNative: function(payload) {
    $('#text-full-name h2').text(payload);
  }
};

var init = function() {
  window.webview = webview;
  showDialog();
};

$(document).ready(function() {
  init();
});
