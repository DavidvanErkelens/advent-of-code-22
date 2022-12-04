//
// Created by David van Erkelens on 04/12/2022.
//

#ifndef CPP_MAIN_H
#define CPP_MAIN_H

#include <string>

std::string read_file(const std::string &filename);
bool line_one_contains_another(const std::string &line);
bool line_one_overlaps_with_other(const std::string &line);

#endif //CPP_MAIN_H
