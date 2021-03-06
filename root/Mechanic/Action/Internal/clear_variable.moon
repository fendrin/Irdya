

wsl_action
    id: "clear_variable"
    description: [[This will delete the given variable. This tag can delete a scalar or an entire array; it can also delete one container at an array index. The macro CLEAR_VARIABLE is a shortcut for this tag.
This action is good to use to clean up the set of variables; for example, a well-behaved scenario will delete any variables that should not be kept for the next scenario before the end of the scenario. One can also clear tags and variables of stored units; for example, one can remove [trait]s and [object]s.]]

    action: (cfg) ->
        for name in *cfg.name
            wesmere.set_variable(name)

    scheme:
        name:
            description: [[the name of the variable to clear. This can also be a comma-separated list of multiple variable names.
If a name ends with an array index, then it deletes that one container, and shifts the indexes of all subsequent containers. For example, {CLEAR_VARIABLE my_awesome_array[2]} deletes my_awesome_array[2], but then moves my_awesome_array[3] to my_awesome_array[2], moves my_awesome_array[4] to my_awesome_array[3], and so on until the end of the array.
Note that {CLEAR_VARIABLE my_awesome_array} deletes the entire array, but {CLEAR_VARIABLE my_awesome_array[0]} deletes only the first container.]]
            list: true
            type: "String"
            mandatory: true


