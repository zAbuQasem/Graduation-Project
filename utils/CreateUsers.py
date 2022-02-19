#!/usr/bin/env python3

from subprocess import run

"""A function to create users and add them to their specified groups."""
def create_users():
	try:
		"""User: [password, group]"""
		users = {"mohammad":["Mohammad_threats2022!", "admin"],
		"moayad": ["Moayad_threats2022!", "adm"],
		"zeyad": ["Zeyad_threats2022!", "forensic_department"],
		 "omar": ["Omar_threats2022!", "forensic_department"],
		"khaled": ["Khaled_threats2022!", "developers"],
		"baker": ["Baker_threats2022!","developers"],
		"nabil": ["Nabil_threats2022!","developers,docker"]}


		"""Creating groups"""
		for group in ['admin','forensic_department','developers']:
			print(f"groupadd {group}")
			

		"""Creating users and adding them to their groups"""
		for username in users.keys():
			print(f'useradd -d /home/{username} -p `mkpasswd \'{users[username][0]}\'` {username} -G {users[username][1]} -s /bin/bash -m')
	except Exception as e:
		print(e)


def main():
	create_users()


if __name__ == '__main__':
	main()



