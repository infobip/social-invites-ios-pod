#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SocialInvite"
  s.version          = "0.1.0"
  s.summary          = "iOS library which enables you to use the Infobip Social Invites service."
  s.description      = <<-DESC
                       This project is an iOS library which can be merged with your iOS project and enables you to use the Infobip Social Invites service.

                       Social invites allow a user that is already satisfied with the product to refer it to their own network via a text message.

                       A mobile phone address book is stocked with contacts with whom the user has developed a personal relationship.
                       DESC
  s.homepage         = "http://socialinvite.infobip.com/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Infobip - Framework Integration Team" => "social.invites@infobip.com" }
  s.source           = { :git => "http://mmilivojevic@git/scm/si/social-invites-ios-pod.git" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.bundle'

  # s.resource_bundles = {
  #   'Resources' => ['Pod/Assets/*.bundle']
  # }

  s.xcconfig = { 'OTHER_LDFLAGS' => '-all_load' }
  s.public_header_files = 'Pod/Classes/InfobipSocialInvite.h'	
  
  s.frameworks = 'MobileCoreServices', 'SystemConfiguration', 'CoreData', 'CoreTelephony'
  s.frameworks = 'AddressBook', 'UIKit', 'QuartzCore', 'CoreGraphics'
  
  s.dependency 'RestKit', '~> 0.24'
  s.dependency 'RHAddressBook', '~> 1.1'
  s.dependency 'libPhoneNumber-iOS', '~> 0.7'

  s.subspec 'Models' do |models|
    models.source_files = 'Pod/Classes/Models/'
  end
end
