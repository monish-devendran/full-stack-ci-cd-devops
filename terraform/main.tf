terraform {
    backend "gcs"{
        bucket = "extended-legend-300803_terraform_state"
        perfix = "state/application-state-file"
    }
}