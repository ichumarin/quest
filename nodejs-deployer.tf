module "nodejs-deployer" {
    source = "./modules/nodejs-deployer"

    region =  "us-east-2"
    instance_type = "t2.micro"
}