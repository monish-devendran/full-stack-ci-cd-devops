terraform {
    backend "gcs"{
        bucket = "extended-legend-300803_terraform_state"
        prefix = "state/application-state-file"
    }
}
