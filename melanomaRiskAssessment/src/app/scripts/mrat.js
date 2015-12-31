var genderChangeLoaded = false;
function addClass(elementList,className) {
  for (var index = 0; index < elementList.length; index++) {
    elementList[index].className += " "+className;
  }
}
function removeClass(elementList,className) {
  for (var index = 0; index < elementList.length; index++) {
    elementList[index].className = elementList[index].className.replace(className,"").trim();
  }
}

function genderChange() {
  if (!genderChangeLoaded) {
    if( document.all && !document.getElementsByTagName ){
      document.getElementsByTagName = function( nodeName ) {
        if( nodeName == '*' ) return document.all;
        var result = [], rightName = new RegExp( nodeName, 'i' ), i;
        for( i=0; i<document.all.length; i++ )
          if( rightName.test( document.all[i].nodeName ) )
            result.push( document.all[i] );
        return result;
      };
    }
    if( typeof document.getElementsByClassName !== "function"){
      document.getElementsByClassName = function( className, nodeName ) {
        var result = [], tag = nodeName||'*', node, seek, i;
        if( document.evaluate ) {
          seek = '//'+ tag +'[@class="'+ className +'"]';
          seek = document.evaluate( seek, document, null, 0, null );
          while( (node = seek.iterateNext()) )
            result.push( node );
        } else {
          var rightClass = new RegExp( '(^| )'+ className +'( |$)' );
          seek = document.getElementsByTagName( tag );
          for( i=0; i<seek.length; i++ )
            if( rightClass.test( (node = seek[i]).className ) )
              result.push( seek[i] );
        }
        return result;
      };
    }
    var lastClass = "select";
    document.getElementById('gender').onchange = function() {
      var className = this.value.toLowerCase();
      var addList;
      var removeList;
      if (lastClass !== "select") {
        removeClass(document.getElementsByClassName(lastClass),"show");
      }
      if (className !== "select") {
        addClass(document.getElementsByClassName(className),"show");
      }
      lastClass = className;
    };
    genderChangeLoaded = true;
  }
}

function displayResult(result) {
  var matches = Number(result).toExponential().toString().match(/(\d+)e([-+]?\d+)/i);
  var estimate = matches[1];
  var outOf = Number('1e'+(2-Number(matches[2])));
  $('#result').append('<h2>'+result+'%</h2><p>Your risk of developing cancer in the next 5 years is '+result+'%. This means that roughly '+estimate+' in '+outOf+' people like you are likely to develop cancer in the next 5 years.').removeClass('hide');
  graphResult(result);
}

function graphResult(result) {
  //To Do:
}

window.onload = genderChange();
$(genderChange());

$(document.forms[0]).on('submit', function(e) {
  e.preventDefault();
  $('#error').addClass('hide').empty();
  $('#result').addClass('hide').empty();
  $('.error').removeClass('error');
  var formData = new FormData(document.forms[0]);
  $.ajax({
    url: document.forms[0].action,
    type: document.forms[0].method,
    data: formData,
    processData: false,
    contentType: false,
    dataType: 'json'
  }).done(function(data) {
    if (data.success) {
      displayResult(data.message);
    } else {
      var message = "";
      if (data.message) {
        message += "<p>" + data.message + "</p>";
      }
      var index;
      for (index in data.missing) {
        $('#'+data.missing[index]).addClass('error');
        message += "<p>The " + data.missing[index] + " question was not answered.</p>";
      }
      for (index in data.nonnumeric) {
        $('#'+data.nonnumeric[index]).addClass('error');
        message += "<p>The " + data.missing[index] + " question contained a nonnumeric answer.</p>";
      }
      $('#error').append(message).removeClass('hide');
    }
  }).fail(function(data) {
    $('#error').append("An unknown error occurred. Please consult the administrator.");
  });
});
