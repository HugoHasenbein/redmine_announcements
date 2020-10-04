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

if Redmine::VERSION::MAJOR >= 4

  class CreateAnnouncements < ActiveRecord::Migration[5.1]
  
    def self.up
      create_table :announcements do |t|
        t.column :project_id,               :integer
        t.column :author_id,                :integer
        t.column :name,                     :string
        t.column :message,                  :text
        t.column :kind,                     :integer
        t.column :public,                   :boolean
        t.column :starts_at,                :datetime
        t.column :ends_at,                  :datetime
        t.column :created_on,               :timestamp
        t.column :updated_on,               :timestamp
      end
    end
    
    def self.down
      drop_table :announcements
    end
    
  end #class

else
  class CreateAnnouncements < ActiveRecord::Migration
  
    def self.up
      create_table :announcements do |t|
        t.column :project_id,               :integer
        t.column :author_id,                :integer
        t.column :name,                     :string
        t.column :message,                  :text
        t.column :kind,                     :integer
        t.column :public,                   :boolean
        t.column :starts_at,                :datetime
        t.column :ends_at,                  :datetime
        t.column :created_on,               :timestamp
        t.column :updated_on,               :timestamp
      end
    end
    
    def self.down
      drop_table :announcements
    end
  end #class
  
end

