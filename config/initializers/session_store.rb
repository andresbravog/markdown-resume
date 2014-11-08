# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store,
                                       key: ENV['COOKIE_SESSION_KEY'] || '_please_change_this_key_'
