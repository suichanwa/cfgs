#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <glob.h>

static char k10temp_path[256] = "";
static char amdgpu_power_path[256] = "";

static void init_hwmon_paths(void) {
    glob_t g;
    if (glob("/sys/class/hwmon/hwmon*", 0, NULL, &g) == 0) {
        for (size_t i = 0; i < g.gl_pathc; i++) {
            char name_file[512];
            snprintf(name_file, sizeof(name_file), "%s/name", g.gl_pathv[i]);
            FILE *f = fopen(name_file, "r");
            if (f) {
                char buf[64] = "";
                if (fgets(buf, sizeof(buf), f)) {
                    buf[strcspn(buf, "\r\n")] = 0;
                    if (strcmp(buf, "k10temp") == 0) {
                        snprintf(k10temp_path, sizeof(k10temp_path), "%s/temp1_input", g.gl_pathv[i]);
                    } else if (strcmp(buf, "amdgpu") == 0) {
                        snprintf(amdgpu_power_path, sizeof(amdgpu_power_path), "%s/power1_average", g.gl_pathv[i]);
                        if (access(amdgpu_power_path, R_OK) != 0) {
                            snprintf(amdgpu_power_path, sizeof(amdgpu_power_path), "%s/power1_input", g.gl_pathv[i]);
                        }
                    }
                }
                fclose(f);
            }
        }
        globfree(&g);
    }
}

static int read_int(const char *path, long long *val) {
    FILE *f = fopen(path, "r");
    if (!f) return 0;
    int ret = (fscanf(f, "%lld", val) == 1);
    fclose(f);
    return ret;
}

static void get_frequencies(double *avg_ghz, double *max_ghz) {
    glob_t g;
    *avg_ghz = 0.0;
    *max_ghz = 0.0;
    if (glob("/sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq", 0, NULL, &g) == 0) {
        long long sum = 0, count = 0, max_khz = 0;
        for (size_t i = 0; i < g.gl_pathc; i++) {
            long long khz = 0;
            if (read_int(g.gl_pathv[i], &khz) && khz > 0) {
                sum += khz;
                count++;
                if (khz > max_khz) max_khz = khz;
            }
        }
        if (count > 0) {
            *avg_ghz = (double)sum / (double)count / 1000000.0;
            *max_ghz = (double)max_khz / 1000000.0;
        }
        globfree(&g);
    }
}

static void read_cpu_stat(unsigned long long *work, unsigned long long *total) {
    FILE *f = fopen("/proc/stat", "r");
    if (!f) return;
    char line[256];
    if (fgets(line, sizeof(line), f)) {
        unsigned long long user, nice, system, idle, iowait, irq, softirq, steal;
        if (sscanf(line, "cpu %llu %llu %llu %llu %llu %llu %llu %llu",
                   &user, &nice, &system, &idle, &iowait, &irq, &softirq, &steal) >= 4) {
            *work = user + nice + system + irq + softirq + steal;
            *total = *work + idle + iowait;
        }
    }
    fclose(f);
}

static void output_step(unsigned long long *prev_work, unsigned long long *prev_total) {
    unsigned long long work = 0, total = 0;
    read_cpu_stat(&work, &total);

    double delta_work = (double)(work - *prev_work);
    double delta_total = (double)(total - *prev_total);
    *prev_work = work;
    *prev_total = total;

    int usage = (delta_total > 0) ? (int)((delta_work * 100.0) / delta_total + 0.5) : 0;
    if (usage > 100) usage = 100;
    if (usage < 0) usage = 0;

    double avg_ghz = 0, max_ghz = 0;
    get_frequencies(&avg_ghz, &max_ghz);

    double watts = 0.0;
    long long p_raw = 0;
    if (amdgpu_power_path[0] && read_int(amdgpu_power_path, &p_raw)) {
        watts = (double)p_raw / 1000000.0;
    }

    int temp_c = 0;
    long long t_raw = 0;
    if (k10temp_path[0] && read_int(k10temp_path, &t_raw)) {
        temp_c = (int)((t_raw + 500) / 1000);
    }

    printf("{\"text\":\"%2d%%\",\"tooltip\":\"<b> AMD Ryzen 7 7840HS</b>\\n  Average Clock: <b>%.2f GHz</b> (Peak: %.2f GHz)\\n  Power Draw:    <b>%.1f W</b>\\n  Temperature:   <b>%d°C</b>\"}\n",
           usage, avg_ghz, max_ghz, watts, temp_c);
    fflush(stdout);
}

int main(void) {
    init_hwmon_paths();
    unsigned long long prev_work = 0, prev_total = 0;
    read_cpu_stat(&prev_work, &prev_total);
    usleep(100000); // 0.1s fast start for instant first frame
    output_step(&prev_work, &prev_total);

    while (1) {
        sleep(2);
        output_step(&prev_work, &prev_total);
    }
    return 0;
}
