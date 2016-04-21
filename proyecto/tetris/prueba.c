#include <stdio.h>

void integer_to_string(int n, char* buf) {
	char *p = buf;
	char const digit[]="0123456789";
	int base = 10;
	if(n==0) {
		*p = digit[n%10];
		++p;
		*p = '\0';
	}
	else {
		if(n<0){
			*p++ = '-';
			n *= -1;
		}

		for (int i = n; i > 0; i = i / base) {
			*p = (i % base) + '0';
			++p;
		}
		*p = '\0';

		do{
			*--p= digit[n%10];
			n=n/10;
		}while(n);

	}

}


int main (void) {
	char* buf;
	int n = 0;

	integer_to_string(n, buf);
	printf("%s\n",buf);

	return 0;

}

