#include <stdio.h>
#include <regex.h>        

main() {

   	FILE *fp;
	regex_t regex;
	int reti;
	char msgbuf[100];
   	char buff[255];
	int i=0;
   	fp = fopen("queries.sql", "r");
while(i!=6)
{
	fscanf(fp, "%s", buff);//scans input only untill next space or newline
	   printf("%d : %s\t",i, buff );
		char *arr=buff;

		//TODO
		//MAtch the pattern and perform corresponding aciton.
	/* Compile regular expression */
	reti = regcomp(&regex, "^[[:alpha:]]", 0);
	if (reti) {
	    fprintf(stderr, "Could not compile regex\n");
	    exit(1);
	}

	/* Execute regular expression */
	reti = regexec(&regex, arr, 0, NULL, 0);
	if (!reti) {
	    puts("Match");
	}
	else if (reti == REG_NOMATCH) {
	    puts("No match");
	}
	else {
	    regerror(reti, &regex, msgbuf, sizeof(msgbuf));
	    fprintf(stderr, "Regex match failed: %s\n", msgbuf);
	    exit(1);
	}

	/* Free memory allocated to the pattern buffer by regcomp() */
	regfree(&regex);

		//printf("%s\t",arr);
		//printf("%c\n",buff[0]);
	i++;
}

/*
fscanf(fp, "%s", buff);//scans input only untill next space or newline
   printf("1 : %s\n", buff );

fscanf(fp, "%s", buff);//scans input only untill next space or newline
   printf("1 : %s\n", buff );

   fgets(buff, 255, (FILE*)fp);//reads input till the end of the line.
   printf("2: %s\n", buff );
   
   fgets(buff, 255, (FILE*)fp);
   printf("3: %s\n", buff );*/
   fclose(fp);

}
