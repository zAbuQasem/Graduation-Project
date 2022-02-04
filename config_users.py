#!/usr/bin/env python3

from subprocess import run

"""A function to create users and add them to their specified groups."""
def create_users():
	try:
		"""User: [password, group]"""
		users = {"Mohammad":["20072007", "Administrators"],
		"Moayad": ["inteligente", "adm"],
		"Zeyad": ["12345b", "Forensic_department"],
		 "Omar": ["12345678a", "Forensic_department"],
		"Khaled": ["yahoo123", "Developers"],
		"Baker": ["il0veyou","Developers"],
		"Nabil": ["121188","Developers, docker"]}


		"""Creating groups"""
		for group in ['Administrators','Forensic_department','Developers']:
			run(['groupadd', group])

		# Creating users and adding them to their groups
		for username in users.keys():
			print(f"\n[-] Adding - user: {username}:{users[username][0]} -> group [{users[username][1]}]")
			"""Creating users"""
			run(['useradd', '-m', f'-d /home/{username}', '-p', f'$("echo "{users[username][0]}" | openssl passwd -1 -stdin)', username , '-G' , users[username][1] ])
	except Exception as e:
		print(f"[!] Failed to add user or user exists.")

def privileges():
	run(['setcap', 'cap_setuid+ep' ,'/usr/bin/python3.8'])
	run(['echo', '"%Administrators	ALL=(ALL:ALL) ALL"', '>> /etc/sudoers']) # Does it work
	run(['echo', '"Khaled ALL=(root) NOPASSWD: /usr/bin/vi"', '>> /etc/sudoers'])



def main():
	create_users()
	"""Create a bash script for this"""
	# privileges()


if __name__ == '__main__':
	main()

"""
Add to vagrant file
Check for python version
configure ssh
Download python3-pip, docker
"""