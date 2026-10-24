#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void output_step(void) {
    long long mem_total = 0, mem_avail = 0;
    FILE *fmem = fopen("/proc/meminfo", "r");
    if (fmem) {
        char line[256];
        while (fgets(line, sizeof(line), fmem)) {
            if (strncmp(line, "MemTotal:", 9) == 0) {
                sscanf(line + 9, "%lld", &mem_total);
            } else if (strncmp(line, "MemAvailable:", 13) == 0) {
                sscanf(line + 13, "%lld", &mem_avail);
            }
        }
        fclose(fmem);
    }

    double ram_total_gib = (double)mem_total / (1024.0 * 1024.0);
    double ram_avail_gib = (double)mem_avail / (1024.0 * 1024.0);
    double ram_used_gib = (double)(mem_total - mem_avail) / (1024.0 * 1024.0);
    int ram_perc = (mem_total > 0) ? (int)((ram_used_gib * 100.0) / ram_total_gib + 0.5) : 0;

    long long zram_total_kib = 0, zram_used_kib = 0;
    long long ssd_total_kib = 0, ssd_used_kib = 0;
    char ssd_name[128] = "";

    FILE *fswaps = fopen("/proc/swaps", "r");
    if (fswaps) {
        char line[256];
        if (fgets(line, sizeof(line), fswaps)) { // skip header
            while (fgets(line, sizeof(line), fswaps)) {
                char fn[128], type[32];
                long long size_k = 0, used_k = 0;
                int prio = 0;
                if (sscanf(line, "%127s %31s %lld %lld %d", fn, type, &size_k, &used_k, &prio) >= 4) {
                    if (strstr(fn, "zram") != NULL) {
                        zram_total_kib += size_k;
                        zram_used_kib += used_k;
                    } else {
                        ssd_total_kib += size_k;
                        ssd_used_kib += used_k;
                        strncpy(ssd_name, fn, sizeof(ssd_name) - 1);
                    }
                }
            }
        }
        fclose(fswaps);
    }

    double zram_total_gib = (double)zram_total_kib / (1024.0 * 1024.0);
    double zram_used_mib = (double)zram_used_kib / 1024.0;
    int zram_perc = (zram_total_kib > 0) ? (int)(((double)zram_used_kib * 100.0) / (double)zram_total_kib + 0.5) : 0;

    double ratio = 0.0;
    FILE *fzstat = fopen("/sys/block/zram0/mm_stat", "r");
    if (fzstat) {
        long long orig = 0, compr = 0;
        if (fscanf(fzstat, "%lld %lld", &orig, &compr) == 2 && compr > 0) {
            ratio = (double)orig / (double)compr;
        }
        fclose(fzstat);
    }

    char zram_ratio_str[64] = "";
    if (ratio > 0.1) {
        snprintf(zram_ratio_str, sizeof(zram_ratio_str), " (ratio: %.1fx)", ratio);
    }

    char ssd_section[256] = "";
    if (ssd_total_kib > 0) {
        double ssd_total_gib = (double)ssd_total_kib / (1024.0 * 1024.0);
        double ssd_used_gib = (double)ssd_used_kib / (1024.0 * 1024.0);
        int ssd_perc = (int)(((double)ssd_used_kib * 100.0) / (double)ssd_total_kib + 0.5);
        snprintf(ssd_section, sizeof(ssd_section),
                 "\\n\\n<b>󰋊 SSD Swap (%s)</b>\\n  Used:  <b>%.1f GiB</b> / %.1f GiB (%d%%)",
                 ssd_name, ssd_used_gib, ssd_total_gib, ssd_perc);
    } else {
        snprintf(ssd_section, sizeof(ssd_section),
                 "\\n\\n<b>󰋊 SSD Swap</b>\\n  <i>None / Inactive</i>");
    }

    printf("{\"text\":\"%0.1fG\",\"tooltip\":\"<b> Physical RAM</b>\\n  Used:  <b>%0.1f GiB</b> / %0.1f GiB (%d%%)\\n  Avail: <b>%0.1f GiB</b> free\\n\\n<b>󰾴 ZRAM (Compressed RAM)</b>\\n  Used:  <b>%.0f MiB</b> / %0.1f GiB (%d%%)%s%s\"}\n",
           ram_used_gib, ram_used_gib, ram_total_gib, ram_perc, ram_avail_gib,
           zram_used_mib, zram_total_gib, zram_perc, zram_ratio_str, ssd_section);
    fflush(stdout);
}

int main(void) {
    output_step(); // Immediate first frame
    while (1) {
        sleep(2);
        output_step();
    }
    return 0;
}
