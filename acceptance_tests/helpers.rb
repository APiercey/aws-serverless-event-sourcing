require 'aws-sdk-lambda'
require "base64"

def lambda_client
  @lambda_client ||= Aws::Lambda::Client.new(region: 'us-east-1')
end

def list_functions
  lambda_client.list_functions({
    function_version: "ALL", # accepts ALL
    max_items: 50,
  }).functions
end

def call_function(name, payload)
  resp = lambda_client.invoke({
    function_name: name, # required
    invocation_type: "RequestResponse", # accepts Event, RequestResponse, DryRun
    log_type: "None", # accepts None, Tail
    client_context: Base64.encode64('{}'),
    payload: JSON.generate(payload),
    qualifier: "$LATEST",
  })

  JSON.parse(resp.payload.read)
end
