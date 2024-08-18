POSTGRES_BINDIR := $(shell pg_config --bindir)
POSTGRES_INCLUDEDIR := $(shell pg_config --includedir-server)

all:
	#make -C ../../adagres all
	POSTGRES_INCLUDEDIR=${POSTGRES_INCLUDEDIR} POSTGRES_BINDIR=${POSTGRES_BINDIR} alr -v build

clean:
	POSTGRES_INCLUDEDIR=${POSTGRES_INCLUDEDIR} POSTGRES_BINDIR=${POSTGRES_BINDIR} alr clean


pp:
	POSTGRES_INCLUDEDIR=${POSTGRES_INCLUDEDIR} POSTGRES_BINDIR=${POSTGRES_BINDIR} alr exec  -- gnatpp -P sum --no-subprojects -M100
