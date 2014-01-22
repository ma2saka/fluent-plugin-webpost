class Fluent::WebpostOutput < Fluent::BufferedOutput
  MAX_POST=100
  DEFAULT_UA='ruby/webpost'

  Fluent::Plugin.register_output('webpost', self)

  include Fluent::SetTagKeyMixin
  config_set_default :include_tag_key, false

  include Fluent::SetTimeKeyMixin
  config_set_default :include_time_key, true

  config_param :post_url, :string
  config_param :user_agent, :string, :default  => DEFAULT_UA

  def initialize
    super
    require 'msgpack'
    require 'net/http'
    require 'json'
  end

  def configure(conf)
    super
    url = conf['post_url'].strip
    if url.size == 0
        raise Fluent::ConfigError.new("post_url")
    end
    @post_url = URI.parse(url)
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def write(chunk)
    rec_arr = []

    chunk.msgpack_each do |records|
        tag, time, record = records
        rec_arr << record
    end

    Net::HTTP.start(@post_url.host, @post_url.port) do |http|
        post_arr = rec_arr.shift(MAX_POST)
        if post_arr.size != 0
            rs = http.post(@post_url.path ,post_arr.to_json , {"user-agent" => user_agent})
            $log.debug("[webpost] #{post_arr.size} items posted #{@post_url.to_s}, returning #{rs.code}.")
        end
    end
  end
end

