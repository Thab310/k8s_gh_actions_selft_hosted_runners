package test

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestIntegrationTest(t *testing.T) {
	/////////////////////////////////////////////////////////////
    // Configure Terraform options
	/////////////////////////////////////////////////////////////
    terraformOptions := &terraform.Options{
        TerraformDir: "../environment/test",
    }

	/////////////////////////////////////////////////////////////
    // Cleanup resources after the test is completed
	/////////////////////////////////////////////////////////////
    defer terraform.Destroy(t, terraformOptions)

	/////////////////////////////////////////////////////////////
    // Initialize Terraform and apply the configuration
	/////////////////////////////////////////////////////////////
    terraform.InitAndApply(t, terraformOptions)

	/////////////////////////////////////////////////////////////
    // Test 01-vpc
	/////////////////////////////////////////////////////////////
    vpcID := terraform.Output(t, terraformOptions, "vpc_id") // Get the VPC ID output
	assert.NotEmpty(t, vpcID, "VPC ID should not be empty") // Verify that the VPC ID is not empty
    vpcCIDR := terraform.Output(t, terraformOptions, "vpc_cidr")
    assert.NotEmpty(t, vpcID)
    assert.NotEmpty(t, vpcCIDR)
    aws.GetVPCById(t, vpcID, &aws.GetVPCByIdInput{})

	/////////////////////////////////////////////////////////////
    // Test 02-igw
	/////////////////////////////////////////////////////////////
    igwID := terraform.Output(t, terraformOptions, "igw_id")
    assert.NotEmpty(t, igwID)
    aws.GetInternetGatewayById(t, igwID, &aws.GetInternetGatewayByIdInput{})

	/////////////////////////////////////////////////////////////
    // Test 03-subnets
	/////////////////////////////////////////////////////////////
    pubSubAZ1ID := terraform.Output(t, terraformOptions, "pub_sub_az1_id")
    pubSubAZ2ID := terraform.Output(t, terraformOptions, "pub_sub_az2_id")
    privSubAZ1ID := terraform.Output(t, terraformOptions, "priv_sub_az1_id")
    privSubAZ2ID := terraform.Output(t, terraformOptions, "priv_sub_az2_id")
    assert.NotEmpty(t, pubSubAZ1ID)
    assert.NotEmpty(t, pubSubAZ2ID)
    assert.NotEmpty(t, privSubAZ1ID)
    assert.NotEmpty(t, privSubAZ2ID)
    aws.GetSubnetById(t, pubSubAZ1ID, &aws.GetSubnetByIdInput{})
    aws.GetSubnetById(t, pubSubAZ2ID, &aws.GetSubnetByIdInput{})
    aws.GetSubnetById(t, privSubAZ1ID, &aws.GetSubnetByIdInput{})
    aws.GetSubnetById(t, privSubAZ2ID, &aws.GetSubnetByIdInput{})

	/////////////////////////////////////////////////////////////
    // Test 04-nat
	/////////////////////////////////////////////////////////////
    natGatewayID := terraform.Output(t, terraformOptions, "nat_gateway_id")
    assert.NotEmpty(t, natGatewayID)
    aws.GetNatGatewayById(t, natGatewayID, &aws.GetNatGatewayByIdInput{})

	/////////////////////////////////////////////////////////////
    // Test 06-eks
	/////////////////////////////////////////////////////////////
    eksClusterName := terraform.Output(t, terraformOptions, "eks_cluster_name")
    assert.NotEmpty(t, eksClusterName)
    aws.GetEksClusterByName(t, eksClusterName, &aws.GetEksClusterByNameInput{})

}