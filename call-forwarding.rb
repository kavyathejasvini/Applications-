Applications-
=============

Call forwarding Application for a new Plivo user
#!/usr/bin/ruby1.9.1
require 'rubygems'
require 'plivo'
require 'sinatra'
include Plivo

set :bind, '0.0.0.0'

AUTH_ID = " "
AUTH_TOKEN = " "


get '/ivr' do
    
    #This will get the account details of the user
    p = Plivo.RESTAPI(AUTH_ID, AUTH_TOKEN)
    response = p.get_account()

    WELCOME_MESSAGE = "Welcome to IVR Menu. Press 1 to call User1. Press 2 to call User2 "
    NO_INPUT_MESSAGE = "No Input received."
    play_loop = 1
    lang = "en-US"
    voice = "WOMAN"
    digit_params = {
                  'action' => 'http://www.example.com/gather/',
                  'method' => 'POST',
                  'timeout' => '7',
                  'numDigits' => '1',
                  'playBeep' => 'true'
                 }
    speak_params = {
                  'loop' => play_loop,
                  'language' => lang,
                  'voice' => voice,
                  }
    get_digits = Plivo::GetDigits.new(digit_params)
    speak = Plivo::Speak.new(WELCOME_MESSAGE, speak_params)
    get_digits.add(speak)
    response = Plivo::Response.new()
    response.add(speak)
    speak_end = Plivo::Speak.new(NO_INPUT_MESSAGE, speak_params)
    response.add(speak_end)
    return response.to_xml
end


post '/ivr' do
    
    user1 = 'XXXXXXXXXX1'
    user2 = 'XXXXXXXXXX2'

    digits = params[:Digits]
    
    #call will forwarded to user1
   if digits == '1'
  
        play_loop = 1
  	    lang = "en-US"
  	    voice = "WOMAN"
  	    text = "Dialling User1"

  	    speak_params = {
  	                'loop' => play_loop,
  	                'language' => lang,
  	                'voice' => voice,
  	                   }
	      speak = Plivo::Speak.new(text, speak_params) 
   	      num_add = Plivo::Number.new(user1)
              dial = Plivo::Dial.new()
              dial.add(num_add)
              response = Plivo::Response.new()
	      response.add(speak)
              response.add(dial)
	      return response.to_xml
    
   #call will be forwarded to user2
   elsif digits == '2'
	      play_loop = 1
        lang = "en-US"
        voice = "WOMAN"
        text = "Dialling User2"

        speak_params = {
                        'loop' => play_loop,
                        'language' => lang,
                        'voice' => voice,
                        }
        speak = Plivo::Speak.new(text, speak_params)
        num_add = Plivo::Number.new(user2)
        dial = Plivo::Dial.new()
        dial.add(num_add)
        response = Plivo::Response.new()
        response.add(speak)
        response.add(dial)
        return response.to_xml

  # So if the user exceeds 7 seconds, he will be directed to the voicemail service
  elsif timeout > '7':   
        play_loop=1
        lang = "en_US"
        voice = "WOMAN"
        voicemail_message = "You are directed to the voicemail  service"
  
        speak_params = {
                        'loop' => play_loop,
                        'language' => lang,
                        'voice' => voice,
                        }
        speak = Plivo::Speak.new(voicemail_message, speak_params)
        
        response = Plivo::Response.new()
        response.add(speak)
        return response.to_xml


  else
	text = "Invalid Option Selected, Please Hangup and try again"
	play_loop = 1
        lang = "en-US"
        voice = "WOMAN"

        speak_params = {
                        'loop' => play_loop,
                        'language' => lang,
                        'voice' => voice,
                        }
        speak = Plivo::Speak.new(text, speak_params)
	      response = Plivo::Response.new()
        response.add(speak)
	      return response.to_xml	
  end
end
