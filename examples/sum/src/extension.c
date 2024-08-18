#include <postgres.h>
#include <fmgr.h>

PG_MODULE_MAGIC;
PG_FUNCTION_INFO_V1(sum);

extern void suminit(void);

extern Datum sum(PG_FUNCTION_ARGS);
void _PG_init(void)
{
    suminit();
}