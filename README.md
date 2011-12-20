= Kanbanery in the Campfire!

This rails app aims to bridge between [kanbanery](http://kanbanery.com)
and [campfire](http://campfirenow.com). It provides an endpoint that
kanbanery can use for event notifications, which are then posted to
a campfire room.

== Running the app on heroku.

    git clone git://github.com/spraints/kanbfire.git
    cd kanbfire
    bundle
    # Open app/controllers/application_controller.rb and
    # update the rules in `#sign_in_from_omniauth` and
    # `signed_in?` to match your rules about who can use
    # the app.
    heroku create --stack cedar
    git push heroku master
    heroku run rake db:schema:load

The authorization code is likely to change.

I'll try to keep upgrading easy:

    git pull
    git push heroku master
    heroku run rake db:migrate

== Setting up the integration

For this, you'll need some information from campfire:

* Your campfire subdomain
* A room in your campfire
* Your campfire API token

Open your heroku app. Log in. (Right now, you have
to log in with a google account. This may change in
the future.)

Click "+ Add". Fill in the information you got from campfire.
Click "Create Project mapping". Right-click on the 
"Live Subscription" and copy the link.

Log into kanbanery and go to the settings for your project.
Go to the "URL Live Update" section, click "Add new", and
paste the url you copied. Click "Add", then click "Active".

= Notes

There are better ways to do a lot of this, e.g. using
the auth token that kanbanery provides, and making the
whole thing look nicer.

This was what I dashed off, trying to get something
in place.
