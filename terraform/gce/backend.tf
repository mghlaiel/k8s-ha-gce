terraform {
  backend "gcs" {
    prefix = "terraform-kkp"
    bucket = "tf-state-kkp-z1v35d6oohyp"
  }
}