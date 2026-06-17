"""Pulumi (Python) — the same IaC goal in a general-purpose language instead of HCL.

I reach for this when the infra needs real logic — loops, conditionals, types — that HCL
fights you on. Here: a tagged bucket plus N web instances stamped out in a plain for-loop.

    pip install -r requirements.txt
    pulumi up
"""
import pulumi
import pulumi_aws as aws

config = pulumi.Config()
instance_count = config.get_int("instanceCount") or 2

common_tags = {"owner": "netops", "project": "lab", "env": "nonprod"}

# Artifacts bucket — tagged at creation, like everything else.
bucket = aws.s3.BucketV2("artifacts", tags=common_tags)

# Newest Amazon Linux 2023 AMI, looked up rather than hardcoded.
ami = aws.ec2.get_ami(
    most_recent=True,
    owners=["amazon"],
    filters=[{"name": "name", "values": ["al2023-ami-*-x86_64"]}],
)

# The loop is the point — the thing HCL's count/for_each makes awkward is just a for-loop here.
instances = []
for i in range(instance_count):
    instances.append(
        aws.ec2.Instance(
            f"web-{i}",
            instance_type="t3.micro",
            ami=ami.id,
            tags={**common_tags, "Name": f"web-{i}"},
        )
    )

pulumi.export("bucket", bucket.bucket)
pulumi.export("instance_ids", [i.id for i in instances])
