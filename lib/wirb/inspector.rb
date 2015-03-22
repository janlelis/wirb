module Wirb
  INSPECTOR = proc{ |value|
    if defined?(value.inspect)
      Wirb.colorize_result_with_timeout(value.inspect)
    else
      "(Object doesn't support #inspect)"
    end
  }
end

