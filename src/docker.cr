require "docker"
require "./docker/schemas"
require "./docker/params"

module Docker
  def self.events(*, since : String? = nil, _until : String? = nil, filters : String? = nil, & : EventMessage ->) : Nil
    client = Client.new

    query = Params.build do |qs|
      qs.add("since", since) unless since.nil?
      qs.add("until", _until) unless _until.nil?
      qs.add("filters", filters) unless filters.nil?
    end

    client.get("/v1.41/events?#{query}") do |response|
      case response.status_code
      when 200
        while line = response.body_io.gets
          yield EventMessage.from_json(line)
        end
      when 400, 500
        raise ErrorResponse.from_json(response.body_io)
      else
        unexpected_response(response)
      end
    end
  end

  def self.network_inspect?(id : String, *, verbose : Bool? = nil, scope : String? = nil) : Network?
    query = Params.build do |qs|
      qs.add("verbose", verbose) unless verbose.nil?
      qs.add("scope", scope) unless scope.nil?
    end
    response = client.get("/v1.41/networks/#{URI.encode_path_segment(id)}?#{query}")
    case response.status_code
    when 200
      Network.from_json(response.body)
    when 404
      # not found
    when 500
      raise ErrorResponse.from_json(response.body)
    else
      unexpected_response(response)
    end
  end

  def self.network_create(network_config : NetworkCreateRequest) : NetworkCreateResponse
    headers = HTTP::Headers{"Content-Type" => "application/json"}
    response = client.post("/v1.41/networks/create", headers: headers, body: network_config.to_json)
    case response.status_code
    when 201
      NetworkCreateResponse.from_json(response.body)
    when 403, 404, 500
      raise ErrorResponse.from_json(response.body)
    else
      unexpected_response(response)
    end
  end

  def self.network_connect(id : String, container : NetworkConnectRequest) : Nil
    headers = HTTP::Headers{"Content-Type" => "application/json"}
    response = client.post("/v1.41/networks/#{URI.encode_path_segment(id)}/connect", headers: headers, body: container.to_json)
    case response.status_code
    when 200
      # ok
    when 403, 404, 500
      raise ErrorResponse.from_json(response.body)
    else
      unexpected_response(response)
    end
  end

  protected def self.unexpected_response(response : HTTP::Client::Response)
    raise "Unexpected HTTP response status #{response.status_code} (#{response.status})"
  end
end
