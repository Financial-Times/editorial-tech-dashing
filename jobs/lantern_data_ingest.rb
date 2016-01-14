require 'httparty'
require 'json'

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|
    url = 'http://lantern.ft.com/status'
    
    response =  HTTParty.get(url, :headers => { "Accept" => "application/json" } )
    json_response = JSON.parse(response.body)

    send_event('LANTERN_DATA_INGEST', { metric: json_response['latestIndex'] })
end