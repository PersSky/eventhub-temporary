locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  # Generate a default name
  default_name = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"

  # Generate a list of hubs to create
  hubs_list = flatten(
    [for namespace, values in var.eventhub_namespaces_hubs :
      [for hubname in keys(lookup(values, "hubs", {})) :
        "${namespace}|${hubname}"
      ]
    ]
  )

  # Generate a list of namespaces to create shared access policies with reader right
  namespaces_reader = [for namespace, values in var.eventhub_namespaces_hubs :
    "${namespace}" if lookup(var.eventhub_namespaces_hubs[namespace], "reader", true)
  ]


  # Generate a list of namespaces to create shared access policies with sender right
  namespaces_sender = [for namespace, values in var.eventhub_namespaces_hubs :
    "${namespace}" if lookup(var.eventhub_namespaces_hubs[namespace], "sender", true)
  ]

  # Generate a list of namespaces to create shared access policies with manage right
  namespaces_manage = [for namespace, values in var.eventhub_namespaces_hubs :
    "${namespace}" if lookup(var.eventhub_namespaces_hubs[namespace], "manage", true)
  ]

  # Generate a list of hubs to create shared access policies with reader right
  hubs_reader = flatten(
    [for namespace, values in var.eventhub_namespaces_hubs :
      [for hubname, params in lookup(values, "hubs", {}) :
        "${namespace}|${hubname}" if lookup(params, "reader", false)
      ]
    ]
  )

  # Generate a list of hubs to create shared access policies with sender right
  hubs_sender = flatten(
    [for namespace, values in var.eventhub_namespaces_hubs :
      [for hubname, params in lookup(values, "hubs", {}) :
        "${namespace}|${hubname}" if lookup(params, "sender", false)
      ]
    ]
  )

  # Generate a list of hubs to create shared access policies with manage right
  hubs_manage = flatten(
    [for namespace, values in var.eventhub_namespaces_hubs :
      [for hubname, params in lookup(values, "hubs", {}) :
        "${namespace}|${hubname}" if lookup(params, "manage", false)
      ]
    ]
  )
}
