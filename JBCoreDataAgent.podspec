Pod::Spec.new do |s|
  s.name         = "JBCoreDataAgent"
  s.version      = "0.0.3"
  s.summary      = "Helps abstract out the core data boilerplate and manage NSFetchRequestControllers"

  s.description  = <<-DESC
                   Trying to make coredata easier for myself. Abstracting things into a file makes it easier to add coredata to any project.

                   * Makes fetching (with or without predicates) easier
                   * Helps manage NSFetchedResultController - Will be adding more functionality for managing and creating these
                   DESC

  s.homepage     = "https://github.com/jbueler/JBCoreDataAgent"
  s.license      = 'MIT'
  s.author       = { "Jeremy Bueler" => "jbueler@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = '5.0'
  s.source       = { :git => "https://github.com/jbueler/JBCoreDataAgent.git", :tag => "0.0.3" }
  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.framework  = 'CoreData'
  s.requires_arc = true
end
