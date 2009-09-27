pdf.image "#{RAILS_ROOT}/public/images/fol_logo_mono.jpg"
pdf.text @event.title
pdf.text @event.start.strftime("%e %B %R%p")
pdf.text "until" + end_time(@event) if @event.end

if @event.venue.present?
  pdf.text @event.venue.name
  pdf.text @event.venue.address_1
  pdf.text @event.venue.address_2
  pdf.text @event.venue.address_3
  pdf.text @event.venue.city
  pdf.text @event.venue.county
  pdf.text @event.venue.postcode
end
  
pdf.text @event.event_type.blank? ? "Other" : @event.event_type
pdf.text @event.theme.blank? ? "Other" : @event.theme
pdf.text @event.cost unless @event.cost.blank?
pdf.text @event.more_info unless @event.more_info.blank?
pdf.text @event.description unless @event.description.blank?
