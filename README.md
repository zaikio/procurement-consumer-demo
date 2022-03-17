# Zaikio Procurement API demo

A simple web application built on top of the Procurement API, to demonstrate connecting
suppliers, browsing products, and ordering them.

**[Live demo](https://zai-procurement-consumer-demo.fly.dev)** | **[API guides](https://docs.zaikio.com)**

## Overview

This application is a simple Rails application without any local state. Most of the
business logic can be found in `app/controllers` (which broadly map to the Procurement
`api/v2` endpoints).

Authentication here is handled using a library called [omniauth], which
is a Ruby gem for easily setting up OAuth2 clients; our configuration can be found in
`config/initializers/omniauth_oauth.rb`. The OAuth2 response includes a JWT token which
expires after an hour, and the whole token is stored in an encrypted cookie using Rails
sessions.

> Omniauth was chosen for demo purposes, but Zaikio also offer a [more fully-featured
> OAuth gem][zaikio-oauth-client] which stores tokens in the database, and also supports
> multiple clients, person/organization tokens, automatic token refreshing and complex
> redirect rules.

To communicate with the Procurement API, this uses a gem called [faraday] for making HTTP
requests.

The client pages use a framework called [hotwire] and the [turbo-rails]. This allows the
client to refresh parts of the page with server-rendered responses - this is how we do the
inline variant browser, for example.

## Installation & running locally

First, you'll need a [Zaikio App][create-app] to authenticate with. In addition to the
default configuration, you'll need to set the `Desired OAuth Scopes` like so:

```
directory.organization.r
procurement_consumer.article_base.r
procurement_consumer.contracts.rw
procurement_consumer.orders.rw
procurement_consumer.material_requirements.rw
```

To run the app locally, we'll also need to add this OAuth redirect URL:

```
http://localhost:3000/auth/zaikio/callback
```

Next, we'll setup a Ruby environment. This application is built using
[Ruby on Rails](https://rubyonrails.org). There are full instructions for setting up Ruby
& the library on the [guides.rubyonrails.org site][install].

Then:

  1. Clone this repository to your computer
  2. Run `bundle install` to fetch all of the dependencies. You will also need to install
     NodeJS & yarn, then run `yarn install` to fetch the CSS & JS assets
  3. Find your Zaikio client ID & secret in the sandbox Hub
     ([documentation][client-credentials]) then set them as environment variables like so:
     `ZAIKIO_CLIENT_ID=...` and `ZAIKIO_CLIENT_SECRET=...`
  4. Run the `bin/dev` command to start a Rails server, then visit `http://localhost:3000`.

## Contributing & license

This code is released under the MIT license. Features, bugfixes and documentation pull
requests & issues are all gratefully received.

[client-credentials]: https://docs.zaikio.com/getting-started/sso-person.html#_2-1-get-client-credentials-for-your-app
[create-app]: https://docs.zaikio.com/getting-started/create-app.html
[faraday]: https://lostisland.github.io/faraday/
[hotwire]: https://hotwired.dev/
[install]: https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails
[omniauth]: https://github.com/omniauth/omniauth
[turbo-rails]: https://github.com/hotwired/turbo-rails/
[zaikio-oauth-client]: https://github.com/zaikio/zaikio-oauth_client/
