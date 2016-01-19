require 'httparty'
require 'json'

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|
    url = ENV['LANTERN_URL'] + '/status'

    response =  HTTParty.get(url, :headers => { "Accept" => "application/json" } )
    json_response = JSON.parse(response.body)
    json_response = json_response['realtime']

    date = DateTime.iso8601(json_response['docDate'])
    formattedDate = date.strftime("%d-%m-%Y")
    hour = date.strftime("%H:%M")
    status = json_response['status'];

    send_event('LANTERN_DATA_REAL_INGEST', {
      status: status,
      metric: formattedDate,
      hour: hour,
      type: 'realtime'
    })
end
