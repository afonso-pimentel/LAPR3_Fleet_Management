# A Makefile with variables and suffix rules

# variaveis
INCLUDES = slot_status.h fill_matrix.h
SOURCES = main.c slot_status.s check_position.s total_occupied_array.s fill_matrix.c
OBJFILES = main.o slot_status.o check_position.o total_occupied_array.o fill_matrix.o
EXEC = prog
EXERC = "US 313,314,315,316"

# Suffix rules
.SUFFIXES : .c .o
.SUFFIXES : .s .o

# How to build an object .o from a code file .c ; $< -- file name
.c.o:
	gcc -Wall -g -c $<

# How to build an object .o from a code file .s ; $< -- file name
.s.o:
	gcc -Wall -g -c $<

${EXEC}: ${OBJFILES}
	gcc -Wall -g -o ${EXEC} ${OBJFILES}

${OBJFILES}: ${SOURCES} ${INCLUDES}

run: ${EXEC}
	./${EXEC}

clean:
	rm -f ${OBJFILES} ${EXEC}

#debug
debug: ${EXEC}
	ddd: ${EXEC} &

vg: ${EXEC}
	valgrind: ./§{EXEC} 

git:
	git add -A
	git commit -a -m ${EXERC}
	git pull
	git push