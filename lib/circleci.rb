def translate_status_to_class(status)
  statuses = {
    'success' => 'passed',
      'fixed' => 'passed',
    'running' => 'pending',
     'failed' => 'failed'
  }
  statuses[status] || 'pending'
end

def update_builds(project, auth_token) 
  api_url = 'https://circleci.com/api/v1/project/%s/%s?circle-token=%s'
  api_url = api_url % [project[:user], project[:repo], auth_token]

  api_response =  HTTParty.get(api_url, :headers => { "Accept" => "application/json" } )
  api_json = JSON.parse(api_response.body)
  return {} if api_json.empty?
    
  latest_builds = api_json.select{ |build| build['status'] != 'queued' }.first(12)
  data = Array.new;
    
  latest_builds.each do |build|
      data.push({
          repo: "#{project[:repo]}",
          branch: "#{build['branch']}",
          committer: build['committer_name'],
          widget_class: "#{translate_status_to_class(build['status'])}"
      })
  end
        
  return data
end