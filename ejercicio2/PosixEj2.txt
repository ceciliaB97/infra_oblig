#include <pthread.h>
#include <stdio.h>
#include <semaphore.h>

// Declaración de funciones
void *ip(), *m1(), *f1(), *ed(), *m2(), *f2(), *db(), *si(), *bd(), *pa(),
    *ia(), *aa(), *cg(), *ro(), *rc(), *is(), *so(), *sd(), *cs(), *dw();

// Declaración de semáforos
sem_t sem_m1, sem_f1, sem_ed, sem_m2, sem_f2, sem_db, sem_bd, sem_pa,
    sem_ia, sem_aa, sem_cg, sem_ro, sem_rc, sem_is, sem_so, sem_sd, sem_cs, sem_si, sem_dw;

int main()
{
    // Inicialización de semáforos
    sem_init(&sem_m1, 0, 0);
    sem_init(&sem_f1, 0, 0);
    sem_init(&sem_ed, 0, 0);
    sem_init(&sem_m2, 0, 0);
    sem_init(&sem_f2, 0, 0);
    sem_init(&sem_db, 0, 0);
    sem_init(&sem_bd, 0, 0);
    sem_init(&sem_pa, 0, 0);
    sem_init(&sem_ia, 0, 0);
    sem_init(&sem_aa, 0, 0);
    sem_init(&sem_cg, 0, 0);
    sem_init(&sem_ro, 0, 0);
    sem_init(&sem_rc, 0, 0);
    sem_init(&sem_is, 0, 0);
    sem_init(&sem_so, 0, 0);
    sem_init(&sem_sd, 0, 0);
    sem_init(&sem_cs, 0, 0);
    sem_init(&sem_si, 0, 0);
    sem_init(&sem_dw, 0, 0);

    // Creación de hilos
    pthread_t t_ip, t_m1, t_f1, t_ed, t_m2, t_f2, t_db, t_si, t_bd, t_pa,
        t_ia, t_aa, t_cg, t_ro, t_rc, t_is, t_so, t_sd, t_cs, t_dw;

    pthread_create(&t_ip, NULL, ip, NULL);
    pthread_create(&t_m1, NULL, m1, NULL);
    pthread_create(&t_f1, NULL, f1, NULL);
    pthread_create(&t_ed, NULL, ed, NULL);
    pthread_create(&t_m2, NULL, m2, NULL);
    pthread_create(&t_f2, NULL, f2, NULL);
    pthread_create(&t_db, NULL, db, NULL);
    pthread_create(&t_si, NULL, si, NULL);
    pthread_create(&t_bd, NULL, bd, NULL);
    pthread_create(&t_pa, NULL, pa, NULL);
    pthread_create(&t_ia, NULL, ia, NULL);
    pthread_create(&t_aa, NULL, aa, NULL);
    pthread_create(&t_cg, NULL, cg, NULL);
    pthread_create(&t_ro, NULL, ro, NULL);
    pthread_create(&t_rc, NULL, rc, NULL);
    pthread_create(&t_is, NULL, is, NULL);
    pthread_create(&t_so, NULL, so, NULL);
    pthread_create(&t_sd, NULL, sd, NULL);
    pthread_create(&t_cs, NULL, cs, NULL);
    pthread_create(&t_dw, NULL, dw, NULL);

    // Esperar a los hilos
    pthread_join(t_ip, NULL);
    pthread_join(t_m1, NULL);
    pthread_join(t_f1, NULL);
    pthread_join(t_ed, NULL);
    pthread_join(t_m2, NULL);
    pthread_join(t_f2, NULL);
    pthread_join(t_db, NULL);
    pthread_join(t_si, NULL);
    pthread_join(t_bd, NULL);
    pthread_join(t_pa, NULL);
    pthread_join(t_ia, NULL);
    pthread_join(t_aa, NULL);
    pthread_join(t_cg, NULL);
    pthread_join(t_ro, NULL);
    pthread_join(t_rc, NULL);
    pthread_join(t_is, NULL);
    pthread_join(t_so, NULL);
    pthread_join(t_sd, NULL);
    pthread_join(t_cs, NULL);
    pthread_join(t_dw, NULL);

    return 0;
}

void *ip() {
    printf("IP\n");
    sem_post(&sem_ed);
    return NULL;
}

void *m1() {
    printf("M1\n");
    sem_post(&sem_m2);
    return NULL;
}

void *f1() {
    printf("F1\n");
    sem_post(&sem_f2);
    return NULL;
}

void *ed() {
    sem_wait(&sem_ed);
    printf("ED\n");
    sem_post(&sem_db);
    sem_post(&sem_pa);
    return NULL;
}

void *m2() {
    sem_wait(&sem_m2);
    printf("M2\n");
    sem_post(&sem_bd);
    sem_post(&sem_ia);
    sem_post(&sem_pa);
    sem_post(&sem_aa);
    return NULL;
}

void *f2() {
    sem_wait(&sem_f2);
    printf("F2\n");
    sem_post(&sem_rc);
    sem_post(&sem_ro);
    sem_post(&sem_cg);
    return NULL;
}

void *db() {
    sem_wait(&sem_db);
    printf("DB\n");
    sem_post(&sem_si);
    sem_post(&sem_bd);
    sem_post(&sem_dw);
    return NULL;
}

void *si() {
    sem_wait(&sem_si);
    sem_wait(&sem_si);
    printf("SI\n");
    sem_post(&sem_cs);
    return NULL;
}

void *bd() {
    sem_wait(&sem_bd);
    sem_wait(&sem_bd);
    printf("BD\n");
    return NULL;
}

void *pa() {
    sem_wait(&sem_pa);
    sem_wait(&sem_pa);
    printf("PA\n");
    sem_post(&sem_ia);
    sem_post(&sem_is);
    sem_post(&sem_aa);
    sem_post(&sem_so);
    sem_post(&sem_ro);
    sem_post(&sem_rc);
    sem_post(&sem_cg);
    return NULL;
}

void *ia() {
    sem_wait(&sem_ia);
    sem_wait(&sem_ia);
    printf("IA\n");
    return NULL;
}

void *aa() {
    sem_wait(&sem_aa);
    sem_wait(&sem_aa);
    printf("AA\n");
    return NULL;
}

void *cg() {
    sem_wait(&sem_cg);
    sem_wait(&sem_cg);
    printf("CG\n");
    return NULL;
}

void *ro() {
    sem_wait(&sem_ro);
    sem_wait(&sem_ro);
    printf("RO\n");
    return NULL;
}

void *rc() {
    sem_wait(&sem_rc);
    sem_wait(&sem_rc);
    printf("RC\n");
    sem_post(&sem_dw);
    sem_post(&sem_so);
    sem_post(&sem_sd);
    sem_post(&sem_si);
    return NULL;
}

void *is() {
    sem_wait(&sem_is);
    printf("IS\n");
    return NULL;
}

void *so() {
    sem_wait(&sem_so);
    sem_wait(&sem_so);
    printf("SO\n");
    sem_post(&sem_sd);
    sem_post(&sem_cs);
    return NULL;
}

void *sd() {
    sem_wait(&sem_sd);
    sem_wait(&sem_sd);
    printf("SD\n");
    return NULL;
}

void *cs() {
    sem_wait(&sem_cs);
    sem_wait(&sem_cs);
    printf("CS\n");
    return NULL;
}

void *dw() {
    sem_wait(&sem_dw);
    sem_wait(&sem_dw);
    printf("DW\n");
    return NULL;
}