locals {

  containers_foreach = {
    for key, value in var.settings.containers : key => value
    if try(value.count, null) == null
  }

  countainers_count = {
    for key, value in var.settings.containers : key => value
    if try(value.count, null) != null
  }

  countainers_count_expanded = {
    for container in
    flatten(
      [
        for key, value in local.countainers_count : [
          for number in range(value.count) :
          {
            key                           = format("%s-%s", key, number)
            iterator                      = number
            name                          = format("%s-%s", value.name, number)
            image                         = value.image
            cpu                           = value.cpu
            memory                        = value.memory
            environment_variables         = try(value.environment_variables, null)
            variables_from_command        = try(value.variables_from_command, {})
            secure_environment_variables  = try(value.secure_environment_variables, null)
            secure_variables_from_command = try(value.secure_variables_from_command, {})
            commands                      = try(value.commands, null)
            gpu                           = try(value.gpu, null)
            ports                         = try(value.ports, {})
            readiness_probe               = try(value.readiness_probe, null)
            liveness_probe                = try(value.liveness_probe, null)
            volume                        = try(value.volume, null)
          }
        ]
      ]
    ) : container.key => container
  }

    # Combine them
  combined_containers = merge(local.containers_foreach, local.countainers_count_expanded)


}