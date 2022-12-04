#include <iostream>
#include <sstream>
#include <fstream>
#include "main.h"

class Elf {
public:
    int startSection;
    int endSection;

    explicit Elf(const std::string &from) {
        size_t split = from.find('-');
        std::string start = from.substr(0, split);
        std::string end = from.substr(split + 1);

        startSection = std::stoi(start);
        endSection = std::stoi(end);
    }

    bool is_contained_by(const Elf &other) const {
        return other.startSection <= startSection && other.endSection >= endSection;
    }

    bool overlaps_with(const Elf &other) const {
        return (other.startSection >= startSection && other.startSection <= endSection) ||
               (startSection >= other.startSection && startSection <= other.endSection);
    }
};

int main() {
    std::string input = read_file("../input/input.txt");

    size_t start = 0;
    size_t lineEnd = input.find('\n');

    size_t counter = 0;

    while (lineEnd != std::string::npos) {
        std::string line = input.substr(start, lineEnd - start);

        // PART 1:  counter += line_one_contains_another(line) ? 1 : 0;
        counter += line_one_overlaps_with_other(line) ? 1 : 0;

        start = lineEnd + 1;
        lineEnd = input.find('\n', start);
    }

    std::cout << "Lines that match: " << counter << std::endl;

    return 0;
}

std::string read_file(const std::string &filename) {
    std::ifstream f(filename);
    std::stringstream buffer;
    buffer << f.rdbuf();
    return buffer.str();
}

bool line_one_contains_another(const std::string &line) {
    size_t split = line.find(',');
    std::string lh = line.substr(0, split);
    std::string rh = line.substr(split + 1);

    Elf left = Elf(lh);
    Elf right = Elf(rh);

    return left.is_contained_by(right) || right.is_contained_by(left);
}

bool line_one_overlaps_with_other(const std::string &line) {
    size_t split = line.find(',');
    std::string lh = line.substr(0, split);
    std::string rh = line.substr(split + 1);

    Elf left = Elf(lh);
    Elf right = Elf(rh);

    return left.overlaps_with(right);
}
