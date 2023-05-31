require "log"
require "./docker"

DOMAIN = ENV.fetch("DOMAIN_TLD", "lvh.me")

Log.setup_from_env
Log.info { "waiting for container:create events" }

# TODO: create shared network if it doesn't exist

filters = {
  type: {"container"},
  event: {"create"},
}
Docker.events(filters: filters.to_json) do |event|
  container_name = event.actor.attributes["name"]
  Log.info { "New container (#{container_name}) created" }

  next unless project = event.actor.attributes["com.docker.compose.project"]?
  next unless service = event.actor.attributes["com.docker.compose.service"]?
  oneoff = event.actor.attributes["com.docker.compose.oneoff"]?

  config = Docker::NetworkConnectRequest.new(container: event.actor.id)

  if oneoff == "False"
    dns_alias = {service, project, DOMAIN}.join('.')
    config.endpoint_config = Docker::EndpointSettings.new(aliases: [dns_alias])
    Log.info { "Attaching #{container_name} to the shared network with alias #{dns_alias}" }
  else
    Log.info { "Attaching #{event.actor.id} to the shared network" }
  end

  Docker.network_connect(event.actor.id, container: config)
rescue ex : Docker::ErrorResponse
  Log.error(exception: ex) { ex.message }
end
