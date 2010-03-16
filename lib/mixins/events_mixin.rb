module ActionControllerExtra
  module EventsMixin
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
    def update_date_params obj
      if params['edit']
        params.update :startyear => '%d'% obj.start.year
        params.update :startmonth => '%d'% obj.start.month
        params.update :startday => '%d'% obj.start.day
        params.update :starthour => '%02d'% obj.start.hour
        params.update :startminute => '%02d'% obj.start.min

        unless obj.end.blank?
          params.update :endyear => '%d'% obj.end.year
          params.update :endmonth => '%d'% obj.end.month
          params.update :endday => '%d'% obj.end.day
          params.update :endhour => '%02d'% obj.end.hour
          params.update :endminute => '%02d'% obj.end.min
        end
      end
    end
  end
end
