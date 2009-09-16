Flickr = $.klass({
  initialize: function(user_id) {
    var element = jQuery('<ul class="flickr_photos clearfix" id="flickr_photos_from_'+user_id+'"></ul>');
    this.element.replaceWith(element);
    $.getJSON("http://api.flickr.com/services/feeds/photos_public.gne?id="+user_id+"&format=json&jsoncallback=?", function(data){ 
      $.each(data.items.slice(0,8), function(i, item) { 
        element.append(
          '<li>'+
            '<a href="'+item.link+'">'+
              '<img src="'+item.media.m.replace(/_m.jpg$/, "_s.jpg")+'" alt="'+item.title+'" />'+
            '</a>'+
          '</li>'
        );
      });
    });
  }
});
YouTube = $.klass({
  initialize: function(user_id) {
    var element = jQuery('<ul class="youtube_videos clearfix" id="youtube_videos_from_'+user_id+'"></ul>');
    this.element.replaceWith(element);
    $.getJSON("http://gdata.youtube.com/feeds/users/"+user_id+"/uploads?alt=json-in-script&callback=?", function(data){ 
      $.each(data.feed.entry.slice(0,6), function(i, item) { 
        element.append(
          '<li>'+
            '<a href="'+item.link[0].href+'">'+
              '<img src="'+item.media$group.media$thumbnail[0].url+'" alt="'+item.title.$t+'" />'+
            '</a>'+
          '</li>'
        );
      });
    });
  }
});

DateSlider = $.klass({
  initialize: function() {
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
      values: [from_day.val(),to_day.val()],
      change: function(event, ui) {
        from_day.val($(this).slider('values', 0));
        to_day.val($(this).slider('values', 1));
      },
      slide: function(event, ui) {
        current_from_day.html($(this).slider('values', 0));
        current_to_day.html($(this).slider('values', 1));
      }
    });
  }
});

EventFilterSlider = $.klass({
  initialize: function() {
    this.hideable = this.element.find(".form_wrapper");
    this.toggles = this.element.find(".toggles");
    this.hideable.hide();
  },
  toggle: function() {
    this.hideable.slideToggle();
  },
  onclick: $.delegate({
    '.toggles': function(el) {
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

VenueFinder = $.klass({
	initialize: function() {
		this.element.find(".new_venue_fields").hide();
	}
});

InfoTip = $.klass({
	initialize: function() {
	  this.container = this.element.parents(".input_with_tip");
	  this.input_tip = this.container.find(".input_tip");
     this.input_tip.hide();
	},
	onfocus: function() {
	  this.input_tip.show();
	},
	onblur: function() {
	  this.input_tip.hide();
	}
});


jQuery(function($) {
  $('.flickr_photos').attach(Flickr, '82586441@N00');
  $('.youtube_videos').attach(YouTube, 'DowningSt');
  $('.date_slider').attach(DateSlider);
  $('.event_filtering').attach(EventFilterSlider);
  $('.event_venue_form').attach(VenueFinder);
  $(".input_with_tip input").attach(InfoTip);
  $(".input_with_tip select").attach(InfoTip);
  $(".input_with_tip textarea").attach(InfoTip);
//  $("input.datepicker").datepicker({ dateFormat: 'd MM yy', minDate: new Date(2009,9,01), maxDate: new Date(2009,9,31) });
  $('.featured_events ul').cycle({fx: 'scrollLeft', pager: ".featured_event_nav", pause: true, pauseOnPagerHover: true});
});



