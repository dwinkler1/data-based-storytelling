// scale an image with markdown tag 
remark.macros.scale = function(w) {
    var url = this;
    return '<img src="' + url + '" style="width: ' + w + '" />';
  };