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

class Announcement < ActiveRecord::Base
  unloadable
  
  ########################################################################################
  #
  # includes
  #
  ########################################################################################
  include Redmine::SafeAttributes
 # include ActiveRecord::AttributeAssignment
 # include ActiveModel::Model
  
  
  ########################################################################################
  #
  # associations
  #
  ########################################################################################
  belongs_to :project
  belongs_to :author, :class_name => 'User'
  
  ########################################################################################
  #
  # constants
  #
  ########################################################################################
  STYLES = {1 => :notice, 2 => :warning, 3 => :error}
  
  ########################################################################################
  #
  # attributes
  #
  ########################################################################################
  safe_attributes 'name',
                  'message',
                  'kind',
                  'starts_at',
                  'ends_at',
                  'project_id'
                  
  safe_attributes 'public',
                  :if => User.current.admin?
                  
  if Redmine::VERSION::MAJOR < 4
    attr_accessible :name, :message, :kind, :starts_at, :ends_at, :public, :project_id, :author_id
  end
  
  ########################################################################################
  #
  # callbacks
  #
  ########################################################################################
  validates_presence_of   :message, :message => l(:label_cannot_be_blank)
  validates_presence_of   :name,    :message => l(:label_cannot_be_blank)
  validates_uniqueness_of :name,    :message => l(:label_cannot_be_blank),  :scope => :project_id
  
  ########################################################################################
  #
  # scopes
  #
  ########################################################################################
  scope :left_join_projects, -> { 
    joins("LEFT OUTER JOIN projects on projects.id = announcements.project_id")
  }
  scope :visible, lambda {|*args| 
    left_join_projects.
    where(Project.allowed_to_condition(args.shift || User.current, :view_announcements, *args) + " OR (project_id IS NULL)" )
  }
  scope :launchable, lambda {|*args| 
    joins(:project).
    where(Project.allowed_to_condition(args.shift || User.current, :launch_announcements, *args) )
  }
  scope :editable, lambda {|*args| 
    if (args.shift || User.current).admin?
      left_join_projects.
      where(Project.allowed_to_condition(args.shift || User.current, :edit_announcements, *args) + " OR (project_id IS NULL)" )
    else
      joins(:project).
      where(Project.allowed_to_condition(args.shift || User.current, :edit_announcements, *args) )
    end
  }
  scope :deletable, lambda {|*args|
    if (args.shift || User.current).admin?
      left_join_projects.
      where(Project.allowed_to_condition(args.shift || User.current, :delete_announcements, *args) + " OR (project_id IS NULL)" )
    else
      joins(:project).
      where(Project.allowed_to_condition(args.shift || User.current, :delete_announcements, *args) )
    end
  }
  scope :global, lambda {|*args|
    where(:project_id => nil)
  }
  
  ########################################################################################
  #
  # class functions
  #
  ########################################################################################
  def self.current_announcements(hide_time, project)
    # current
    scope = visible.where( "#{table_name}.starts_at <= now() AND #{table_name}.ends_at >= now()")
    # reactivated
    scope = scope.where(   "#{table_name}.updated_on > ? OR #{table_name}.starts_at > ?", hide_time, hide_time) if hide_time
    # project, ancestors (parent projects) and global
    if project
    scope = scope.where(:project_id => [project && project.self_and_ancestors.map(&:id), nil].flatten.uniq)
    scope = scope.where("(#{Project.allowed_to_condition(User.current, :view_announcements)}) OR (project_id IS NULL)" )
    else
    scope = scope.where(:project_id => nil)
    end
    # anonymous users
    scope = scope.where("public = #{connection.quoted_true}") if User.current.anonymous?
    # return scope
    scope
  end #def
  
  def self.kinds_for_select
    STYLES.map do |k,v|
      [l("label_#{v}".to_sym), k]
    end + [["", ""]]
  end #def
  
  ########################################################################################
  #
  # permission functions
  #
  ########################################################################################
  def visible?(usr=nil)
    (usr || User.current).allowed_to?( :view_announcements,   self.project)
  end #def
  
  def global?(usr=nil)
    !project_id
  end #def
  
  def launchable?(usr=nil)
    (usr || User.current).allowed_to?( :launch_announcements, self.project)
  end #def
  
  def editable?(usr=nil)
   (usr || User.current).allowed_to?( :edit_announcements,    self.project)
  end #def
  
  def deletable?(usr=nil)
    (usr || User.current).allowed_to?( :delete_announcements, self.project)
  end #def
  
  ########################################################################################
  #
  # view functions
  #
  ########################################################################################
  def css_classes(options={})
    css = [] 
    css << "flash #{STYLES[kind]}"
    css.join(" ")
  end #def
  
end #class

