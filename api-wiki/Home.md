API Wiki
=================

Server
---

#### Boot

`/var/log/boot.log`

Ensure that:

* Redis
* Unicorn
* NGINX
* Sidekiq
* PostgreSQL

Start on reboot

#### Firewall

Logs:

`/var/log/ufw.log`

#### Restarting

`sudo shutdown`

`sudo reboot`

Do not use `now` keyword

Environment Variables
---

Environment variables are managed by Figaro.  The config/application.yml
file is NOT stored in git. Instead it is transferred to the remote server with
Figaros Capistrano script.

Deployment
---

`bundle exec` is required.

To copy configuration files: `bundle exec cap deploy:setup`

Deploy site: `bundle exec cap deploy`

Services
---

#### NGINX

Config files:
`/etc/nginx/nginx.conf`
`/etc/nginx/sites-available/*`

Check config:
`sudo nginx -t`

Reload configuration:
`sudo nginx -s reload`

Restart:
`sudo nginx -s restart`

Start:
`sudo nginx`

Access logs:
`/usr/share/nginx/logs/api.dogood.mobi.access.log`

#### Unicorn

`/etc/init.d/unicorn_dg-api restart|stop|start|status`

#### Sidekiq

Restarts on deployment are handled by Capistrano.

Starts on server reboot are handled by this upstart script:

`/etc/init/sidekiq-workers.conf`

It references this main upstart script, which doesnt contain run levels:

`/etc/init/sidekiq.conf`

After modifying it (if symlinked) do:

`sudo initctl reload-configuration`

`sudo status sidekiq index=0`

`ps -aux | grep sidekiq`

`bundle exec sidekiqctl`

Debugging:

Logs are in

`/var/log/upstart`

Change log level verbosity:
`sudo initctl log-priority debug`

Back to normal:
`sudo initctl log-priority message`

Sidekiq logs are in:

`/home/mhayman/setup/dg/api/current/log/sidekiq.log`

#### Mandrill

#### New Relic

APNs
----

http://www.raywenderlich.com/32960/

#### Build certificate:

Make sure to specify a passphrase for personal key

    openssl x509 -in aps_production.cer -inform der -out DoGoodProdCert.pem
    openssl pkcs12 -nocerts -out DoGoodKey.pem -in personal.p12
    cat DoGoodProdCert.pem DoGoodKey.pem > apple_push_notification_production.pem

    openssl x509 -in aps_development.cer -inform der -out DoGoodDevCert.pem
    openssl pkcs12 -nocerts -out DoGoodKey.pem -in personal.p12
    cat DoGoodDevCert.pem DoGoodKey.pem > apple_push_notification_development.pem

#### Test certificate:

`openssl s_client -connect gateway.sandbox.push.apple.com:2195 -cert YourSSLCertAndPrivateKey.pem -debug -showcerts -CAfile server-ca-cert.pem`

(server-ca-cert.pem is the root-2048 Entrust Cert & comes with most servers and is included with Mac OS X & Ubuntu)

[Useful APNS Technical Notes](https://developer.apple.com/library/ios/technotes/tn2265/_index.html)
[](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/CommunicatingWIthAPS.html)

Points
---

Action             |Points  |Accrue to
-------------------|-------:|-------
Voting on a post   |      2 |Nominated user
Posting a comment  |      3 |Commenter
Posting a good     |      4 |Poster
Redeeming a reward | - cost |Redeemer

External Services to Document:
---

* DigitalOcean
* Linode
* NewRelic
* Airbrake?/Rollwhatever
* Google Analytics
* Foursquare
* Twitter
* Facebook

Web Site
----

serve locally: `grunt serve`

build to dist: `grunt build`

push dist branch to github: `grunt buildcontrol:prod`

deploy from github: `cap deploy`

tmp
---

https://github.com/mperham/sidekiq/wiki/Error-Handling
https://github.com/mperham/sidekiq/wiki/Deployment

