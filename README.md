Assorted logstash plugins.

tcp_custom
==========

This plugin is basically an enhanced version of the built-in output `tcp`. It 
allows to manipulate the payload before it is sent out; you can have exactly 
the fields you need and convert them if needed.

To report to sensu, you can have:

    output {
      tcp_custom {
        codec => "json"
        host => "localhost"
        port => 3030
        mapping => {
          "output" => "%{message}"
          "name" => "logstash_to_sensu"
          "status" => 1
          "handler" => "debug"
        }
        convert => {
          "status" => "%d"
        }
      }
      ...
    }

statsd_custom
=============

This plugin scans selected message fields for statsd metrics (in raw format)
and sends them to the configured statsd server.

    output {
      statsd_custom {
        "host" => "localhost"
        "port" => 8125
        "fields" => ["message"]
      }
    }

