rbElections
------------------------------------------------------------------------------

A simple web app to pull election data from a database and display it to the
web.  Data is updated by uploading a file exported from the voting machines. 

### Todo

I can check the status of delayed_job with `script/delayed_job status` or I
can check for a pid file in `#{Rails.root}/tmp/pids/`.  I would like to remove
election file upload in the creation view and in the update view check if
delayed_job is running.  If not running, offer to start rather than allow file
uploads.

Start with this:

    system "cd #{Rails.root} && RAILS_ENV=production script/delayed_job start"

You can run script/delayed_job -h to verify this syntax for running in
production.