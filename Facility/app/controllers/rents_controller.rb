class RentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false ,only: [:update, :controllpane, :info]
  def new
    if params[:largerent]
      facility = Facility.find_by(id: params[:id])
      rents = Facility.find_by(id: params[:id]).rents
      date = params[:day]
      reg = /^(.*)\/(.*)\/(.*)/
      day = DateTime.new(date[reg,1].to_i,date[reg,2].to_i,date[reg,3].to_i)
      now = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day)
      next_week = ((day.to_time - now.to_time)/1.day).to_i / 7
      if params[:cartrent].to_i > 1
        serial = "%d" % (Time.now.to_f*10000)
        cart_verify_or_not = true
      else
        serial = '000000'
        cart_verify_or_not = false
      end
      days = []
      times = []
      puts '---------------------------------------------------'
      puts
      for k in 1..params[:weekly].to_i
        puts '------------------------'
        puts week_offset = (k-1)*7
        puts (day  + week_offset.day)
        puts '------------------------'
        days.push(day  + week_offset.day)
      end
      puts
      puts '---------------------------------------------------'
      for i in  params[:period].to_i..(params[:period].to_i+params[:cartrent].to_i-1)
        times.push(i.to_s(16))
      end
      if facility.rents.where(day: days, period: times).length == 0
        days.each do |the_day|
          times.each do |time|
            facility.rents.create(user_id: current_user,day: the_day, period: time, cart_serial: serial, cart: cart_verify_or_not)
          end
          serial = (serial.to_d + 1).to_s.chop.chop if serial != '000000'
        end
        redirect_to "/facilities/#{params[:id]}?next_week=#{next_week}", notice: 'success'
        return
      else
        redirect_to "/facilities/#{params[:id]}?next_week=#{next_week}", notice: 'repeat'
        return
      end
    elsif params[:cartrent]
      if params[:cartrent].to_i > 1
        serial = "%d" % (Time.now.to_f*10000)
      else
        serial = '000000'
      end
      facility = Facility.find_by(id: params[:id])
      rents = Facility.find_by(id: params[:id]).rents
      date = params[:day]
      reg = /^(.*)\/(.*)\/(.*)/
      day = DateTime.new(date[reg,1].to_i,date[reg,2].to_i,date[reg,3].to_i)
      now = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day)
      next_week = ((day.to_time - now.to_time)/1.day).to_i / 7
      for i in 1..params[:cartrent].to_i
        if(params[:period].to_i(16) + params[:cartrent].to_i - 1 > 16)
          redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s , notice: 'failed'
          return
        end
        if rents.find_by(day: day, period: (params[:period].to_i(16)+i-1).to_s(16))
          if(facility.verify && rents.where(day: day, period: (params[:period].to_i(16)+i-1).to_s(16)).size >= 4)
            redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s, notice: 'failed'
            return
          end
          if(rents.find_by(day: day, period: (params[:period].to_i(16)+i-1).to_s(16)).user_id==current_user)
            redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s, notice: 'repeat'
            return
          end
        end
      end
      for i in 1..params[:cartrent].to_i
        rents.create(period: (params[:period].to_i(16)+i-1).to_s(16), day: day, description: params[:description], user_id: current_user, cart: true, cart_serial: serial)
      end
      redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s, notice: 'success'
    else
      reg = /^(.*)-(.*)-(.*)-(.*)/
      facility = Facility.find_by(id: params[:id])
      rents = facility.rents
      if params[:periods].present?
      params[:periods].each do |period|
        day = DateTime.new(period[reg,1].to_i,period[reg,2].to_i,period[reg,3].to_i)
        period = period[reg,4].to_i(16).to_s
        if day.to_i + 28800 + period.to_i*3600 < Time.now.utc.to_i
          redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s, notice: 'past'
          return
        end
        if rents.where(day: day, period: period).size!=0
          if !facility.verify || rents.where(day: day, period: period).size>=4
            redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s ,notice: 'failed'
            return
          end
          if rents.find_by(day: day, period: period).user_id==current_user
            redirect_to "facilities/#{params[:id]}?next_week=" + next_week.to_s, notice: 'repeat'
            return
          end
        end
      end
      params[:periods].each do |period|
        day = DateTime.new(period[reg,1].to_i,period[reg,2].to_i,period[reg,3].to_i)
        period = period[reg,4]
        rents.create(day: day, period: period.to_i.to_s(16), description: params[:description], user_id: current_user)
      end
      end
      redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s, notice: 'success'
    end
  end

  def update
    if params["permit"]
      return if Facility.find_by(id: params[:id]).users.where(portal_id: current_user).nil?
      if params["serial"]=='000000'
        rent = Facility.find_by(id: params[:id]).rents.find_by(id: params["rent_id"])
        rent.update(verified: true)
      else
        if params['serial']!='000000'
          Facility.find_by(id: params[:id]).rents.where(cart_serial: params["serial"]).update(verified: true)
        else
          Facility.find_by(id: params[:id]).rents.where(id: params["single_id"])
        end
      end
    else
      reg= /^(.*)-(.*)-(.*)-(.*)/
      p = params[:rent_day]
      year = p[reg,1]
      month = p[reg,2]
      day = p[reg,3]
      time = p[reg,4]
      the_day = DateTime.new(year.to_i,month.to_i,day.to_i)
      the_rent = Facility.find_by(id: params[:id]).rents.find_by(day: the_day, period: time)
      if the_rent.present?
        return if the_rent.user_id != current_user
        the_rent.update(description: params[:description])
        next_week = ((the_day.to_time - DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day).to_time)/1.day).to_i / 7
        redirect_to "/facilities/#{params[:id]}?next_week=" + next_week.to_s, notice: 'success'
      end
    end
  end

  def destroy
    if params[:serial]!='000000'
      rents = Facility.find_by(id: params[:id]).rents.where(cart_serial: params[:serial])
      rents.each do |r|
        r.destroy
      end
    elsif params[:serial]=='000000'
      Facility.find_by(id: params[:id]).rents.find_by(id: params[:single_id]).destroy
    else
      facility = Facility.find_by(id: params[:id])
      the_rent = facility.rents.find_by(id: params[:rent_id])
      if(facility.users.find_by(portal_id: current_user).present? || the_rent.user_id == current_user)
        the_rent.destroy
      end
    end
  end

  def form
  end

  def info
    render :layout => false
  end

  def controllpane
  end

end
