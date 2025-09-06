package com.example.frontend

import android.app.Application
import java.io.InputStream
import java.util.Properties

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Set AppAuth properties immediately
        System.setProperty("net.openid.appauth.allow_http", "true")
        System.setProperty("net.openid.appauth.allow_insecure_connections", "true")
        System.setProperty("net.openid.appauth.allow_http_for_redirect_uris", "true")
        System.setProperty("net.openid.appauth.allow_http_for_token_endpoint", "true")
        
        // Load additional AppAuth properties from assets
        try {
            val inputStream: InputStream = assets.open("app_auth.properties")
            val properties = Properties()
            properties.load(inputStream)
            
            // Set system properties from loaded properties
            properties.forEach { (key, value) ->
                System.setProperty(key.toString(), value.toString())
            }
            
            inputStream.close()
        } catch (e: Exception) {
            // Properties file not found, continue with hardcoded values
        }
        
        // Set security manager to allow HTTP connections
        try {
            System.setSecurityManager(null)
        } catch (e: Exception) {
            // Ignore if setting fails
        }
    }
}
