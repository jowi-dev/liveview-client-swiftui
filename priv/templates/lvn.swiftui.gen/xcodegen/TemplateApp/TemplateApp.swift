//
//  <%= @app_namespace %>.swift
//  <%= @app_namespace %>
//

import SwiftUI

@main
struct <%= @app_namespace %>: App {
    <%= if @notify do %>
        // Delegate for handling push notifications
        @UIApplicationDelegateAdaptor(AppDelegate.self)
    <% end %>
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
