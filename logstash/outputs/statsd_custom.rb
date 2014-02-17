require "logstash/outputs/udp"
require "logstash/namespace"

class LogStash::Outputs::StatsdCustom < LogStash::Outputs::UDP
  # Monitor logstash messages for statsd packets and send them
  # out to statsd when found.

  config_name "statsd_custom"
  milestone 1

  # The fields to monitor for statsd packets.
  config :fields, :validate => :array, :default => ["message"]
  
  public
  def receive(event)
    return unless output?(event)

    @fields.each do |field|    
      event[field].split(/\s+/).each do |token|
        @codec.encode(token) if token =~ /[a-zA-Z0-9_.-]+:[a-zA-Z0-9|:_.-]+/
      end
    end
  end
end
