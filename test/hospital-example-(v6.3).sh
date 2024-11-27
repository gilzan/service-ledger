#!/bin/bash

########## ADMIN OPERATIONS ##########

#Register the Hospital organisation in SL, along with its admin
curl -sk --request POST \
	--header "Content-Type: application/json" \
	--data '{"org_name": "hospital", "username": "hospital_admin","password": "hosadm"}' \
	https://localhost:6023/v1/signup/admin | jq -r "."
	
#TODO
#The address of the Algorand account generated by the above API call MUST BE FUNDED at https://bank.testnet.algorand.network/

#Admin login
ADMIN_TOKEN=$(curl -sk --request POST \
	--header "Content-Type: application/json" \
	--data '{"username": "hospital_admin","password": "hosadm"}' \
	https://localhost:6023/v1/login | jq -r ".sl_token")
	
#Create a user for the Hospital
curl -sk --request POST \
	--header "Content-Type: application/json" \
	--header "Authorization: Bearer ${ADMIN_TOKEN}" \
	--data '{"username": "hospital_user1","password": "password"}' \
	https://localhost:6023/v1/signup/hospital/user | jq -r "."

#Create a TAXII apiroot for the Hospital
curl -sk --request POST \
	--header "Content-Type: application/json" \
	--header "Authorization: Bearer ${ADMIN_TOKEN}" \
	--data '{"title": "The Hospital","description": "Hospital Group"}' \
	https://localhost:6023/hospital | jq -r "."

#Create a TAXII collection inside the Hospital's apiroot
curl -sk --request POST \
	--header "Content-Type: application/json" \
	--header "Authorization: Bearer ${ADMIN_TOKEN}" \
	--data '{"title": "Attacks","alias": "attack"}' \
	https://localhost:6023/hospital/collections | jq -r "."
	
########## USER OPERATIONS ##########

#User login
USER_TOKEN=$(curl -sk --request POST \
	--header "Content-Type: application/json" \
	--data '{"username": "hospital_user1","password": "password"}' \
	https://localhost:6023/v1/login | jq -r ".sl_token")
	
#Get Hospital's collections
curl -sk --request GET \
	--header "Accept: application/json" \
	--header "Authorization: Bearer ${USER_TOKEN}" \
	https://localhost:6023/hospital/collections | jq -r "."
	
#Get Hospital's collection "attack"
curl -sk --request GET \
	--header "Accept: application/json" \
	--header "Authorization: Bearer ${USER_TOKEN}" \
	https://localhost:6023/hospital/collections/attack | jq -r "."
	
#Store a STIX object inside the Hospital's collection "attack"
curl -sk --request POST \
	--header "Content-Type: application/json" \
	--header "Authorization: Bearer ${USER_TOKEN}" \
	--data @stix-obj-example.json \
	https://localhost:6023/hospital/collections/attack/objects | jq -r "."
	
#Get status of STIX object creation
curl -sk --request GET \
	--header "Accept: application/json" \
	--header "Authorization: Bearer ${USER_TOKEN}" \
	https://localhost:6023/hospital/status/70778cf1-1078-45cc-8598-2aa3e718b94e | jq -r "."
	
#Get STIX objects of the Hospital "attack" collection
curl -sk --request GET \
	--header "Accept: application/json" \
	--header "Authorization: Bearer ${USER_TOKEN}" \
	https://localhost:6023/hospital/collections/attack/objects | jq -r "."
	
#Get a specific STIX object of the Hospital "attack" collection
curl -sk --request GET \
	--header "Accept: application/json" \
	--header "Authorization: Bearer ${USER_TOKEN}" \
	https://localhost:6023/hospital/collections/attack/objects/bundle--2a25c3c8-5d88-4ae9-862a-cc3396442317 | jq -r "."
	
#Get versions of a specific STIX object of the Hospital "attack" collection
curl -sk --request GET \
	--header "Accept: application/json" \
	--header "Authorization: Bearer ${USER_TOKEN}" \
	https://localhost:6023/hospital/collections/attack/objects/bundle--2a25c3c8-5d88-4ae9-862a-cc3396442317/versions | jq -r "."
