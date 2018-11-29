#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/timeb.h>
#include <time.h> 
#include <string.h>
#include <stdlib.h>


char* strrev(char* str)
{
	char *p1, *p2;
	if (!str || !*str)
		return str;
	for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2)
	{
		*p1 ^= *p2;
		*p2 ^= *p1;
		*p1 ^= *p2;
	}
	return str;
}


void itochar(int x, char* szBuffer, int radix)
{
	int i = 0, n, xx;
	n = x;
	while (n > 0)
	{
		xx = n%radix;
		n = n/radix;
		szBuffer[i++] = '0' + xx;
	}
	szBuffer[i] = '\0';
	strrev(szBuffer);
}




main( int argc, char ** argv )     // 4个参数   w h in out
{
	
	FILE	*fpr;
	FILE	*fp;
	char	*line_buf;
 	int     W1, H1, W2, H2;
	int	    i, j, k;
	int	    ret;
		
	if(argc!=5)
		{
		printf("arg error \n");
		printf("w h in out \n");
		printf("usage: create a pgm from yuv file \n");
		
		return;
		}
	
	W1 = atoi(argv[1]);
	H1 = atoi(argv[2]);
	
	fpr = fopen(argv[3], "r");
	if (NULL == fpr) {
		printf("can't open %s for read\n", argv[3]);
		return -1;
	}
	fp = fopen(argv[4], "w");
	if (NULL == fp) {
		printf("can't open %s for write\n", argv[4]);
		return -1;
	}
	
	const char *format = "P5";
	char parameters_str[5];
	
	fputs(format, fp);
	fputc('\n', fp);
	
	itochar(W1, parameters_str, 10);
	fputs(parameters_str, fp);
	parameters_str[0] = 0;
	fputc(' ', fp);
	
	itochar(H1, parameters_str, 10);
	fputs(parameters_str, fp);
	parameters_str[0] = 0;
	fputc('\n', fp);
	
	int maxgrey = 255;
	itochar(maxgrey, parameters_str, 10);
	fputs(parameters_str, fp);
	fputc('\n', fp);
	
	
	line_buf = (char *)malloc(W1);
	for (i = 0; i < H1; i++) {
		ret = fread(line_buf, W1, 1, fpr);
		ret = fwrite(line_buf, W1, 1, fp);
	}
	
	
	fclose(fpr);
	fclose(fp);


}



