package main

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"pkg"
)

type renderer interface {
	Render(io.Writer) error
}

func main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println(r)
			return
		}
		fmt.Println("success")
	}()
	id, r := parse()
	buf := bytes.NewBuffer(make([]byte, 0, 5*1024))
	if err := r.Render(buf); err != nil {
		panic(err)
	}
	flush("./"+id+"/README.md", buf)
}

func parse() (string, renderer) {
	var section, description string

	fs := flag.NewFlagSet("build", flag.PanicOnError)
	fs.StringVar(&section, "s", "", "section (go, php, etc.)")
	fs.StringVar(&description, "d", "", "section description")
	fs.Parse(os.Args[1:])

	switch section {
	case "css", "go", "javascript", "php", "python":
		return section, &pkg.PackageSection{
			ID:          section,
			Description: description,
		}
	case "awesome":
		return section, &pkg.AwesomeSection{}
	default:
		panic(fmt.Sprintf("section %q not supported", section))
	}
}

func flush(filename string, r io.Reader) {
	file, err := os.OpenFile(filename, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.FileMode(0644))
	if err != nil {
		panic(err)
	}

	data, err := ioutil.ReadAll(r)
	if err != nil {
		panic(err)
	}

	_, err = file.Write(data)
	if err != nil {
		panic(err)
	}
}
