Pod::Spec.new do |s|
  s.name = 'SocialInvite'
  s.version = '0.1.0'
  s.summary = 'iOS library which enables you to use the Infobip Social Invites service.'
  s.license = 'MIT'
  s.authors = {"Infobip - Framework Integration Team"=>"social.invites@infobip.com"}
  s.homepage = 'http://socialinvite.infobip.com/'
  s.description = '                       This project is an iOS library which can be merged with your iOS project and enables you to use the Infobip Social Invites service.

                       Social invites allow a user that is already satisfied with the product to refer it to their own network via a text message.

                       A mobile phone address book is stocked with contacts with whom the user has developed a personal relationship.
'
  s.frameworks = ["MobileCoreServices", "SystemConfiguration", "CoreData", "CoreTelephony", "AddressBook", "UIKit", "QuartzCore", "CoreGraphics"]
  s.requires_arc = true
  s.source = {}

  s.platform = :ios, '7.0'
  s.ios.platform             = :ios, '7.0'
  s.ios.preserve_paths       = 'ios/SocialInvite.framework'
  s.ios.public_header_files  = 'ios/SocialInvite.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'ios/SocialInvite.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'ios/SocialInvite.framework'
end
