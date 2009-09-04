

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

RefineEventSearch = $.klass({
  initialize: function(section_to_close) {
    this.section_to_close = section_to_close
  },
  onclick: function() {
    this.section_to_close.slideToggle(this.section_to_close)
  }
});

FormSlider = $.klass({
  
  initialize: function() {
    this.element_to_toggle = $("#"+this.element.attr("id").replace("toggles_", ""));
    this.element_to_toggle.hide()
  },
  
  onclick: function() {
    this.element_to_toggle.slideToggle();
    return false;
  }
  
});

SliderCancel = $.klass({
  initialize: function() {
    this.element_to_slideUp = $("#"+this.element.attr("id").replace("hides_", ""));
  },

  onclick: function() {
  this.element_to_slideUp.slideUp();
  return false;
  }
});

QueryFormSlider = $.klass(FormSlider, {
  
  onclick: function($super) {
  this.element.fadeOut('200', function() {  $super();});
  return false
  }

});


DateSlider = $.klass({
  initialize: function() {
    this.element.find('select').hide();
    var from_day = this.element.find("#filter_from_day");
    var to_day = this.element.find("#filter_to_day");
    var current_from_day = this.element.find(".current_time_span .current_from_day")
    var current_to_day = this.element.find(".current_time_span .current_to_day")
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


  

jQuery(function($) {
  $('.flickr_photos').attach(Flickr, '82586441@N00');
  $('.youtube_videos').attach(YouTube, 'DowningSt');
  $('.date_slider').attach(DateSlider);
  $('.toggler').attach(FormSlider);
  $('.self_toggler').attach(QueryFormSlider);
  $('.cancel_search').attach(SliderCancel);
});


$('.featured_events').cycle({pager: ".featured_event_nav", pause: true, pauseOnPagerHover: true})

