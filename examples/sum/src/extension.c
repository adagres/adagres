#include <postgres.h>
#include <fmgr.h>

PG_MODULE_MAGIC;
PG_FUNCTION_INFO_V1(sum);

void suminit(void);
extern void _PG_init(void);
void _PG_init(void)
{
    suminit();
}