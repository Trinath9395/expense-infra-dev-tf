#!/bin/bash 


sudo dnf install ansible -y 
# push 
# ansible-playbook -i inventory.yaml mysql.yaml

#pull

ansible-pull -i localhost, -U https://github.com/Trinath9395/ansible-expense-roles.tf.git main.yaml -e COMPONENT=backend -e ENVIRONMENT=$1
