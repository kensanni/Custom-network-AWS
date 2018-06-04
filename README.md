# Custom-network-AWS

##  About
Custom-network-AWS is a simple program that create a custom network(VPC- Virtual Private Cloud) and loadbalancer for both the web application and REST API on AWS using [`terraform`](https://www.terraform.io/)

### Instructions
Follow the guidlines below to create a custom network using this terraform script

1. Clone the repository and `cd` into `custom-network-AWS` directory

    ```
      git clone https://github.com/kensanni/Custom-network-AWS
      
      cd custom-network-AWS
    ```
2. To run terraform file `.tf` we need to have terraform install.
   >- Ensure you have terraform install by running `terraform -v`.
   >- You should get the version of your terraform. if you don't get any response, you probably do not have terraform               installed.
   >- You can install terraform using [`homebrew`](https://brew.sh/) by running `brew install terraform`.

3. Now that we have terraform installed, we have to initialize terraform
   >- terraform init
  
4.  Having initialized terraform, we need to create a `terraform.tfvars` file to specify our `AWS secret and access key`
    ```
      access_key = "YOUR_AWS_ACCESS_KEY"

      secret_key = "YOUR_AWS_SECRET_KEY"
    ```
5.  To have access into the instances created by terraform, make sure you log into the AWS EC2 dashboard and create a new         keypair named `test-run`. You can follow the instruction below to create a keypair
    >- On your AWS management console, click on the `Services` drop-down, under the `Compute` section click on EC2.
    >- On EC2 dashboard, By the side-navigation bar under `NETWORK & SECURITY` section, click on `Key Pairs`.
    >- Click on the button with `Create Key Pair` description and input `test-run` as the key pair name value.
   
6. To create the necessary resources specify in the `.tf` file, run the `terraform apply` command
   >- terraform apply
   
7. The `terraform apply` commmand would create the following on AWS
    - A VPC with a private and public subnet
    - Route table to determine where network traffic is directed.
    - Internet gateway for connecting to the internet
    - Database and API instance created in the private subnet
    - Web Application and nat instance created in the public subnet
    - Loadbalancer for both the API and Web application
  
8.  We can only SSH into the API and database instance through the nat instance with the private ip using the test-run keypair.
    >- ssh into the nat instance
    >- create a new file named `test-run` and copy the content of your test-run keypair into the file.
    >- you can ssh into the database or nat-instance with the keypair alongside private ip.
