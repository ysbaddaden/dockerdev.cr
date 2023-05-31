module Docker
  class ErrorResponse < Exception
    def self.new(pull : JSON::PullParser)
      message = nil
      pull.read_object do |key|
        if key == "message"
          message = pull.read_string
        end
      end
      new message.not_nil!
    end
  end

  class EventMessage
    include JSON::Serializable

    @[JSON::Field(key: "Type")]
    property! type : String?

    @[JSON::Field(key: "Action")]
    property! action : String?

    @[JSON::Field(key: "Actor")]
    property! actor : EventActor?

    @[JSON::Field(key: "scope")]
    property! scope : String?

    @[JSON::Field(key: "time")]
    property! time : Int64

    @[JSON::Field(key: "timeNano")]
    property! time_nano : Int64?

    def initialize(
      @type : String? = nil,
      @action : String? = nil,
      @actor : EventActor? = nil,
      @scope : String? = nil,
      @time : Int64? = nil,
      @time_nano : Int64? = nil)
    end
  end

  class EventActor
    include JSON::Serializable

    @[JSON::Field(key: "ID")]
    property! id : String?

    @[JSON::Field(key: "Attributes")]
    property! attributes : Hash(String, String)?

    def initialize(
      @id : String? = nil,
      @attributes : Hash(String, String)? = nil)
    end
  end

  class NetworkConnectRequest
    include JSON::Serializable

    @[JSON::Field(key: "Container")]
    property! container : String?

    @[JSON::Field(key: "EndpointConfig")]
    property! endpoint_config : EndpointSettings?

    def initialize(
      @container : String? = nil,
      @endpoint_config : EndpointSettings? = nil)
    end
  end

  class EndpointSettings
    include JSON::Serializable

    @[JSON::Field(key: "IPAMConfig")]
    property! ipam_config : EndpointIPAMConfig?

    @[JSON::Field(key: "Links")]
    property! links : Array(String)?

    @[JSON::Field(key: "Aliases")]
    property! aliases : Array(String)?

    @[JSON::Field(key: "NetworkID")]
    property! network_id : String?

    @[JSON::Field(key: "EndpointID")]
    property! endpoint_id : String?

    @[JSON::Field(key: "Gateway")]
    property! gateway : String?

    @[JSON::Field(key: "IPAddress")]
    property! ip_address : String?

    @[JSON::Field(key: "IPPrefixLen")]
    property! ip_prefix_len : Int64?

    @[JSON::Field(key: "IPv6Gateway")]
    property! ipv6_gateway : String?

    @[JSON::Field(key: "GlobalIPv6Address")]
    property! global_ipv6_address : String?

    @[JSON::Field(key: "GlobalIPv6PrefixLen")]
    property! global_ipv6_prefix_len : Int64?

    @[JSON::Field(key: "MacAddress")]
    property! mac_address : String?

    @[JSON::Field(key: "DriverOpts")]
    property! driver_opts : Hash(String, String)?

    def initialize(
      @ipam_config : EndpointIPAMConfig? = nil,
      @links : Array(String)? = nil,
      @aliases : Array(String)? = nil,
      @network_id : String? = nil,
      @endpoint_id : String? = nil,
      @gateway : String? = nil,
      @ip_address : String? = nil,
      @ip_prefix_len : Int64? = nil,
      @ipv6_gateway : String? = nil,
      @global_ipv6_address : String? = nil,
      @global_ipv6_prefix_len : Int64? = nil,
      @mac_address : String? = nil,
      @driver_opts : Hash(String, String)? = nil)
    end
  end

  class EndpointIPAMConfig
    include JSON::Serializable

    @[JSON::Field(key: "IPv4Address")]
    property! ipv4_address : String?

    @[JSON::Field(key: "IPv6Address")]
    property! ipv6_address : String?

    @[JSON::Field(key: "LinkLocalIPs")]
    property! link_local_ips : Array(String)?

    def initialize(
      @ipv4_address : String? = nil,
      @ipv6_address : String? = nil,
      @link_local_ips : Array(String)? = nil)
    end
  end
end
