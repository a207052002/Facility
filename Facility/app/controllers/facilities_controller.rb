class FacilitiesController < ApplicationController
  layout false, only: [:table,:edit,:edit_table]
  def index
    if params[:search]
      render "search", layout: false
    end
  end

  def create
    verify = params[:verify] || false
    limit = params[:limit] || false

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
      if params[:more]=='admin' && facility.users.find_by(portal_id: params[:content]).nil?
        user = User.find_or_create_by(portal_id: params[:content])
        facility.users << user
      elsif params[:more]=='member' && facility.allow_users.find_by(portal_id: params[:content])
        user = User.find_or_create_by(portal_id: params[:content])
        facility.allow_users << user
      elsif params[:more]=='description'
        facility.update(description: params[:content])
        redirect_to '/facilities/'+params[:id]+'/edit/more', notice: 'description changed'
      else
        redirect_to '/facilities/'+params[:id]+'/edit/more', notice: 'Error'
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

  def search
  end

  def edit_table
  end
end
