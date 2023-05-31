import boto3

# Create an EC2 client
ec2 = boto3.client('ec2')

# Define the Lambda function handler
def lambda_handler(event, context):
    # Define EC2 instance parameters
    instance_params = {
        'ImageId': 'ami-xxxxxxxx',  # Specify the desired Amazon Machine Image (AMI) ID
        'InstanceType': 't2.micro',  # Specify the instance type
        'MinCount': 1,
        'MaxCount': 1
    }

    try:
        # Create EC2 instance
        response = ec2.run_instances(**instance_params)
        instance_id = response['Instances'][0]['InstanceId']
        print(f"EC2 instance created with ID: {instance_id}")
    except Exception as e:
        print(f"Error creating EC2 instance: {str(e)}")
