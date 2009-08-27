Flickr = $.klass({
  initialize: function(user_id) {
    var element = jQuery('<ul class="flickr_photos" id="flickr_photos_from_'+user_id+'"></ul>');
    this.element.html(element);
    $.getJSON("http://api.flickr.com/services/feeds/photos_public.gne?id="+user_id+"&format=json&jsoncallback=?", function(data){ 
      $.each(data.items.slice(0,6), function(i, item) { 
        element.append(
          '<li>'+
            '<a href="'+item.link+'">'+
              '<img src="'+item.media.m.replace(/_m.jpg$/, "_m.jpg")+'" alt="'+item.title+'" />'+
            '</a>'+
            '<p>'+item.title+'</p>'+
          '</li>'
        );
      });
    });
  }
});


jQuery(function($) {
  $('.flickr_photos').attach(Flickr, '82586441@N00');
});


$('.featured_events').cycle({pager: ".featured_event_nav", pause: true, pauseOnPagerHover: true})