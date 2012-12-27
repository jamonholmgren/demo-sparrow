# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'rubygems'
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'demo-sparrow'
  
  app.frameworks += %w(AudioToolbox CFNetwork SystemConfiguration MobileCoreServices Security QuartzCore StoreKit)
  
  app.info_plist['UIStatusBarHidden'] = true
  
  app.pods do
    pod "Sparrow-Framework"
  end
end
