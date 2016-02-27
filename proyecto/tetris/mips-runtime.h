/*
  Librería para emular las llamadas al sistema ofrecidas por MARS (y SPIM)
 */

#ifndef MIPSRUNTIME_H_
#define MIPSRUNTIME_H_

/*
print integer
1
$a0 = integer to print
*/
void print_integer(int a0);

/*
print float
2
$f12 = float to print
*/

/*
 * print double
3
$f12 = double to print
*/

/*
print string
4
$a0 = address of null-terminated string to print
*/
void print_string(const char *a0);

/*
read integer
5

$v0 contains integer read
*/
int read_integer(void);

/*
read float
6

$f0 contains float read
*/

/*
read double
7

$f0 contains double read
*/

/*
read string
8
$a0 = address of input buffer $a1 = maximum number of characters to read
*/
void read_string(char *a0, int a1);

/*
sbrk (allocate heap memory)
9
$a0 = number of bytes to allocate
$v0 contains address of allocated memory
*/

/*
exit (terminate execution)
10
*/
void mips_exit(int exitcode);

/*
print character
11
$a0 = character to print
See note below table
*/
void print_character(char a0);

/*
read character
12
$v0 contains character read
*/
int read_character(void);

/*
open file
13
$a0 = address of null-terminated string containing filename $a1 = flags $a2 = mode
$v0 contains file descriptor (negative if error). See note below table
*/

/*
read from file
14
$a0 = file descriptor $a1 = address of input buffer $a2 = maximum number of characters to read
$v0 contains number of characters read (0 if end-of-file, negative if error). See note below table
*/

/*
write to file
15
$a0 = file descriptor $a1 = address of output buffer $a2 = number of characters to write
$v0 contains number of characters written (negative if error). See note below table
*/

/*
close file
16
$a0 = file descriptor
*/

/*
exit2 (terminate with value)
17
$a0 = termination result
*/

/*
time (system time)
30
$a0 = low order 32 bits of system time $a1 = high order 32 bits of system time. 
 */
unsigned long long get_time(void);

/*
clear screen
39
 */
void clear_screen(void);


/*
random int
41
$a0 = i.d. of pseudorandom number generator (any int).
$a0 contains the next pseudorandom, uniformly distributed int value from this random number generator's sequence.
*/
int random_int(int id);

/*
random int range
42
$a0 = i.d. of pseudorandom number generator (any int). $a1 = upper bound of range of returned values.
$a0 contains pseudorandom, uniformly distributed int value in the range 0 = [int] [upper bound], drawn from this random number generator's sequence. 
*/
int random_int_range(int id, int max);

#ifndef NULL
#define NULL ((void *)0)
#endif

#endif /* MIPSRUNTIME_H_ */

