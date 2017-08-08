class RentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false ,only: [:info]
  def new
    if params[:cart]
      serial = Time.now.to_f.to_s
      rents = Facility.find_by(params[:id]).rents
      cart_reg = /^(.*)\/(.*)\/(.*)\/(.*)/
      params[:periods].each do |p|
        day = DateTime.new(p[cart_reg, 1].to_i,p[cart_reg,2].to_i,p[cart_reg,3].to_i)
        period = p[cart_reg,4]
        rents.create(period: period, day: day, description: params[:description], user_id: current_user, cart: true, cart_serial: serial)
      end
    redirect_to "/facilities/#{params[:id]}", notice: 'success'
    else
      date = params[:day]
      reg = /^(.*)\/(.*)\/(.*)/
      day = DateTime.new(date[reg,1].to_i,date[reg,2].to_i,date[reg,3].to_i)
      if(DateTime.new(date[reg,1].to_i ,date[reg,2].to_i, date[reg,3].to_i, (params[:period].to_i+7),0,0,'+8') >  DateTime.now )
        the_rent = (rents = Facility.find_by(id: params[:id]).rents).find_by(day: day, period: params[:period], description: params[:description], user_id: current_user)
        if(the_rent.nil? || Facility.find_by(id: params[:id]).verify)
          if(params['largerent'] && the_rent.nil?)
            if params['rentweeks'].nil?
              redirect_to "/facilities/#{params[:id]}", notice: 'largeillegal'
            end
            for i in 1..params['rentweeks'].to_i
              if !rents.find_by(period: params[:period], day: day+i*7).nil?
                redirect_to "/facilities/#{params[:id]}", notice: 'largefailed'
              end
            end
            for i in 0..params['rentweeks'].to_i
              rents.create(day: day+i*7, period: params[:period], description: params[:description], user_id: current_user, large: true)
            end
            redirect_to "/facilities/#{params[:id]}"
          else
            rents.create(day: day, period: params[:period], description: params[:description], user_id: current_user)
            redirect_to "/facilities/#{params[:id]}", notice: 'success'
          end
        else
          redirect_to "/facilities/#{params[:id]}", notice: 'failed'
        end
      else
        redirect_to "/facilities/#{params[:id]}", notice: 'past'
      end
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
    facility = Facility.find_by(id: params[:id])
    the_rent = facility.rents.find_by(id: params[:rent_id])
    if(facility.users.find_by(portal_id: current_user).present? || the_rent.user_id == current_user)
      the_rent.destroy
    end
  end

  def form
  end

  def info
    if params[:change_rent]

    end
  end

end
