# Makefile para Calculadora Programador Didática
# Assembly x86-64

ASM = nasm
LD = ld
ASM_FLAGS = -f elf64
LD_FLAGS = 

TARGET = calculadora
SOURCE = calculadora.asm
OBJECT = calculadora.o

# Regra padrão
all: $(TARGET)

# Compilar o programa
$(TARGET): $(OBJECT)
	$(LD) $(LD_FLAGS) -o $(TARGET) $(OBJECT)

# Assemblar o código fonte
$(OBJECT): $(SOURCE)
	$(ASM) $(ASM_FLAGS) -o $(OBJECT) $(SOURCE)

# Limpar arquivos gerados
clean:
	rm -f $(OBJECT) $(TARGET)

# Executar o programa
run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run

