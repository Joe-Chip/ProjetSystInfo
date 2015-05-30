int global_non_init;
int global_init = 9;
int glabal_init_par_exp = 5 * 8;

void toto (int lulz);

int main () {
    int i = 4 + 2;
    const int j = 7;

    if (i > j) {
        i = i * 2;
    } else {
        i = 1;
    }

    while (i < j) {
        i = i + 2;
    }

    toto(i);

    return 0;
}


void toto (int lulz)
{
    int lalz;

    lalz = lulz + global_init;
}

