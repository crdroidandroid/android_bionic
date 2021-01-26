#include <math.h>

#ifndef type
__FBSDID("$FreeBSD$");
#define type            double
#define roundit         round
#define dtype           long
#define DTYPE_MIN       LONG_MIN
#define DTYPE_MAX       LONG_MAX
#define fn              lround
#endif

long lround(double x)

{
	return round(x);
}
