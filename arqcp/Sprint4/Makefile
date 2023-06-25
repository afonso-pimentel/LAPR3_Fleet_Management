# A Makefile with variables and suffix rules
# variaveis
INCLUDES = 409_import_containers.h 410_calculate_consumption.h 410_is_container_refrigerated.h 411_alarm_not_enough_energy.h container_struct.h
SOURCES = 409_import_containers.c 410_calculate_consumption.c 410_is_container_refrigerated.s 411_alarm_not_enough_energy.c main.c
OBJFILES = 409_import_containers.o 410_calculate_consumption.o 410_is_container_refrigerated.o 411_alarm_not_enough_energy.o main.o
EXEC = prog

# Suffix rules
.SUFFIXES : .c .o

# How to build an object .o from a code file .c ; $< -- file name
.c.o:
	gcc -Wall -g -c $<

${EXEC}: ${OBJFILES}
	gcc -Wall -g -o ${EXEC} ${OBJFILES}

${OBJFILES}: ${SOURCES} ${INCLUDES}

run: ${EXEC}
	./${EXEC}

clean:
	rm -f ${OBJFILES} ${EXEC}
