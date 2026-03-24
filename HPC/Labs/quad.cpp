#include <omp.h>

#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

namespace {

constexpr double kIntegrationStart = 0.0;
constexpr double kIntegrationEnd = 1.0;
constexpr double kTargetAccuracy = 1e-8;
constexpr double kExactIntegral = 3.14159265358979323846264338327950288;
constexpr double kBenchmarkTargetTime = 0.2;
constexpr int kBenchmarkMaxRepeats = 20;

double integrand(double x) { return 4.0 / (1.0 + x * x); }

double midpoint_serial(std::size_t num_intervals) {
  const double dx = (kIntegrationEnd - kIntegrationStart) /
                    static_cast<double>(num_intervals);
  double sum = 0.0;

  for (std::size_t i = 0; i < num_intervals; ++i) {
    const double x = kIntegrationStart + (static_cast<double>(i) + 0.5) * dx;
    sum += integrand(x);
  }

  return sum * dx;
}

double midpoint_manual_reduce(std::size_t num_intervals) {
  const double dx = (kIntegrationEnd - kIntegrationStart) /
                    static_cast<double>(num_intervals);

#if defined(_OPENMP)
  const int max_threads = omp_get_max_threads();
  std::vector<double> partial_sums(static_cast<std::size_t>(max_threads), 0.0);

#pragma omp parallel
  {
    const int thread_id = omp_get_thread_num();
    const int num_threads = omp_get_num_threads();
    const std::size_t begin =
        num_intervals * static_cast<std::size_t>(thread_id) /
        static_cast<std::size_t>(num_threads);
    const std::size_t end =
        num_intervals * static_cast<std::size_t>(thread_id + 1) /
        static_cast<std::size_t>(num_threads);

    double local_sum = 0.0;
    for (std::size_t i = begin; i < end; ++i) {
      const double x =
          kIntegrationStart + (static_cast<double>(i) + 0.5) * dx;
      local_sum += integrand(x);
    }

    partial_sums[static_cast<std::size_t>(thread_id)] = local_sum;
  }

  double sum = 0.0;
  for (double partial_sum : partial_sums) {
    sum += partial_sum;
  }

  return sum * dx;
#else
  return midpoint_serial(num_intervals);
#endif
}

double midpoint_omp_reduce(std::size_t num_intervals) {
  const double dx = (kIntegrationEnd - kIntegrationStart) /
                    static_cast<double>(num_intervals);
  double sum = 0.0;

#if defined(_OPENMP)
#pragma omp parallel for reduction(+ : sum) schedule(static)
  for (long long i = 0; i < static_cast<long long>(num_intervals); ++i) {
    const double x = kIntegrationStart + (static_cast<double>(i) + 0.5) * dx;
    sum += integrand(x);
  }
#else
  for (std::size_t i = 0; i < num_intervals; ++i) {
    const double x = kIntegrationStart + (static_cast<double>(i) + 0.5) * dx;
    sum += integrand(x);
  }
#endif

  return sum * dx;
}

double absolute_error(double estimate) {
  return std::abs(estimate - kExactIntegral);
}

template <typename Integrator>
double benchmark_integrator(Integrator integrator, std::size_t num_intervals,
                            double &value) {
  int repeats = 0;
  double total_time = 0.0;
  value = 0.0;

  do {
    const double start_time = omp_get_wtime();
    value = integrator(num_intervals);
    total_time += omp_get_wtime() - start_time;
    ++repeats;
  } while (repeats < kBenchmarkMaxRepeats && total_time < kBenchmarkTargetTime);

  return total_time / static_cast<double>(repeats);
}

std::size_t find_num_intervals_for_accuracy(double target_accuracy) {
  std::size_t num_intervals = 16;

  while (true) {
    const double estimate = midpoint_serial(num_intervals);
    if (absolute_error(estimate) <= target_accuracy) {
      return num_intervals;
    }

    num_intervals *= 2;
  }
}

std::vector<std::size_t> build_benchmark_sizes(std::size_t accuracy_intervals) {
  return {
      accuracy_intervals / 4,
      accuracy_intervals / 2,
      accuracy_intervals,
      accuracy_intervals * 2,
      accuracy_intervals * 4,
      accuracy_intervals * 8,
      accuracy_intervals * 16,
  };
}

} // namespace

int main(int argc, char *argv[]) {
  std::string output_path = "output_run_08_quadrature.csv";
  if (argc >= 2) {
    output_path = argv[1];
  }

  const std::size_t accuracy_intervals =
      find_num_intervals_for_accuracy(kTargetAccuracy);
  const std::vector<std::size_t> benchmark_sizes =
      build_benchmark_sizes(accuracy_intervals);

  std::ofstream csv_output(output_path.c_str());
  if (!csv_output.is_open()) {
    std::cerr << "Failed to open output file '" << output_path << "'"
              << std::endl;
    return EXIT_FAILURE;
  }

  csv_output << "N,time_serial,time_hand_reduce,time_omp_reduce,error_serial,";
  csv_output << "error_hand_reduce,error_omp_reduce,speedup_hand_reduce,";
  csv_output << "speedup_omp_reduce\n";

  std::cout << std::setprecision(10);
  std::cout << "Midpoint integration benchmark" << std::endl;
  std::cout << " + exact_integral: " << kExactIntegral << std::endl;
  std::cout << " + target_accuracy: " << kTargetAccuracy << std::endl;
  std::cout << " + accuracy_intervals: " << accuracy_intervals << std::endl;
#if defined(_OPENMP)
  std::cout << " + omp_max_threads: " << omp_get_max_threads() << std::endl;
#else
  std::cout << " + omp_max_threads: 1" << std::endl;
#endif

  for (std::size_t num_intervals : benchmark_sizes) {
    double serial_value = 0.0;
    double hand_reduce_value = 0.0;
    double omp_reduce_value = 0.0;

    const double time_serial =
        benchmark_integrator(midpoint_serial, num_intervals, serial_value);
    const double time_hand_reduce = benchmark_integrator(
        midpoint_manual_reduce, num_intervals, hand_reduce_value);
    const double time_omp_reduce =
        benchmark_integrator(midpoint_omp_reduce, num_intervals, omp_reduce_value);

    const double error_serial = absolute_error(serial_value);
    const double error_hand_reduce = absolute_error(hand_reduce_value);
    const double error_omp_reduce = absolute_error(omp_reduce_value);
    const double speedup_hand_reduce = time_serial / time_hand_reduce;
    const double speedup_omp_reduce = time_serial / time_omp_reduce;

    std::cout << "N=" << num_intervals << " serial=" << time_serial
              << " hand_reduce=" << time_hand_reduce
              << " omp_reduce=" << time_omp_reduce << " err_serial="
              << error_serial << std::endl;

    csv_output << num_intervals << ',' << time_serial << ',' << time_hand_reduce
               << ',' << time_omp_reduce << ',' << error_serial << ','
               << error_hand_reduce << ',' << error_omp_reduce << ','
               << speedup_hand_reduce << ',' << speedup_omp_reduce << '\n';
  }

  csv_output.close();
  return EXIT_SUCCESS;
}
