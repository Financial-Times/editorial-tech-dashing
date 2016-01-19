require 'httparty'
require 'json'

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|
    url = ENV['LANTERN_URL'] + '/status'

    response =  HTTParty.get(url, :headers => { "Accept" => "application/json" } )
    json_response = JSON.parse(response.body)
    json_response = json_response['historical']

    date = DateTime.strptime(json_response['latestIndex'], "%Y-%m-%d")
    formattedDate = date.strftime("%d-%m-%Y")

    send_event('LANTERN_DATA_HIST_INGEST', { metric: formattedDate, type: 'historical' })
end
