#!/usr/bin/python3

PassPolicy = "_threats2022!"
with open("names.txt", "r") as f:
	for user in f.readlines():
		user = user.strip()
		creds = user+": "+user + PassPolicy
		print(creds)