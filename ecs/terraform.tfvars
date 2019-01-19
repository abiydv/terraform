lb_cert_name         = "ACM_CERT_NAME"
environment          = "dev"      # Specify your environment (either of dev, qa, prod - to set anything else,
                                  # remember to add it in the map variables vpc and account id in variables.tf file
endpoint             = "app"
app_count            = 2
app_image            = "REPO_URL/IMAGE:TAG"
container_env_value  = "dev-value-if-any"
