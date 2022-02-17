#!/usr/bin/env python3

from subprocess import run

"""A function to create users and add them to their specified groups."""
def create_users():
	try:
		"""User: [password, group]"""
		users = {"Mohammad":["Mohammad_threats2022!", "Administrators"],
		"Moayad": ["Moayad_threats2022!", "adm"],
		"Zeyad": ["Zeyad_threats2022!", "Forensic_department"],
		 "Omar": ["Omar_threats2022!", "Forensic_department"],
		"Khaled": ["Khaled_threats2022!", "Developers"],
		"Baker": ["Baker_threats2022!","Developers"],
		"Nabil": ["Nabil_threats2022!","Developers, docker"]}


		"""Creating groups"""
		for group in ['Administrators','Forensic_department','Developers']:
			run(['groupadd', group])

		# Creating users and adding them to their groups
		for username in users.keys():
			print(f"\n[-] Adding - user: {username}:{users[username][0]} -> group [{users[username][1]}]")
			"""Creating users"""
			run(['useradd', '-m', f'-d /home/{username}', '-p', f'$("echo "{users[username][0]}" | openssl passwd -1 -stdin)', username , '-G' , users[username][1] ])
	except Exception as e:
		print(e)


def main():
	create_users()


if __name__ == '__main__':
	main()

