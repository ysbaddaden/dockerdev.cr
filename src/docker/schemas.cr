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

  class IPAM
    include JSON::Serializable

    @[JSON::Field(key: "Driver")]
    property! driver : String?

    @[JSON::Field(key: "Config")]
    property! config : Array(IPAMConfig)?

    @[JSON::Field(key: "Options")]
    property! options : Hash(String, String)?

    def initialize(
      @driver : String? = nil,
      @config : Array(IPAMConfig)? = nil,
      @options : Hash(String, String)? = nil)
    end
  end

  class IPAMConfig
    include JSON::Serializable

    @[JSON::Field(key: "Subnet")]
    property! subnet : String?

    @[JSON::Field(key: "IPRange")]
    property! ip_range : String?

    @[JSON::Field(key: "Gateway")]
    property! gateway : String?

    @[JSON::Field(key: "AuxiliaryAddresses")]
    property! auxiliary_addresses : Hash(String, String)?

    def initialize(
      @subnet : String? = nil,
      @ip_range : String? = nil,
      @gateway : String? = nil,
      @auxiliary_addresses : Hash(String, String)? = nil)
    end
  end

  class Network
    include JSON::Serializable

    @[JSON::Field(key: "Name")]
    property! name : String?

    @[JSON::Field(key: "Id")]
    property! id : String?

    @[JSON::Field(key: "Created")]
    property! created : Time?

    @[JSON::Field(key: "Scope")]
    property! scope : String?

    @[JSON::Field(key: "Driver")]
    property! driver : String?

    @[JSON::Field(key: "EnableIPv6")]
    property! enable_ipv6 : Bool?

    @[JSON::Field(key: "IPAM")]
    property! ipam : IPAM?

    @[JSON::Field(key: "Internal")]
    property! internal : Bool?

    @[JSON::Field(key: "Attachable")]
    property! attachable : Bool?

    @[JSON::Field(key: "Ingress")]
    property! ingress : Bool?

    @[JSON::Field(key: "Containers")]
    property! containers : Hash(String, NetworkContainer)?

    @[JSON::Field(key: "Options")]
    property! options : Hash(String, String)?

    @[JSON::Field(key: "Labels")]
    property! labels : Hash(String, String)?

    def initialize(
      @name : String? = nil,
      @id : String? = nil,
      @created : Time? = nil,
      @scope : String? = nil,
      @driver : String? = nil,
      @enable_ipv6 : Bool? = nil,
      @ipam : IPAM? = nil,
      @internal : Bool? = nil,
      @attachable : Bool? = nil,
      @ingress : Bool? = nil,
      @containers : Hash(String, NetworkContainer)? = nil,
      @options : Hash(String, String)? = nil,
      @labels : Hash(String, String) = nil)
    end
  end

  class NetworkContainer
    include JSON::Serializable

    @[JSON::Field(key: "Name")]
    property! name : String?

    @[JSON::Field(key: "EndpointID")]
    property! endpoint_id : String?

    @[JSON::Field(key: "MacAddress")]
    property! mac_address : String?

    @[JSON::Field(key: "IPv4Address")]
    property! ipv4_address : String?

    @[JSON::Field(key: "IPv6Address")]
    property! ipv6_address : String?

    def initialize(
      @name : String? = nil,
      @endpoint_id : String? = nil,
      @mac_address : String? = nil,
      @ipv4_address : String? = nil,
      @ipv6_address : String? = nil)
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

  class NetworkCreateRequest
    include JSON::Serializable

    @[JSON::Field(key: "Name")]
    property name : String

    @[JSON::Field(key: "CheckDuplicate")]
    property! check_duplicate : Bool?

    @[JSON::Field(key: "Driver")]
    property! driver : String?

    @[JSON::Field(key: "Internal")]
    property! internal : Bool?

    @[JSON::Field(key: "Attachable")]
    property! attachable : Bool?

    @[JSON::Field(key: "Ingress")]
    property! ingress : Bool?

    @[JSON::Field(key: "IPAM")]
    property! ipam : IPAM?

    @[JSON::Field(key: "EnableIPv6")]
    property! enable_ipv6 : Bool?

    @[JSON::Field(key: "Options")]
    property! options : Hash(String, String)?

    @[JSON::Field(key: "Labels")]
    property! labels : Hash(String, String)?

    def initialize(
      @name : String,
      @check_duplicate : Bool? = nil,
      @driver : String? = nil,
      @internal : Bool? = nil,
      @attachable : Bool? = nil,
      @ingress : Bool? = nil,
      @ipam : ::Docker::IPAM? = nil,
      @enable_ipv6 : Bool? = nil,
      @options : Hash(String, String)? = nil,
      @labels : Hash(String, String)? = nil)
    end
  end

  class NetworkCreateResponse
    include JSON::Serializable

    @[JSON::Field(key: "Id")]
    property! id : String?

    @[JSON::Field(key: "Warning")]
    property! warning : String?

    def initialize(@id : String? = nil, @warning : String? = nil)
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
