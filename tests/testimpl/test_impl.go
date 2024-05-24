package common

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/lambda"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/require"
)

func TestDoesLambdaFunctionExist(t *testing.T, ctx types.TestContext) {
	lambdaClient := lambda.NewFromConfig(GetAWSConfig(t))
	lambdaArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "function_arn")
	lambdaName := terraform.Output(t, ctx.TerratestTerraformOptions(), "function_name")

	t.Run("TestDoesLambdaFunctionExist", func(t *testing.T) {
		output, err := lambdaClient.GetFunction(context.TODO(), &lambda.GetFunctionInput{FunctionName: &lambdaName})
		if err != nil {
			t.Errorf("Error getting cluster description: %v", err)
		}

		require.Equal(t, lambdaArn, *output.Configuration.FunctionArn, "Expected ARN to match")
		require.Equal(t, lambdaName, *output.Configuration.FunctionName, "Expected Name to match")
	})
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
