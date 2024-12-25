# frozen_string_literal: true

require 'aws-sdk-secretsmanager'

# Retrieve and update secrets from AWS Secrets Manager
class ManageSecrets
  def initialize(name)
    @name = name
    @client = Aws::SecretsManager::Client.new(region: 'us-west-2')
  end

  def read_secret
    get_secret_value_response = @client.get_secret_value(secret_id: @name)
    return JSON.parse(get_secret_value_response.secret_string)
  end

  def update_secret(value)
    response = @client.update_secret(secret_id: @name, secret_string: value)
    return false unless response.version_id
    return true
  end
end
