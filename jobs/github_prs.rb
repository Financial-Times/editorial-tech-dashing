require 'octokit'
require 'time'

SCHEDULER.every '1m', :first_in => 0, :allow_overlapping => false, :timeout => '59s' do |job|
    
  client = Octokit::Client.new(:access_token => ENV["GIT_API_KEY"])
  my_organization = "Financial-Times"
  repos = ["Lantern"]

  open_pull_requests = repos.inject([]) { |pulls, repo|
    client.pull_requests("#{my_organization}/#{repo}", :state => 'open').each do |pull|
      pulls.push({
        title: pull.title,
        repo: repo,
        updated_at: pull.updated_at.strftime("%b %-d %Y, %l:%m %p"),
        creator: "@" + pull.user.login,
        old: Date.parse(pull.updated_at.strftime("%b %-d %Y")) < Date.today
        });
    end
    pulls
  }

  send_event('PR_WIDGET_DATA_ID', { header: "Open Pull Requests", pulls: open_pull_requests })
end
