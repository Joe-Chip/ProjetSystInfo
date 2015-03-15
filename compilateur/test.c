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

    return 0;
}
