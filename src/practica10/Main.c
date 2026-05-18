#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);

void update_temp(int *temps){
    for(int i = 0; i < 2; i++){
        int cambio = (rand() % 11) - 5; // [-5,5]
        temps[i] += cambio;
    }
}

void update_flags(int *temps,int *last,unsigned char *flags){
    for(int i = 0; i < 2; i++){
        flags[i] = 0;
        int diff = temps[i] - last[i];

        if(diff == 0) set_bit(&flags[i], 0);   // N
        if(diff == 1) set_bit(&flags[i], 1);   // O
        if(diff == 2) set_bit(&flags[i], 2);   // T
        if(diff > 2)  set_bit(&flags[i], 3);   // G
        if(diff < 0)  set_bit(&flags[i], 4);   // D
        if(diff > 0)  set_bit(&flags[i], 5);   // U

        last[i] = temps[i];
    }
}

void print_status(int *temps,unsigned char *flags){
    for(int i = 0; i < 2; i++){
        printf("SENSOR %d: ~ %d °C ", i+1, temps[i]);

        if(get_bit(flags[i],0)) printf("- ");
        else if(get_bit(flags[i],4)) printf("< ");
        else if(get_bit(flags[i],2)) printf("<< ");
        else if(get_bit(flags[i],3)) printf("<<< ");
        else if(get_bit(flags[i],1)) printf("> ");
        else if(get_bit(flags[i],5)) printf(">> ");

        printf("\n");
    }
}

int main(){
    int temps[2] = {25,25};
    int last[2] = {25,25};
    unsigned char flags[2] = {0,0};

    srand(time(NULL));

    int op;

    do{
        printf("\nSENSOR 1: ~ %d °C\n", temps[0]);
        printf("SENSOR 2: ~ %d °C\n", temps[1]);

        printf("[1] Actualizar\n[2] Salir\n");
        printf("Seleccionar: ");
        scanf("%d", &op);

        if(op == 1){
            update_temp(temps);
            update_flags(temps,last,flags);
            print_status(temps,flags);
        }

    }while(op != 2);

    return 0;
}