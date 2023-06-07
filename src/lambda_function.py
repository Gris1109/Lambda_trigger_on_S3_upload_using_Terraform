import json
import boto3

# Create an EC2 client
ec2 = boto3.client('ec2')

# Define the Lambda function handler
def lambda_handler(event, context):

    """
    # Retrieve the bucket name from the event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    timestamp = event["Records"][0]["eventTime"]
    s3_key = event["Records"][0]["s3"]["object"]["key"]
    s3_data_size = event["Records"][0]["s3"]["object"]["size"]
    ip_address = event["Records"][0]["requestParameters"]["sourceIPAddress"]
    event_type = event["Records"][0]["eventName"]
    owner_id = event["Records"][0]["s3"]["bucket"]["ownerIdentity"]["principalId"]
    
    # Print the bucket name
    print("Bucket Name:", bucket_name)
    print("s3_key:", s3_key)
    print("s3_size:", s3_data_size)
    print("event_type:", event_type)
    print("owner_id:", owner_id)
    """

    # Define EC2 instance parameters
    instance_params = {
        'ImageId': 'ami-0261755***b8c4a84',  # Specify the desired Amazon Machine Image (AMI) ID
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
        
        
    
