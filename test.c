
#include "molae.h"

int
main(int argc, char *argv[])
{
	AEDesc ae;
		
	if (get_launch_appleevent(&ae, 1))
		return 2;

	return ae.descriptorType != typeNull ? 0 : 1;
}
