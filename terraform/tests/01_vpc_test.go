package vpc

import (
    "testing"
    "fmt"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestVpcModule(t *testing.T) {
    // Configure Terraform options
    terraformOptions := &terraform.Options{
        TerraformDir: "../modules/01-vpc", 
    }

    // Destroy the resources after the test
    defer terraform.Destroy(t, terraformOptions)

    // Initialize and apply the Terraform configuration
    terraform.InitAndApply(t, terraformOptions)

    // Get the VPC ID output
    vpcId := terraform.Output(t, terraformOptions, "vpc_id")

    // Verify that the VPC ID is not empty
    assert.NotEmpty(t, vpcId, "VPC ID should not be empty")

    // You can add more assertions for other VPC attributes
    // For example, verifying the CIDR block
    expectedCidrBlock := "11.0.0.0/16"
    vpcCidrBlock := terraform.Output(t, terraformOptions, "vpc_cidr_block")
    assert.Equal(t, expectedCidrBlock, vpcCidrBlock, fmt.Sprintf("Expected VPC CIDR block to be %s, but got %s", expectedCidrBlock, vpcCidrBlock))
}