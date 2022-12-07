package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	s "strings"
)

type directory struct {
	parent  *directory
	subdirs map[string]directory
	files   map[string]file
	name    string
}

type file struct {
	name string
	size int
}

func (dir *directory) size() int {
	totalSize := 0

	for _, subdir := range dir.subdirs {
		totalSize += subdir.size()
	}

	for _, file := range dir.files {
		totalSize += file.size
	}

	return totalSize
}

func (dir *directory) print(level int) {
	indent := s.Repeat(" ", level*4)
	fmt.Printf("%s- %s (dir)\n", indent, dir.name)
	for _, subdir := range dir.subdirs {
		subdir.print(level + 1)
	}
	for _, file := range dir.files {
		fmt.Printf("%s    - %s (file, size=%d)\n", indent, file.name, file.size)
	}
}

func (dir *directory) fileSizesUnderLimit(limit int) []int {
	var underLimit = make([]int, 0)
	for _, subdir := range dir.subdirs {
		underLimit = append(underLimit, subdir.fileSizesUnderLimit(limit)...)
	}

	if limit == 0 || dir.size() <= limit {
		underLimit = append(underLimit, dir.size())
	}

	return underLimit
}

func sum(numbers ...int) int {
	total := 0
	for _, number := range numbers {
		total += number
	}
	return total
}

func main() {
	data, err := os.ReadFile("input/input.txt")
	check(err)

	var fileData = string(data)
	var lines = s.Split(fileData, "\n")

	var firstDir *directory = nil
	var currentDir *directory = nil

	for _, line := range lines {
		if s.HasPrefix(line, "$ cd /") {
			if firstDir == nil {
				newDir := directory{
					parent:  nil,
					subdirs: make(map[string]directory, 1),
					files:   make(map[string]file, 1),
					name:    "/",
				}
				currentDir = &newDir
				firstDir = &newDir
			} else {
				currentDir = firstDir
			}
		} else if s.HasPrefix(line, "$ cd") {
			dirname := line[5:]
			if dirname == ".." {
				currentDir = currentDir.parent
			} else {
				nextDir := currentDir.subdirs[dirname]
				currentDir = &nextDir
			}
		} else if s.HasPrefix(line, "$ ls") {
			// ignore
		} else if s.HasPrefix(line, "dir") {
			dirname := line[4:]
			currentDir.subdirs[dirname] = directory{
				parent:  currentDir,
				subdirs: make(map[string]directory, 1),
				files:   make(map[string]file, 1),
				name:    dirname,
			}
		} else {
			fileStats := s.Split(line, " ")
			fileSize, _ := strconv.Atoi(fileStats[0])
			currentDir.files[fileStats[0]] = file{
				name: fileStats[1],
				size: fileSize,
			}
		}
	}

	firstDir.print(0)

	// Part 1:
	//sizesUnderLimit := firstDir.fileSizesUnderLimit(100000)
	//fmt.Println(sum(sizesUnderLimit...))

	// Part 2:
	var requiredForUpdate = 30000000
	var totalSize = 70000000
	var takenSpace = firstDir.size()
	var unusedSpace = totalSize - takenSpace
	var extraRequired = requiredForUpdate - unusedSpace
	sizesUnderLimit := firstDir.fileSizesUnderLimit(0)
	sort.Ints(sizesUnderLimit)
	fmt.Println(sizesUnderLimit)
	for _, size := range sizesUnderLimit {
		if size >= extraRequired {
			fmt.Printf("Smallest directory to delete: %d\n", size)
			break
		}
	}
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}
