import io
import json
import boto3
from PIL import Image

s3 = boto3.client('s3')
def lambda_handler(event, context):
    for record in event["Records"]:
        # Extract Key name from record
        key_name = record["s3"]["object"]["key"]
    
        # Load image from S3
        resp = s3.get_object(
            Bucket="<name of input bucket>",
            Key=key_name
        )
        image_data = resp["Body"].read()
        with Image.open(io.BytesIO(image_data)) as im:
            # Resize Image 
            im = im.resize((300, 300))
            output_img = io.BytesIO()
            im.save(output_img, format='PNG')
    
        # Store resized image to different bucket
        output_img.seek(0)
        s3.put_object(
            Bucket="<name of output bucket>",
            Key=key_name,
            Body=output_img.read()
        )
