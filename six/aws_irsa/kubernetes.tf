resource "harness_platform_connector_kubernetes" "kubernetes" {
  count = (
    local.fmt_connector_type == "kubernetes"
    ?
    1
    :
    0
  )

  # [Required] (String) Unique identifier of the resource.
  identifier = local.fmt_identifier
  # [Required] (String) Name of the resource.
  name = var.name
  # [Optional] (Set of String) Tags to filter delegates for connection.
  delegate_selectors = (
    lookup(var.kubernetes_credentials, "type", null) != "delegate"
    ?
    var.delegate_selectors
    :
    null
  )
  # [Optional] (String) Description of the resource.
  description = var.description
  # [Optional] (String) Unique identifier of the organization.
  org_id = var.organization_id
  # [Optional] (String) Unique identifier of the project.
  project_id = var.project_id
  # [Optional] (Set of String) Tags to associate with the resource.
  tags = local.common_tags

  # [Optional] (Block List, Max: 1) Client key and certificate config for the connector. (see below for nested schema)
  dynamic "client_key_cert" {
    for_each = (
      lookup(var.kubernetes_credentials, "type", null) == "certificate"
      ?
      [var.kubernetes_credentials]
      :
      []
    )
    content {
      # [Required] (String) Reference to the secret containing the client certificate for the connector.
      # To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}.
      # To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      client_cert_ref = lookup(client_key_cert.value, "client_cert_ref", null)
      # [Required] (String) The algorithm used to generate the client key for the connector. Valid values are RSA, EC
      client_key_algorithm = lookup(client_key_cert.value, "client_key_algorithm", null)
      # [Required] (String) Reference to the secret containing the client key for the connector.
      # To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}.
      # To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      client_key_ref = lookup(client_key_cert.value, "client_key_ref", null)
      # [Required] (String) The URL of the Kubernetes cluster.
      master_url = lookup(client_key_cert.value, "master_url", null)

      # [Optional] (String) Reference to the secret containing the CA certificate for the connector.
      # To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}.
      # To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      ca_cert_ref = lookup(client_key_cert.value, "ca_cert_ref", null)
      # [Optional] (String) Reference to the secret containing the client key passphrase for the connector.
      # To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}.
      # To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      client_key_passphrase_ref = lookup(client_key_cert.value, "client_key_passphrase_ref", null)
    }

  }


  # [Optional] (Block List, Max: 1) Credentials are inherited from the delegate. (see below for nested schema)
  dynamic "inherit_from_delegate" {
    for_each = (
      lookup(var.kubernetes_credentials, "type", null) == "delegate"
      ?
      [var.kubernetes_credentials]
      :
      []
    )
    content {
      # [Required] (Set of String) Selectors to use for the delegate.
      delegate_selectors = lookup(inherit_from_delegate.value, "delegates", var.delegate_selectors)
    }
  }

  # [Optional] (Block List, Max: 1) OpenID configuration for the connector. (see below for nested schema)
  dynamic "openid_connect" {
    for_each = (
      lookup(var.kubernetes_credentials, "type", null) == "openid_connect"
      ?
      [var.kubernetes_credentials]
      :
      []
    )
    content {
      # [Required]  (String) Reference to the secret containing the client ID for the connector. To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}. To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      client_id_ref = lookup(openid_connect.value, "client_id_ref", null)
      # [Required]  (String) The URL of the OpenID Connect issuer.
      issuer_url = lookup(openid_connect.value, "issuer_url", null)
      # [Required]  (String) The URL of the Kubernetes cluster.
      master_url = lookup(openid_connect.value, "master_url", null)
      # [Required]  (String) Reference to the secret containing the password for the connector. To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}. To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      password_ref = lookup(openid_connect.value, "password_ref", null)

      # [Optional]  (List of String) Scopes to request for the connector.
      scopes = lookup(openid_connect.value, "scopes", null)
      # [Optional]  (String) Reference to the secret containing the client secret for the connector. To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}. To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      secret_ref = lookup(openid_connect.value, "secret_ref", null)
      # [Optional]  (String) Username for the connector.
      username = lookup(openid_connect.value, "username", null)
      # [Optional]  (String) Reference to the secret containing the username for the connector. To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}. To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      username_ref = lookup(openid_connect.value, "username_ref", null)
    }
  }

  # [Optional] (Block List, Max: 1) Service account for the connector. (see below for nested schema)
  dynamic "service_account" {
    for_each = (
      lookup(var.kubernetes_credentials, "type", null) == "service_account"
      ?
      [var.kubernetes_credentials]
      :
      []
    )
    content {
      # [Required]  (String) The URL of the Kubernetes cluster.
      master_url = lookup(service_account.value, "master_url", null)
      # [Required]  (String) Reference to the secret containing the service account token for the connector. To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}. To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      service_account_token_ref = lookup(service_account.value, "service_account_token_ref", null)
    }
  }
  # [Optional] (Block List, Max: 1) Username and password for the connector. (see below for nested schema)
  dynamic "username_password" {
    for_each = (
      lookup(var.kubernetes_credentials, "type", null) == "username"
      ?
      [var.kubernetes_credentials]
      :
      []
    )
    content {
      # [Required] (String) The URL of the Kubernetes cluster.
      master_url = lookup(username_passowrd.value, "master_url", null)
      # [Required] (String) Reference to the secret containing the password for the connector. To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}. To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      password_ref = lookup(username_passowrd.value, "password_ref", null)

      # [Optional] (String) Username for the connector.
      username = lookup(username_passowrd.value, "username", null)
      # [Optional] (String) Reference to the secret containing the username for the connector. To reference a secret at the organization scope, prefix 'org' to the expression: org.{identifier}. To reference a secret at the account scope, prefix 'account` to the expression: account.{identifier}.
      username_ref = lookup(username_passowrd.value, "username_ref", null)
    }
  }
}
