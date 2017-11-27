/***********************************
Javascript for DHtmlModalPopupControl.  Allows a user to create a simple modal popup.
This code was heavily influenced by Control.Modal by Ryan Johnson 
(http://livepipe.net/projects/control_modal/)
************************************/
ModalPopup = Class.create();
//Setup static class definitions
Object.extend(ModalPopup,
{
    ie: false, //Is the browser IE 6?
    loaded: false, //Has the class been loaded?
    overlay: false, //The overlay element to be used for disabling other elements
    iframe: false, //iFrame for IE 6 so that selects do not show through
    current: false, //The current open ModalPopup.					
    overlayStyles: {
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        zIndex: 9998
    },
    overlayIEStyles: {
        position: 'absolute',
        top: 0,
        left: 0,
        zIndex: 9998
    },
    iframeStyles: {
        position: 'absolute',
        top: 0,
        left: 0,
        border: 'none',
        filter: 'progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)'
    },
    load: function() {
        if (!ModalPopup.loaded) {
            ModalPopup.loaded = true;
            ModalPopup.ie = !(typeof document.body.style.maxHeight != 'undefined'); //Is this correct?

            ModalPopup.overlay = $(document.createElement('div'));
            ModalPopup.overlay.id = 'modal_overlay';
            Object.extend(ModalPopup.overlay.style, ModalPopup['overlay' + (ModalPopup.ie ? 'IE' : '') + 'Styles']);
            ModalPopup.overlay.hide();

            ModalPopup.iframe = $(document.createElement('iframe'));
            ModalPopup.iframe.id = 'modal_overlay';
            Object.extend(ModalPopup.iframe.style, ModalPopup['iframeStyles']);
            ModalPopup.iframe.hide();

            //IE 6 has a problem when the body margin is not set to 0

            var body_tag = document.getElementsByTagName('body')[0];
            body_tag.appendChild(ModalPopup.overlay);
            body_tag.appendChild(ModalPopup.iframe);

        }
    },
    close: function(evt) { //Static method to close all ModalPopup instances
        if (ModalPopup.current)
            ModalPopup.current.close();
        if (evt != null) {
            Event.stop(evt);
            return false;
        }
    },
    closePopupIfOpen: function(popupid) {
        if (ModalPopup.current && ModalPopup.current.element && ModalPopup.current.element.id == popupid)
            ModalPopup.current.close();
    },
    center: function(element) {
        if (!element._absolutized) {
            element.setStyle({
                position: 'absolute'
            });
            element._absolutized = true;
        }
        var dimensions = element.getDimensions();
        Position.prepare();
        var offset_left = (Position.deltaX + Math.floor((ModalPopup.getWindowWidth() - dimensions.width) / 2));
        var offset_top = (Position.deltaY + ((ModalPopup.getWindowHeight() > dimensions.height) ? Math.floor((ModalPopup.getWindowHeight() - dimensions.height) / 2) : 0));
        element.setStyle({
            top: ((dimensions.height <= ModalPopup.getDocumentHeight()) ? ((offset_top != null && offset_top > 0) ? offset_top : '0') + 'px' : 0),
            left: ((dimensions.width <= ModalPopup.getDocumentWidth()) ? ((offset_left != null && offset_left > 0) ? offset_left : '0') + 'px' : 0)
        });
    },
    getWindowWidth: function() {
        return (self.innerWidth || document.documentElement.clientWidth || document.body.clientWidth || 0);
    },
    getWindowHeight: function() {
        return (self.innerHeight || document.documentElement.clientHeight || document.body.clientHeight || 0);
    },
    getDocumentWidth: function() {
        return Math.min(document.body.scrollWidth, ModalPopup.getWindowWidth());
    },
    getDocumentHeight: function() {
        return Math.max(document.body.scrollHeight, ModalPopup.getWindowHeight());
    },
    onKeyDown: function(event) {
        if (event.keyCode == Event.KEY_ESC)
            ModalPopup.close();
    }
});

