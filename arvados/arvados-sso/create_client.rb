client_name = ENV['SSO_CLIENT_NAME']

c = Client.find_by(name: client_name)

if c.nil?
	c = Client.new
	c.name = client_name
end

c.app_id = "arvados-server"
c.app_secret = ENV['SSO_APP_SECRET']
c.save!

