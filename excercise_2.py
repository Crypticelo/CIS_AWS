import boto3


def create_instances(ec2_resource, number):
    instances = ec2_resource.create_instances(
        ImageId='ami-063d43db0594b521b',
        MinCount=1,
        MaxCount=number,
        InstanceType='t2.micro',
        KeyName='anes'
    )

    for instance in instances:
        print(f'EC2 instance "{instance.id}" has been launched')
        instance.wait_until_running()
        print(f'EC2 instance "{instance.id}" has been started')


def list_instances(ec2_resource):
   instances = ec2_resource.instances.all()
   for instance in instances:
       print(instance)
       print(f'EC2 instance {instance.id}" information:')
       print(f'EC2 instance tags: {instance.tags}')
       print(f'Instance state: {instance.state["Name"]}')
       print(f'Instance AMI: {instance.image.id}')
       print(f'Instance platform: {instance.platform}')
       print(f'Instance type: "{instance.instance_type}"')
       print(f'Public IPv4 address: {instance.public_ip_address}')
       print('-' * 60)

if __name__ == "__main__":
    ec2_resource = boto3.resource('ec2',
                                  aws_access_key_id='AKIAQR5EPTPOLYPNLYOI',
                                  aws_secret_access_key='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',
                                  region_name='us-east-1'
                                  )
    list_instances(ec2_resource)