require 'httparty'
require 'json'

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|
    url = 'http://lantern.ft.com/status'
    
    response =  HTTParty.get(url, :headers => { "Accept" => "application/json" } )
    json_response = JSON.parse(response.body)
    json_response = json_response['realtime']
    
    date = DateTime.strptime(json_response['latestIndex'], "%Y-%m-%d-%H")
    formattedDate = date.strftime("%d-%m-%Y")
    hour = date.strftime("%I:%M")
    
    send_event('LANTERN_DATA_REAL_INGEST', { metric: formattedDate, hour: hour, type: 'realtime'})
end