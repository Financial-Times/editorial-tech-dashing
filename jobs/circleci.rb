require 'httparty'
require 'digest/md5'

projects = [
    { user: 'Financial-Times', repo: 'Lantern', branch: 'master' }
]

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s'  do
    items = update_builds(projects[0], ENV['CIRCLE_CI_AUTH_TOKEN'])
    send_event('CIRCLE_CI_BUILDS', { items: items, time: Time.now.strftime("%H:%M") })
end