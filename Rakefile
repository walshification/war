require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

task :war do
  sh %{ruby ./lib/game.rb}
end

task :love_not_war do
  puts "<3 EVERYONE'S A WINNER! <3"
end
