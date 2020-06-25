aws secretsmanager get-secret-value --secret-id /tf-infra/deploy/ssh_key --query SecretString --output text > ~/.ssh/tf-infra-ssh 
