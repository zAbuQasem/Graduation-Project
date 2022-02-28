#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include <unistd.h>

#define BRED "\e[1;31m"
#define BWHT "\e[1;37m"
#define RESET "\x1B[0m"
#define BYEL "\e[1;33m"

void DownloadFiles();

int main(int argc, char **argv){
	char password[21];
	int result;
	printf(BYEL "\n #####################\n # Package installer #\n #####################\n\n"RESET);
	printf(BYEL "[!] Please enter the password: "RESET);
	scanf("%s", password);
	result = strcmp(password,"SuperSecurePassword!");
	if(result != 0){
		printf(BRED"[!] Authentication error!!\n\n"RESET);
		exit(1);
	}
	DownloadFiles();
	return 0;

}

void DownloadFiles(){
	char package[100];
	int check;
	setuid(0);
	printf(BYEL "[!] Enter package name: "RESET);
	check = scanf("%s",package);
	if (check != EOF){
		char cmd[200];
		sprintf(cmd, "apt install -y %s", package);
		printf(BWHT"\n[+] Installing: %s\n"RESET, package);
		system(cmd);
	}else{
		printf(BRED"\n[!] Please enter a valid string!\n\n"RESET);
		DownloadFiles();

	}
}

