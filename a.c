#include <stdlib.h>
#include <stdio.h>

int compare(const void* a, const void* b) {
    return (*(int*) a > *(int*) b) -  (*(int*) a < *(int*) b);
}

int main() {
    int arr[] = {2,4,5,98,1};
    qsort(arr, sizeof(arr)/sizeof(int), sizeof(int), compare);
    for (int i=0; i<5; i++) {
        printf("%d ", arr[i]);
    }
}