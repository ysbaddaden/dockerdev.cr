require "uri/params"

module Docker
  struct Params
    def self.build(&) : String
      URI::Params.build do |qs|
        yield new(qs)
      end
    end

    def initialize(@qs : URI::Params::Builder)
    end

    def add(name : String, value : Enumerable, collection_format : String? = nil) : Nil
      if collection_format == "multi"
        value.each { |item| @qs.add(name : String, encode(val, nil)) }
      else
        @qs.add(name : String, encode(val, collection_format))
      end
    end

    def add(name : String, value, collection_format : String? = nil) : Nil
      @qs.add(name, encode(value, nil))
    end

    def encode(value : Enumerable, collection_format : String?) : String
      String.build do |str|
        value.each_with_index do |item, i|
          unless i == 0
            case collection_format
            when "ssv"
              str << ' '
            when "tsv"
              str << '\t'
            when "pipes"
              str << '|'
            else
              str << ',' # csv
            end
          end
          str << encode(item)
        end
      end
    end

    def encode(value : Bool, collection_format : String? = nil) : String
      value ? "1" : "0"
    end

    def encode(value : String, collection_format : String? = nil) : String
      value
    end

    def encode(value : Time, collection_format : String? = nil) : String
      value.to_rfc3339
    end

    def encode(value, collection_format : String? = nil) : String
      param.to_s
    end
  end
end
