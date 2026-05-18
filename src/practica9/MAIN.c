#include <stdio.h>

extern int maximo(int *arr, int len);
extern int minimo(int *arr, int len);
extern int sumatoria(int *arr, int len);

int main() {
    int arr[5];
    int n = 5;

    printf("Captura 5 numeros:\n");

    for(int i = 0; i < n; i++) {
        printf("Elemento %d: ", i);
        scanf("%d", &arr[i]);
    }

    printf("\nArreglo:\n");
    for(int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }

    printf("\n\nMaximo: %d\n", maximo(arr, n));
    printf("Minimo: %d\n", minimo(arr, n));
    printf("Sumatoria: %d\n", sumatoria(arr, n));

    return 0;
}