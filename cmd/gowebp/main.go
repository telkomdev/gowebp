package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
)

// run:
// docker run --rm -e INPUT_FILE_NAME=hiho.png -e OUTPUT_FILE_NAME=hohi.webp -v /Users/wuriyanto/Documents/go-projects/gowebp/data/:/data gowebp
func main() {

	args := os.Args
	if len(args) < 3 {
		fmt.Println("required at least one argument")
		os.Exit(1)
	}

	file, err := os.Open(args[1])
	if err != nil {
		fmt.Printf("cannot open file: %v\n", err)
		os.Exit(1)
	}

	defer func() {
		file.Close()
	}()

	tempFile, err := ioutil.TempFile("", "")
	if err != nil {
		fmt.Printf("cannot create tmp file: %v\n", err)
		os.Exit(1)
	}

	if err := tempFile.Close(); err != nil {
		fmt.Printf("cannot close tmp file: %v\n", err)
		os.Exit(1)
	}

	cmd := exec.Command("cwebp", "-q", "80", file.Name(), "-o", tempFile.Name())
	if _, err := cmd.CombinedOutput(); err != nil {
		fmt.Printf("cannot combined output: %v\n", err)
		os.Exit(1)
	}

	data, err := ioutil.ReadFile(tempFile.Name())
	if err != nil {
		fmt.Printf("cannot readfile: %v\n", err)
		os.Exit(1)
	}

	// create output file
	outFile, err := os.Create(args[2])
	if err != nil {
		fmt.Printf("cannot create file: %v\n", err)
		os.Exit(1)
	}

	defer func() {
		outFile.Close()
	}()

	_, err = outFile.Write(data)
	if err != nil {
		fmt.Printf("cannot write file: %v\n", err)
		os.Exit(1)
	}
}
