require 'httparty'
require 'json'

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|

   data = Array.new;
   urls = [ ENV['MARTJOB_URL'] + '/process-new-pages',
            ENV['MARTJOB_URL'] + '/articlemetadata-cdc',
            ENV['MARTJOB_URL'] + '/article-insights',
            ENV['MARTJOB_URL'] + '/unload-trigger']

   urls.each do |url|
      name = (url.split('/')[-1])
      response =  HTTParty.get(url, :headers => { "Accept" => "application/json" } )
      json_response = JSON.parse(response.body)

      if json_response["status"] == "UP"
           data.push({
              name: name,
              status: json_response['status']
           })
       else
           data.push({
              name: name,
              status: json_response['status'],
              dashboardStatus: json_response['dashboardStatus'],
              lateness: json_response['lateness']
           })
       end
   end

   send_event('MART_JOB', { items: data })
end
