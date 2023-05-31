require "log"
require "./docker"

DOMAIN = ENV.fetch("DOMAIN_TLD", "lvh.me")
NETWORK_NAME = ENV.fetch("NETWORK_NAME", "shared")

Log.setup_from_env

if network = Docker.network_inspect?(NETWORK_NAME)
  Log.info { "Using existing network name=#{network.name} id=#{network.id[0, 12]}" }
else
  network = Docker.network_create(Docker::NetworkCreateRequest.new(name: NETWORK_NAME))
  Log.info { "Created network name=#{NETWORK_NAME} id=#{network.id[0, 12]}" }
end

Log.info { "Waiting for container:create events" }

filters = {
  type: {"container"},
  event: {"create"},
}
Docker.events(filters: filters.to_json) do |event|
  container_name = event.actor.attributes["name"]
  Log.debug { "New container (#{container_name}) created" }

  next unless project = event.actor.attributes["com.docker.compose.project"]?
  next unless service = event.actor.attributes["com.docker.compose.service"]?
  oneoff = event.actor.attributes["com.docker.compose.oneoff"]?
  network_config = Docker::NetworkConnectRequest.new(container: event.actor.id)

  if oneoff == "False"
    dns_alias = {service, project, DOMAIN}.join('.')
    network_config.endpoint_config = Docker::EndpointSettings.new(aliases: [dns_alias])
    Log.info { "Attaching #{container_name} to the #{NETWORK_NAME} network with alias #{dns_alias}" }
  else
    Log.info { "Attaching #{event.actor.id} to the #{NETWORK_NAME} network" }
  end

  Docker.network_connect(network.id, network_config)
rescue ex : Docker::ErrorResponse
  Log.error(exception: ex) { ex.message }
end
