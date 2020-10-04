# redmine_announcements

Plugin for Redmine. Adds arbitrary site announcements to redmine. 

![PNG that represents a quick overview](/doc/Overview.png)

*Root announcements* are displayed on every project or even on the login screen if chosen to do so. 

*Project announcements* are only shown within the project and also to its child projects, if child projects have activated announcements. 

All announcements can have four different styles "Notice", "Warning", "Error" and "blank". 

Announcements can be styled in textile or in mark down.

Original work by Sandeep Kumar https://github.com/buoyant/redmine_announcements

This version is completely recoded and has left being a fork. 

### Use case(s)

Warn users about upcoming server maintenace. Remind users to do certain tasks. Tell everybody working on the project about upcoming events. Users may acknowledge announcement to make it disappear.

### Install

1. download plugin and copy plugin folder redmine_announcements go to Redmine's plugins folder

2. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_announcements`

3. restart server f.i.  

`sudo /etc/init.d/apache2 restart`

### Uninstall

1. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_announcements VERSION=0`

2. go to plugins folder, delete plugin folder redmine_attachment_categories

`rm -r redmine_announcements`

3. restart server f.i.  

`sudo /etc/init.d/apache2 restart`

### Use

Activate plugin in projects configuration page under "Modules". 

Assign rights and permissions under "Administration" -> "Rights and Permissions"

#### 1. Option 1: you are an adminstrator / you have administrator rights

Go to "Projects" page and click on "Announcements" in the application menu. 

Click "New Announcement". 

Fill announcement with text, textile or markdown (whichever you have chosen to be your markup language in Redmine's configuration).

![PNG that represents a quick overview](/doc/Edit_root_announcement.png)

Choose "Public" if you want your announcement to be seen even on the login screen

Choose "Kind" to choose style of your choice. 

Click preview

Save

You will notice the ubiquitous root (admin) announcement


#### 2. Option 2: you are a user having assigned appropriate rights under "Administration" -> "Rights and Permissions"

Go to "Projects", choose your project and in the project menu page and click on "Announcements". 

Click "New Announcement". 

Fill announcement with text, textile or markdown (whichever you have chosen to be your markup language in Redmine's configuration).

![PNG that represents a quick overview](/doc/Edit_project_announcement.png)

You cannot choose "Public" - only administrators can do so.

Choose "Kind" to choose style of your choice. 

Click preview

Save

You will notice the project announcement, which can also be seen in this project's child projects, if child projects have an activated "Announcements"-module.


#### 3. You are any user, but an anonymous user

You see one or more announcements: Click "Dismiss Announcements" and all announcements are gone.


#### 4. You are an anonymous user 

Just note the (admin or root) Announcement 

#### 5. Special Feature

All saved project announcements can be launched from the "+" menu in the project menu, if user has appropriate rights assigned under "Administration" -> "Rights and Permissions".

Choose "+" and the name of the announcement - and the announcement is activated for the rest of the day.

![PNG that represents a quick overview](/doc/Launch_project_announcement.png)

*Use Case:* emergencies, frequent announcements

*Notice:* root announcements cannot be launched from the "+" menu". Top launch a root announcement, just go to the root announcement editor and set appropriate start and end date. This will activate the root announcement in the correspopnding time interval. Project announcemenmt can also be activate by setting the time interval.

**Have fun!**

### Localisations

* English
* German
* French

### Change-Log* 

**2.0.0** Running on Redmine 3.4.x and 4.x




