class FacilitiesController < ApplicationController
  layout false, only: [:table,:edit,:edit_table, :appform]
  def index
    if params[:search]
      render "search", layout: false
    end
  end

  def create
    verify = params[:verify] || false
    limit = params[:limit] || false
    if(current_user != "F143610" && current_user != "A375754" && current_user != "105502047")
      redirect_to '/facilities', notice: 'forbidden'
      return
    elsif
      facility = User.find_by(portal_id: current_user).facilities.create(name: params[:name], description: params[:description], membership: limit, verify: verify, board: params[:board])
      facility.allow_users.create(portal_id: current_user)
      redirect_to '/facilities'
    end
  end

  def new
  end

  def edit
    not_found if Facility.find_by(id: params[:id]).nil?
  end

  def show
    not_found if Facility.find_by(id: params[:id]).nil?
    if current_user.nil?
#      redirect_to '/facilities', notice: 'unlogin'
    else
      if (facility = Facility.find_by(id: params[:id])).membership
        redirect_to '/facilities', notice: 'limit' if facility.allow_users.find_by(portal_id: current_user).nil?
      end
    end
  end

  def update
    not_found if Facility.find_by(id: params[:id]).nil?
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
    not_found if Facility.find_by(id: params[:id]).nil?
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
    not_found if Facility.find_by(id: params[:id]).nil?
    owner = (facility=Facility.find_by(id: params[:id])).users.find_by(portal_id: current_user)
    if(owner.present? && params[:content].present?)
      if params[:more]=='admin'
        the_user = facility.users.find_by(portal_id: params[:content])
	return if the_user.portal_id == current_user
        the_user.destroy if the_user.present?
      elsif params[:more]=='member'
        the_member = facility.allow_users.find_by(portal_id: params[:content])
	return if the_member.portal_id == current_user
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
    not_found if Facility.find_by(id: params[:id]).nil?
    rents = Facility.find_by(id: params[:id]).rents.where(saw: false)
    rents.update(saw: true) if rents.present?
  end
  def instruction
  end

  def mail_verify
    info = Mailverify.find_by(portal_id: current_user)
    if info.present?
      if params[:token] == info.token
        User.find_by(portal_id: current_user).update(mail: info.mail)
        redirect_to '/facilities', notice: 'mail_success'
      else
        redirect_to '/facilities', notice: 'verify_failed_token'
      end
    else
      redirect_to '/facilities', notice: 'verify_failed_login'
    end
  end

  def mail_verify_request
    mail = NotifyMailer.mail_verify(params[:mail], current_user)
    mail.deliver_now! if mail.present?
  end

  def notify_switch
    user = User.find_by(portal_id: current_user)
    if user.mail.present?
      user.notify = !user.notify
      user.save!
    end
  end
  def tel_set
    user = User.find_by(portal_id: current_user)
    if user.present?
      user.update(tel: params[:tel])
    end
  end

  def appform
  end

end
