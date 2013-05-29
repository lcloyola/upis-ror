namespace :db do
  task :add_transcript_settings => :environment do
    Setting.transcript = {:headera  => 'secondary school record',
                          :headerb  => 'form 137',
                          :elevenpt => true,
                          :raw      => true,
                          :copyfor  => "UP Admissions",
                          :syperpage=> 3,
                          :height		=> 850
                          }
  end
end

