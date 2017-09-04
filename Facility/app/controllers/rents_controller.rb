class RentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false ,only: [:info]
  layout false ,only: [:controllpane]
  def new
    if params[:cartrent].present?
      serial = "%d" % (Time.now.to_f*10000)
      facility = Facility.find_by(id: params[:id])
      rents = Facility.find_by(id: params[:id]).rents
      date = params[:day]
      reg = /^(.*)\/(.*)\/(.*)/
      day = DateTime.new(date[reg,1].to_i,date[reg,2].to_i,date[reg,3].to_i)
      for i in 1..params[:cartrent].to_i
        if rents.find_by(day: day, period: params[:period].to_i+i-1)
          if(facility.verify && rents.where(day: day, period: params[:period].to_i+i-1).size >= 4)
            redirect_to "/facilities/#{params[:id]}", notice: 'failed'
            return
          end
        end
      end
      for i in 1..params[:cartrent].to_i
        rents.create(period: params[:period].to_i+i-1, day: day, description: params[:description], user_id: current_user, cart: true, cart_serial: serial)
      end
      redirect_to "/facilities/#{params[:id]}", notice: 'success'
    else
      reg = /^(.*)-(.*)-(.*)-(.*)/
      facility = Facility.find_by(id: params[:id])
      rents = facility.rents
      params[:periods].each do |period|
        day = DateTime.new(period[reg,1].to_i,period[reg,2].to_i,period[reg,3].to_i)
        period = period[reg,4]
        if day.to_i + 28800 + period.to_i*3600 < Time.now.utc.to_i
          redirect_to "/facilities/#{params[:id]}", notice: 'past'
          return
        end
        if rents.where(day: day, period: period).size!=0
          if !facility.verify || rents.where(day: day, period: period).size>=4
            redirect_to "/facilities/#{params[:id]}" ,notice: 'failed'
            return
          end
        end
      end
      params[:periods].each do |period|
        day = DateTime.new(period[reg,1].to_i,period[reg,2].to_i,period[reg,3].to_i)
        period = period[reg,4]
        rents.create(day: day, period: period.to_i.to_s(16), description: params[:description], user_id: current_user)
      end
      redirect_to "/facilities/#{params[:id]}", notice: 'success'
    end
  end

  def update
    if params["permit"]
      rent = Facility.find_by(id: params[:id]).rents.find_by(params["rent_id"])
      rent.verified = true
      rent.save
    end
  end

  def destroy
    if params[:count]=='serial'
      serial = Facility.find_by(id: params[:id]).rents.find_by(id: params[:rent_id]).cart_serial
      rents = Facility.find_by(id: params[:id]).rents.where(cart_serial: serial)
      rents.each do |r|
        r.destroy
      end
      redirect_to '/facilities'
    elsif params[:count]=='single'
      Facility.find_by(id: params[:id]).rents.find_by(id: params[:rent_id]).destroy
      redirect_to '/facilities'
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
