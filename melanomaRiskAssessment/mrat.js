window.onload = function() {
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
};
