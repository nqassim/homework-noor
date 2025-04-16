class HealthRoutes < Sinatra::Base
  before do
    auth_header = request.env['HTTP_AUTHORIZATION']
    if auth_header && auth_header.start_with?('Basic ')
      encoded = auth_header.split(' ', 2).last
      decoded = Base64.decode64(encoded)
      username, password = decoded.split(':', 2)

      # Read expected credentials from your .access file
      expected_user, expected_pass = File.readlines('config/.access').map { |line| line.split('=').last.strip }

      request.env['AUTHED'] = (username == expected_user && password == expected_pass)
    end
  end
  get('/') do
    if request.env['AUTHED'] == true
      'App working OK'
    else
      status 403
    end
  end
end
