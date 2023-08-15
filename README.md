# TurboFlash

Automagically include your flash messages in your Ruby on Rails [TurboStream](https://github.com/hotwired/turbo-rails) responses.

![Video demo](https://i.imgur.com/pVqX9ZV.gif)

## Usage

By default, TurboFlash will inherit all flashes that you normally set. This can be turned off with the `inherit_flashes`
configuration flag.

To explicitly set flashes, TurboFlash exposes a `flash.turbo` method that's similar to `flash`:

```ruby
class UsersController < ApplicationController
  def update
    @user = current_user
    unless @user.valid_password?(user_params[:current_password])
      @user.errors.add(:current_password, "is invalid.")
      return respond_to do |f|
        f.html do 
          flash.now[:notice] = "There was an error."
          render :show
        end
        f.turbo_stream do
          flash.turbo[:notice] = "There was an error."
          render turbo_stream: turbo_stream.replace(@user, partial: 'form')
        end 
      end
    end
    
    # ... 
  end
  
  private 
  
  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
```

Of course, the response will be what you expect:

```ruby
turbo_stream.replace(@user, partial: 'form')
```

TurboFlash will also automatically inject the following into your Turbo response:

```ruby
turbo_stream.update("flash", partial: "shared/flash", locals: { role: :notice, message: "There was an error." })
```

If you want to get more granular, use `flash.turbo#set_options`:

```ruby 
flash.turbo.set_options(action: :append)[:notice] = "This will be appended."
```

You could even:

```ruby 
flash.turbo.set_options(action: :append, partial: "layouts/_cool_awesome_flash")[:error] = "This will be appended from the partial cool_awesome_flash with an error role."
```

The defaults are customizable and shown below.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'turbo_flash'
```

And then execute:
```bash
$ bundle
```

Create a partial of `shared/_flash.html.erb`:

```erb 
<div class="flash flash-<%= local_assigns[:role] %>">
  <%= local_assigns[:message] %>
</div>
```

Ensure that the TurboStream target — a tag with an `id` of `flash` exists in your layout:

```erb
<!DOCTYPE html>
<html>
  <head>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag 'application', media: 'all', data: { turbo_track: :reload } %>
    <%= javascript_pack_tag 'application', data: { turbo_track: :reload } %>
  </head>

  <body>
    <div id="flash">
      <% flash.each do |role, message| %>
        <%= render(partial: 'shared/flash', locals: { role: role, message: message }) %>
      <% end %>
    </div>
    
    <%= yield %>
  </body>
</html>
```

## Turbo frames (instead of *.turbo_stream.erb)

When using Turbo Frames, while the controller response will be injected with the relevant turbo_stream tags, Turbo will
only render the matching Turbo Frame content, and ignore the turbo_streams. To get around this, you can utilize the
turbo layout `turbo_rails/frame.html.erb` and use `turbo_stream_from` to send the updates back to the browser. For example:

```erb
# app/views/layouts/turbo_rails/frame.html.erb
<html>
  <head>
    <%= yield :head %>
  </head>
  <body>
    
    <% flash.turbo.flashes.each do |role, message| %>
      <%= Turbo::StreamsChannel.broadcast_prepend_to current_user, :alerts, target: "alerts",
      partial: 'shared/flash', locals: { role:, message: } %> <%# customize this based on your project %>
    <% end %>
    
    <%= yield %>
  </body>
</html>
```

## Configuration

In an initializer (defaults are shown):

```
TurboFlash.configure do |config|
  # make all flashes TurboFlash-flashes
  # config.inherit_flashes = true 
  
  # clear the TurboFlash target if there are no flashes in a TurboStream response
  # config.clear_target_unless_flashed = true 
  
  # the default TurboStream target element ID
  # config.target = "flash"
  
  # the default TurboStream action
  # config.action = :update 
  
  # the default TurboStream partial
  # config.partial = 'shared/flash'
  
  # the default flash key variable name
  # config.key = :role 
  
  # the default flash message variable name
  # config.value = :message 
end
```

## Gotchas

If `TurboFlash.configuration.inherit_flashes` is `false`, and you want to copy over the regular flashes,
you can invoke `flash.turbo!(options = {})` to copy over the flashes that are currently stored in the session.

If `TurboFlash.configuration.clear_target_unless_flashed` is `false`, and you would like to clear flashes in the TurboStream
response, you can invoke `flash.turbo.clear_target!` to clear the TurboStream target if there are no flashes.

If you want to clear all potential TurboFlashes, call `flash.turbo.clear!`

## Contributing

There wasn't much thought put into this, but it works for me, so it might work for you!

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
