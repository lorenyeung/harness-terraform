module "organization" {
    source = "./modules/organization"
    other-input-variable = "..."
}

module "pipelines" {
    source = "./modules/pipelines"
    other-input-variable = "..."
}

module "project" {
    source = "./modules/project"
    other-input-variable = "..."
}

module "s3" {
    source = "./modules/s3"
    other-input-variable = "..."
}