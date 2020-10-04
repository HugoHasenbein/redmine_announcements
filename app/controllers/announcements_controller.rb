# encoding: utf-8
#
# Redmine plugin for displaying announcements in the user interface
#
# originally publisehd by Sandeep Kumar / sandeepleo11
# migrated to Redmine 4.1 and enhanced by Stephan Wenzel
#
# Copyright © 2020 Stephan Wenzel <stephan.wenzel@drwpatent.de>
#                  as far as not originally created by Sandeep Kumar
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

class AnnouncementsController < ApplicationController
  unloadable
  
  ########################################################################################
  #
  # helpers
  #
  ########################################################################################
  helper :announcement_routes
  include AnnouncementRoutesHelper
  
  ########################################################################################
  #
  # callbacks
  #
  ########################################################################################
  before_action :find_optional_project,              :except => [:hide] #does authorization check
  before_action :find_visible_announcement,          :only   => [:show]
  before_action :find_launchable_announcement,       :only   => [:launch]
  before_action :find_editable_announcement,         :only   => [:edit, :update]
  before_action :find_deletable_announcement,        :only   => [:destroy]
  before_action :set_timezone,                       :only   => [:new, :launch, :edit]
  
  ########################################################################################
  #
  # standard controller functions
  #
  ########################################################################################
  def index
    @announcements = Announcement.editable.where(:project => @project)
  end #def
  
  def show
  end #def
  
  def new
    @announcement = Announcement.new(:starts_at => Time.now, :ends_at => Time.now + 60.minutes)
  end #def
  
  def create
    @announcement = Announcement.new(announcement_params)
    if @announcement.save
      redirect_to _project_announcements_path(@project), :notice => l(:label_announcement_created)
    else
      flash[:error] = l(:label_announcement_not_created)
      render :action => "new"
    end
  end #def
  
  def edit
  end #def
  
  def update
    if @announcement.update_attributes(announcement_params)
      redirect_to _project_announcements_path(@project), :notice => l(:label_announcement_updated)
    else
      flash[:error] = l(:label_announcement_not_updated)
      render :action => "edit"
    end
  end #def
  
  def destroy
    @announcement.destroy
    redirect_to _project_announcements_path(@project)
  end #def
  
  ########################################################################################
  #
  # announcement specific functions
  #
  ########################################################################################
  def launch
    @announcement.update_attributes(:starts_at => Time.now, :ends_at => Time.now.end_of_day)
    redirect_to :back
  end #def 
  
  def hide
    session[:announcement_hide_time] = Time.now if User.current.logged?
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end #def
  
  def preview
    @announcement = Announcement.new(announcement_params)
    if Redmine::VERSION::MAJOR < 4
      @message = params.dig(:announcement, :message)
      render :layout => false
    else
      @previewed = @announcement
      @text = params.dig(:text)
      render :partial => 'preview'
    end
  end #def
  
  ########################################################################################
  #
  # private
  #
  ########################################################################################
  private
  
  def find_visible_announcement
    @announcement  = Announcement.visible.where(:id => params[:id]).first
    raise ActiveRecord::RecordNotFound unless @announcement
  rescue ActiveRecord::RecordNotFound
    render_404
  end #def
  
  def find_launchable_announcement
    @announcement  = Announcement.launchable.where(:id => params[:id]).first
    raise ActiveRecord::RecordNotFound unless @announcement
  rescue ActiveRecord::RecordNotFound
    render_404
  end #def
  
  def find_editable_announcement
    @announcement  = Announcement.editable.where(:id => params[:id]).first
    raise ActiveRecord::RecordNotFound unless @announcement
  rescue ActiveRecord::RecordNotFound
    render_404
  end #def
  
  def find_deletable_announcement
    @announcement  = Announcement.deletable.where(:id => params[:id]).first
    raise ActiveRecord::RecordNotFound unless @announcement
  rescue ActiveRecord::RecordNotFound
    render_404
  end #def
  
  def find_optional_visible_announcement
    @announcement  = Announcement.visible.where(:id => params[:id]).first
  end #def
  
  def find_optional_project
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    allowed = User.current.allowed_to?({:controller => :announcements, :action => params[:action]}, @project, :global => false)
    allowed || User.current.admin? ? true : deny_access
  rescue ActiveRecord::RecordNotFound
    render_404
  end #def
  
  def set_timezone
    Time.zone = User.current.time_zone
  end #def
  
  def announcement_params
    params[:announcement] = params[:announcement].merge(:project_id => @project&.id, :author_id => User.current.id)
    params.require(:announcement).permit(:name, :message, :kind, :public, :starts_at, :ends_at, :project_id, :author_id) 
  end #def
end

