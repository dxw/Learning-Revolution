module ActionControllerExtra
  module EventMixin
    def process_dates
      if params[:startyear] and params[:startmonth] and params[:startday] and params[:starthour] and params[:startminute]
        y = params[:startyear].to_i
        mo = params[:startmonth].to_i
        d = params[:startday].to_i
        h = params[:starthour].to_i
        mi = params[:startminute].to_i
        start = Time.zone.local(y, mo, d, h, mi)
        params[:event][:start] = start.to_s

        if params[:endhour] != 'NONE' and params[:endminute] != 'NONE'
          y = params[:endyear].to_i unless params[:endyear] == 'NONE'
          mo = params[:endmonth].to_i unless params[:endmonth] == 'NONE'
          d = params[:endday].to_i unless params[:endday] == 'NONE'
          h = params[:endhour].to_i
          mi = params[:endminute].to_i
          begin
            params[:event][:end] = Time.zone.local(y, mo, d, h, mi).to_s
          rescue ArgumentError
          end
        end
      end
    end
  end
end
