Flickr = $.klass({
  initialize: function(user_id) {
    var element = jQuery('<ul class="flickr_photos" id="flickr_photos_from_'+user_id+'"></ul>');
    this.element.replaceWith(element);
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
YouTube = $.klass({
  initialize: function(user_id) {
    var element = jQuery('<ul class="youtube_videos" id="youtube_videos_from_'+user_id+'"></ul>');
    this.element.replaceWith(element);
    $.getJSON("http://gdata.youtube.com/feeds/users/"+user_id+"/uploads?alt=json-in-script&callback=?", function(data){ 
      $.each(data.feed.entry.slice(0,4), function(i, item) { 
        element.append(
          '<li>'+
            '<a href="'+item.link[0].href+'">'+
              '<img src="'+item.media$group.media$thumbnail[0].url+'" alt="'+item.title.$t+'" />'+
            '</a>'+
            '<p>'+item.title.$t+'</p>'+
          '</li>'
        );
      });
    });
  }
});



jQuery(function($) {
  $('.flickr_photos').attach(Flickr, '82586441@N00');
  $('.youtube_videos').attach(YouTube, 'DowningSt');
});


$('.featured_events').cycle({pager: ".featured_event_nav", pause: true, pauseOnPagerHover: true})