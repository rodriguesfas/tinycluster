BIN    =  mpi_hello_world
MPICC  ?= mpicc
MPIRUN ?= mpirun

.PHONY: all clean
all: ${BIN}

${BIN}: *.c
	${MPICC} -o ${BIN} mpi_hello_world.c

run_local: ${BIN}
	${MPIRUN} -np 1 ./${BIN}

run_network: ${BIN}
	${MPIRUN} -np 3 --host node1,node2,node3 ./${BIN}

clean:
	rm -f ${BIN}
