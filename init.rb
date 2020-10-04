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

require 'redmine'

Redmine::Plugin.register :redmine_announcements do
  name 'RedmineAnnouncements'
  author 'Stephan Wenzel, originally: Sandeep Kumar / sandeepleo11'
  description 'Site wide announcements plugin for Redmine'
  version '2.0.0'
  
#-----------------------------------------------------------------------------------------
# Permissions
#-----------------------------------------------------------------------------------------
  project_module :announcements do
    permission :view_announcements,   :announcements => [:index, :show, :hide], :previews => [:announcement]
    permission :launch_announcements, :announcements => [:index, :show, :hide, :launch]
    permission :edit_announcements,   :announcements => [:index, :show, :hide, :launch, :new, :create, :edit, :update], :previews => [:announcement]
    permission :delete_announcements, :announcements => [:destroy]
  end
  
#-----------------------------------------------------------------------------------------
# Menus
#-----------------------------------------------------------------------------------------
  menu :application_menu, 
       :announcements, {:controller => 'announcements', :action => 'index' },
       :caption    => :label_announcements, 
       :before     => :settings, 
       :if         => Proc.new{ User.current.admin? }
       
  menu :project_menu, 
       :announcements, {:controller => 'announcements', :action => 'index' },
       :caption    => :label_announcements, 
       :before     => :settings, 
       :param      => :project_id,
       :permission => :edit_announcements
       
#-----------------------------------------------------------------------------------------
# Project: '+' Menu 
#-----------------------------------------------------------------------------------------
  menu :project_menu, 
       :announcements, {:controller => 'announcements', :action => 'new' },
       :caption    => :label_new_announcement, 
       :param      => :project_id,
       :parent     => :new_object,
       :permission => :edit_announcements,
       :children   => Proc.new{|project|
         announcements = Announcement.launchable.where(:project => project)
         announcements.map{|announcement|
           Redmine::MenuManager::MenuItem.new(
             "announcement-#{announcement.name}", 
             {:controller => 'announcements', :action => 'launch', :project_id => project.identifier, :id => announcement.id },
             :caption     => " &middot; #{CGI::escapeHTML(announcement.name)}".html_safe,
             :permission  => :launch_announcements
           )
         }
       }
end

#---------------------------------------------------------------------------------------
# Plugin Library
#---------------------------------------------------------------------------------------
require 'redmine_announcements'

