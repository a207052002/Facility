class FacilitiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false, only: [:table,:edit]
  def index
  end

  def create
    if(params[:verify]=='true')
      verify = true
    else
      verify = false
    end

    if(params[:limit]=='true')
      limit = true
    else
      limit = false
    end
    facility = User.find_by(portal_id: current_user).facilities.create(name: params[:name], description: params[:description], membership: limit, verify: verify, board: params[:board])
    facility.allow_users.create(portal_id: current_user)
    redirect_to '/facilities'
  end

  def new
  end

  def edit
  end

  def show
    if current_user.nil?
      redirect_to '/facilities', notice: 'unlogin'
    else
      if (facility = Facility.find_by(id: params[:id])).membership
        redirect_to '/facilities', notice: 'limit' if facility.allow_users.find_by(portal_id: current_user).nil?
      end
    end
  end

  def update
    if params['change']=='board'
      Facility.find_by(id: params[:id]).update(board: params['board'])
      redirect_to '/facilities', notice: 'board'
    elsif params['change']=='membership'
      facility = Facility.find_by(id: params[:id])
      facility.update(membership: !facility.membership)
      redirect_to '/facilities', notice: 'membership'
    else
      redirect_to '/facilities', notice: 'do not fuck me'
    end
  end

  def more
  end

  def more_edit
    owner = (facility=Facility.find_by(id: params[:id])).users.find_by(portal_id: current_user)
    if(owner.present? && params[:content].present?)
      if params[:more]=='admin'
        facility.users.create(portal_id: params[:content])
      elsif params[:more]=='member'
        facility.allow_users.create(portal_id: params[:content])
      elsif params[:more]=='description'
        facility.update(description: params[:content])
        redirect_to '/facilities/'+params[:id]+'/edit/more', notice: 'description changed'
      end
    end
  end

  def more_delete
    owner = (facility=Facility.find_by(id: params[:id])).users.find_by(portal_id: current_user)
    if(owner.present? && params[:content].present?)
      if params[:more]=='admin'
        the_user = facility.users.find_by(portal_id: params[:content])
        the_user.destroy if the_user.present?
      elsif params[:more]=='member'
        the_member = facility.allow_users.find_by(portal_id: params[:content])
        the_member.destroy if the_member.present?
      end
    end
  end

  def destory
  end

  def table
  end
end
