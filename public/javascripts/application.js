Flickr = $.klass({
  initialize: function (user_id) {
    var current_element = this.element
    $.getJSON("http://api.flickr.com/services/feeds/photos_public.gne?id=" + user_id + "&format=json&jsoncallback=?", function (data) { 
      var element = jQuery('<ul class="flickr_photos clearfix" id="flickr_photos_from_' + user_id + '"></ul>');
      current_element.replaceWith(element);
      $.each(data.items.slice(0, 8), function (i, item) { 
        element.append(
          '<li>' +
            '<a href="' + item.link + '">' +
              '<img src="' + item.media.m.replace(/_m\.jpg$/, "_s.jpg") + '" alt="' + item.title + '" />' +
            '</a>' +
          '</li>'
        );
      });
    });
  }
});
YouTube = $.klass({
  initialize: function (user_id) {
    var current_element = this.element
    $.getJSON("http://gdata.youtube.com/feeds/users/" + user_id + "/uploads?alt=json-in-script&callback=?", function (data) { 
      var element = jQuery('<ul class="youtube_videos clearfix" id="youtube_videos_from_' + user_id + '"></ul>');
      current_element.replaceWith(element);
      $.each(data.feed.entry.slice(0, 6), function (i, item) { 
        element.append(
          '<li>' +
            '<a href="' + item.link[0].href + '">' +
              '<img src="' + item.media$group.media$thumbnail[0].url + '" alt="' + item.title.$t + '" />' +
            '</a>' +
          '</li>'
        );
      });
    });
  }
});
YouTubePlayer = $.klass({
  initialize: function (user_id) {
    var current_element = this.element
    $.getJSON("http://gdata.youtube.com/feeds/users/" + user_id + "/uploads?&orderby=updated&alt=json-in-script&callback=?", function (data) { 

      var latest_video_url = data.feed.entry[0].media$group.media$content[0].url
      var element = jQuery('<object width="340" height="243">');
      element.append(
        '<param name="movie" value="' + latest_video_url  + '&amp;hl=en&amp;fs=1"></param>' + 
        '<param name="allowFullScreen" value="true"></param>' +
        '<param name="allowscriptaccess" value="always"></param>' +
        '</object>'
        );
      debugger
      current_element.after(element);
    });
  }
});
DateSlider = $.klass({
  initialize: function () {
    this.element.find('select').hide();
    var from_day = this.element.find("#filter_from_day");
    var to_day = this.element.find("#filter_to_day");
    var current_from_day = this.element.find(".current_time_span .current_from_day");
    var current_to_day = this.element.find(".current_time_span .current_to_day");
    this.element.find('.slider').slider({ 
      animate: true, 
      range: true, 
      min: 1, 
      max: 31, 
      values: [from_day.val(), to_day.val()],
      change: function (event, ui) {
        from_day.val($(this).slider('values', 0));
        to_day.val($(this).slider('values', 1));
      },
      slide: function (event, ui) {
        current_from_day.html($(this).slider('values', 0));
        current_to_day.html($(this).slider('values', 1));
      }
    });
  }
});

EventFilterSlider = $.klass({
  initialize: function () {
    this.hideable = this.element.find(".form_wrapper");
    this.toggles = this.element.find(".toggles");
    this.hideable.hide(function() {
      // added for IE6 and IE7 to correctly hide child elements too.
      $(".input_tip").hide();
    });

  },
  toggle: function () {
    this.hideable.slideToggle();
  },
  onclick: $.delegate({
    '.toggles': function (el) {
      this.toggle();
      this.toggles.toggleClass("active");
      if (el.find('img') && !el.find('img').attr('src').match('_active')) {
        // remove the _active suffix
       el.find('img').attr('src', el.find('img').attr('src').replace('.png','_active.png'));
      }
      else 
      {
        // add the suffix
       el.find('img').attr('src', el.find('img').attr('src').replace('_active',''));
      }
      return false;
    }
  })
});

InfoTip = $.klass({
	initialize: function () {
	  this.container = this.element.parents(".input_with_tip");
	  this.input_tip = this.container.find(".input_tip");
	  // need to explicitly hide the tool tip, for IE6 and 7
    this.input_tip_tool_tip = this.input_tip.find('.tooltip');
    this.input_tip.hide();
    this.input_tip_tool_tip.hide()
	},
	onfocus: function () {
	  this.input_tip.show();
    this.input_tip_tool_tip.show()
	},
	onblur: function () {
	  this.input_tip.hide();
    this.input_tip_tool_tip.hide()
	}
});

DisableEventPostcode = $.klass({
      onchange: function() {
         $('#venue_postcode').attr('disabled', $('#cyberevent').attr('checked'));
         
         if($('#cyberevent').attr('checked'))
         {
            $("label[for=venue_postcode]").addClass('disabled');
         }
         else
         {
            $("label[for=venue_postcode]").removeClass('disabled');
         }
      }
});

PostcodeHint = $.klass({
      
      // If you change this text, make sure you change it in EventsController#index
      empty_text: 'Enter your postcode here',
      
      on_initialise_or_blur: function() {         
         
         if($('#filter_location').val() == '' || $('#filter_location').val() == this.empty_text)
         {
            $('#filter_location').val(this.empty_text)
            $('#filter_location').addClass('empty');
         }
      },
      
      initialize: function() {
         this.on_initialise_or_blur()
      },
      
      onblur: function() {
         this.on_initialise_or_blur()
      },
               
      onclick: function()
      {
         if($('#filter_location').val() == this.empty_text)
         {
            $('#filter_location').val('')
            $('#filter_location').removeClass('empty');
         }
      }
});


jQuery(function ($) {
  $('.featured_youtube h3').attach(YouTubePlayer, 'learnrevolution');
  $('.flickr_photos').attach(Flickr, '42889703@N05');
  $('.youtube_videos').attach(YouTube, 'learnrevolution');
  $('.date_slider').attach(DateSlider);
  $('.event_filtering').attach(EventFilterSlider);
  // This is dead now: $('.event_venue_form').attach(VenueFinder);
  $(".input_with_tip input").attach(InfoTip);
  $(".input_with_tip select").attach(InfoTip);
  $(".input_with_tip textarea").attach(InfoTip);
//  $("input.datepicker").datepicker({ dateFormat: 'd MM yy', minDate: new Date(2009,9,01), maxDate: new Date(2009,9,31) });
  $('.featured_events ul').cycle({fx: 'scrollLeft', pager: ".featured_event_nav", pause: true, pauseOnPagerHover: true});
  $('#cyberevent').attach(DisableEventPostcode);
  $('#filter_location').attach(PostcodeHint);
});