//Define instance methods and properties	
Object.extend(ModalPopup.prototype,
{
    //class instance variables
    element: false, //The div of the modal popup
    openElement: false, //The element that will be clicked on to open the popup
    closeElement: false, //The element that will be clicked on to close the popup
    initialize: function(element, openElement, closeElement, options) {
        this.element = $(element);
        this.openElement = $(openElement);
        this.closeElement = $(closeElement);
        this.options = {
            beforeOpen: Prototype.emptyFunction,
            afterOpen: Prototype.emptyFunction,
            beforeClose: Prototype.emptyFunction,
            afterClose: Prototype.emptyFunction,
            overlayBackgroundColor: '#000000',
            overlayOpacity: 0.5,
            width: false,
            height: false,
            zIndex: 9990
        };
        Object.extend(this.options, options || {});

        //Wireup the onclick
        if (this.openElement) {
            this.openElement.onclick = function(event) {
                this.open();
                Event.stop(event);
                return false;
            } .bindAsEventListener(this);
        }

        //Set up the position method
        this.position = function(event) {
            ModalPopup.center(this.element);

            if (ModalPopup.ie) {
                //IE 6 is wierd in that it will not give you the size of the document,
                //if you ask for the size of the doc, and you are full screen, it seems
                //to subtract the margins from the size.
                Position.prepare();

                ModalPopup.iframe.setStyle({
                    height: ModalPopup.getWindowHeight() + 'px',
                    width: ModalPopup.getWindowWidth() + 'px', //+margin...
                    top: Position.deltaY, //Scroll offSet
                    left: Position.deltaX //Scroll offSet 
                });

                ModalPopup.overlay.setStyle({
                    height: ModalPopup.getWindowHeight() + 'px',
                    width: ModalPopup.getWindowWidth() + 'px', //+margin...
                    top: Position.deltaY, //Scroll offSet
                    left: Position.deltaX //Scroll offSet 
                });
            }
        } .bind(this);
    },
    open: function() {

        //=== means == and of the same type
        if (this.notify('beforeOpen') === false)
            return; //If beforeOpen failed(exception) or the method cancelled the event, return.  

        if (!ModalPopup.loaded) //Check to make sure the class has been initialized.
            ModalPopup.load();
        ModalPopup.close(); //Close any open popup

        //You can press esc to cancel
        Event.observe($(document.getElementsByTagName('body')[0]), 'keydown', ModalPopup.onKeyDown);

        ModalPopup.current = this;

        //Set the style for the overlay
        ModalPopup.overlay.setStyle({
            zIndex: this.options.zIndex + 1, //should set this
            opacity: this.options.overlayOpacity, //This is not good enough?
            backgroundColor: this.options.overlayBackgroundColor
        });

        if (ModalPopup.ie)
            ModalPopup.iframe.setStyle({
                zIndex: this.options.zIndex //should set this
            });

        //Set the style for the popup
        this.element.setStyle({
            zIndex: this.options.zIndex + 2,
            width: (this.options.width ? (typeof (this.options.width) == 'function' ? this.options.width() : this.options.width) + 'px' : null),
            height: (this.options.height ? (typeof (this.options.height) == 'function' ? this.options.height() : this.options.height) + 'px' : null)
        });

        //Show the popup				
        if (ModalPopup.ie)
            ModalPopup.iframe.show();
        ModalPopup.overlay.show();
        this.element.show();


        //Center it, and wire up events for the resizing and scrolling
        this.position();
        Event.observe(window, 'resize', this.position, false);
        Event.observe(window, 'scroll', this.position, false);

        if (this.closeElement)
            this.closeElement.observe('click', ModalPopup.close);

        this.notify('afterOpen'); //Fire afterOpen event
    },
    close: function() {

        if (this.notify('beforeClose') === false)
            return; //return if beforeClose failed (exception) or the code wants it to not close

        //Stop observing esc to cancel.
        Event.stopObserving(window, 'keyup', ModalPopup.onKeyDown);

        this.element.hide();
        ModalPopup.overlay.hide();
        if (ModalPopup.ie)
            ModalPopup.iframe.hide();
        ModalPopup.current = false;

        //Stop observing resize events.					
        Event.stopObserving(window, 'resize', this.position, false);
        Event.stopObserving(window, 'scroll', this.position, false);

        //Stop observing close link
        if (this.closeElement)
            ModalPopup.overlay.stopObserving('click', ModalPopup.close);

        this.notify('afterClose');
    },
    notify: function(event_name) {
        try {
            if (this.options[event_name])
                return this.options[event_name].apply(this.options[event_name], $A(arguments).slice(1));
        } catch (e) {
            if (e != $break)
                throw e;
            else
                return false;
        }
    }
});