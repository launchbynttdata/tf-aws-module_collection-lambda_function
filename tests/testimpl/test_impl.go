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

func TestLambdaFunction(t *testing.T, ctx types.TestContext) {
	lambdaClient := lambda.NewFromConfig(GetAWSConfig(t))
	functionArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "function_arn")

	output, err := lambdaClient.GetFunction(context.TODO(), &lambda.GetFunctionInput{
		FunctionName: &functionArn,
	})
	if err != nil {
		t.Errorf("Error getting function %s: %v", functionArn, err)
	}
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
