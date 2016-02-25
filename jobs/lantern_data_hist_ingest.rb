require 'httparty'
require 'json'

lastValue = 0

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|
    url = ENV['LANTERN_URL'] + '/status'

    response =  HTTParty.get(url, :headers => { "Accept" => "application/json" } )
    json_response = JSON.parse(response.body)
    historical = json_response['historical']

    activePollers = json_response['activePollers']

    date = DateTime.strptime(historical['latestEvent'], "%Y-%m-%d")
    formattedDate = date.strftime("%d-%m-%Y")

    send_event('LANTERN_DATA_HIST_INGEST', { metric: formattedDate, type: 'historical' })
    send_event('LANTERN_DATA_POLLERS', { current: activePollers, last: lastValue })

    lastValue = activePollers
end
