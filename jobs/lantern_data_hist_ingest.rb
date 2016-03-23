require 'httparty'
require 'json'

lastValue = 0

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|
    url = ENV['LANTERN_URL'] + '/status'
    response =  HTTParty.get(url, :headers => { "Accept" => "application/json" } )
    json_response = JSON.parse(response.body)

    # Status JSON
    historical = json_response['historical']
    realtime = json_response['realtime']
    aggregation = json_response['aggregation']
    activePollers = json_response['activePollers']

    # Realtime index date calculations
    realDate = DateTime.iso8601(realtime['docDate'])
    realFormattedDate = realDate.strftime("%d-%m-%Y")
    realHour = realDate.strftime("%H:%M")
    realStatus = realtime['status'];

    # Histroical index date calculations
    histDate = DateTime.strptime(historical['latestEvent'], "%Y-%m-%d")
    histFormattedDate = histDate.strftime("%d-%m-%Y")

    # Aggregation index date calculations
    aggDate = DateTime.strptime(aggregation['latestEvent'], "%Y-%m-%d")
    aggFormattedDate = aggDate.strftime("%d-%m-%Y")

    # Send event to the dashboard
    send_event('LANTERN_DATA_HIST_INGEST', { metric: histFormattedDate, type: 'historical' })
    send_event('LANTERN_DATA_REAL_INGEST', { status: realStatus, metric: realFormattedDate, hour: realHour, type: 'realtime' })
    send_event('LANTERN_DATA_AGG_INGEST', { metric: aggFormattedDate, type: 'aggreagtion' })
    send_event('LANTERN_DATA_POLLERS', { current: activePollers, last: lastValue })

    lastValue = activePollers
end
