terraform {
  # Require Terraform version 0.13.x (recommended)
  required_version = "~> 0.13.0"

  # Require the latest 2.x version of the New Relic provider
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.12"
    }
  }
}
provider "newrelic" {}

resource "newrelic_alert_policy" "Mobile-DCS-TF" {
  name = "Mobile-DCS-TF"
  incident_preference = "PER_POLICY" # PER_POLICY is default
}

# Response time
resource "newrelic_nrql_alert_condition" "ModernAppiOS_98Percentile_ResponseTime" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.Mobile-DCS-TF.id
  type                         = "static"
  name                         = "ModernApp-iOS 98% Response Time"
  description                  = "This is alert conditionn for 98th % response time of mBanking iOS"
  runbook_url                  = "https://www.example.com"
  enabled                      = false
  violation_time_limit_seconds = 3600
  value_function               = "single_value"

  fill_option          = "static"
  fill_value           = 1.0

  aggregation_window             = 60
  expiration_duration            = 120
  open_violation_on_expiration   = true
  close_violations_on_expiration = true

  nrql {
    query             = "SELECT percentile(responseTime, 98)*1000 as '98 percentile (ms)' from MobileRequest WHERE appName='ModernApp-iOS' "
    evaluation_offset = 3
  }

  critical {
    operator              = "above"
    threshold             = 5000
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = 3000
    threshold_duration    = 600
    threshold_occurrences = "ALL"
  }
}

