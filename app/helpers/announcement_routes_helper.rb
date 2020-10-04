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

module AnnouncementRoutesHelper

  # Returns the path to project announcement or to the cross-project
  # announcement list if project is nil
  def _project_announcement_path(project, *args)
    if project
      project_announcement_path(project, *args)
    else
      announcement_path(*args)
    end
  end
  
  def _project_announcements_path(project, *args)
    if project
      project_announcements_path(project, *args)
    else
      announcements_path(*args)
    end
  end
  
  def _new_project_announcement_path(project, *args)
    if project
      new_project_announcement_path(project, *args)
    else
      new_announcement_path(*args)
    end
  end
  
  def _edit_project_announcement_path(project, *args)
    if project
      edit_project_announcement_path(project, *args)
    else
      edit_announcement_path(*args)
    end
  end
  
  def _create_or_edit_project_announcement_path(project, announcement, *args)
    if announcement.new_record?
      _project_announcements_path(project)
    else
      _project_announcement_path(project, announcement)
    end
  end
  
  def _show_or_edit_project_announcement_path(project, announcement, *args)
    if announcement.editable?
      _edit_project_announcement_path(project, announcement, *args)
    else
      _project_announcement_path(project, announcement, *args)
    end
  end

  
end
