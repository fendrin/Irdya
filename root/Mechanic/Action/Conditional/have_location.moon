
_ = (str) -> return str

parse_range = (str) ->



wsl_action
    id: "have_location"
    description: _ "A location matching this filter exists."

    action: (cfg, kernel) ->
        unless cfg.count
            return kernel\get_location(cfg) != nil

        locations = kernel\get_locations(cfg)

        number = #locations


    scheme:
        StandardLocationFilter:
            description: "Selection criteria."
        count:
            description: [[(Optional) If used, a number of locations equal to the value must match the filter. Accepts a number, range, or comma separated range. If not used, the default value is "1-99999".]]