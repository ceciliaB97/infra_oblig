#include <pthread.h>
#include <stdio.h>
#include <semaphore.h>

// Declaración de funciones
void *in(), *m1(), *f1(), *qg(), *td(), *m2(), *fn(), *mf(), *min(), *rr(), *pr(),
    *sr(), *inu(), *cb(), *sn();

// Declaración de semáforos
sem_t sem_in, sem_m1, sem_f1, sem_qg, sem_td, sem_m2, sem_fn, sem_mf, sem_min,
    sem_rr, sem_pr, sem_sr, sem_inu, sem_cb, sem_sn;

int main()
{
    // Inicialización de semáforos
    sem_init(&sem_in, 0, 0);
    sem_init(&sem_m1, 0, 0);
    sem_init(&sem_f1, 0, 0);
    sem_init(&sem_qg, 0, 0);
    sem_init(&sem_td, 0, 0);
    sem_init(&sem_m2, 0, 0);
    sem_init(&sem_fn, 0, 0);
    sem_init(&sem_mf, 0, 0);
    sem_init(&sem_min, 0, 0);
    sem_init(&sem_rr, 0, 0);
    sem_init(&sem_pr, 0, 0);
    sem_init(&sem_sr, 0, 0);
    sem_init(&sem_inu, 0, 0);
    sem_init(&sem_cb, 0, 0);
    sem_init(&sem_sn, 0, 0);

    // Creación de hilos
    pthread_t t_in, t_m1, t_f1, t_qg, t_td, t_m2, t_fn, t_mf, t_min,
    t_rr, t_pr, t_sr, t_inu, t_cb, t_sn;

    pthread_create(&t_in, NULL, in, NULL);
    pthread_create(&t_m1, NULL, m1, NULL);
    pthread_create(&t_f1, NULL, f1, NULL);
    pthread_create(&t_qg, NULL, qg, NULL);
    pthread_create(&t_td, NULL, td, NULL);
    pthread_create(&t_m2, NULL, m2, NULL);
    pthread_create(&t_fn, NULL, fn, NULL);
    pthread_create(&t_mf, NULL, mf, NULL);
    pthread_create(&t_min, NULL, min, NULL);
    pthread_create(&t_rr, NULL, rr, NULL);
    pthread_create(&t_pr, NULL, pr, NULL);
    pthread_create(&t_sr, NULL, sr, NULL);
    pthread_create(&t_inu, NULL, inu, NULL);
    pthread_create(&t_cb, NULL, cb, NULL);
    pthread_create(&t_sn, NULL, sn, NULL);

    // Esperar a los hilos
    pthread_join(t_in, NULL);
    pthread_join(t_m1, NULL);
    pthread_join(t_f1, NULL);
    pthread_join(t_qg, NULL);
    pthread_join(t_td, NULL);
    pthread_join(t_m2, NULL);
    pthread_join(t_fn, NULL);
    pthread_join(t_mf, NULL);
    pthread_join(t_min, NULL);
    pthread_join(t_rr, NULL);
    pthread_join(t_pr, NULL);
    pthread_join(t_sr, NULL);
    pthread_join(t_inu, NULL);
    pthread_join(t_cb, NULL);
    pthread_join(t_sn, NULL);

    return 0;
}

void *in() {
    printf("IN\n");
    return NULL;
}

void *m1() {
    printf("M1\n");
    sem_post(&sem_m2);
    return NULL;
}

void *f1() {
    printf("F1\n");
    sem_post(&sem_fn);
    sem_post(&sem_td);
    return NULL;
}

void *qg() {
    printf("QG\n");
    sem_post(&sem_td);
    sem_post(&sem_min);
    return NULL;
}

void *m2() {
    sem_wait(&sem_m2);
    printf("M2\n");
    sem_post(&sem_rr);
    sem_post(&sem_mf);
    sem_post(&sem_fn);
    return NULL;
}

void *td() {
    sem_wait(&sem_td);
    sem_wait(&sem_td);
    printf("TD\n");
    sem_post(&sem_mf);
    return NULL;
}

void *fn() {
    sem_wait(&sem_fn);
    sem_wait(&sem_fn);
    printf("FN\n");
    sem_post(&sem_rr);
    sem_post(&sem_min);
    sem_post(&sem_inu);
    sem_post(&sem_pr);
    return NULL;
}

void *mf() {
    sem_wait(&sem_mf);
    sem_wait(&sem_mf);
    printf("MF\n");
    sem_post(&sem_sr);
    return NULL;
}

void *min() {
    sem_wait(&sem_min);
    sem_wait(&sem_min);
    printf("MIN\n");
    sem_post(&sem_pr);
    sem_post(&sem_cb);
    return NULL;
}

void *rr() {
    sem_wait(&sem_rr);
    sem_wait(&sem_rr);
    printf("RR\n");
    sem_post(&sem_sr);
    return NULL;
}

void *pr() {
    sem_wait(&sem_pr);
    sem_wait(&sem_pr);
    printf("PR\n");
    sem_post(&sem_inu);
    sem_post(&sem_sn);
    sem_post(&sem_cb);
    return NULL;
}

void *sr() {
    sem_wait(&sem_sr);
    sem_wait(&sem_sr);
    printf("SR\n");
    sem_post(&sem_sn);
    return NULL;
}

void *inu() {
    sem_wait(&sem_inu);
    sem_wait(&sem_inu);
    printf("INU\n");
    return NULL;
}

void *cb() {
    sem_wait(&sem_cb);
    sem_wait(&sem_cb);
    printf("CB\n");
    return NULL;
}

void *sn() {
    sem_wait(&sem_sn);
    sem_wait(&sem_sn);
    printf("SN\n");
    return NULL;
}