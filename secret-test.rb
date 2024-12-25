require 'aws-sdk-secretsmanager'

def get_secret
  client = Aws::SecretsManager::Client.new(region: 'us-west-2')

  begin
    get_secret_value_response = client.get_secret_value(secret_id: 'whereisjeremy-locations')
  rescue StandardError => e
    raise e
  end

  get_secret_value_response.secret_string
end

puts get_secret
