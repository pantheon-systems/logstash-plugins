Assorted logstash plugins.

[![Deprecated](https://img.shields.io/badge/Pantheon-Deprecated-yellow?logo=pantheon&color=FFDC28)](https://pantheon.io/docs/oss-support-levels#deprecated)

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

statsd_raw
=============

This plugin scans selected message fields for statsd metrics ([in raw text format](https://github.com/etsy/statsd/blob/master/docs/metric_types.md)), i.e. `gorets:1|c|@0.1`
and sends them to the configured statsd server.

    output {
      statsd_raw {
        "host" => "localhost"
        "port" => 8125
        "fields" => ["message"]
      }
    }

You would probably want to filter for specific messages using filters because
only some events should be scanned, like this:

    filter {
      grok {
        match => ["message", "\b[a-zA-Z0-9_.-]+:[a-zA-Z0-9|:_.-]+"]
        add_tag => ["statsd"]
      }
    }

    output {
      if "statsd" in [tags] {
        statsd_custom {
          host => "localhost"
          port => 8125
          namespace => "logstash_groks_metrics"
        }
      }
    }
