/* ===================================================
 * The following is a modified version (by @rnmp) of:
 *
 * bootstrap-markdown.js v2.10.0
 * http://github.com/toopay/bootstrap-markdown
 * ===================================================
 * Copyright 2013-2016 Taufan Aditya
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */

/**
 * jQuery.browser.mobile (http://detectmobilebrowser.com/)
 *
 * jQuery.browser.mobile will be true if the browser is a mobile device
 *
 **/
(function(a){(jQuery.browser=jQuery.browser||{}).mobile=/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))})(navigator.userAgent||navigator.vendor||window.opera);

(function(factory){
    if (typeof define === "function" && define.amd) {
        //RequireJS
        define(["jquery"], factory);
    } else if (typeof exports === 'object') {
        //Backbone.js
        factory(require('jquery'));
    } else {
        //Jquery plugin
        factory(jQuery);
    }
}(function($){
  "use strict"; // jshint ;_;

  /* MARKDOWN CLASS DEFINITION
   * ========================== */

  var Markdown = function (element, options) {
    // @TODO : remove this BC on next major release
    // @see : https://github.com/toopay/bootstrap-markdown/issues/109
    var opts = ['autofocus', 'savable', 'hideable', 'width', 
      'height', 'resize', 'iconlibrary', 'language', 
      'footer', 'fullscreen', 'hiddenButtons', 'disabledButtons'];
    $.each(opts,function(_, opt){
      if (typeof $(element).data(opt) !== 'undefined') {
        options = typeof options == 'object' ? options : {}
        options[opt] = $(element).data(opt)
      }
    });
    // End BC

    // Class Properties
    this.$ns           = 'bootstrap-markdown';
    this.$element      = $(element);
    this.$editable     = {el:null, type:null,attrKeys:[], attrValues:[], content:null};
    this.$options      = $.extend(true, {}, $.fn.markdown.defaults, options, this.$element.data('options'));
    this.$oldContent   = null;
    this.$isPreview    = false;
    this.$isFullscreen = false;
    this.$editor       = null;
    this.$textarea     = null;
    this.$handler      = [];
    this.$callback     = [];
    this.$nextTab      = [];

    this.showEditor();
  };

  Markdown.prototype = {

    constructor: Markdown

  , __alterButtons: function(name,alter) {
      var handler = this.$handler, isAll = (name == 'all'),that = this;

      $.each(handler,function(k,v) {
        var halt = true;
        if (isAll) {
          halt = false;
        } else {
          halt = v.indexOf(name) < 0;
        }

        if (halt === false) {
          alter(that.$editor.find('button[data-handler="'+v+'"]'));
        }
      });
    }

  , __buildButtons: function(buttonsArray, container) {
      var i,
          ns = this.$ns,
          handler = this.$handler,
          callback = this.$callback;

      for (i=0;i<buttonsArray.length;i++) {
        // Build each group container
        var y, btnGroups = buttonsArray[i];
        for (y=0;y<btnGroups.length;y++) {
          // Build each button group
          var z,
              buttons = btnGroups[y].data,
              btnGroupContainer = $('<span/>', {
                                    'class': 'btn-group'
                                  });

          for (z=0;z<buttons.length;z++) {
            var button = buttons[z],
                buttonContainer, buttonIconContainer,
                buttonHandler = ns+'-'+button.name,
                buttonIcon = this.__getIcon(button.icon),
                btnText = button.btnText ? button.btnText : '',
                btnClass = button.btnClass || '',
                tabIndex = button.tabIndex ? button.tabIndex : '-1',
                hotkey = typeof button.hotkey !== 'undefined' ? button.hotkey : '',
                hotkeyCaption = typeof jQuery.hotkeys !== 'undefined' && hotkey !== '' ? ' ('+hotkey+')' : '';

            // Construct the button object
            buttonContainer = $('<button></button>');
            buttonContainer.text(btnText).addClass('button').addClass(btnClass);
            // if(btnClass.match(/btn\-(primary|success|info|warning|danger|link)/)){
                // buttonContainer.removeClass('btn-default');
            // }
            buttonContainer.attr({
                'type': 'button',
                'title': this.__localize(button.title) + hotkeyCaption,
                'tabindex': tabIndex,
                'data-provider': ns,
                'data-handler': buttonHandler,
                'data-hotkey': hotkey
            });
            if (button.toggle === true){
              buttonContainer.attr('data-toggle', 'button');
            }
            buttonIconContainer = $('<span/>');
            buttonIconContainer.addClass(buttonIcon);
            buttonIconContainer.prependTo(buttonContainer);

            // Attach the button object
            btnGroupContainer.append(buttonContainer);

            // Register handler and callback
            handler.push(buttonHandler);
            callback.push(button.callback);
          }

          // Attach the button group into container dom
          container.append(btnGroupContainer);
        }
      }

      return container;
    }
  , __setListener: function() {
      // Set size and resizable Properties
      // var hasRows = typeof this.$textarea.attr('rows') !== 'undefined',
      //     maxRows = this.$textarea.val().split("\n").length > 5 ? this.$textarea.val().split("\n").length : '5',
      //     rowsVal = hasRows ? this.$textarea.attr('rows') : maxRows;

      // this.$textarea.attr('rows',rowsVal);
      // if (this.$options.resize) {
        // this.$textarea.css('resize',this.$options.resize);
      // }

      this.$textarea.on({
          'focus' : $.proxy(this.focus, this),
          'keyup' : $.proxy(this.keyup, this),
          'change' : $.proxy(this.change, this),
          'select' : $.proxy(this.select, this)
      });

      if (this.eventSupported('keydown')) {
        // this.$textarea.on('keydown', $.proxy(this.keydown, this));
      }

      if (this.eventSupported('keypress')) {
        this.$textarea.on('keypress', $.proxy(this.keypress, this))
      }

      // Re-attach markdown data
      this.$textarea.data('markdown',this);
    }

  , __handle: function(e) {
      var target = $(e.currentTarget),
          handler = this.$handler,
          callback = this.$callback,
          handlerName = target.attr('data-handler'),
          callbackIndex = handler.indexOf(handlerName),
          callbackHandler = callback[callbackIndex];

      // Trigger the focusin
      $(e.currentTarget).focus();

      callbackHandler(this);

      // Trigger onChange for each button handle
      this.change(this);

      // Unless it was the save handler,
      // focusin the textarea
      if (handlerName.indexOf('cmdSave') < 0) {
        this.$textarea.focus();
      }

      e.preventDefault();
    }

  , __localize: function(string) {
      var messages = $.fn.markdown.messages,
          language = this.$options.language;
      if (
        typeof messages !== 'undefined' &&
        typeof messages[language] !== 'undefined' &&
        typeof messages[language][string] !== 'undefined'
      ) {
        return messages[language][string];
      }
      return string;
    }

  , __getIcon: function(src) {
    return typeof src == 'object' ? src[this.$options.iconlibrary] : src;
  }

  , setFullscreen: function(mode) {
    var $editor = this.$editor,
        $textarea = this.$textarea;

    if (mode === true) {
      $editor.addClass('md-fullscreen-mode');
      $('body').addClass('md-nooverflow');
      this.$options.onFullscreen(this);
    } else {
      $editor.removeClass('md-fullscreen-mode');
      $('body').removeClass('md-nooverflow');
      this.$options.onFullscreenExit(this);

      if (this.$isPreview == true) this.hidePreview().showPreview()
    }

    this.$isFullscreen = mode;
    $textarea.focus();
  }

  , showEditor: function() {
      var instance = this,
          textarea,
          ns = this.$ns,
          container = this.$element,
          originalHeigth = container.css('height'),
          originalWidth = container.css('width'),
          editable = this.$editable,
          handler = this.$handler,
          callback = this.$callback,
          options = this.$options,
          editor = $( '<div/>', {
                      'class': 'md-editor',
                      click: function() {
                        instance.focus();
                      }
                    });

      // Prepare the editor
      if (this.$editor === null) {
        // Create the panel
        var editorHeader = $('<div/>', {
                            'class': 'editor-header'
                            });

        // Merge the main & additional button groups together
        var allBtnGroups = [];
        if (options.buttons.length > 0) allBtnGroups = allBtnGroups.concat(options.buttons[0]);
        if (options.additionalButtons.length > 0) {
          // iterate the additional button groups
          $.each(options.additionalButtons[0], function(idx, buttonGroup){
            
            // see if the group name of the addional group matches an existing group
            var matchingGroups = $.grep(allBtnGroups, function(allButtonGroup, allIdx){
              return allButtonGroup.name === buttonGroup.name;
            });

            // if it matches add the addional buttons to that group, if not just add it to the all buttons group
            if(matchingGroups.length > 0) {
              matchingGroups[0].data = matchingGroups[0].data.concat(buttonGroup.data);
            } else {              
              allBtnGroups.push(options.additionalButtons[0][idx]);
            }

          });
        } 

        // Reduce and/or reorder the button groups
        if (options.reorderButtonGroups.length > 0) {
          allBtnGroups = allBtnGroups
              .filter(function(btnGroup) {
                return options.reorderButtonGroups.indexOf(btnGroup.name) > -1;
              })
              .sort(function(a, b) {
                if (options.reorderButtonGroups.indexOf(a.name) < options.reorderButtonGroups.indexOf(b.name)) return -1;
                if (options.reorderButtonGroups.indexOf(a.name) > options.reorderButtonGroups.indexOf(b.name)) return 1;
                return 0;
              });
        }

        // Build the buttons
        if (allBtnGroups.length > 0) {
          editorHeader = this.__buildButtons([allBtnGroups], editorHeader);
        }

        if (options.fullscreen.enable) {
          editorHeader.append('<div class="md-controls"><a class="md-control md-control-fullscreen" href="#"><span class="'+this.__getIcon(options.fullscreen.icons.fullscreenOn)+'"></span></a></div>').on('click', '.md-control-fullscreen', function(e) {
              e.preventDefault();
              instance.setFullscreen(true);
          });
        }


        container.before(editor);
        textarea = container;
        editor.append(textarea);
        editor.append(editorHeader);

        var editorFooter = $('<div/>', {
                           'class': 'md-footer'
                         }),
            createFooter = false,
            footer = '';
        // Create the footer if savable
        if (options.savable) {
          createFooter = true;
          var saveHandler = 'cmdSave';

          // Register handler and callback
          handler.push(saveHandler);
          callback.push(options.onSave);

          editorFooter.append('<button class="btn btn-success" data-provider="'
                              + ns
                              + '" data-handler="'
                              + saveHandler
                              + '"><i class="icon icon-white icon-ok"></i> '
                              + this.__localize('Save')
                              + '</button>');


        }

        footer = typeof options.footer === 'function' ? options.footer(this) : options.footer;

        if ($.trim(footer) !== '') {
          createFooter = true;
          editorFooter.append(footer);
        }

        if (createFooter) editor.append(editorFooter);

        // Set width
        if (options.width && options.width !== 'inherit') {
          if (jQuery.isNumeric(options.width)) {
            editor.css('display', 'table');
            textarea.css('width', options.width + 'px');
          } else {
            editor.addClass(options.width);
          }
        }

        // Set height
        if (options.height && options.height !== 'inherit') {
          if (jQuery.isNumeric(options.height)) {
            var height = options.height;
            if (editorHeader) height = Math.max(0, height - editorHeader.outerHeight());
            if (editorFooter) height = Math.max(0, height - editorFooter.outerHeight());
            textarea.css('height', height + 'px');
          } else {
            editor.addClass(options.height);
          }
        }

        // Reference
        this.$editor     = editor;
        this.$textarea   = textarea;
        this.$editable   = editable;
        this.$oldContent = this.getContent();

        this.__setListener();

        // Set editor attributes, data short-hand API and listener
        this.$editor.attr('id',(new Date()).getTime());
        this.$editor.on('click', '[data-provider="bootstrap-markdown"]', $.proxy(this.__handle, this));

        if (this.$element.is(':disabled') || this.$element.is('[readonly]')) {
          this.$editor.addClass('md-editor-disabled');
          this.disableButtons('all');
        }

        if (this.eventSupported('keydown') && typeof jQuery.hotkeys === 'object') {
          editorHeader.find('[data-provider="bootstrap-markdown"]').each(function() {
            var $button = $(this),
                hotkey = $button.attr('data-hotkey');
            if (hotkey.toLowerCase() !== '') {
              textarea.bind('keydown', hotkey, function() {
                $button.trigger('click');
                return false;
              });
            }
          });
        }

        if (options.initialstate === 'preview') {
          this.showPreview();
        } else if (options.initialstate === 'fullscreen' && options.fullscreen.enable) {
          this.setFullscreen(true);
        }

      } else {
        this.$editor.show();
      }

      if (options.autofocus) {
        this.$textarea.focus();
        this.$editor.addClass('active');
      }

      if (options.fullscreen.enable && options.fullscreen !== false) {
        this.$editor.append('<div class="md-fullscreen-controls">'
                        + '<a href="#" class="exit-fullscreen" title="Exit fullscreen"><span class="' + this.__getIcon(options.fullscreen.icons.fullscreenOff) + '">'
                        + '</span></a>'
                        + '</div>');
        this.$editor.on('click', '.exit-fullscreen', function(e) {
          e.preventDefault();
          instance.setFullscreen(false);
        });
      }

      // hide hidden buttons from options
      this.hideButtons(options.hiddenButtons);

      // disable disabled buttons from options
      this.disableButtons(options.disabledButtons);

      // enable dropZone if available and configured
      if (options.dropZoneOptions) {
        if (this.$editor.dropzone) {
          options.dropZoneOptions.init = function() {
            var caretPos = 0;
            this.on('drop', function(e) {
              caretPos = textarea.prop('selectionStart');
            });
            this.on('success', function(file, path) {
              var text = textarea.val();
              textarea.val(text.substring(0, caretPos) + '\n![description](' + path + ')\n' + text.substring(caretPos) );
            });
            this.on('error', function(file, error, xhr) {
              console.log('Error:', error);
            });
          }
          this.$textarea.addClass('dropzone');
          this.$editor.dropzone(options.dropZoneOptions);
        } else {
          console.log('dropZoneOptions was configured, but DropZone was not detected.');
        }
      }

      // Trigger the onShow hook
      options.onShow(this);

      return this;
    }

  , parseContent: function(val) {
      var content;

      // parse with supported markdown parser
      var val = val || this.$textarea.val();

      if (this.$options.parser) {
        content = this.$options.parser(val);
      } else if (typeof markdown == 'object') {
        content = markdown.toHTML(val);
      } else if (typeof marked == 'function') {
        content = marked(val);
      } else {
        content = val;
      }
      return content;
    }

  , showPreview: function() {
      var options = this.$options,
          container = this.$textarea,
          afterContainer = container.next(),
          replacementContainer = $('<div/>',{'class':'md-preview','data-provider':'markdown-preview'}),
          content,
          callbackContent;

      if (this.$isPreview == true) {
        // Avoid sequenced element creation on missused scenario
        // @see https://github.com/toopay/bootstrap-markdown/issues/170
        return this;
      }
      
      // Give flag that tell the editor enter preview mode
      this.$isPreview = true;
      // Disable all buttons
      this.disableButtons('all').enableButtons('cmdPreview');

      // Try to get the content from callback
      callbackContent = options.onPreview(this);
      // Set the content based from the callback content if string otherwise parse value from textarea
      content = typeof callbackContent == 'string' ? callbackContent : this.parseContent();

      // Build preview element
      replacementContainer.html(content);

      if (afterContainer && afterContainer.attr('class') == 'md-footer') {
        // If there is footer element, insert the preview container before it
        replacementContainer.insertBefore(afterContainer);
      } else {
        // Otherwise, just append it after textarea
        container.parent().append(replacementContainer);
      }

      // Set the preview element dimensions
      replacementContainer.css({
        width: container.outerWidth() + 'px',
        height: container.outerHeight() + 'px'
      });

      if (this.$options.resize) {
        replacementContainer.css('resize',this.$options.resize);
      }

      // Hide the last-active textarea
      container.hide();

      // Attach the editor instances
      replacementContainer.data('markdown',this);

      if (this.$element.is(':disabled') || this.$element.is('[readonly]')) {
        this.$editor.addClass('md-editor-disabled');
        this.disableButtons('all');
      }

      return this;
    }

  , hidePreview: function() {
      // Give flag that tell the editor quit preview mode
      this.$isPreview = false;

      // Obtain the preview container
      var container = this.$editor.find('div[data-provider="markdown-preview"]');

      // Remove the preview container
      container.remove();

      // Enable all buttons
      this.enableButtons('all');
      // Disable configured disabled buttons
      this.disableButtons(this.$options.disabledButtons);

      // Back to the editor
      this.$textarea.show();
      this.__setListener();

      return this;
    }

  , isDirty: function() {
      return this.$oldContent != this.getContent();
    }

  , getContent: function() {
      return this.$textarea.val();
    }

  , setContent: function(content) {
      this.$textarea.val(content);
      return this;
    }

  , findSelection: function(chunk) {
    var content = this.getContent(), startChunkPosition;

    if (startChunkPosition = content.indexOf(chunk), startChunkPosition >= 0 && chunk.length > 0) {
      var oldSelection = this.getSelection(), selection;

      this.setSelection(startChunkPosition,startChunkPosition+chunk.length);
      selection = this.getSelection();

      this.setSelection(oldSelection.start,oldSelection.end);

      return selection;
    } else {
      return null;
    }
  }

  , getSelection: function() {

      var e = this.$textarea[0];

      return (

          ('selectionStart' in e && function() {
              var l = e.selectionEnd - e.selectionStart;
              return { start: e.selectionStart, end: e.selectionEnd, length: l, text: e.value.substr(e.selectionStart, l) };
          }) ||

          /* browser not supported */
          function() {
            return null;
          }

      )();

    }

  , setSelection: function(start,end) {

      var e = this.$textarea[0];

      var evt = document.createEvent('Event');
      evt.initEvent('autosize:update', true, false);
      e.dispatchEvent(evt);

      return (

          ('selectionStart' in e && function() {
              e.selectionStart = start;
              e.selectionEnd = end;
              return;
          }) ||

          /* browser not supported */
          function() {
            return null;
          }

      )();

    }

  , replaceSelection: function(text) {

      var e = this.$textarea[0];

      return (

          ('selectionStart' in e && function() {
              e.value = e.value.substr(0, e.selectionStart) + text + e.value.substr(e.selectionEnd, e.value.length);
              // Set cursor to the last replacement end
              e.selectionStart = e.value.length;
              return this;
          }) ||

          /* browser not supported */
          function() {
              e.value += text;
              return jQuery(e);
          }

      )();
    }

  , getNextTab: function() {
      // Shift the nextTab
      if (this.$nextTab.length === 0) {
        return null;
      } else {
        var nextTab, tab = this.$nextTab.shift();

        if (typeof tab == 'function') {
          nextTab = tab();
        } else if (typeof tab == 'object' && tab.length > 0) {
          nextTab = tab;
        }

        return nextTab;
      }
    }

  , setNextTab: function(start,end) {
      // Push new selection into nextTab collections
      if (typeof start == 'string') {
        var that = this;
        this.$nextTab.push(function(){
          return that.findSelection(start);
        });
      } else if (typeof start == 'number' && typeof end == 'number') {
        var oldSelection = this.getSelection();

        this.setSelection(start,end);
        this.$nextTab.push(this.getSelection());

        this.setSelection(oldSelection.start,oldSelection.end);
      }

      return;
    }

  , __parseButtonNameParam: function (names) {
      return typeof names == 'string' ?
                      names.split(' ') :
                      names;

    }

  , enableButtons: function(name) {
      var buttons = this.__parseButtonNameParam(name),
        that = this;

      $.each(buttons, function(i, v) {
        that.__alterButtons(buttons[i], function (el) {
          el.removeAttr('disabled');
        });
      });

      return this;
    }

  , disableButtons: function(name) {
      var buttons = this.__parseButtonNameParam(name),
        that = this;

      $.each(buttons, function(i, v) {
        that.__alterButtons(buttons[i], function (el) {
          el.attr('disabled','disabled');
        });
      });

      return this;
    }

  , hideButtons: function(name) {
      var buttons = this.__parseButtonNameParam(name),
        that = this;

      $.each(buttons, function(i, v) {
        that.__alterButtons(buttons[i], function (el) {
          el.addClass('hidden');
        });
      });

      return this;
    }

  , showButtons: function(name) {
      var buttons = this.__parseButtonNameParam(name),
        that = this;

      $.each(buttons, function(i, v) {
        that.__alterButtons(buttons[i], function (el) {
          el.removeClass('hidden');
        });
      });

      return this;
    }

  , eventSupported: function(eventName) {
      var isSupported = eventName in this.$element;
      if (!isSupported) {
        this.$element.setAttribute(eventName, 'return;');
        isSupported = typeof this.$element[eventName] === 'function';
      }
      return isSupported;
    }

  , keyup: function (e) {
      var blocked = false;
      switch(e.keyCode) {
        case 40: // down arrow
        case 38: // up arrow
        case 16: // shift
        case 17: // ctrl
        case 18: // alt
          break;

        case 9: // tab
          var nextTab;
          if (nextTab = this.getNextTab(),nextTab !== null) {
            // Get the nextTab if exists
            var that = this;
            setTimeout(function(){
              that.setSelection(nextTab.start,nextTab.end);
            },500);

            blocked = true;
          } else {
            // The next tab memory contains nothing...
            // check the cursor position to determine tab action
            var cursor = this.getSelection();

            if (cursor.start == cursor.end && cursor.end == this.getContent().length) {
              // The cursor already reach the end of the content
              blocked = false;
            } else {
              // Put the cursor to the end
              this.setSelection(this.getContent().length,this.getContent().length);

              blocked = true;
            }
          }

          break;

        case 13: // enter
          blocked = false;
          break;
        case 27: // escape
          if (this.$isFullscreen) this.setFullscreen(false);
          blocked = false;
          break;

        default:
          blocked = false;
      }

      if (blocked) {
        e.stopPropagation();
        e.preventDefault();
      }

      this.$options.onChange(this);
    }

  , change: function(e) {
      this.$options.onChange(this);
      return this;
    }
  , select: function (e) {
      this.$options.onSelect(this);
      return this;
    }
  , focus: function (e) {
      var options = this.$options,
          isHideable = options.hideable,
          editor = this.$editor;

      editor.addClass('active');

      // Blur other markdown(s)
      $(document).find('.md-editor').each(function(){
        if ($(this).attr('id') !== editor.attr('id')) {
          var attachedMarkdown;

          if (attachedMarkdown = $(this).find('textarea').data('markdown'),
              attachedMarkdown === null) {
              attachedMarkdown = $(this).find('div[data-provider="markdown-preview"]').data('markdown');
          }

          if (attachedMarkdown) {
            attachedMarkdown.blur();
          }
        }
      });

      // Trigger the onFocus hook
      options.onFocus(this);

      return this;
    }

  , blur: function (e) {
      var options = this.$options,
          isHideable = options.hideable,
          editor = this.$editor,
          editable = this.$editable;

      if (editor.hasClass('active') || this.$element.parent().length === 0) {
        editor.removeClass('active');

        if (isHideable) {
          // Check for editable elements
          if (editable.el !== null) {
            // Build the original element
            var oldElement = $('<'+editable.type+'/>'),
                content = this.getContent(),
                currentContent = this.parseContent(content);

            $(editable.attrKeys).each(function(k,v) {
              oldElement.attr(editable.attrKeys[k],editable.attrValues[k]);
            });

            // Get the editor content
            oldElement.html(currentContent);

            editor.replaceWith(oldElement);
          } else {
            editor.hide();
          }
        }

        // Trigger the onBlur hook
        options.onBlur(this);
      }

      return this;
    }

  };

 /* MARKDOWN PLUGIN DEFINITION
  * ========================== */

  var old = $.fn.markdown;

  $.fn.markdown = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('markdown')
        , options = typeof option == 'object' && option;
      if (!data) $this.data('markdown', (data = new Markdown(this, options)))
    })
  };

  $.fn.markdown.messages = {};

  $.fn.markdown.defaults = {
    /* Editor Properties */
    autofocus: false,
    hideable: false,
    savable: false,
    width: 'inherit',
    height: 'inherit',
    resize: 'none',
    iconlibrary: 'glyph',
    language: 'en',
    initialstate: 'editor',
    parser: null,
    dropZoneOptions: null,

    /* Buttons Properties */
    buttons: [
      [{
        name: 'groupFont',
        data: [{
          name: 'cmdBold',
          hotkey: 'Ctrl+B',
          title: 'Bold',
          btnText: 'B',
          btnClass: 'bold',
          callback: function(e){
            // Give/remove ** surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent();

            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('bold');
            } else {
              chunk = selected.text;
            }

            // transform selection and set the cursor into chunked text
            if (content.substr(selected.start-2,2) === '**'
                && content.substr(selected.end,2) === '**' ) {
              e.setSelection(selected.start-2,selected.end+2);
              e.replaceSelection(chunk);
              cursor = selected.start-2;
            } else {
              e.replaceSelection('**'+chunk+'**');
              cursor = selected.start+2;
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        },{
          name: 'cmdItalic',
          title: 'Italic',
          btnText: 'I',
          btnClass: 'italics',
          hotkey: 'Ctrl+I',
          callback: function(e){
            // Give/remove * surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent();

            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('italics');
            } else {
              chunk = selected.text;
            }

            // transform selection and set the cursor into chunked text
            if (content.substr(selected.start-1,1) === '_'
                && content.substr(selected.end,1) === '_' ) {
              e.setSelection(selected.start-1,selected.end+1);
              e.replaceSelection(chunk);
              cursor = selected.start-1;
            } else {
              e.replaceSelection('_'+chunk+'_');
              cursor = selected.start+1;
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        },{
          name: 'cmdHeading',
          title: 'Heading',
          btnText: 'H',
          btnClass: 'heading',
          hotkey: 'Ctrl+H',
          callback: function(e){
            // Append/remove ### surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent(), pointer, prevChar;

            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('heading');
            } else {
              chunk = selected.text + (selected.length === 0 ? '\n' : '');
            }

            // transform selection and set the cursor into chunked text
            if ((pointer = 2, content.substr(selected.start-pointer,pointer) === '# ')
                || (pointer = 1, content.substr(selected.start-pointer,pointer) === '#')) {
              e.setSelection(selected.start-pointer,selected.end);
              e.replaceSelection(chunk);
              cursor = selected.start-pointer;
            } else if (selected.start > 0 && (prevChar = content.substr(selected.start-1,1), !!prevChar && prevChar != '\n')) {
              e.replaceSelection('\n# '+chunk);
              cursor = selected.start+3;
            } else {
              // Empty string before element
              e.replaceSelection('# '+chunk);
              cursor = selected.start+2;
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        }]
      },{
        name: 'groupLink',
        data: [{
          name: 'cmdUrl',
          title: 'URL/Link',
          btnText: 'Link',
          btnClass: 'link',
          hotkey: 'Ctrl+L',
          callback: function(e){
            // Give [] surround the selection and prepend the link
            var chunk, cursor, selected = e.getSelection(), content = e.getContent(), link;

            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('link title');
            } else {
              chunk = selected.text;
            }

            link = prompt(e.__localize('URL'),'http://');
            if (link === null) {
              return;
            }

            // var urlRegex = new RegExp('^((http|https)://|(mailto:)|(//))[a-z0-9]', 'i');
            // if (link !== null && link !== '' && link !== 'http://' && urlRegex.test(link)) {
              // var sanitizedLink = $('<div>'+link+'</div>').text();

              // transform selection and set the cursor into chunked text
              e.replaceSelection('['+chunk+']('+link+')');
              cursor = selected.start+1;

              // Set the cursor
              e.setSelection(cursor,cursor+chunk.length);
            // }
          }
        },{
          name: 'cmdImage',
          title: 'Image',
          btnText: 'Image',
          btnClass: 'image',
          hotkey: 'Ctrl+G',
          callback: function(e){
            // Give ![] surround the selection and prepend the image link
            var chunk = '', cursor, selected = e.getSelection(), content = e.getContent();

            var $form = e.$textarea.closest('.block-form');
            var $imageWizard = $('<div class="img-wizard"></div>');

            var $closeButton = $('<a class="close-button">&times;</a>');

            var upload_text = jQuery.browser.mobile ? 'upload picture' : 'drag&drop / upload';

            var $uploadContainer = $('<div class="option"><p>'+upload_text+'</p></div>');
            var $fileInput = $('<input accept="image/*" type="file" />');
            $uploadContainer.append($fileInput);

            var $textContainer = $('<div class="option"><p>direct link</p></div>');
            var $urlInput = $('<input type="text" value="http://" />');
            var $urlButton = $('<a class="button">done</a>');
            $textContainer.append($urlInput);

            $imageWizard.append($uploadContainer);
            $imageWizard.append('<div class="or"></div>');
            $imageWizard.append($textContainer);
            $imageWizard.append($closeButton);
            $imageWizard.append($urlButton);
            $form.append($imageWizard);

            var $progressBar  = $("<div class='progress-bar'></div>");
            $imageWizard.prepend($progressBar);

            var policyData = JSON.parse(JSON.stringify($form.data('form-data')))

            $fileInput.fileupload({
              add: function(e, data){
                policyData['Content-Type'] = data.files[0].type;
                data.formData = policyData;
                data.submit()
              },
              fileInput:       $fileInput,
              url:             $form.data('url'),
              type:            'POST',
              autoUpload:      true,
              formData:        policyData,
              paramName:       'file',
              dataType:        'XML',
              replaceFileInput: false,
              progressall: function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $progressBar.css('width', progress + '%')
              },
              start: function (e) {
                $progressBar.css('width', '0%')
              },
              done: function(event, data) {
                insertImageLink(decodeURIComponent($(data.jqXHR.responseXML).find("Location").text()));
              },
              fail: function(e, data) {
                $progressBar.css('width', '0%')
                alert('Please upload an image…');
              }
            });

            $urlButton.on('click', function(){
              insertImageLink($urlInput.val());
            });

            $closeButton.on('click', function(){
              $imageWizard.remove();
            });

            function insertImageLink(link){
              var linkDirectories = link.split('/');
              chunk = linkDirectories[linkDirectories.length - 1];
              e.replaceSelection('!['+chunk+']('+link+')');
              e.setSelection(cursor+chunk.length+link.length+5,cursor+chunk.length+link.length+5);
              $imageWizard.remove();
            }
          }
        }]
      },{
        name: 'groupMisc',
        data: [{
          name: 'cmdList',
          hotkey: 'Ctrl+U',
          title: 'List',
          btnText: 'List',
          btnClass: 'list',
          callback: function(e){
            // Prepend/Give - surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent();

            // transform selection and set the cursor into chunked text
            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('list item');

              e.replaceSelection('* '+chunk);
              // Set the cursor
              cursor = selected.start+2;
            } else {
              if (selected.text.indexOf('\n') < 0) {
                chunk = selected.text;

                e.replaceSelection('* '+chunk);

                // Set the cursor
                cursor = selected.start+2;
              } else {
                var list = [];

                list = selected.text.split('\n');
                chunk = list[0];

                $.each(list,function(k,v) {
                  list[k] = '* '+v;
                });

                e.replaceSelection(list.join('\n'));

                // Set the cursor
                cursor = selected.start+2;
              }
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        },
        {
          name: 'cmdListO',
          hotkey: 'Ctrl+O',
          title: 'Ordered List',
          btnText: '1. List',
          callback: function(e) {

            // Prepend/Give - surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent();

            // transform selection and set the cursor into chunked text
            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('list item');
              e.replaceSelection('1. '+chunk);
              // Set the cursor
              cursor = selected.start+3;
            } else {
              if (selected.text.indexOf('\n') < 0) {
                chunk = selected.text;

                e.replaceSelection('1. '+chunk);

                // Set the cursor
                cursor = selected.start+3;
              } else {
                var list = [];

                list = selected.text.split('\n');
                chunk = list[0];

                $.each(list,function(k,v) {
                  list[k] = '1. '+v;
                });

                e.replaceSelection('\n\n'+list.join('\n'));

                // Set the cursor
                cursor = selected.start+5;
              }
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        },
        {
          name: 'cmdCode',
          hotkey: 'Ctrl+K',
          title: 'Code',
          btnText: 'Code',
          callback: function(e) {
            // Give/remove ** surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent();

            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('code syntax');
            } else {
              chunk = selected.text;
            }

            // transform selection and set the cursor into chunked text
            if (content.substr(selected.start-4,4) === '```\n'
                && content.substr(selected.end,4) === '\n```') {
              e.setSelection(selected.start-4, selected.end+4);
              e.replaceSelection(chunk);
              cursor = selected.start-4;
            } else if (content.substr(selected.start-1,1) === '`'
                && content.substr(selected.end,1) === '`') {
              e.setSelection(selected.start-1,selected.end+1);
              e.replaceSelection(chunk);
              cursor = selected.start-1;
            } else if (content.indexOf('\n') > -1) {
              e.replaceSelection('```\n'+chunk+'\n```');
              cursor = selected.start+4;
            } else {
              e.replaceSelection('`'+chunk+'`');
              cursor = selected.start+1;
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        },
        {
          name: 'cmdQuote',
          hotkey: 'Ctrl+Q',
          title: 'Quote',
          btnText: 'Quote',
          btnClass: 'quote',
          callback: function(e) {
            // Prepend/Give - surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent();

            // transform selection and set the cursor into chunked text
            if (selected.length === 0) {
              // Give extra word
              chunk = e.__localize('quote');

              e.replaceSelection('> '+chunk);

              // Set the cursor
              cursor = selected.start+2;
            } else {
              if (selected.text.indexOf('\n') < 0) {
                chunk = selected.text;

                e.replaceSelection('> '+chunk);

                // Set the cursor
                cursor = selected.start+2;
              } else {
                var list = [];

                list = selected.text.split('\n');
                chunk = list[0];

                $.each(list,function(k,v) {
                  list[k] = '> '+v;
                });

                e.replaceSelection(list.join('\n'));

                // Set the cursor
                cursor = selected.start+2;
              }
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        },
        {
          name: 'cmdPoll',
          // hotkey: 'Ctrl+U',
          title: 'Poll',
          btnText: 'Poll',
          btnClass: 'poll-icon',
          callback: function(e){
            // Prepend/Give - surround the selection
            var chunk, cursor, selected = e.getSelection(), content = e.getContent();

            // transform selection and set the cursor into chunked text
            if (selected.length === 0) {
              // Give extra word
              chunk = "Name your poll here, options below"
              e.replaceSelection('Name your poll here, options below\n\n() Enter poll option...\n() Enter poll option...\n() Etc.');
              // Set the cursor
              cursor = selected.start;
            } else {
              if (selected.text.indexOf('\n') < 0) {
                chunk = selected.text;

                e.replaceSelection('() '+chunk);

                // Set the cursor
                cursor = selected.start+3;
              } else {
                var list = [];

                list = selected.text.split('\n');
                chunk = list[0];

                $.each(list,function(k,v) {
                  list[k] = '() '+v;
                });

                e.replaceSelection(list.join('\n'));

                // Set the cursor
                cursor = selected.start+3;
              }
            }

            // Set the cursor
            e.setSelection(cursor,cursor+chunk.length);
          }
        }]
      },{
        name: 'groupUtil',
        data: [{
          name: 'cmdPreview',
          toggle: true,
          hotkey: 'Ctrl+P',
          title: 'Preview',
          btnText: 'preview',
          btnClass: 'btn btn-primary btn-sm',
          callback: function(e){
            // Check the preview mode and toggle based on this flag
            var isPreview = e.$isPreview,content;

            if (isPreview === false) {
              // Give flag that tell the editor enter preview mode
              e.showPreview();
            } else {
              e.hidePreview();
            }
          }
        }]
      }]
    ],
    additionalButtons:[], // Place to hook more buttons by code
    reorderButtonGroups:[],
    hiddenButtons:['cmdPreview', 'cmdListO', 'cmdCode'], // Default hidden buttons
    disabledButtons:[], // Default disabled buttons
    footer: '',
    fullscreen: {
      enable: true,
      icons: {
        fullscreenOn: {
          fa: 'fa fa-expand',
          glyph: 'glyphicon glyphicon-fullscreen',
          'fa-3': 'icon-resize-full',
          octicons: 'octicon octicon-link-external'
        },
        fullscreenOff: {
          fa: 'fa fa-compress',
          glyph: 'glyphicon glyphicon-fullscreen',
          'fa-3': 'icon-resize-small',
          octicons: 'octicon octicon-browser'
        }
      }
    },

    /* Events hook */
    onShow: function (e) {},
    onPreview: function (e) {},
    onSave: function (e) {},
    onBlur: function (e) {},
    onFocus: function (e) {},
    onChange: function(e) {},
    onFullscreen: function(e) {},
    onFullscreenExit: function(e) {},
    onSelect: function (e) {}
  };

  $.fn.markdown.Constructor = Markdown;


 /* MARKDOWN NO CONFLICT
  * ==================== */

  $.fn.markdown.noConflict = function () {
    $.fn.markdown = old;
    return this;
  };

  /* MARKDOWN GLOBAL FUNCTION & DATA-API
  * ==================================== */
  var initMarkdown = function(el) {
    var $this = el;

    if ($this.data('markdown')) {
      $this.data('markdown').showEditor();
      return;
    }

    $this.markdown()
  };

  var blurNonFocused = function(e) {
    var $activeElement = $(document.activeElement);

    // Blur event
    $(document).find('.md-editor').each(function(){
      var $this            = $(this),
          focused          = $activeElement.closest('.md-editor')[0] === this,
          attachedMarkdown = $this.find('textarea').data('markdown') ||
                             $this.find('div[data-provider="markdown-preview"]').data('markdown');

      if (attachedMarkdown && !focused) {
        attachedMarkdown.blur();
      }
    })
  };

}));
