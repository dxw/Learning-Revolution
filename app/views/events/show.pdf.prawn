pdf.image "#{RAILS_ROOT}/public/images/fol_logo_mono.jpg"
pdf.pad(30) do
  pdf.text @event.title, :size => 24
end

pdf.pad(10) do
  pdf.text @event.start.strftime("%e %B %R%p")
  pdf.text "until " + end_time(@event) if @event.end
end

if @event.venue.present?
  pdf.pad(10) do
    pdf.text @event.venue.name
    pdf.text @event.venue.address_1
    pdf.text @event.venue.address_2
    pdf.text @event.venue.address_3
    pdf.text @event.venue.city
    pdf.text @event.venue.county
    pdf.text @event.venue.postcode
  end
end

pdf.text "Event type: " + (@event.event_type.blank? ? "Other" : @event.event_type)
pdf.text "Event theme: " + (@event.theme.blank? ? "Other" : @event.theme)
pdf.text @event.cost unless @event.cost.blank?
pdf.text @event.more_info unless @event.more_info.blank?
pdf.text @event.description unless @event.description.blank?
