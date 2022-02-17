#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include <unistd.h>

#define RED   "\x1B[31m"
#define GRN   "\x1B[32m"
#define YEL   "\x1B[33m"
#define BLU   "\x1B[34m"
#define RESET "\x1B[0m"

void DownloadFiles();

int main(int argc, char **argv){
	char password[21];
	int result;
	printf(YEL "[!] Package installer -Beta\n"RESET);
	printf(BLU "[!] Please enter the password: "RESET);
	scanf("%s", password);
	result = strcmp(password,"SuperSecurePassword!");
	if(result != 0){
		printf(RED"[!] Authentication error!!\n"RESET);
		exit(1);
	}
	printf(GRN"[+] Authorized!\n"RESET);
	DownloadFiles();
	return 0;

}

void DownloadFiles(){
	char package[100];
	int check;
	setuid(0);
	printf(BLU "[!] Enter package name: "RESET);
	check = scanf("%s",package);
	if (check != EOF){
		char cmd[200];
		sprintf(cmd, "apt install -y %s", package);
		printf(GRN"[+] Installing: %s\n"RESET, package);
		system(cmd);
	}else{
		printf(RED"\n[!] Please enter a valid string!\n"RESET);
		DownloadFiles();

	}
}

