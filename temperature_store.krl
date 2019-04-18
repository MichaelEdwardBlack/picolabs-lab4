ruleset temperature_store {
  meta {
    name "Temperature Store"
    author "Michael Black"

  }

  rule guard_temperatures_map {
    select when wovyn new_temperature_reading

    if ent:temperature_readings.isnull() then noop();

    fired {
      ent:temperature_readings := {};
    }
  }

  rule collect_temperatures {
    select when wovyn new_temperature_reading

    pre {
      temperature = event:attrs{"temperature"}
      timestamp = event:attrs{"timestamp"}
    }

    //if (temperature.isnull() || timestamp.isnull()) then noop()

    fired {
      ent:temperature_readings{timestamp} := temperature;
    }
  }

  rule guard_tempearture_violations_map {
    select when wovyn threshold_violation

    if ent:temperature_violations.isnull() then noop()

    fired {
      ent:temperature_violations := {};
    }
  }

  rule collect_threshold_violations {
    select when wovyn threshold_violation

    pre {
      tempF = event:attrs{"temperatureF"}
      timestamp = event:attrs{"timestamp"}
    }

    //if (tempF.isnull() || timestamp.isnull()) then noop();

    fired {
      ent:violated_temp := tempF;
      ent:violated_timestamp := timestamp;
    }
  }

/*
  rule clear_temperatures {
    select when sensor reading_reset

    pre {
      ent:temperature_readings = {};
    }
  }
  */
}
