# guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
#   watch('config/application.rb')
#   watch('config/environment.rb')
#   watch(%r{^config/environments/.+\.rb$})
#   watch(%r{^config/initializers/.+\.rb$})
#   watch('spec/spec_helper.rb')
# end

guard 'rspec', :cli => "--color", :version => 2, :all_after_pass => false, :all_on_start => false do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }

  # Rails example
  watch('spec/spec_helper.rb')                       { "spec" }
  watch('config/routes.rb')                          { "spec/routing" }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/sieve-parser/(.+)\.rb})                           { |m| "spec/sieve-parser/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
  watch(%r{^app/views/(.+)/})                        { |m| "spec/requests/#{m[1]}_spec.rb" }
end
