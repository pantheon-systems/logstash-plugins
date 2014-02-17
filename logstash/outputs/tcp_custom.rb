require "scanf"
require "logstash/outputs/tcp"
require "logstash/namespace"

class LogStash::Outputs::TcpCustom < LogStash::Outputs::Tcp
  # Write events over a TCP socket.
  #
  # In addition to the built-in Tcp output, format the message before sending.

  config_name "tcp_custom"
  milestone 1

  # Output only the specified fields or the entire event by default.
  #
  #     mapping => {"server" => "%{machine}"}
  config :mapping, :validate => :hash

  # Convert values using `scanf` where needed.
  #
  #     convert => {"port" => "%d"}
  config :convert, :validate => :hash
  
  public
  def receive(event)
    return unless output?(event)

    if @mapping
      evt = Hash.new
      @mapping.each do |k,v|
        evt[k] = event.sprintf(v)
      end
    else
      evt = event.to_hash
    end

    if @convert
      @convert.each do |k,f|
        evt[k] = evt[k].scanf(f)[0]
      end
    end

    @codec.encode(evt)
  end
end
