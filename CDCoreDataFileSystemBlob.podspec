Pod::Spec.new do |s|

  s.name         = "CDCoreDataFileSystemBlob"
  s.version      = "0.0.1"
  s.summary      = "Associate data (blob) to NSManagedObjects and store it to file system instead of the database."
  s.description  = "Associate data (blob) to NSManagedObjects and store it to file system instead of the database."

  s.homepage     = "https://github.com/ChristianDeckert/CDCoreDataFileSystemBlob"
  s.license      = "MIT"

  s.author             = { "Christian Deckert" => "christian.deckert@icloud.com" }

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.7"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"


  s.source       = { :git => "https://github.com/ChristianDeckert/CDCoreDataFileSystemBlob.git", :tag => "#{s.version}" }

  s.default_subspec = 'Default'

  s.subspec 'Default' do |ss|
    ss.source_files = "Source/**/*.{swift}"
  end

end
