#!/bin/bash 
sudo dnf install ansible -y 
# push 
# ansible-playbook -i inventory frontend.yaml 

#pull

ansible-pull -i localhost, U https://github.com/Trinath9395/ansible-expense-roles.tf.git main.yaml -e COMPONENT=frontend -e ENVIRONMENT=$1